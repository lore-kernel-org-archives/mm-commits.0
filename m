Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52DACECAAA1
	for <mm-commits@archiver.kernel.org>; Fri, 28 Oct 2022 20:24:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229553AbiJ1UYP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 28 Oct 2022 16:24:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229515AbiJ1UYO (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 28 Oct 2022 16:24:14 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BEF51E8B88
        for <mm-commits@vger.kernel.org>; Fri, 28 Oct 2022 13:24:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D9981B82C90
        for <mm-commits@vger.kernel.org>; Fri, 28 Oct 2022 20:24:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6657EC433D6;
        Fri, 28 Oct 2022 20:24:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1666988650;
        bh=wCwEcoPRFu8pUOvbPQY6OhIVfQhHY69fNz4sJTCrnAk=;
        h=Date:To:From:Subject:From;
        b=HlBqQTZ5BGLlscXoXS7f7rsOOYouAEsy4AOk+XOK7q0ZWBHnzDrbipTS5upIuzVEH
         uQXNHCmbtir9Q80UexP0s481ebZAl3NGYA13xy4JJuiyvkJ8HOiaNJVWgVWIneUgiq
         9yDzee05VDARshRcy6rInlQdKaevpQt/ckh7KlM8=
Date:   Fri, 28 Oct 2022 13:24:09 -0700
To:     mm-commits@vger.kernel.org, lukas.bulwahn@gmail.com,
        Liam.Howlett@oracle.com, dan.carpenter@oracle.com,
        liam.howlett@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + maple_tree-mte_set_full-and-mte_clear_full-clang-analyzer-clean-up.patch added to mm-unstable branch
Message-Id: <20221028202410.6657EC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: maple_tree: mte_set_full() and mte_clear_full() clang-analyzer clean up
has been added to the -mm mm-unstable branch.  Its filename is
     maple_tree-mte_set_full-and-mte_clear_full-clang-analyzer-clean-up.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple_tree-mte_set_full-and-mte_clear_full-clang-analyzer-clean-up.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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

mmap-fix-remap_file_pages-regression.patch
maple_tree-remove-pointer-to-pointer-use-in-mas_alloc_nodes.patch
maple_tree-mas_anode_descend-clang-analyzer-clean-up.patch
maple_tree-reorganize-testing-to-restore-module-testing.patch
maple_tree-fix-mas_find_rev-comment.patch
maple_tree-update-copyright-dates-for-test-code.patch
maple_tree-mte_set_full-and-mte_clear_full-clang-analyzer-clean-up.patch

