Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BEC7194AD1
	for <mm-commits@vger.kernel.org>; Wed,  4 Dec 2024 22:13:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733350393; cv=none; b=CsZXzhsaQ0ynL4P/rmXY672letzYoGUPLtHBh5dlpdAQUO3L6SG5lKNcMZ6ZGtcpYg4+dTx7p26edGn64Ms13sKSheqiLUCZ+86Gx0tqxwRmdXaSLGegek4qJGVzBRZhnFwpRTZYs/pals2fJKclczPe6s0ZCCDpE0yEqz0eVJw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733350393; c=relaxed/simple;
	bh=PPfqDZ+XphvZeHxuhywrZRHwF2Yq3P4nwMUocXD83Jk=;
	h=Date:To:From:Subject:Message-Id; b=CDGVaK+veXmUPVeWu3LnQ8dx227BmqG80D+YQoQrmn+WB4Dn4KvVZlDC/2guEryN66hPbEMos79KiqFLakZXwmmYL+1HIjKCl073m5v3ThRLvjwnLIgXRMFT2BK16X3JDnOSoReeJwOxCZpWsM+kU5QL4/KYQzPg9nLj2+14DbU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=dbDnLOGl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="dbDnLOGl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8FA7C4CECD;
	Wed,  4 Dec 2024 22:13:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1733350392;
	bh=PPfqDZ+XphvZeHxuhywrZRHwF2Yq3P4nwMUocXD83Jk=;
	h=Date:To:From:Subject:From;
	b=dbDnLOGlucXq1DuttoA2Hh3+dIdzbrzvgto1lq94h8tw1YBj131zpw7a5xa3n5fnw
	 tZWxwZpUQ8glSSRAUQzxbQXfaJS+a7NN+l1orE9kDfyO+W4yAc7iEJhb60i4VoxNLT
	 hMuHLh/VcD572B4mQtpMBexJbRqTfR4umEwZsYEQ=
Date: Wed, 04 Dec 2024 14:13:12 -0800
To: mm-commits@vger.kernel.org,xuanzhuo@linux.alibaba.com,vgoyal@redhat.com,thuth@redhat.com,svens@linux.ibm.com,mst@redhat.com,jasowang@redhat.com,imbrenda@linux.ibm.com,hca@linux.ibm.com,gor@linux.ibm.com,frankja@linux.ibm.com,farman@linux.ibm.com,eperezma@redhat.com,dyoung@redhat.com,cohuck@redhat.com,borntraeger@linux.ibm.com,bhe@redhat.com,agordeev@linux.ibm.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + fs-proc-vmcore-factor-out-allocating-a-vmcore-range-and-adding-it-to-a-list.patch added to mm-unstable branch
Message-Id: <20241204221312.B8FA7C4CECD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: fs/proc/vmcore: factor out allocating a vmcore range and adding it to a list
has been added to the -mm mm-unstable branch.  Its filename is
     fs-proc-vmcore-factor-out-allocating-a-vmcore-range-and-adding-it-to-a-list.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fs-proc-vmcore-factor-out-allocating-a-vmcore-range-and-adding-it-to-a-list.patch

This patch will later appear in the mm-unstable branch at
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
From: David Hildenbrand <david@redhat.com>
Subject: fs/proc/vmcore: factor out allocating a vmcore range and adding it to a list
Date: Wed, 4 Dec 2024 13:54:37 +0100

Let's factor it out into include/linux/crash_dump.h, from where we can use
it also outside of vmcore.c later.

Link: https://lkml.kernel.org/r/20241204125444.1734652-7-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Acked-by: Baoquan He <bhe@redhat.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: Cornelia Huck <cohuck@redhat.com>
Cc: Dave Young <dyoung@redhat.com>
Cc: Eric Farman <farman@linux.ibm.com>
Cc: Eugenio Pérez <eperezma@redhat.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Janosch Frank <frankja@linux.ibm.com>
Cc: Jason Wang <jasowang@redhat.com>
Cc: Michael S. Tsirkin <mst@redhat.com>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Thomas Huth <thuth@redhat.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/vmcore.c           |   21 ++-------------------
 include/linux/crash_dump.h |   14 ++++++++++++++
 2 files changed, 16 insertions(+), 19 deletions(-)

--- a/fs/proc/vmcore.c~fs-proc-vmcore-factor-out-allocating-a-vmcore-range-and-adding-it-to-a-list
+++ a/fs/proc/vmcore.c
@@ -709,11 +709,6 @@ static const struct proc_ops vmcore_proc
 	.proc_mmap	= mmap_vmcore,
 };
 
