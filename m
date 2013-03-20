From: akpm@linux-foundation.org
Subject: [nacked] vmcore-introduce-mmap_vmcore.patch removed from -mm tree
Date: Wed, 20 Mar 2013 16:33:17 -0700
Message-ID: <20130320233317.7E0D05A400F@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ve0-f202.google.com ([209.85.128.202]:48801 "EHLO
	mail-ve0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754226Ab3CTXdT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 20 Mar 2013 19:33:19 -0400
Received: by mail-ve0-f202.google.com with SMTP id m1so211413ves.5
        for <mm-commits@vger.kernel.org>; Wed, 20 Mar 2013 16:33:18 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: d.hatayama@jp.fujitsu.com, ebiederm@xmission.com, vgoyal@redhat.com, zhangyanfei@cn.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     Subject: vmcore: introduce mmap_vmcore()
has been removed from the -mm tree.  Its filename was
     vmcore-introduce-mmap_vmcore.patch

This patch was dropped because it was nacked

------------------------------------------------------
From: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Subject: vmcore: introduce mmap_vmcore()

This patch introduces mmap_vmcore().

If flag MEM_TYPE_CURRENT_KERNEL is set, remapped is the buffer on the 2nd
kernel.  If not set, remapped is some area in old memory.

Neither writable nor executable mapping is permitted even with mprotect().
 Non-writable mapping is also requirement of remap_pfn_range() when
mapping linear pages on non-consequtive physical pages; see
is_cow_mapping().

On x86-32 PAE kernels, mmap() supports at most 16TB memory only.  This
limitation comes from the fact that the third argument of
remap_pfn_range(), pfn, is of 32-bit length on x86-32: unsigned long.

Signed-off-by: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Cc: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/vmcore.c |   72 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 72 insertions(+)

diff -puN fs/proc/vmcore.c~vmcore-introduce-mmap_vmcore fs/proc/vmcore.c
--- a/fs/proc/vmcore.c~vmcore-introduce-mmap_vmcore
+++ a/fs/proc/vmcore.c
@@ -185,9 +185,81 @@ static ssize_t read_vmcore(struct file *
 	return acc;
 }
 
+static int mmap_vmcore(struct file *file, struct vm_area_struct *vma)
+{
+	size_t size = vma->vm_end - vma->vm_start;
+	u64 start, end, len, tsz;
+	struct vmcore *m;
+
+	if (!support_mmap_vmcore)
+		return -ENODEV;
+
+	start = (u64)vma->vm_pgoff << PAGE_SHIFT;
+	end = start + size;
+
+	if (size > vmcore_size || end > vmcore_size)
+		return -EINVAL;
+
+	if (vma->vm_flags & (VM_WRITE | VM_EXEC))
+		return -EPERM;
+
+	vma->vm_flags &= ~(VM_MAYWRITE | VM_MAYEXEC);
+
+	len = 0;
+
+	if (start < elfcorebuf_sz) {
+		u64 pfn;
+
+		tsz = elfcorebuf_sz - start;
+		if (size < tsz)
+			tsz = size;
+		pfn = __pa(elfcorebuf + start) >> PAGE_SHIFT;
+		if (remap_pfn_range(vma, vma->vm_start, pfn, tsz,
+				    vma->vm_page_prot))
+			return -EAGAIN;
+		size -= tsz;
+		start += tsz;
+		len += tsz;
+
+		if (size == 0)
+			return 0;
+	}
+
+	list_for_each_entry(m, &vmcore_list, list) {
+		if (start < m->offset + m->size) {
+			u64 pfn = 0;
+
+			tsz = m->offset + m->size - start;
+			if (size < tsz)
+				tsz = size;
+			if (m->flag & MEM_TYPE_CURRENT_KERNEL) {
+				pfn = __pa(m->buf + start - m->offset)
+					>> PAGE_SHIFT;
+			} else {
+				pfn = (m->paddr + (start - m->offset))
+					>> PAGE_SHIFT;
+			}
+			if (remap_pfn_range(vma, vma->vm_start + len, pfn, tsz,
+					    vma->vm_page_prot)) {
+				do_munmap(vma->vm_mm, vma->vm_start, len);
+				return -EAGAIN;
+			}
+			size -= tsz;
+			start += tsz;
+			len += tsz;
+
+			if (size == 0)
+				return 0;
+		}
+	}
+
+	return 0;
+}
+
 static const struct file_operations proc_vmcore_operations = {
 	.read		= read_vmcore,
 	.llseek		= default_llseek,
+	.mmap		= mmap_vmcore,
 };
 
 static struct vmcore* __init get_new_element(void)
_

Patches currently in -mm which might be from d.hatayama@jp.fujitsu.com are


