Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10E3FC433EF
	for <mm-commits@archiver.kernel.org>; Thu, 12 May 2022 22:38:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344743AbiELWip (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 12 May 2022 18:38:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242098AbiELWio (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 12 May 2022 18:38:44 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0200D261943
        for <mm-commits@vger.kernel.org>; Thu, 12 May 2022 15:38:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7E363B82910
        for <mm-commits@vger.kernel.org>; Thu, 12 May 2022 22:38:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 345C9C385B8;
        Thu, 12 May 2022 22:38:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652395120;
        bh=BAtVPmu1M3puw7Eqk+0BAMH4CbeqMuybxvjHHPG7OXg=;
        h=Date:To:From:Subject:From;
        b=2Zqumz7EIY4ek0ncdxu760bgQy7W5khoFjMUh+CkgEksKgi7sAZev03vB4luKhfP6
         nuDklU0oQKoHG/t1AsgWFmpcyL8ctFfWKwKCncjX0irgzUWNlX/5tZ83Jey4b+DEk+
         Ptq6fvDB8imm/R4tWbYm3ECmK6yPSCCOiW49SoZI=
Date:   Thu, 12 May 2022 15:38:39 -0700
To:     mm-commits@vger.kernel.org, zhang.yunkai@zte.com.cn,
        yang.yang29@zte.com.cn, willy@infradead.org,
        wang.yong12@zte.com.cn, ran.xiaokai@zte.com.cn,
        ammarfaizi2@gnuweeb.org, xu.xin16@zte.com.cn,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [nacked] mm-ksm-introduce-ksm_force-for-each-process.patch removed from -mm tree
Message-Id: <20220512223840.345C9C385B8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/ksm: introduce ksm_force for each process
has been removed from the -mm tree.  Its filename was
     mm-ksm-introduce-ksm_force-for-each-process.patch

This patch was dropped because it was nacked

------------------------------------------------------
From: cgel.zte@gmail.com
Subject: mm/ksm: introduce ksm_force for each process

From: xu xin <xu.xin16@zte.com.cn>

To use KSM, we have to explicitly call madvise() in application code,
which means installed apps on OS needs to be uninstall and source code
needs to be modified. It is inconvenient.

In order to change this situation, We add a new proc file ksm_force
under /proc/<pid>/ to support turning on/off KSM scanning of a
process's mm dynamically.

If ksm_force is set to 1, force all anonymous and 'qualified' VMAs
of this mm to be involved in KSM scanning without explicitly calling
madvise to mark VMA as MADV_MERGEABLE. But It is effective only when
the klob of /sys/kernel/mm/ksm/run is set as 1.

If ksm_force is set to 0, cancel the feature of ksm_force of this
process and unmerge those merged pages belonging to VMAs which is not
madvised as MADV_MERGEABLE of this process, but leave MADV_MERGEABLE
areas merged.

[akpm@linux-foundation.org: rename ksm_vma_check() to vma_scannable()]
Link: https://lkml.kernel.org/r/20220512070347.1628163-1-xu.xin16@zte.com.cn
Signed-off-by: xu xin <xu.xin16@zte.com.cn>
Reviewed-by: Yang Yang <yang.yang29@zte.com.cn>
Reviewed-by: Ran Xiaokai <ran.xiaokai@zte.com.cn>
Reviewed-by: wangyong <wang.yong12@zte.com.cn>
Reviewed-by: Yunkai Zhang <zhang.yunkai@zte.com.cn>
Suggested-by: Matthew Wilcox <willy@infradead.org>
Suggested-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/ksm.rst |   19 ++++
 Documentation/filesystems/proc.rst   |   17 ++++
 fs/proc/base.c                       |   97 +++++++++++++++++++++++++
 include/linux/mm_types.h             |    9 ++
 mm/ksm.c                             |   32 +++++++-
 5 files changed, 171 insertions(+), 3 deletions(-)

--- a/Documentation/admin-guide/mm/ksm.rst~mm-ksm-introduce-ksm_force-for-each-process
+++ a/Documentation/admin-guide/mm/ksm.rst
@@ -32,7 +32,7 @@ are swapped back in: ksmd must rediscove
 Controlling KSM with madvise
 ============================
 
-KSM only operates on those areas of address space which an application
+KSM can operates on those areas of address space which an application
 has advised to be likely candidates for merging, by using the madvise(2)
 system call::
 
@@ -70,6 +70,23 @@ Applications should be considerate in th
 restricting its use to areas likely to benefit.  KSM's scans may use a lot
 of processing power: some installations will disable KSM for that reason.
 
+Controlling KSM with procfs
+===========================
+
+KSM can also operate on anonymous areas of address space of those processes's
+knob ``/proc/<pid>/ksm_force`` is on, even if app codes doesn't call madvise()
+explicitly to advise specific areas as MADV_MERGEABLE.
+
+You can set ksm_force to 1 to force all anonymous and qualified VMAs of
+this process to be involved in KSM scanning.
+	e.g. ``echo 1 > /proc/<pid>/ksm_force``
+
+You can also set ksm_force to 0 to cancel that force feature of this process
+and unmerge those merged pages which belongs to those VMAs not marked as
+MADV_MERGEABLE of this process. But that still leave those pages belonging to
+VMAs marked as MADV_MERGEABLE merged (fallback to the default state).
+	e.g. ``echo 0 > /proc/<pid>/ksm_force``
+
 .. _ksm_sysfs:
 
 KSM daemon sysfs interface
--- a/Documentation/filesystems/proc.rst~mm-ksm-introduce-ksm_force-for-each-process
+++ a/Documentation/filesystems/proc.rst
@@ -47,6 +47,7 @@ fixes/update part 1.1  Stefani Seibold <
   3.10  /proc/<pid>/timerslack_ns - Task timerslack value
   3.11	/proc/<pid>/patch_state - Livepatch patch operation state
   3.12	/proc/<pid>/arch_status - Task architecture specific information
+  3.13	/proc/<pid>/ksm_force - Setting of mandatory involvement in KSM
 
   4	Configuring procfs
   4.1	Mount options
@@ -2218,6 +2219,22 @@ AVX512_elapsed_ms
   the task is unlikely an AVX512 user, but depends on the workload and the
   scheduling scenario, it also could be a false negative mentioned above.
 
+3.13	/proc/<pid>/ksm_force - Setting of mandatory involvement in KSM
+-----------------------------------------------------------------------
+When CONFIG_KSM is enabled, this file can be used to specify if this
+process's anonymous memory can be involved in KSM scanning without app codes
+explicitly calling madvise to mark memory address as MADV_MERGEABLE.
+
+If writing 1 to this file, the kernel will force all anonymous and qualified
+memory to be involved in KSM scanning without explicitly calling madvise to
+mark memory address as MADV_MERGEABLE. But that is effective only when the
+klob of '/sys/kernel/mm/ksm/run' is set as 1.
+
+If writing 0 to this file, the mandatory KSM feature of this process's will
+be cancelled and unmerge those merged pages which belongs to those areas not
+marked as MADV_MERGEABLE of this process, but leave those pages belonging to
+areas marked as MADV_MERGEABLE merged (fallback to the default state).
+
 Chapter 4: Configuring procfs
 =============================
 
--- a/fs/proc/base.c~mm-ksm-introduce-ksm_force-for-each-process
+++ a/fs/proc/base.c
@@ -96,6 +96,7 @@
 #include <linux/time_namespace.h>
 #include <linux/resctrl.h>
 #include <linux/cn_proc.h>
+#include <linux/ksm.h>
 #include <trace/events/oom.h>
 #include "internal.h"
 #include "fd.h"
@@ -3171,6 +3172,100 @@ static int proc_pid_ksm_merging_pages(st
 
 	return 0;
 }
+
+static ssize_t ksm_force_read(struct file *file, char __user *buf, size_t count,
+				loff_t *ppos)
+{
+	struct task_struct *task;
+	struct mm_struct *mm;
+	char buffer[PROC_NUMBUF];
+	ssize_t len;
+	int ret;
+
+	task = get_proc_task(file_inode(file));
+	if (!task)
+		return -ESRCH;
+
+	mm = get_task_mm(task);
+	ret = 0;
+	if (mm) {
+		len = snprintf(buffer, sizeof(buffer), "%d\n", mm->ksm_force);
+		ret =  simple_read_from_buffer(buf, count, ppos, buffer, len);
+		mmput(mm);
+	}
+
+	return ret;
+}
+
+static ssize_t ksm_force_write(struct file *file, const char __user *buf,
+				size_t count, loff_t *ppos)
+{
+	struct task_struct *task;
+	struct mm_struct *mm;
+	char buffer[PROC_NUMBUF];
+	int force;
+	int err = 0;
+	int str_len;
+
+	if (count > sizeof(buffer) - 1) {
+		count = sizeof(buffer) - 1;
+	}
+
+	str_len = strncpy_from_user(buffer, buf, count);
+	if (str_len < 0)
+		return -EFAULT;
+	buffer[str_len] = '\0';
+
+	err = kstrtoint(strstrip(buffer), 0, &force);
+	if (err)
+		return err;
+
+	if (force != 0 && force != 1)
+		return -EINVAL;
+
+	task = get_proc_task(file_inode(file));
+	if (!task)
+		return -ESRCH;
+
+	mm = get_task_mm(task);
+	if (!mm)
+		goto out_put_task;
+
+	if (mm->ksm_force != force) {
+		if (mmap_write_lock_killable(mm)) {
+			err = -EINTR;
+			goto out_mmput;
+		}
+
+		if (force == 0)
+			mm->ksm_force = force;
+		else {
+			/*
+			 * Force anonymous pages of this mm to be involved in KSM merging
+			 * without explicitly calling madvise.
+			 */
+			if (!test_bit(MMF_VM_MERGEABLE, &mm->flags))
+				err = __ksm_enter(mm);
+			if (!err)
+				mm->ksm_force = force;
+		}
+
+		mmap_write_unlock(mm);
+	}
+
+out_mmput:
+	mmput(mm);
+out_put_task:
+	put_task_struct(task);
+
+	return err < 0 ? err : count;
+}
+
+static const struct file_operations proc_pid_ksm_force_operations = {
+	.read		= ksm_force_read,
+	.write		= ksm_force_write,
+	.llseek		= generic_file_llseek,
+};
 #endif /* CONFIG_KSM */
 
 #ifdef CONFIG_STACKLEAK_METRICS
@@ -3306,6 +3401,7 @@ static const struct pid_entry tgid_base_
 #endif
 #ifdef CONFIG_KSM
 	ONE("ksm_merging_pages",  S_IRUSR, proc_pid_ksm_merging_pages),
+	REG("ksm_force", S_IRUSR|S_IWUSR, proc_pid_ksm_force_operations),
 #endif
 };
 
@@ -3642,6 +3738,7 @@ static const struct pid_entry tid_base_s
 #endif
 #ifdef CONFIG_KSM
 	ONE("ksm_merging_pages",  S_IRUSR, proc_pid_ksm_merging_pages),
+	REG("ksm_force", S_IRUSR|S_IWUSR, proc_pid_ksm_force_operations),
 #endif
 };
 
