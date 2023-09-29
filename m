Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 853EDE728CF
	for <mm-commits@archiver.kernel.org>; Fri, 29 Sep 2023 18:45:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233310AbjI2Sp0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 29 Sep 2023 14:45:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233493AbjI2SpZ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 29 Sep 2023 14:45:25 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75B991A4
        for <mm-commits@vger.kernel.org>; Fri, 29 Sep 2023 11:45:22 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E556C433C7;
        Fri, 29 Sep 2023 18:45:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696013122;
        bh=xbQbUvpDdTHZi4SKrYHqJGZU0ZzzTXLKkyjKTsyx7dk=;
        h=Date:To:From:Subject:From;
        b=rxo40aqeizU79SL/UePqKEM2YNJ0hBjXCa+MU9o0xrCqUlGwMxnPaochAnVzXqeoq
         WnopG+uTAmv9Hq2TpqtOWATCLX0GD+090omi08fSmC32hMYelEgYPdxwXRRP24Voj0
         YyMzFG1Cc14V9KE6PcQ0xr6r9R6knkpwz8DHINqU=
Date:   Fri, 29 Sep 2023 11:45:21 -0700
To:     mm-commits@vger.kernel.org, adobriyan@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + proc-save-loc-by-using-while-loop.patch added to mm-nonmm-unstable branch
Message-Id: <20230929184522.0E556C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: proc: save LOC by using while loop
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     proc-save-loc-by-using-while-loop.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/proc-save-loc-by-using-while-loop.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: proc: save LOC by using while loop
Date: Fri, 29 Sep 2023 19:31:41 +0300

Use while loop instead of infinite loop with "break;".

Also move some variable to the inner scope where they belong.

Link: https://lkml.kernel.org/r/82c8f8e7-8ded-46ca-8857-e60b991d6205@p183
Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/inode.c |   11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

--- a/fs/proc/inode.c~proc-save-loc-by-using-while-loop
+++ a/fs/proc/inode.c
@@ -110,18 +110,15 @@ void __init proc_init_kmemcache(void)
 
 void proc_invalidate_siblings_dcache(struct hlist_head *inodes, spinlock_t *lock)
 {
-	struct inode *inode;
-	struct proc_inode *ei;
 	struct hlist_node *node;
 	struct super_block *old_sb = NULL;
 
 	rcu_read_lock();
-	for (;;) {
+	while ((node = hlist_first_rcu(inodes))) {
+		struct proc_inode *ei = hlist_entry(node, struct proc_inode, sibling_inodes);
 		struct super_block *sb;
-		node = hlist_first_rcu(inodes);
-		if (!node)
-			break;
-		ei = hlist_entry(node, struct proc_inode, sibling_inodes);
+		struct inode *inode;
+
 		spin_lock(lock);
 		hlist_del_init_rcu(&ei->sibling_inodes);
 		spin_unlock(lock);
_

Patches currently in -mm which might be from adobriyan@gmail.com are

extract-and-use-file_line-macro.patch
proc-use-initializer-for-clearing-some-buffers.patch
proc-save-loc-by-using-while-loop.patch

