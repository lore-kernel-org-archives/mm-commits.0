From: akpm@linux-foundation.org
Subject: + ksm-fix-null-pointer-dereference-in-scan_get_next_rmap_item.patch added to -mm tree
Date: Thu, 09 Jun 2011 16:37:12 -0700
Message-ID: <201106092337.p59NbCQH008350@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51034 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756155Ab1FIXhX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Jun 2011 19:37:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hughd@google.com, aarcange@redhat.com, andrea@betterlinux.com, chrisw@sous-sol.org, stable@kernel.org


The patch titled
     ksm: fix NULL pointer dereference in scan_get_next_rmap_item()
has been added to the -mm tree.  Its filename is
     ksm-fix-null-pointer-dereference-in-scan_get_next_rmap_item.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ksm: fix NULL pointer dereference in scan_get_next_rmap_item()
From: Hugh Dickins <hughd@google.com>

Andrea Righi reported a case where an exiting task can race against
ksmd::scan_get_next_rmap_item (http://lkml.org/lkml/2011/6/1/742) easily
triggering a NULL pointer dereference in ksmd.

ksm_scan.mm_slot == &ksm_mm_head with only one registered mm

CPU 1 (__ksm_exit)		CPU 2 (scan_get_next_rmap_item)
 				list_empty() is false
lock				slot == &ksm_mm_head
list_del(slot->mm_list)
(list now empty)
unlock
				lock
				slot = list_entry(slot->mm_list.next)
				(list is empty, so slot is still ksm_mm_head)
				unlock
				slot->mm == NULL ... Oops

Close this race by revalidating that the new slot is not simply the list
head again.

Andrea's test case:

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/mman.h>

#define BUFSIZE getpagesize()

int main(int argc, char **argv)
{
	void *ptr;

	if (posix_memalign(&ptr, getpagesize(), BUFSIZE) < 0) {
		perror("posix_memalign");
		exit(1);
	}
	if (madvise(ptr, BUFSIZE, MADV_MERGEABLE) < 0) {
		perror("madvise");
		exit(1);
	}
	*(char *)NULL = 0;

	return 0;
}

Reported-by: Andrea Righi <andrea@betterlinux.com>
Tested-by: Andrea Righi <andrea@betterlinux.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Hugh Dickins <hughd@google.com>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/ksm.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN mm/ksm.c~ksm-fix-null-pointer-dereference-in-scan_get_next_rmap_item mm/ksm.c
--- a/mm/ksm.c~ksm-fix-null-pointer-dereference-in-scan_get_next_rmap_item
+++ a/mm/ksm.c
@@ -1302,6 +1302,12 @@ static struct rmap_item *scan_get_next_r
 		slot = list_entry(slot->mm_list.next, struct mm_slot, mm_list);
 		ksm_scan.mm_slot = slot;
 		spin_unlock(&ksm_mmlist_lock);
+		/*
+		 * Although we tested list_empty() above, a racing __ksm_exit
+		 * of the last mm on the list may have removed it since then.
+		 */
+		if (slot == &ksm_mm_head)
+			return NULL;
 next_mm:
 		ksm_scan.address = 0;
 		ksm_scan.rmap_list = &slot->rmap_list;
_

Patches currently in -mm which might be from hughd@google.com are

mm-fix-wrong-kunmap_atomic-pointer.patch
mm-migratec-dont-account-swapcache-as-shmem.patch
linux-next.patch
ksm-fix-null-pointer-dereference-in-scan_get_next_rmap_item.patch
mm-move-vmtruncate_range-to-truncatec.patch
mm-move-shmem-prototypes-to-shmem_fsh.patch
tmpfs-take-control-of-its-truncate_range.patch
tmpfs-add-shmem_read_mapping_page_gfp.patch
drm-ttm-use-shmem_read_mapping_page.patch
drm-i915-use-shmem_read_mapping_page.patch
drm-i915-use-shmem_truncate_range.patch
drm-i915-more-struct_mutex-locking.patch
mm-cleanup-descriptions-of-filler-arg.patch
mm-truncate-functions-are-in-truncatec.patch
mm-tidy-vmtruncate_range-and-related-functions.patch
mm-consistent-truncate-and-invalidate-loops.patch
mm-pincer-in-truncate_inode_pages_range.patch
tmpfs-no-need-to-use-i_lock.patch
prio_tree-debugging-patch.patch