-static struct vmcore_range * __init get_new_element(void)
-{
-	return kzalloc(sizeof(struct vmcore_range), GFP_KERNEL);
-}
-
 static u64 get_vmcore_size(size_t elfsz, size_t elfnotesegsz,
 			   struct list_head *vc_list)
 {
@@ -1116,7 +1111,6 @@ static int __init process_ptload_program
 						size_t elfnotes_sz,
 						struct list_head *vc_list)
 {
-	struct vmcore_range *new;
 	int i;
 	Elf64_Ehdr *ehdr_ptr;
 	Elf64_Phdr *phdr_ptr;
@@ -1139,13 +1133,8 @@ static int __init process_ptload_program
 		end = roundup(paddr + phdr_ptr->p_memsz, PAGE_SIZE);
 		size = end - start;
 
-		/* Add this contiguous chunk of memory to vmcore list.*/
-		new = get_new_element();
-		if (!new)
+		if (vmcore_alloc_add_range(vc_list, start, size))
 			return -ENOMEM;
-		new->paddr = start;
-		new->size = size;
-		list_add_tail(&new->list, vc_list);
 
 		/* Update the program header offset. */
 		phdr_ptr->p_offset = vmcore_off + (paddr - start);
@@ -1159,7 +1148,6 @@ static int __init process_ptload_program
 						size_t elfnotes_sz,
 						struct list_head *vc_list)
 {
-	struct vmcore_range *new;
 	int i;
 	Elf32_Ehdr *ehdr_ptr;
 	Elf32_Phdr *phdr_ptr;
@@ -1182,13 +1170,8 @@ static int __init process_ptload_program
 		end = roundup(paddr + phdr_ptr->p_memsz, PAGE_SIZE);
 		size = end - start;
 
-		/* Add this contiguous chunk of memory to vmcore list.*/
-		new = get_new_element();
-		if (!new)
+		if (vmcore_alloc_add_range(vc_list, start, size))
 			return -ENOMEM;
-		new->paddr = start;
-		new->size = size;
-		list_add_tail(&new->list, vc_list);
 
 		/* Update the program header offset */
 		phdr_ptr->p_offset = vmcore_off + (paddr - start);
--- a/include/linux/crash_dump.h~fs-proc-vmcore-factor-out-allocating-a-vmcore-range-and-adding-it-to-a-list
+++ a/include/linux/crash_dump.h
@@ -121,6 +121,20 @@ struct vmcore_range {
 	loff_t offset;
 };
 
+/* Allocate a vmcore range and add it to the list. */
+static inline int vmcore_alloc_add_range(struct list_head *list,
+		unsigned long long paddr, unsigned long long size)
+{
+	struct vmcore_range *m = kzalloc(sizeof(*m), GFP_KERNEL);
+
+	if (!m)
+		return -ENOMEM;
+	m->paddr = paddr;
+	m->size = size;
+	list_add_tail(&m->list, list);
+	return 0;
+}
+
 #else /* !CONFIG_CRASH_DUMP */
 static inline bool is_kdump_kernel(void) { return false; }
 #endif /* CONFIG_CRASH_DUMP */
_

Patches currently in -mm which might be from david@redhat.com are

mm-mempolicy-fix-migrate_to_node-assuming-there-is-at-least-one-vma-in-a-mm.patch
mm-filemap-dont-call-folio_test_locked-without-a-reference-in-next_uptodate_folio.patch
docs-tmpfs-update-the-large-folios-policy-for-tmpfs-and-shmem.patch
mm-memory_hotplug-move-debug_pagealloc_map_pages-into-online_pages_range.patch
mm-page_isolation-dont-pass-gfp-flags-to-isolate_single_pageblock.patch
mm-page_isolation-dont-pass-gfp-flags-to-start_isolate_page_range.patch
mm-page_alloc-make-__alloc_contig_migrate_range-static.patch
mm-page_alloc-sort-out-the-alloc_contig_range-gfp-flags-mess.patch
mm-page_alloc-forward-the-gfp-flags-from-alloc_contig_range-to-post_alloc_hook.patch
powernv-memtrace-use-__gfp_zero-with-alloc_contig_pages.patch
mm-hugetlb-dont-map-folios-writable-without-vm_write-when-copying-during-fork.patch
fs-proc-vmcore-convert-vmcore_cb_lock-into-vmcore_mutex.patch
fs-proc-vmcore-replace-vmcoredd_mutex-by-vmcore_mutex.patch
fs-proc-vmcore-disallow-vmcore-modifications-while-the-vmcore-is-open.patch
fs-proc-vmcore-prefix-all-pr_-with-vmcore.patch
fs-proc-vmcore-move-vmcore-definitions-out-of-kcoreh.patch
fs-proc-vmcore-factor-out-allocating-a-vmcore-range-and-adding-it-to-a-list.patch
fs-proc-vmcore-factor-out-freeing-a-list-of-vmcore-ranges.patch
fs-proc-vmcore-introduce-proc_vmcore_device_ram-to-detect-device-ram-ranges-in-2nd-kernel.patch
virtio-mem-mark-device-ready-before-registering-callbacks-in-kdump-mode.patch
virtio-mem-remember-usable-region-size.patch
virtio-mem-support-config_proc_vmcore_device_ram.patch
s390-kdump-virtio-mem-kdump-support-config_proc_vmcore_device_ram.patch

