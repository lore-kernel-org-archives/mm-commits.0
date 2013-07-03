From: akpm@linux-foundation.org
Subject: [folded-merged] vmcore-support-mmap-on-proc-vmcore-fix.patch
 removed from -mm tree
Date: Wed, 03 Jul 2013 14:31:36 -0700
Message-ID: <51d49838.tVjKr2muUKiybUsT%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40017 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932221Ab3GCVbi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Jul 2013 17:31:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, zhangyanfei@cn.fujitsu.com, vgoyal@redhat.com, lisa.mitchell@hp.com, kumagai-atsushi@mxc.nes.nec.co.jp, kosaki.motohiro@jp.fujitsu.com, d.hatayama@jp.fujitsu.com, akpm@linux-foundation.org

Subject: [folded-merged] vmcore-support-mmap-on-proc-vmcore-fix.patch removed from -mm tree
To: akpm@linux-foundation.org,d.hatayama@jp.fujitsu.com,kosaki.motohiro@jp.fujitsu.com,kumagai-atsushi@mxc.nes.nec.co.jp,lisa.mitchell@hp.com,vgoyal@redhat.com,zhangyanfei@cn.fujitsu.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 03 Jul 2013 14:31:36 -0700


The patch titled
     Subject: vmcore-support-mmap-on-proc-vmcore-fix
has been removed from the -mm tree.  Its filename was
     vmcore-support-mmap-on-proc-vmcore-fix.patch

This patch was dropped because it was folded into vmcore-support-mmap-on-proc-vmcore.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: vmcore-support-mmap-on-proc-vmcore-fix

use min(), switch to conventional error-unwinding approach

Cc: Atsushi Kumagai <kumagai-atsushi@mxc.nes.nec.co.jp>
Cc: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Lisa Mitchell <lisa.mitchell@hp.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/vmcore.c |   27 ++++++++++-----------------
 1 file changed, 10 insertions(+), 17 deletions(-)

diff -puN fs/proc/vmcore.c~vmcore-support-mmap-on-proc-vmcore-fix fs/proc/vmcore.c
--- a/fs/proc/vmcore.c~vmcore-support-mmap-on-proc-vmcore-fix
+++ a/fs/proc/vmcore.c
@@ -218,9 +218,7 @@ static int mmap_vmcore(struct file *file
 	if (start < elfcorebuf_sz) {
 		u64 pfn;
 
-		tsz = elfcorebuf_sz - start;
-		if (size < tsz)
-			tsz = size;
+		tsz = min(elfcorebuf_sz - (size_t)start, size);
 		pfn = __pa(elfcorebuf + start) >> PAGE_SHIFT;
 		if (remap_pfn_range(vma, vma->vm_start, pfn, tsz,
 				    vma->vm_page_prot))
@@ -236,15 +234,11 @@ static int mmap_vmcore(struct file *file
 	if (start < elfcorebuf_sz + elfnotes_sz) {
 		void *kaddr;
 
-		tsz = elfcorebuf_sz + elfnotes_sz - start;
-		if (size < tsz)
-			tsz = size;
+		tsz = min(elfcorebuf_sz + elfnotes_sz - (size_t)start, size);
 		kaddr = elfnotes_buf + start - elfcorebuf_sz;
 		if (remap_vmalloc_range_partial(vma, vma->vm_start + len,
-						kaddr, tsz)) {
-			do_munmap(vma->vm_mm, vma->vm_start, len);
-			return -EAGAIN;
-		}
+						kaddr, tsz))
+			goto fail;
 		size -= tsz;
 		start += tsz;
 		len += tsz;
@@ -257,16 +251,12 @@ static int mmap_vmcore(struct file *file
 		if (start < m->offset + m->size) {
 			u64 paddr = 0;
 
-			tsz = m->offset + m->size - start;
-			if (size < tsz)
-				tsz = size;
+			tsz = min_t(size_t, m->offset + m->size - start, size);
 			paddr = m->paddr + start - m->offset;
 			if (remap_pfn_range(vma, vma->vm_start + len,
 					    paddr >> PAGE_SHIFT, tsz,
-					    vma->vm_page_prot)) {
-				do_munmap(vma->vm_mm, vma->vm_start, len);
-				return -EAGAIN;
-			}
+					    vma->vm_page_prot))
+				goto fail;
 			size -= tsz;
 			start += tsz;
 			len += tsz;
@@ -277,6 +267,9 @@ static int mmap_vmcore(struct file *file
 	}
 
 	return 0;
+fail:
+	do_munmap(vma->vm_mm, vma->vm_start, len);
+	return -EAGAIN;
 }
 
 static const struct file_operations proc_vmcore_operations = {
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
vmcore-allocate-elf-note-segment-in-the-2nd-kernel-vmalloc-memory.patch
vmcore-allow-user-process-to-remap-elf-note-segment-buffer.patch
vmcore-support-mmap-on-proc-vmcore.patch
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

