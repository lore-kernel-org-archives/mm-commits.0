Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E73FFC433EF
	for <mm-commits@archiver.kernel.org>; Tue, 10 May 2022 04:19:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236231AbiEJEXY (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 May 2022 00:23:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236100AbiEJEWW (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 May 2022 00:22:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C94D1BA8C1
        for <mm-commits@vger.kernel.org>; Mon,  9 May 2022 21:17:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1542C6176D
        for <mm-commits@vger.kernel.org>; Tue, 10 May 2022 04:17:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E023C385C8;
        Tue, 10 May 2022 04:17:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652156256;
        bh=/+IEhK595wCttfaWRnuen7H3TtSc/3aEjnM8hbQSEU8=;
        h=Date:To:From:Subject:From;
        b=PUdKvY1ANVs1SU8hquIQiMyiH6VvmRk1b97Ek8J+Rr5J9X76yxhwNotfeFuBjH5LW
         Yzson3PsAkmmKnjVJxePniq/97mDE2uVBnq6QFguIau4Z2uQmsN3/nT05TBI0GcFs8
         WdaUuT12YIbIR9XpWORuBJStgMyoowhCthqKafQY=
Date:   Mon, 09 May 2022 21:17:35 -0700
To:     mm-commits@vger.kernel.org, yangtiezhu@loongson.cn,
        viro@zeniv.linux.org.uk, hch@lst.de, bhe@redhat.com,
        amit.kachhap@arm.com, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] vmcore-convert-read_from_oldmem-to-take-an-iov_iter.patch removed from -mm tree
Message-Id: <20220510041736.6E023C385C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: vmcore: convert read_from_oldmem() to take an iov_iter
has been removed from the -mm tree.  Its filename was
     vmcore-convert-read_from_oldmem-to-take-an-iov_iter.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: vmcore: convert read_from_oldmem() to take an iov_iter

Remove the read_from_oldmem() wrapper introduced earlier and convert all
the remaining callers to pass an iov_iter.

Link: https://lkml.kernel.org/r/20220408090636.560886-4-bhe@redhat.com
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Baoquan He <bhe@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Cc: Tiezhu Yang <yangtiezhu@loongson.cn>
Cc: Amit Daniel Kachhap <amit.kachhap@arm.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/crash_dump_64.c |    7 ++++-
 fs/proc/vmcore.c                |   40 +++++++++++-------------------
 include/linux/crash_dump.h      |   10 +++----
 3 files changed, 25 insertions(+), 32 deletions(-)

--- a/arch/x86/kernel/crash_dump_64.c~vmcore-convert-read_from_oldmem-to-take-an-iov_iter
+++ a/arch/x86/kernel/crash_dump_64.c
@@ -54,6 +54,11 @@ ssize_t copy_oldmem_page_encrypted(struc
 
 ssize_t elfcorehdr_read(char *buf, size_t count, u64 *ppos)
 {
-	return read_from_oldmem(buf, count, ppos, 0,
+	struct kvec kvec = { .iov_base = buf, .iov_len = count };
+	struct iov_iter iter;
+
+	iov_iter_kvec(&iter, READ, &kvec, 1, count);
+
+	return read_from_oldmem(&iter, count, ppos,
 				cc_platform_has(CC_ATTR_GUEST_MEM_ENCRYPT));
 }
--- a/fs/proc/vmcore.c~vmcore-convert-read_from_oldmem-to-take-an-iov_iter
+++ a/fs/proc/vmcore.c
@@ -129,7 +129,7 @@ static int open_vmcore(struct inode *ino
 }
 
 /* Reads a page from the oldmem device from given offset. */
-static ssize_t read_from_oldmem_iter(struct iov_iter *iter, size_t count,
+ssize_t read_from_oldmem(struct iov_iter *iter, size_t count,
 			 u64 *ppos, bool encrypted)
 {
 	unsigned long pfn, offset;
@@ -178,27 +178,6 @@ static ssize_t read_from_oldmem_iter(str
 	return read;
 }
 
-ssize_t read_from_oldmem(char *buf, size_t count,
-			 u64 *ppos, int userbuf,
-			 bool encrypted)
-{
-	struct iov_iter iter;
-	struct iovec iov;
-	struct kvec kvec;
-
-	if (userbuf) {
-		iov.iov_base = (__force void __user *)buf;
-		iov.iov_len = count;
-		iov_iter_init(&iter, READ, &iov, 1, count);
-	} else {
-		kvec.iov_base = buf;
-		kvec.iov_len = count;
-		iov_iter_kvec(&iter, READ, &kvec, 1, count);
-	}
-
-	return read_from_oldmem_iter(&iter, count, ppos, encrypted);
-}
-
 /*
  * Architectures may override this function to allocate ELF header in 2nd kernel
  */
@@ -218,7 +197,12 @@ void __weak elfcorehdr_free(unsigned lon
  */
 ssize_t __weak elfcorehdr_read(char *buf, size_t count, u64 *ppos)
 {
-	return read_from_oldmem(buf, count, ppos, 0, false);
+	struct kvec kvec = { .iov_base = buf, .iov_len = count };
+	struct iov_iter iter;
+
+	iov_iter_kvec(&iter, READ, &kvec, 1, count);
+
+	return read_from_oldmem(&iter, count, ppos, false);
 }
 
 /*
@@ -226,7 +210,13 @@ ssize_t __weak elfcorehdr_read(char *buf
  */
 ssize_t __weak elfcorehdr_read_notes(char *buf, size_t count, u64 *ppos)
 {
-	return read_from_oldmem(buf, count, ppos, 0, cc_platform_has(CC_ATTR_MEM_ENCRYPT));
+	struct kvec kvec = { .iov_base = buf, .iov_len = count };
+	struct iov_iter iter;
+
+	iov_iter_kvec(&iter, READ, &kvec, 1, count);
+
+	return read_from_oldmem(&iter, count, ppos,
+			cc_platform_has(CC_ATTR_MEM_ENCRYPT));
 }
 
 /*
@@ -402,7 +392,7 @@ static ssize_t __read_vmcore(struct iov_
 					    m->offset + m->size - *fpos,
 					    iov_iter_count(iter));
 			start = m->paddr + *fpos - m->offset;
-			tmp = read_from_oldmem_iter(iter, tsz, &start,
+			tmp = read_from_oldmem(iter, tsz, &start,
 					cc_platform_has(CC_ATTR_MEM_ENCRYPT));
 			if (tmp < 0)
 				return tmp;
--- a/include/linux/crash_dump.h~vmcore-convert-read_from_oldmem-to-take-an-iov_iter
+++ a/include/linux/crash_dump.h
@@ -134,13 +134,11 @@ static inline int vmcore_add_device_dump
 #endif /* CONFIG_PROC_VMCORE_DEVICE_DUMP */
 
 #ifdef CONFIG_PROC_VMCORE
-ssize_t read_from_oldmem(char *buf, size_t count,
-			 u64 *ppos, int userbuf,
-			 bool encrypted);
+ssize_t read_from_oldmem(struct iov_iter *iter, size_t count,
+			 u64 *ppos, bool encrypted);
 #else
-static inline ssize_t read_from_oldmem(char *buf, size_t count,
-				       u64 *ppos, int userbuf,
-				       bool encrypted)
+static inline ssize_t read_from_oldmem(struct iov_iter *iter, size_t count,
+				       u64 *ppos, bool encrypted)
 {
 	return -EOPNOTSUPP;
 }
_

Patches currently in -mm which might be from willy@infradead.org are

shmem-convert-shmem_alloc_hugepage-to-use-vma_alloc_folio.patch
mm-huge_memory-convert-do_huge_pmd_anonymous_page-to-use-vma_alloc_folio.patch
alpha-fix-alloc_zeroed_user_highpage_movable.patch
mm-remove-alloc_pages_vma.patch
vmscan-use-folio_mapped-in-shrink_page_list.patch
vmscan-convert-the-writeback-handling-in-shrink_page_list-to-folios.patch
swap-turn-get_swap_page-into-folio_alloc_swap.patch
swap-convert-add_to_swap-to-take-a-folio.patch
vmscan-convert-dirty-page-handling-to-folios.patch
vmscan-convert-page-buffer-handling-to-use-folios.patch
vmscan-convert-lazy-freeing-to-folios.patch
vmscan-move-initialisation-of-mapping-down.patch
vmscan-convert-the-activate_locked-portion-of-shrink_page_list-to-folios.patch
mm-allow-can_split_folio-to-be-called-when-thp-are-disabled.patch
vmscan-remove-remaining-uses-of-page-in-shrink_page_list.patch
mm-shmem-use-a-folio-in-shmem_unused_huge_shrink.patch
mm-swap-add-folio_throttle_swaprate.patch
mm-shmem-convert-shmem_add_to_page_cache-to-take-a-folio.patch
mm-shmem-turn-shmem_should_replace_page-into-shmem_should_replace_folio.patch
mm-shmem-add-shmem_alloc_folio.patch
mm-shmem-convert-shmem_alloc_and_acct_page-to-use-a-folio.patch
mm-shmem-convert-shmem_getpage_gfp-to-use-a-folio.patch
mm-shmem-convert-shmem_swapin_page-to-shmem_swapin_folio.patch
mm-add-folio_mapping_flags.patch
mm-add-folio_test_movable.patch
mm-migrate-convert-move_to_new_page-into-move_to_new_folio.patch
mm-add-vma-iterator.patch
mmap-use-the-vma-iterator-in-count_vma_pages_range.patch
proc-remove-vma-rbtree-use-from-nommu.patch
arm64-remove-mmap-linked-list-from-vdso.patch
parisc-remove-mmap-linked-list-from-cache-handling.patch
powerpc-remove-mmap-linked-list-walks.patch
s390-remove-vma-linked-list-walks.patch
x86-remove-vma-linked-list-walks.patch
xtensa-remove-vma-linked-list-walks.patch
cxl-remove-vma-linked-list-walk.patch
optee-remove-vma-linked-list-walk.patch
um-remove-vma-linked-list-walk.patch
coredump-remove-vma-linked-list-walk.patch
exec-use-vma-iterator-instead-of-linked-list.patch
fs-proc-task_mmu-stop-using-linked-list-and-highest_vm_end.patch
acct-use-vma-iterator-instead-of-linked-list.patch
perf-use-vma-iterator.patch
sched-use-maple-tree-iterator-to-walk-vmas.patch
fork-use-vma-iterator.patch
mm-khugepaged-stop-using-vma-linked-list.patch
mm-ksm-use-vma-iterators-instead-of-vma-linked-list.patch
mm-mlock-use-vma-iterator-and-maple-state-instead-of-vma-linked-list.patch
mm-pagewalk-use-vma_find-instead-of-vma-linked-list.patch
i915-use-the-vma-iterator.patch
nommu-remove-uses-of-vma-linked-list.patch

