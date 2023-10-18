Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88073C41513
	for <mm-commits@archiver.kernel.org>; Wed, 18 Oct 2023 21:44:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232130AbjJRVoB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Oct 2023 17:44:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344874AbjJRVn4 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Oct 2023 17:43:56 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF08311F
        for <mm-commits@vger.kernel.org>; Wed, 18 Oct 2023 14:43:54 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC68AC433CC;
        Wed, 18 Oct 2023 21:43:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1697665434;
        bh=9NFsvu7JMrK22LSbCCJIa5qrbl4xk/Kl6nICwIo3ve8=;
        h=Date:To:From:Subject:From;
        b=ScVYjpCSc6XMcEtWWANSb7jz650yB5wiUL0EUvrW410fBu91kWBesTIBZ0IGTRaNU
         faNSIomSk5qtskejTzd9LEqyPq5IaNy9nxG12vtj9kBJeiX8SvjRcGA4jYXpyGs0zq
         oq/u9U8sAG5K3SLEZ0QQfLcWp1BUhAE1pP6PKfFE=
Date:   Wed, 18 Oct 2023 14:43:54 -0700
To:     mm-commits@vger.kernel.org, adobriyan@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] proc-save-loc-by-using-while-loop.patch removed from -mm tree
Message-Id: <20231018214354.AC68AC433CC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: proc: save LOC by using while loop
has been removed from the -mm tree.  Its filename was
     proc-save-loc-by-using-while-loop.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


