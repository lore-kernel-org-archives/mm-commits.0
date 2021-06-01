Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F317BC4708F
	for <mm-commits@archiver.kernel.org>; Tue,  1 Jun 2021 23:54:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D050E613AD
	for <mm-commits@archiver.kernel.org>; Tue,  1 Jun 2021 23:54:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235193AbhFAXzu (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 1 Jun 2021 19:55:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:54180 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234766AbhFAXzu (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 1 Jun 2021 19:55:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C08AA61245;
        Tue,  1 Jun 2021 23:54:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1622591648;
        bh=aG/u8AgUNc2ooZvJYY4VEeFMDlNfwGt+kxYNOl9vTbw=;
        h=Date:From:To:Subject:From;
        b=xKtiX6PTePXZ0i5L9mgtESxKCI+qenfl5FkFhGp6wrTp8QCI93/l5st8jFjTeGYx5
         54PtYg8vVead27yygxSQ7w2XFHKYYTQY88rqpeAYsYNKWMgrsJIs7I15VeXDvaeMad
         sXjvRGOZVfqX4yXpzt+wCsX+gR3hPlRt03h1JyVM=
Date:   Tue, 01 Jun 2021 16:54:07 -0700
From:   akpm@linux-foundation.org
To:     adobriyan@gmail.com, chenying.kernel@bytedance.com,
        mm-commits@vger.kernel.org, rppt@kernel.org,
        songmuchun@bytedance.com, zhouchengming@bytedance.com,
        zhoufeng.zf@bytedance.com
Subject:  + fs-proc-kcorec-add-mmap-interface.patch added to -mm
 tree
Message-ID: <20210601235407.PPIqMfoJn%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fs/proc/kcore.c: add mmap interface
has been added to the -mm tree.  Its filename is
     fs-proc-kcorec-add-mmap-interface.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/fs-proc-kcorec-add-mmap-interface.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/fs-proc-kcorec-add-mmap-interface.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: ZHOUFENG <zhoufeng.zf@bytedance.com>
Subject: fs/proc/kcore.c: add mmap interface

When we do the kernel monitor, use the DRGN
(https://github.com/osandov/drgn) access to kernel data structures, found
that the system calls a lot.  DRGN is implemented by reading /proc/kcore. 
After looking at the kcore code, it is found that kcore does not implement
mmap, resulting in frequent context switching triggered by read. 
Therefore, we want to add mmap interface to optimize performance.  Since
vmalloc and module areas will change with allocation and release,
consistency cannot be guaranteed, so mmap interface only maps KCORE_TEXT
and KCORE_RAM.

The test results:
1. the default version of kcore
real 11.00
user 8.53
sys 3.59

% time     seconds  usecs/call     calls    errors syscall
------ ----------- ----------- --------- --------- ----------------
99.64  128.578319          12  11168701           pread64
...
------ ----------- ----------- --------- --------- ----------------
100.00  129.042853              11193748       966 total

2. added kcore for the mmap interface
real 6.44
user 7.32
sys 0.24

% time     seconds  usecs/call     calls    errors syscall
------ ----------- ----------- --------- --------- ----------------
32.94    0.130120          24      5317       315 futex
11.66    0.046077          21      2231         1 lstat
 9.23    0.036449         177       206           mmap
...
------ ----------- ----------- --------- --------- ----------------
100.00    0.395077                 25435       971 total

The test results show that the number of system calls and time consumption
are significantly reduced.

Thanks to Andrew Morton for your advice.

Link: https://lkml.kernel.org/r/20210601082241.13378-1-zhoufeng.zf@bytedance.com
Co-developed-by: CHENYING <chenying.kernel@bytedance.com>
Signed-off-by: CHENYING <chenying.kernel@bytedance.com>
Signed-off-by: ZHOUFENG <zhoufeng.zf@bytedance.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Chengming Zhou <zhouchengming@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/kcore.c |   67 ++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 67 insertions(+)

--- a/fs/proc/kcore.c~fs-proc-kcorec-add-mmap-interface
+++ a/fs/proc/kcore.c
@@ -614,11 +614,78 @@ static int release_kcore(struct inode *i
 	return 0;
 }
 
+static vm_fault_t mmap_kcore_fault(struct vm_fault *vmf)
+{
+	return VM_FAULT_SIGBUS;
+}
+
+static const struct vm_operations_struct kcore_mmap_ops = {
+	.fault = mmap_kcore_fault,
+};
+
+static int mmap_kcore(struct file *file, struct vm_area_struct *vma)
+{
+	size_t size = vma->vm_end - vma->vm_start;
+	u64 start, pfn;
+	int nphdr;
+	size_t data_offset;
+	size_t phdrs_len, notes_len;
+	struct kcore_list *m = NULL;
+	int ret = 0;
+
+	down_read(&kclist_lock);
+
+	get_kcore_size(&nphdr, &phdrs_len, &notes_len, &data_offset);
+
+	start = kc_offset_to_vaddr(((u64)vma->vm_pgoff << PAGE_SHIFT) -
+		((data_offset >> PAGE_SHIFT) << PAGE_SHIFT));
+
+	list_for_each_entry(m, &kclist_head, list) {
+		if (start >= m->addr && size <= m->size)
+			break;
+	}
+
+	if (&m->list == &kclist_head) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	if (vma->vm_flags & (VM_WRITE | VM_EXEC)) {
+		ret = -EPERM;
+		goto out;
+	}
+
+	vma->vm_flags &= ~(VM_MAYWRITE | VM_MAYEXEC);
+	vma->vm_flags |= VM_MIXEDMAP;
+	vma->vm_ops = &kcore_mmap_ops;
+
+	if (kern_addr_valid(start)) {
+		if (m->type == KCORE_RAM || m->type == KCORE_REMAP)
+			pfn = __pa(start) >> PAGE_SHIFT;
+		else if (m->type == KCORE_TEXT)
+			pfn = __pa_symbol(start) >> PAGE_SHIFT;
+		else {
+			ret = -EFAULT;
+			goto out;
+		}
+
+		ret = remap_pfn_range(vma, vma->vm_start, pfn, size,
+				vma->vm_page_prot);
+	} else {
+		ret = -EFAULT;
+	}
+
+out:
+	up_read(&kclist_lock);
+	return ret;
+}
+
 static const struct proc_ops kcore_proc_ops = {
 	.proc_read	= read_kcore,
 	.proc_open	= open_kcore,
 	.proc_release	= release_kcore,
 	.proc_lseek	= default_llseek,
+	.proc_mmap	= mmap_kcore,
 };
 
 /* just remember that we have to update kcore */
_

Patches currently in -mm which might be from zhoufeng.zf@bytedance.com are

fs-proc-kcorec-add-mmap-interface.patch

