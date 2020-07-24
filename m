Return-Path: <SRS0=g5V1=BD=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47A38C433E3
	for <mm-commits@archiver.kernel.org>; Fri, 24 Jul 2020 23:38:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 20625206E3
	for <mm-commits@archiver.kernel.org>; Fri, 24 Jul 2020 23:38:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1595633935;
	bh=lRX92plD2TPoG8TVgqFbZGcCkCrCedXeGYr/v4LD5/c=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=PqCFJhEslXSjqVUpt8JK8BVzrWdkU/f8hPaLVqSGiHPou1aYhs7KBAIcfhGw8cPeZ
	 b54tJ69mBds655+MCZh5wnykFxkvKRDA7weDf4df9e5n4jRzM7IB9oOB8kOZJl0tm9
	 fvz3J/nQ/9CbhF1trN7cjg5+u4RmiTcvigndCrj0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726769AbgGXXiy (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 24 Jul 2020 19:38:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:44604 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726783AbgGXXix (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 24 Jul 2020 19:38:53 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C8D162070E;
        Fri, 24 Jul 2020 23:38:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595633932;
        bh=lRX92plD2TPoG8TVgqFbZGcCkCrCedXeGYr/v4LD5/c=;
        h=Date:From:To:Subject:From;
        b=gSo9O4w19Oc2tk6Zu82zNMw2PwDw5PA5dJp02+tOCyLU0/OEieHkXmJE1IrExHJdj
         WPwxrlMfwq3jcL/xIUxddi5lRFQsMfoyrrVqFXCWrTB4xxU0PCDi7tEVV/AWVqzqrh
         llN7IlpVcysi954mv4U5JpbW5EYKAxg1lmmLaM1w=
Date:   Fri, 24 Jul 2020 16:38:51 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, arnd@arndb.de, bp@alien8.de,
        dave.hansen@linux.intel.com, david@redhat.com, dennis@kernel.org,
        guro@fb.com, hpa@zytor.com, joel@joelfernandes.org,
        jroedel@suse.de, laoar.shao@gmail.com, lpf.vector@gmail.com,
        luto@kernel.org, mhocko@kernel.org, mingo@redhat.com,
        mm-commits@vger.kernel.org, naresh.kamboju@linaro.org,
        oleksiy.avramchenko@sonymobile.com, peterz@infradead.org,
        rostedt@goodmis.org, rppt@linux.ibm.com, sfr@canb.auug.org.au,
        shakeelb@google.com, tglx@linutronix.de, urezki@gmail.com,
        willy@infradead.org
Subject:  [merged]
 revert-revert-mm-vmalloc-modify-struct-vmap_area-to-reduce-its-size.patch
 removed from -mm tree
Message-ID: <20200724233851.qL7ccFqel%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: revert "Revert "mm/vmalloc: modify struct vmap_area to reduce its size""
has been removed from the -mm tree.  Its filename was
     revert-revert-mm-vmalloc-modify-struct-vmap_area-to-reduce-its-size.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: revert "Revert "mm/vmalloc: modify struct vmap_area to reduce its size""

Revert linux-next's bdbfb1d52d5e5 ("Revert "mm/vmalloc: modify struct
vmap_area to reduce its size"").

Numerous reports of kernel crashes due to this.  We can't figure out what
it's for or why it's in -next.

Link: http://lkml.kernel.org/r/20200722144650.GA19628@pc636
Link: http://lkml.kernel.org/r/CA+G9fYuj3bHUMz8XQztbmTgF0c5+rZ5-FkUjFyvEftej2jLT+Q@mail.gmail.com
Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>
Cc: Uladzislau Rezki <urezki@gmail.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Pengfei Li <lpf.vector@gmail.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Yafang Shao <laoar.shao@gmail.com>
Cc: Joel Fernandes <joel@joelfernandes.org>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Oleksiy Avramchenko <oleksiy.avramchenko@sonymobile.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Mike Rapoport <rppt@linux.ibm.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Joerg Roedel <jroedel@suse.de>
Cc: Roman Gushchin <guro@fb.com>
Cc: Dennis Zhou <dennis@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/vmalloc.h |   20 +++++++++++++-------
 mm/vmalloc.c            |   24 ++++++++++--------------
 2 files changed, 23 insertions(+), 21 deletions(-)

--- a/include/linux/vmalloc.h~revert-revert-mm-vmalloc-modify-struct-vmap_area-to-reduce-its-size
+++ a/include/linux/vmalloc.h
@@ -67,15 +67,21 @@ struct vmap_area {
 	unsigned long va_start;
 	unsigned long va_end;
 
-	/*
-	 * Largest available free size in subtree.
-	 */
-	unsigned long subtree_max_size;
-	unsigned long flags;
 	struct rb_node rb_node;         /* address sorted rbtree */
 	struct list_head list;          /* address sorted list */
-	struct llist_node purge_list;    /* "lazy purge" list */
-	struct vm_struct *vm;
+
+	/*
+	 * The following three variables can be packed, because
+	 * a vmap_area object is always one of the three states:
+	 *    1) in "free" tree (root is vmap_area_root)
+	 *    2) in "busy" tree (root is free_vmap_area_root)
+	 *    3) in purge list  (head is vmap_purge_list)
+	 */
+	union {
+		unsigned long subtree_max_size; /* in "free" tree */
+		struct vm_struct *vm;           /* in "busy" tree */
+		struct llist_node purge_list;   /* in purge list */
+	};
 };
 
 /*
--- a/mm/vmalloc.c~revert-revert-mm-vmalloc-modify-struct-vmap_area-to-reduce-its-size
+++ a/mm/vmalloc.c
@@ -408,7 +408,6 @@ EXPORT_SYMBOL(vmalloc_to_pfn);
 #define DEBUG_AUGMENT_PROPAGATE_CHECK 0
 #define DEBUG_AUGMENT_LOWEST_MATCH_CHECK 0
 
-#define VM_VM_AREA	0x04
 
 static DEFINE_SPINLOCK(vmap_area_lock);
 static DEFINE_SPINLOCK(free_vmap_area_lock);
@@ -1220,7 +1219,7 @@ retry:
 
 	va->va_start = addr;
 	va->va_end = addr + size;
-	va->flags = 0;
+	va->vm = NULL;
 
 
 	spin_lock(&vmap_area_lock);
@@ -1995,7 +1994,6 @@ void __init vmalloc_init(void)
 		if (WARN_ON_ONCE(!va))
 			continue;
 
-		va->flags = VM_VM_AREA;
 		va->va_start = (unsigned long)tmp->addr;
 		va->va_end = va->va_start + tmp->size;
 		va->vm = tmp;
@@ -2040,7 +2038,6 @@ static void setup_vmalloc_vm(struct vm_s
 			      unsigned long flags, const void *caller)
 {
 	spin_lock(&vmap_area_lock);
-	va->flags |= VM_VM_AREA;
 	setup_vmalloc_vm_locked(vm, va, flags, caller);
 	spin_unlock(&vmap_area_lock);
 }
@@ -2141,10 +2138,10 @@ struct vm_struct *find_vm_area(const voi
 	struct vmap_area *va;
 
 	va = find_vmap_area((unsigned long)addr);
-	if (va && va->flags & VM_VM_AREA)
-		return va->vm;
+	if (!va)
+		return NULL;
 
-	return NULL;
+	return va->vm;
 }
 
 /**
@@ -2165,11 +2162,10 @@ struct vm_struct *remove_vm_area(const v
 
 	spin_lock(&vmap_area_lock);
 	va = __find_vmap_area((unsigned long)addr);
-	if (va && va->flags & VM_VM_AREA) {
+	if (va && va->vm) {
 		struct vm_struct *vm = va->vm;
 
 		va->vm = NULL;
-		va->flags &= ~VM_VM_AREA;
 		spin_unlock(&vmap_area_lock);
 
 		kasan_free_shadow(vm);
@@ -2835,7 +2831,7 @@ long vread(char *buf, char *addr, unsign
 		if (!count)
 			break;
 
-		if (!(va->flags & VM_VM_AREA))
+		if (!va->vm)
 			continue;
 
 		vm = va->vm;
@@ -2915,7 +2911,7 @@ long vwrite(char *buf, char *addr, unsig
 		if (!count)
 			break;
 
-		if (!(va->flags & VM_VM_AREA))
+		if (!va->vm)
 			continue;
 
 		vm = va->vm;
@@ -3506,10 +3502,10 @@ static int s_show(struct seq_file *m, vo
 	va = list_entry(p, struct vmap_area, list);
 
 	/*
-	 * s_show can encounter race with remove_vm_area, !VM_VM_AREA on
-	 * behalf of vmap area is being tear down or vm_map_ram allocation.
+	 * s_show can encounter race with remove_vm_area, !vm on behalf
+	 * of vmap area is being tear down or vm_map_ram allocation.
 	 */
-	if (!(va->flags & VM_VM_AREA)) {
+	if (!va->vm) {
 		seq_printf(m, "0x%pK-0x%pK %7ld vm_map_ram\n",
 			(void *)va->va_start, (void *)va->va_end,
 			va->va_end - va->va_start);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-fix-kthread_use_mm-vs-tlb-invalidate-fix.patch
mm.patch
mm-handle-page-mapping-better-in-dump_page-fix.patch
mm-memcg-percpu-account-percpu-memory-to-memory-cgroups-fix.patch
mm-memcg-percpu-account-percpu-memory-to-memory-cgroups-fix-fix.patch
mm-thp-replace-http-links-with-https-ones-fix.patch
mm-vmstat-add-events-for-thp-migration-without-split-fix.patch
mmhwpoison-rework-soft-offline-for-in-use-pages-fix.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix-2.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
mm-migrate-clear-__gfp_reclaim-to-make-the-migration-callback-consistent-with-regular-thp-allocations-fix.patch
mm-madvise-introduce-process_madvise-syscall-an-external-memory-hinting-api-fix.patch
mm-madvise-introduce-process_madvise-syscall-an-external-memory-hinting-api-fix-2.patch
kernel-forkc-export-kernel_thread-to-modules.patch

