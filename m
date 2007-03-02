From: akpm@linux-foundation.org
Subject: - vm-invalidate_inode_pages2_range-should-not-exit-early.patch removed from -mm tree
Date: Thu, 01 Mar 2007 21:07:37 -0800
Message-ID: <200703020507.l2257bj4000884@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:42407 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422764AbXCBFHk (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 2 Mar 2007 00:07:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Trond.Myklebust@netapp.com, mm-commits@vger.kernel.org


The patch titled
     VM: invalidate_inode_pages2_range() should not exit early
has been removed from the -mm tree.  Its filename was
     vm-invalidate_inode_pages2_range-should-not-exit-early.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: VM: invalidate_inode_pages2_range() should not exit early
From: Trond Myklebust <Trond.Myklebust@netapp.com>

Fix invalidate_inode_pages2_range() so that it does not immediately exit
just because a single page in the specified range could not be removed.

Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/truncate.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/truncate.c~vm-invalidate_inode_pages2_range-should-not-exit-early mm/truncate.c
--- a/mm/truncate.c~vm-invalidate_inode_pages2_range-should-not-exit-early
+++ a/mm/truncate.c
@@ -375,10 +375,10 @@ int invalidate_inode_pages2_range(struct
 
 	pagevec_init(&pvec, 0);
 	next = start;
-	while (next <= end && !ret && !wrapped &&
+	while (next <= end && !wrapped &&
 		pagevec_lookup(&pvec, mapping, next,
 			min(end - next, (pgoff_t)PAGEVEC_SIZE - 1) + 1)) {
-		for (i = 0; !ret && i < pagevec_count(&pvec); i++) {
+		for (i = 0; i < pagevec_count(&pvec); i++) {
 			struct page *page = pvec.pages[i];
 			pgoff_t page_index;
 
_

Patches currently in -mm which might be from Trond.Myklebust@netapp.com are

origin.patch
auth_gss-unregister-gss_domain-when-unloading-module.patch
nfs-kill-the-obsolete-nfs_paranoia.patch
nfs-nfs_getattr-cant-call-nfs_sync_mapping_range-for-non-regular-files.patch
