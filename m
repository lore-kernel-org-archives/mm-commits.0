Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B0F8C71145
	for <mm-commits@archiver.kernel.org>; Thu, 24 Aug 2023 22:00:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243792AbjHXWA1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Aug 2023 18:00:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243845AbjHXWAX (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Aug 2023 18:00:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D90381BE6;
        Thu, 24 Aug 2023 15:00:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 78C836361B;
        Thu, 24 Aug 2023 22:00:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2C80C433C8;
        Thu, 24 Aug 2023 22:00:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692914419;
        bh=QzZ3B29ZpeIXP1Docmt+R6yug/vu3LqFJ4ZpavpYzEQ=;
        h=Date:To:From:Subject:From;
        b=nWWWb+2rntfE78hzbASEWc2PagaaZnnF833484ysXFgdn6pjrZ/Z9+Ctswc7+NDYb
         KoC/NBpVx132j49d41Pw8VLg/xv6nuY+ZyNnGzGG/uHUfcx7xY7pOodSf7eg4td6Sa
         CgKRPqGNMp8eZyboxpu42vP85gSr3vKwauDtUcyg=
Date:   Thu, 24 Aug 2023 15:00:19 -0700
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        Liam.Howlett@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] maple_tree-disable-mas_wr_append-when-other-readers-are-possible.patch removed from -mm tree
Message-Id: <20230824220019.D2C80C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: maple_tree: disable mas_wr_append() when other readers are possible
has been removed from the -mm tree.  Its filename was
     maple_tree-disable-mas_wr_append-when-other-readers-are-possible.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: maple_tree: disable mas_wr_append() when other readers are possible
Date: Fri, 18 Aug 2023 20:43:55 -0400

The current implementation of append may cause duplicate data and/or
incorrect ranges to be returned to a reader during an update.  Although
this has not been reported or seen, disable the append write operation
while the tree is in rcu mode out of an abundance of caution.

During the analysis of the mas_next_slot() the following was
artificially created by separating the writer and reader code:

Writer:                                 reader:
mas_wr_append
    set end pivot
    updates end metata
    Detects write to last slot
    last slot write is to start of slot
    store current contents in slot
    overwrite old end pivot
                                        mas_next_slot():
                                                read end metadata
                                                read old end pivot
                                                return with incorrect range
    store new value

Alternatively:

Writer:                                 reader:
mas_wr_append
    set end pivot
    updates end metata
    Detects write to last slot
    last lost write to end of slot
    store value
                                        mas_next_slot():
                                                read end metadata
                                                read old end pivot
                                                read new end pivot
                                                return with incorrect range
    set old end pivot

There may be other accesses that are not safe since we are now updating
both metadata and pointers, so disabling append if there could be rcu
readers is the safest action.

Link: https://lkml.kernel.org/r/20230819004356.1454718-2-Liam.Howlett@oracle.com
Fixes: 54a611b60590 ("Maple Tree: add new data structure")
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/lib/maple_tree.c~maple_tree-disable-mas_wr_append-when-other-readers-are-possible
+++ a/lib/maple_tree.c
@@ -4265,6 +4265,10 @@ static inline unsigned char mas_wr_new_e
  * mas_wr_append: Attempt to append
  * @wr_mas: the maple write state
  *
+ * This is currently unsafe in rcu mode since the end of the node may be cached
+ * by readers while the node contents may be updated which could result in
+ * inaccurate information.
+ *
  * Return: True if appended, false otherwise
  */
 static inline bool mas_wr_append(struct ma_wr_state *wr_mas)
@@ -4274,6 +4278,9 @@ static inline bool mas_wr_append(struct
 	struct ma_state *mas = wr_mas->mas;
 	unsigned char node_pivots = mt_pivots[wr_mas->type];
 
+	if (mt_in_rcu(mas->tree))
+		return false;
+
 	if (mas->offset != wr_mas->node_end)
 		return false;
 
_

Patches currently in -mm which might be from Liam.Howlett@oracle.com are

maple_tree-clean-up-mas_wr_append.patch

