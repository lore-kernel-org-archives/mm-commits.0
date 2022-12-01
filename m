Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50C97C352A1
	for <mm-commits@archiver.kernel.org>; Thu,  1 Dec 2022 00:00:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229780AbiLAAAl (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Nov 2022 19:00:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229975AbiLAAAY (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 30 Nov 2022 19:00:24 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E73C83EBC
        for <mm-commits@vger.kernel.org>; Wed, 30 Nov 2022 16:00:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9246161E69
        for <mm-commits@vger.kernel.org>; Thu,  1 Dec 2022 00:00:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA578C433C1;
        Thu,  1 Dec 2022 00:00:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669852820;
        bh=SejqET2c5J7LWoElJWpZCBKDuZxTDJRnXQraE97b6rM=;
        h=Date:To:From:Subject:From;
        b=XIXA9m3XLSQLwR+8Nof7LKrulkK34W6bbApwuW9pKtTSpy1ptqrFJtXf7FkD02eQK
         uNhtVK6j1FSPi4FVKFfQ8mp1T32KiP6/dT6yoSOtW+8EgR8+MA6BLIPd8ALjEpaBki
         CM7ux9YpjpAnlircqST6x/DxYaUrJ0tLSQX+Sw1Y=
Date:   Wed, 30 Nov 2022 16:00:20 -0800
To:     mm-commits@vger.kernel.org, lukas.bulwahn@gmail.com,
        Liam.Howlett@oracle.com, dan.carpenter@oracle.com,
        liam.howlett@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maple_tree-mte_set_full-and-mte_clear_full-clang-analyzer-clean-up.patch removed from -mm tree
Message-Id: <20221201000020.CA578C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: maple_tree: mte_set_full() and mte_clear_full() clang-analyzer clean up
has been removed from the -mm tree.  Its filename was
     maple_tree-mte_set_full-and-mte_clear_full-clang-analyzer-clean-up.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Liam Howlett <liam.howlett@oracle.com>
Subject: maple_tree: mte_set_full() and mte_clear_full() clang-analyzer clean up
Date: Fri, 28 Oct 2022 14:45:34 +0000

mte_set_full() and mte_clear_full() were incorrectly setting a pointer to
a value without returning a result.  Fix this by returning the modified
pointer to be use as necessary.  Also add a third function to return if
the bit is set or not.

Link: https://lore.kernel.org/lkml/20221026120029.12555-1-lukas.bulwahn@gmail.com/
Link: https://lkml.kernel.org/r/20221028144520.2776767-1-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Suggested-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Suggested-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

--- a/lib/maple_tree.c~maple_tree-mte_set_full-and-mte_clear_full-clang-analyzer-clean-up
+++ a/lib/maple_tree.c
@@ -323,14 +323,19 @@ static inline void *mte_safe_root(const
 	return (void *)((unsigned long)node & ~MAPLE_ROOT_NODE);
 }
 
-static inline void mte_set_full(const struct maple_enode *node)
+static inline void *mte_set_full(const struct maple_enode *node)
 {
-	node = (void *)((unsigned long)node & ~MAPLE_ENODE_NULL);
+	return (void *)((unsigned long)node & ~MAPLE_ENODE_NULL);
 }
 
-static inline void mte_clear_full(const struct maple_enode *node)
+static inline void *mte_clear_full(const struct maple_enode *node)
 {
-	node = (void *)((unsigned long)node | MAPLE_ENODE_NULL);
+	return (void *)((unsigned long)node | MAPLE_ENODE_NULL);
+}
+
+static inline bool mte_has_null(const struct maple_enode *node)
+{
+	return (unsigned long)node & MAPLE_ENODE_NULL;
 }
 
 static inline bool ma_is_root(struct maple_node *node)
_

Patches currently in -mm which might be from liam.howlett@oracle.com are

maple_tree-fix-mas_find_rev-comment.patch
maple_tree-update-copyright-dates-for-test-code.patch

