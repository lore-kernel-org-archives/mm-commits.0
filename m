From: akpm@linux-foundation.org
Subject: [folded-merged]
 vmalloc-introduce-remap_vmalloc_range_partial-fix.patch removed from -mm
 tree
Date: Wed, 03 Jul 2013 14:30:28 -0700
Message-ID: <51d497f4.AQmroqlJcZ1wfJqP%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39997 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753622Ab3GCVa3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Jul 2013 17:30:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, zhangyanfei@cn.fujitsu.com, vgoyal@redhat.com, lisa.mitchell@hp.com, kumagai-atsushi@mxc.nes.nec.co.jp, kosaki.motohiro@jp.fujitsu.com, d.hatayama@jp.fujitsu.com, akpm@linux-foundation.org

Subject: [folded-merged] vmalloc-introduce-remap_vmalloc_range_partial-fix.patch removed from -mm tree
To: akpm@linux-foundation.org,d.hatayama@jp.fujitsu.com,kosaki.motohiro@jp.fujitsu.com,kumagai-atsushi@mxc.nes.nec.co.jp,lisa.mitchell@hp.com,vgoyal@redhat.com,zhangyanfei@cn.fujitsu.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 03 Jul 2013 14:30:28 -0700


The patch titled
     Subject: vmalloc-introduce-remap_vmalloc_range_partial-fix
has been removed from the -mm tree.  Its filename was
     vmalloc-introduce-remap_vmalloc_range_partial-fix.patch

This patch was dropped because it was folded into vmalloc-introduce-remap_vmalloc_range_partial.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: vmalloc-introduce-remap_vmalloc_range_partial-fix

use PAGE_ALIGNED()

Cc: Atsushi Kumagai <kumagai-atsushi@mxc.nes.nec.co.jp>
Cc: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Lisa Mitchell <lisa.mitchell@hp.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff -puN mm/vmalloc.c~vmalloc-introduce-remap_vmalloc_range_partial-fix mm/vmalloc.c
--- a/mm/vmalloc.c~vmalloc-introduce-remap_vmalloc_range_partial-fix
+++ a/mm/vmalloc.c
@@ -1476,10 +1476,9 @@ static void __vunmap(const void *addr, i
 	if (!addr)
 		return;
 
-	if ((PAGE_SIZE-1) & (unsigned long)addr) {
-		WARN(1, KERN_ERR "Trying to vfree() bad address (%p)\n", addr);
+	if (WARN(!PAGE_ALIGNED(addr), "Trying to vfree() bad address (%p)\n",
+			addr));
 		return;
-	}
 
 	area = remove_vm_area(addr);
 	if (unlikely(!area)) {
@@ -2170,8 +2169,7 @@ int remap_vmalloc_range_partial(struct v
 
 	size = PAGE_ALIGN(size);
 
-	if (((PAGE_SIZE-1) & (unsigned long)uaddr) ||
-	    ((PAGE_SIZE-1) & (unsigned long)kaddr))
+	if (!PAGE_ALIGNED(uaddr) || !PAGE_ALIGNED(kaddr))
 		return -EINVAL;
 
 	area = find_vm_area(kaddr);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
include-linux-smph-on_each_cpu-switch-back-to-a-macro.patch
sound-soc-codecs-si476xc-dont-use-0bnnn.patch
ocfs2-xattr-remove-useless-free-space-checking.patch
ocfs2-rework-transaction-rollback-in-ocfs2_relink_block_group-fix.patch
ocfs2-fix-readonly-issue-in-ocfs2_unlink.patch
ocfs2-adjust-switch_case-syntax-at-o2net_state_change.patch
clear_refs-sanitize-accepted-commands-declaration.patch
mm-remove-compressed-copy-from-zram-in-memory.patch
memory_hotplug-use-pgdat_resize_lock-in-__offline_pages.patch
include-linux-mmh-add-page_aligned-helper.patch
vmcore-allocate-buffer-for-elf-headers-on-page-size-alignment.patch
vmalloc-introduce-remap_vmalloc_range_partial.patch
vmcore-allocate-elf-note-segment-in-the-2nd-kernel-vmalloc-memory-fix.patch
vmcore-allow-user-process-to-remap-elf-note-segment-buffer-fix.patch
vmcore-support-mmap-on-proc-vmcore-fix.patch
mm-remove-lru-parameter-from-__lru_cache_add-and-lru_cache_add_lru.patch
mm-tune-vm_committed_as-percpu_counter-batching-size-fix.patch
swap-discard-while-swapping-only-if-swap_flag_discard_pages-fix.patch
mm-use-a-dedicated-lock-to-protect-totalram_pages-and-zone-managed_pages-fix.patch
mm-correctly-update-zone-managed_pages-fix.patch
mm-correctly-update-zone-managed_pages-fix-fix-fix.patch
clean-up-scary-strncpydst-src-strlensrc-uses-fix.patch
dump_stack-serialize-the-output-from-dump_stack-fix.patch
checkpatch-warn-when-using-gccs-binary-constant-extension.patch
rtc-add-nxp-pcf2127-support-i2c-fix.patch
ptrace-add-ability-to-get-set-signal-blocked-mask-fix.patch
dev-oldmem-remove-the-interface-fix.patch
idr-print-a-stack-dump-after-ida_remove-warning-fix.patch
documentation-accounting-getdelaysc-avoid-strncpy-in-accounting-tool-fix.patch
drivers-w1-slaves-w1_ds2408c-add-magic-sequence-to-disable-p0-test-mode-fix.patch
tools-testing-selftests-dont-assume-the-x-bit-is-set-on-scripts.patch

