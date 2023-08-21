Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 630C3EE49AF
	for <mm-commits@archiver.kernel.org>; Mon, 21 Aug 2023 20:41:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229839AbjHUUlN (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 21 Aug 2023 16:41:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229874AbjHUUkh (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 21 Aug 2023 16:40:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A76F11B1
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 13:40:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0109564B0F
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 20:40:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51DACC433C7;
        Mon, 21 Aug 2023 20:40:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692650413;
        bh=SJAU7TUJDDi7POT+FmKRhdL0OoCHdZpWgS25O5/kW2I=;
        h=Date:To:From:Subject:From;
        b=DZqV9b13wtbIQAifb1HP0JcTzPtn7cgLI+K9fEurvu4i+VQaVX+4PM14TalmRdk8M
         mVtPOO3KYM9LOh8J1iGPLEbH212gzNVLw/e7e897YE1YIFLznWdR7cpnSvOASjgV8y
         R7IVGX0wqp/IchUbMyIXYpdn4BUSh1ixgm4reYJc=
Date:   Mon, 21 Aug 2023 13:40:12 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, surenb@google.com,
        paulmck@kernel.org, Liam.Howlett@oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maple_tree-change-mas_adopt_children-parent-usage.patch removed from -mm tree
Message-Id: <20230821204013.51DACC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: maple_tree: change mas_adopt_children() parent usage
has been removed from the -mm tree.  Its filename was
     maple_tree-change-mas_adopt_children-parent-usage.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: maple_tree: change mas_adopt_children() parent usage
Date: Fri, 4 Aug 2023 12:59:50 -0400

All calls to mas_adopt_children() currently pass the parent as the node in
the maple state.  Allow for the parent pointer that is passed in to be
used instead.

Link: https://lkml.kernel.org/r/20230804165951.2661157-6-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Paul E. McKenney <paulmck@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/maple_tree.c~maple_tree-change-mas_adopt_children-parent-usage
+++ a/lib/maple_tree.c
@@ -1702,7 +1702,7 @@ static inline void mas_adopt_children(st
 		struct maple_enode *parent)
 {
 	enum maple_type type = mte_node_type(parent);
-	struct maple_node *node = mas_mn(mas);
+	struct maple_node *node = mte_to_node(parent);
 	void __rcu **slots = ma_slots(node, type);
 	unsigned long *pivots = ma_pivots(node, type);
 	struct maple_enode *child;
_

Patches currently in -mm which might be from Liam.Howlett@oracle.com are

maple_tree-disable-mas_wr_append-when-other-readers-are-possible.patch
maple_tree-clean-up-mas_wr_append.patch

