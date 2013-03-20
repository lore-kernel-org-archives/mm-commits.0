From: akpm@linux-foundation.org
Subject: [nacked] vmcore-check-if-vmcore-objects-satify-mmaps-page-size-boundary-requirement.patch removed from -mm tree
Date: Wed, 20 Mar 2013 16:33:08 -0700
Message-ID: <20130320233308.862245A400F@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qe0-f74.google.com ([209.85.128.74]:41243 "EHLO
	mail-qe0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753856Ab3CTXdK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 20 Mar 2013 19:33:10 -0400
Received: by mail-qe0-f74.google.com with SMTP id 9so211882qea.3
        for <mm-commits@vger.kernel.org>; Wed, 20 Mar 2013 16:33:09 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: d.hatayama@jp.fujitsu.com, ebiederm@xmission.com, vgoyal@redhat.com, zhangyanfei@cn.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     Subject: vmcore: check if vmcore objects satify mmap()'s page-size boundary requirement
has been removed from the -mm tree.  Its filename was
     vmcore-check-if-vmcore-objects-satify-mmaps-page-size-boundary-requirement.patch

This patch was dropped because it was nacked

------------------------------------------------------
From: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Subject: vmcore: check if vmcore objects satify mmap()'s page-size boundary requirement

If there's some vmcore object that doesn't satisfy page-size boundary
requirement, remap_pfn_range() fails to remap it to user-space.

Objects that possibly don't satisfy the requirement are ELF note segments
only.  The memory chunks corresponding to PT_LOAD entries are guaranteed
to satisfy page-size boundary requirement by the copy from old memory to
buffer in 2nd kernel done in later patch.

This patch doesn't copy each note segment into the 2nd kernel since they
amount to so large in total if there are multiple CPUs.  For example,
current maximum number of CPUs in x86_64 is 5120, where note segments
exceed 1MB with NT_PRSTATUS only.

Signed-off-by: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Cc: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/vmcore.c |   22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff -puN fs/proc/vmcore.c~vmcore-check-if-vmcore-objects-satify-mmaps-page-size-boundary-requirement fs/proc/vmcore.c
--- a/fs/proc/vmcore.c~vmcore-check-if-vmcore-objects-satify-mmaps-page-size-boundary-requirement
+++ a/fs/proc/vmcore.c
@@ -38,6 +38,8 @@ static u64 vmcore_size;
 
 static struct proc_dir_entry *proc_vmcore = NULL;
 
+static bool support_mmap_vmcore;
+
 /*
  * Returns > 0 for RAM pages, 0 for non-RAM pages, < 0 on error
  * The called function has to take care of module refcounting.
@@ -911,6 +913,7 @@ static int __init parse_crash_elf_header
 static int __init vmcore_init(void)
 {
 	int rc = 0;
+	struct vmcore *m;
 
 	/* If elfcorehdr= has been passed in cmdline, then capture the dump.*/
 	if (!(is_vmcore_usable()))
@@ -921,6 +924,25 @@ static int __init vmcore_init(void)
 		return rc;
 	}
 
+	/* If some object doesn't satisfy PAGE_SIZE boundary
+	 * requirement, mmap_vmcore() is not exported to
+	 * user-space. */
+	support_mmap_vmcore = true;
+	list_for_each_entry(m, &vmcore_list, list) {
+		u64 paddr;
+
+		if (m->flag & MEM_TYPE_CURRENT_KERNEL)
+			paddr = (u64)__pa(m->buf);
+		else
+			paddr = m->paddr;
+
+		if ((m->offset & ~PAGE_MASK) || (paddr & ~PAGE_MASK)
+		    || (m->size & ~PAGE_MASK)) {
+			support_mmap_vmcore = false;
+			break;
+		}
+	}
+
 	proc_vmcore = proc_create("vmcore", S_IRUSR, NULL, &proc_vmcore_operations);
 	if (proc_vmcore)
 		proc_vmcore->size = vmcore_size;
_

Patches currently in -mm which might be from d.hatayama@jp.fujitsu.com are

vmcore-round-up-offset-of-vmcore-object-in-page-size-boundary.patch
vmcore-count-holes-generated-by-round-up-operation-for-vmcore-size.patch
vmcore-introduce-mmap_vmcore.patch

