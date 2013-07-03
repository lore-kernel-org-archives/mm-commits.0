From: akpm@linux-foundation.org
Subject: [folded-merged]
 vmcore-allocate-buffer-for-elf-headers-on-page-size-alignment-fix.patch
 removed from -mm tree
Date: Wed, 03 Jul 2013 14:29:39 -0700
Message-ID: <51d497c3.LN1Cea6H7dFC857c%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39986 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751395Ab3GCV3k (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Jul 2013 17:29:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, zhangyanfei@cn.fujitsu.com, vgoyal@redhat.com, lisa.mitchell@hp.com, kumagai-atsushi@mxc.nes.nec.co.jp, kosaki.motohiro@jp.fujitsu.com, d.hatayama@jp.fujitsu.com, akpm@linux-foundation.org

Subject: [folded-merged] vmcore-allocate-buffer-for-elf-headers-on-page-size-alignment-fix.patch removed from -mm tree
To: akpm@linux-foundation.org,d.hatayama@jp.fujitsu.com,kosaki.motohiro@jp.fujitsu.com,kumagai-atsushi@mxc.nes.nec.co.jp,lisa.mitchell@hp.com,vgoyal@redhat.com,zhangyanfei@cn.fujitsu.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 03 Jul 2013 14:29:39 -0700


The patch titled
     Subject: vmcore-allocate-buffer-for-elf-headers-on-page-size-alignment-fix
has been removed from the -mm tree.  Its filename was
     vmcore-allocate-buffer-for-elf-headers-on-page-size-alignment-fix.patch

This patch was dropped because it was folded into vmcore-allocate-buffer-for-elf-headers-on-page-size-alignment.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: vmcore-allocate-buffer-for-elf-headers-on-page-size-alignment-fix

Cc: Atsushi Kumagai <kumagai-atsushi@mxc.nes.nec.co.jp>
Cc: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Lisa Mitchell <lisa.mitchell@hp.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/vmcore.c |   69 ++++++++++++++++++++-------------------------
 1 file changed, 31 insertions(+), 38 deletions(-)

diff -puN fs/proc/vmcore.c~vmcore-allocate-buffer-for-elf-headers-on-page-size-alignment-fix fs/proc/vmcore.c
--- a/fs/proc/vmcore.c~vmcore-allocate-buffer-for-elf-headers-on-page-size-alignment-fix
+++ a/fs/proc/vmcore.c
@@ -477,6 +477,12 @@ static void __init set_vmcore_list_offse
 	}
 }
 
+static void free_elfcorebuf(void)
+{
+	free_pages((unsigned long)elfcorebuf, get_order(elfcorebuf_sz_orig));
+	elfcorebuf = NULL;
+}
+
 static int __init parse_crash_elf64_headers(void)
 {
 	int rc=0;
@@ -505,36 +511,31 @@ static int __init parse_crash_elf64_head
 	}
 
 	/* Read in all elf headers. */
-	elfcorebuf_sz_orig = sizeof(Elf64_Ehdr) + ehdr.e_phnum * sizeof(Elf64_Phdr);
+	elfcorebuf_sz_orig = sizeof(Elf64_Ehdr) +
+				ehdr.e_phnum * sizeof(Elf64_Phdr);
 	elfcorebuf_sz = elfcorebuf_sz_orig;
-	elfcorebuf = (void *) __get_free_pages(GFP_KERNEL | __GFP_ZERO,
-					       get_order(elfcorebuf_sz_orig));
+	elfcorebuf = (void *)__get_free_pages(GFP_KERNEL | __GFP_ZERO,
+					      get_order(elfcorebuf_sz_orig));
 	if (!elfcorebuf)
 		return -ENOMEM;
 	addr = elfcorehdr_addr;
 	rc = read_from_oldmem(elfcorebuf, elfcorebuf_sz_orig, &addr, 0);
-	if (rc < 0) {
-		free_pages((unsigned long)elfcorebuf,
-			   get_order(elfcorebuf_sz_orig));
-		return rc;
-	}
+	if (rc < 0)
+		goto fail;
 
 	/* Merge all PT_NOTE headers into one. */
 	rc = merge_note_headers_elf64(elfcorebuf, &elfcorebuf_sz, &vmcore_list);
-	if (rc) {
-		free_pages((unsigned long)elfcorebuf,
-			   get_order(elfcorebuf_sz_orig));
-		return rc;
-	}
+	if (rc)
+		goto fail;
 	rc = process_ptload_program_headers_elf64(elfcorebuf, elfcorebuf_sz,
 							&vmcore_list);
-	if (rc) {
-		free_pages((unsigned long)elfcorebuf,
-			   get_order(elfcorebuf_sz_orig));
-		return rc;
-	}
+	if (rc)
+		goto fail;
 	set_vmcore_list_offsets(elfcorebuf_sz, &vmcore_list);
 	return 0;
+fail:
+	free_elfcorebuf();
+	return rc;
 }
 
 static int __init parse_crash_elf32_headers(void)
@@ -567,34 +568,28 @@ static int __init parse_crash_elf32_head
 	/* Read in all elf headers. */
 	elfcorebuf_sz_orig = sizeof(Elf32_Ehdr) + ehdr.e_phnum * sizeof(Elf32_Phdr);
 	elfcorebuf_sz = elfcorebuf_sz_orig;
-	elfcorebuf = (void *) __get_free_pages(GFP_KERNEL | __GFP_ZERO,
-					       get_order(elfcorebuf_sz_orig));
+	elfcorebuf = (void *)__get_free_pages(GFP_KERNEL | __GFP_ZERO,
+					      get_order(elfcorebuf_sz_orig));
 	if (!elfcorebuf)
 		return -ENOMEM;
 	addr = elfcorehdr_addr;
 	rc = read_from_oldmem(elfcorebuf, elfcorebuf_sz_orig, &addr, 0);
-	if (rc < 0) {
-		free_pages((unsigned long)elfcorebuf,
-			   get_order(elfcorebuf_sz_orig));
-		return rc;
-	}
+	if (rc < 0)
+		goto fail;
 
 	/* Merge all PT_NOTE headers into one. */
 	rc = merge_note_headers_elf32(elfcorebuf, &elfcorebuf_sz, &vmcore_list);
-	if (rc) {
-		free_pages((unsigned long)elfcorebuf,
-			   get_order(elfcorebuf_sz_orig));
-		return rc;
-	}
+	if (rc)
+		goto fail;
 	rc = process_ptload_program_headers_elf32(elfcorebuf, elfcorebuf_sz,
 								&vmcore_list);
-	if (rc) {
-		free_pages((unsigned long)elfcorebuf,
-			   get_order(elfcorebuf_sz_orig));
-		return rc;
-	}
+	if (rc)
+		goto fail;
 	set_vmcore_list_offsets(elfcorebuf_sz, &vmcore_list);
 	return 0;
+fail:
+	free_elfcorebuf();
+	return rc;
 }
 
 static int __init parse_crash_elf_headers(void)
@@ -672,8 +667,6 @@ void vmcore_cleanup(void)
 		list_del(&m->list);
 		kfree(m);
 	}
-	free_pages((unsigned long)elfcorebuf,
-		   get_order(elfcorebuf_sz_orig));
-	elfcorebuf = NULL;
+	free_elfcorebuf();
 }
 EXPORT_SYMBOL_GPL(vmcore_cleanup);
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
vmalloc-introduce-remap_vmalloc_range_partial-fix.patch
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

