From: akpm@linux-foundation.org
Subject: [folded] fs-make-sure-data-stored-into-inode-is-properly-seen-before-unlocking-new-inode-fix.patch removed from -mm tree
Date: Mon, 21 Sep 2009 15:14:06 -0700
Message-ID: <200909212214.n8LME67C010507@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48607 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753405AbZIUWPV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 21 Sep 2009 18:15:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, hch@infradead.org, jack@suse.cz, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     fs-make-sure-data-stored-into-inode-is-properly-seen-before-unlocking-new-inode-fix
has been removed from the -mm tree.  Its filename was
     fs-make-sure-data-stored-into-inode-is-properly-seen-before-unlocking-new-inode-fix.patch

This patch was dropped because it was folded into fs-make-sure-data-stored-into-inode-is-properly-seen-before-unlocking-new-inode.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fs-make-sure-data-stored-into-inode-is-properly-seen-before-unlocking-new-inode-fix
From: Andrew Morton <akpm@linux-foundation.org>

add some commentary

Cc: <stable@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/inode.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff -puN fs/inode.c~fs-make-sure-data-stored-into-inode-is-properly-seen-before-unlocking-new-inode-fix fs/inode.c
--- a/fs/inode.c~fs-make-sure-data-stored-into-inode-is-properly-seen-before-unlocking-new-inode-fix
+++ a/fs/inode.c
@@ -697,12 +697,13 @@ void unlock_new_inode(struct inode *inod
 	}
 #endif
 	/*
-	 * This is special!  We do not need the spinlock
-	 * when clearing I_LOCK, because we're guaranteed
-	 * that nobody else tries to do anything about the
-	 * state of the inode when it is locked, as we
-	 * just created it (so there can be no old holders
-	 * that haven't tested I_LOCK).
+	 * This is special!  We do not need the spinlock when clearing I_LOCK,
+	 * because we're guaranteed that nobody else tries to do anything about
+	 * the state of the inode when it is locked, as we just created it (so
+	 * there can be no old holders that haven't tested I_LOCK).
+	 * However we must emit the memory barrier so that other CPUs reliably
+	 * see the clearing of I_LOCK after the other inode initialisation has
+	 * completed.
 	 */
 	smp_mb();
 	WARN_ON((inode->i_state & (I_LOCK|I_NEW)) != (I_LOCK|I_NEW));
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
fs-make-sure-data-stored-into-inode-is-properly-seen-before-unlocking-new-inode.patch
fs-make-sure-data-stored-into-inode-is-properly-seen-before-unlocking-new-inode-fix.patch
drivers-mfd-ab3100-corec-fiw-warning-and-powerpc-build-error.patch
mm-make-swap-token-dummies-static-inlines.patch
memory-hotplug-update-zone-pcp-at-memory-online.patch
revert-hugetlb-restore-interleaving-of-bootmem-huge-pages-2631.patch
vmscan-dont-attempt-to-reclaim-anon-page-in-lumpy-reclaim-when-no-swap-space-is-avilable.patch
revert-proc-kcore-work-around-a-bug.patch
arches-drop-superfluous-casts-in-nr_free_pages-callers.patch
tracing-page-allocator-add-trace-event-for-page-traffic-related-to-the-buddy-lists.patch
page-allocator-maintain-rolling-count-of-pages-to-free-from-the-pcp.patch
hugetlb-add-map_hugetlb-for-mmaping-pseudo-anonymous-huge-page-regions.patch
alpha-convert-to-use-arch_gettimeoffset.patch
cpuidle-fix-the-menu-governor-to-boost-io-performance.patch