--- a/include/linux/mm_types.h~mm-ksm-introduce-ksm_force-for-each-process
+++ a/include/linux/mm_types.h
@@ -649,6 +649,15 @@ struct mm_struct {
 		 * merging.
 		 */
 		unsigned long ksm_merging_pages;
+		/*
+		 * If true, force anonymous pages of this mm to be involved in KSM
+		 * merging without explicitly calling madvise. It is effctive only
+		 * when the klob of '/sys/kernel/mm/ksm/run' is set as 1. If false,
+		 * cancel the feature of ksm_force of this process and unmerge
+		 * those merged pages which is not madvised as MERGEABLE of this
+		 * process, but leave MERGEABLE areas merged.
+		 */
+		bool ksm_force;
 #endif
 	} __randomize_layout;
 
--- a/mm/ksm.c~mm-ksm-introduce-ksm_force-for-each-process
+++ a/mm/ksm.c
@@ -334,6 +334,34 @@ static void __init ksm_slab_free(void)
 	mm_slot_cache = NULL;
 }
 
+/* Check if vma is qualified for ksmd scanning */
+static bool vma_scannable(struct vm_area_struct *vma)
+{
+	unsigned long vm_flags = vma->vm_flags;
+
+	if (!(vma->vm_flags & VM_MERGEABLE) && !(vma->vm_mm->ksm_force))
+		return false;
+
+	if (vm_flags & (VM_SHARED	| VM_MAYSHARE	|
+			VM_PFNMAP	| VM_IO | VM_DONTEXPAND |
+			VM_HUGETLB	| VM_MIXEDMAP))
+		return false;       /* just ignore this vma*/
+
+	if (vma_is_dax(vma))
+		return false;
+
+#ifdef VM_SAO
+	if (vm_flags & VM_SAO)
+		return false;
+#endif
+#ifdef VM_SPARC_ADI
+	if (vm_flags & VM_SPARC_ADI)
+		return false;
+#endif
+
+	return true;
+}
+
 static __always_inline bool is_stable_node_chain(struct stable_node *chain)
 {
 	return chain->rmap_hlist_len == STABLE_NODE_CHAIN;
@@ -523,7 +551,7 @@ static struct vm_area_struct *find_merge
 	if (ksm_test_exit(mm))
 		return NULL;
 	vma = vma_lookup(mm, addr);
-	if (!vma || !(vma->vm_flags & VM_MERGEABLE) || !vma->anon_vma)
+	if (!vma || !vma_scannable(vma) || !vma->anon_vma)
 		return NULL;
 	return vma;
 }
@@ -2300,7 +2328,7 @@ next_mm:
 		goto no_vmas;
 
 	for_each_vma(vmi, vma) {
-		if (!(vma->vm_flags & VM_MERGEABLE))
+		if (!vma_scannable(vma))
 			continue;
 		if (ksm_scan.address < vma->vm_start)
 			ksm_scan.address = vma->vm_start;
_

Patches currently in -mm which might be from xu.xin16@zte.com.cn are


