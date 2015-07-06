From: akpm@linux-foundation.org
Subject: [to-be-updated] mm-provide-new-get_vaddr_frames-helper-fix.patch
 removed from -mm tree
Date: Mon, 06 Jul 2015 15:19:07 -0700
Message-ID: <559afedb.r4zSqyurnxGjjOyA%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33682 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754506AbbGFWTH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Jul 2015 18:19:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, hans.verkuil@cisco.com, jack@suse.cz, mchehab@osg.samsung.com, sergey.senozhatsky.work@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-provide-new-get_vaddr_frames-helper-fix
has been removed from the -mm tree.  Its filename was
     mm-provide-new-get_vaddr_frames-helper-fix.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-provide-new-get_vaddr_frames-helper-fix

use kvfree(), per Sergey

Cc: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff -puN mm/gup.c~mm-provide-new-get_vaddr_frames-helper-fix mm/gup.c
--- a/mm/gup.c~mm-provide-new-get_vaddr_frames-helper-fix
+++ a/mm/gup.c
@@ -1155,10 +1155,7 @@ void frame_vector_destroy(struct frame_v
 {
 	/* Make sure put_vaddr_frames() got called properly... */
 	VM_BUG_ON(vec->nr_frames > 0);
-	if (!is_vmalloc_addr(vec))
-		kfree(vec);
-	else
-		vfree(vec);
+	kvfree(vec);
 }
 EXPORT_SYMBOL(frame_vector_destroy);
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-move-get_vaddr_frames-behind-a-config-option.patch
mm-move-get_vaddr_frames-behind-a-config-option-fix.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
openrisc-fix-config_uid16-setting.patch
mm.patch
slab-infrastructure-for-bulk-object-allocation-and-freeing-v3-fix.patch
userfaultfd-change-the-read-api-to-return-a-uffd_msg-fix-2.patch
userfaultfd-change-the-read-api-to-return-a-uffd_msg-fix-2-fix.patch
userfaultfd-avoid-mmap_sem-read-recursion-in-mcopy_atomic-fix.patch
fs-userfaultfdc-work-around-i386-build-error.patch
include-linux-page-flagsh-rename-macros-to-avoid-collisions.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated.patch
x86-add-pmd_-for-thp-fix.patch
sparc-add-pmd_-for-thp-fix.patch
mm-support-madvisemadv_free-fix-2.patch
mm-dont-split-thp-page-when-syscall-is-called-fix-3.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix-fix.patch
linux-next.patch
drivers-gpu-drm-i915-intel_spritec-fix-build.patch
drivers-gpu-drm-i915-intel_tvc-fix-build.patch
net-netfilter-ipset-work-around-gcc-444-initializer-bug.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch

