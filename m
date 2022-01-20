Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A997C433F5
	for <mm-commits@archiver.kernel.org>; Thu, 20 Jan 2022 21:21:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242456AbiATVVC (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 20 Jan 2022 16:21:02 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:33458 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232069AbiATVVC (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 20 Jan 2022 16:21:02 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4E6F96185A
        for <mm-commits@vger.kernel.org>; Thu, 20 Jan 2022 21:21:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D5EBC340E0;
        Thu, 20 Jan 2022 21:21:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642713661;
        bh=Vciwww1w9hkrkcmwmL2Ta20axKQOvIINvaF9YlG7yRU=;
        h=Date:From:To:Subject:From;
        b=TMaxtN15eKqekz1fhCSq+dJIrIvNEVdAgw0HyVImDzGyTEyilcdIgvuh/KLszL3iw
         b5mrb3f4bgEbwkSIsNng+ggMc026EisefIdjcbWjHxd5+cgHNl6IE0rrI6Gn10RtoS
         auqS9WzHkP6gmV0iCgi4ZbH95GreVBAuh2JbkUFw=
Date:   Thu, 20 Jan 2022 13:21:00 -0800
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, mm-commits@vger.kernel.org
Subject:  [obsolete] linux-next-rejects.patch removed from -mm tree
Message-ID: <20220120212100.N7V4_DBa7%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-rejects
has been removed from the -mm tree.  Its filename was
     linux-next-rejects.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kthread.h |    2 +-
 kernel/kthread.c        |   27 +++++++++++++++------------
 mm/memremap.c           |    2 +-
 mm/zsmalloc.c           |    2 +-
 4 files changed, 18 insertions(+), 15 deletions(-)

--- a/include/linux/kthread.h~linux-next-rejects
+++ a/include/linux/kthread.h
@@ -34,7 +34,7 @@ struct task_struct *kthread_create_on_cp
 					  const char *namefmt);
 
 void get_kthread_comm(char *buf, size_t buf_size, struct task_struct *tsk);
-void set_kthread_struct(struct task_struct *p);
+bool set_kthread_struct(struct task_struct *p);
 
 void kthread_set_per_cpu(struct task_struct *k, int cpu);
 bool kthread_is_per_cpu(struct task_struct *k);
--- a/kernel/kthread.c~linux-next-rejects
+++ a/kernel/kthread.c
@@ -90,7 +90,7 @@ static inline struct kthread *to_kthread
  */
 static inline struct kthread *__to_kthread(struct task_struct *p)
 {
-	void *kthread = (__force void *)p->set_child_tid;
+	void *kthread = p->worker_private;
 	if (kthread && !(p->flags & PF_KTHREAD))
 		kthread = NULL;
 	return kthread;
@@ -108,20 +108,23 @@ void get_kthread_comm(char *buf, size_t
 	strscpy_pad(buf, kthread->full_name, buf_size);
 }
 
-void set_kthread_struct(struct task_struct *p)
+bool set_kthread_struct(struct task_struct *p)
 {
 	struct kthread *kthread;
 
-	if (__to_kthread(p))
-		return;
+	if (WARN_ON_ONCE(to_kthread(p)))
+		return false;
 
 	kthread = kzalloc(sizeof(*kthread), GFP_KERNEL);
-	/*
-	 * We abuse ->set_child_tid to avoid the new member and because it
-	 * can't be wrongly copied by copy_process(). We also rely on fact
-	 * that the caller can't exec, so PF_KTHREAD can't be cleared.
-	 */
-	p->set_child_tid = (__force void __user *)kthread;
+	if (!kthread)
+		return false;
+
+	init_completion(&kthread->exited);
+	init_completion(&kthread->parked);
+	p->vfork_done = &kthread->exited;
+
+	p->worker_private = kthread;
+	return true;
 }
 
 void free_kthread_struct(struct task_struct *k)
@@ -129,8 +132,7 @@ void free_kthread_struct(struct task_str
 	struct kthread *kthread;
 
 	/*
-	 * Can be NULL if this kthread was created by kernel_thread()
-	 * or if kmalloc() in kthread() failed.
+	 * Can be NULL if kmalloc() in set_kthread_struct() failed.
 	 */
 	kthread = to_kthread(k);
 	if (!kthread)
@@ -139,6 +141,7 @@ void free_kthread_struct(struct task_str
 #ifdef CONFIG_BLK_CGROUP
 	WARN_ON_ONCE(kthread->blkcg_css);
 #endif
+	k->worker_private = NULL;
 	kfree(kthread->full_name);
 	kfree(kthread);
 }
--- a/mm/memremap.c~linux-next-rejects
+++ a/mm/memremap.c
@@ -298,7 +298,7 @@ static int pagemap_range(struct dev_page
 	memmap_init_zone_device(&NODE_DATA(nid)->node_zones[ZONE_DEVICE],
 				PHYS_PFN(range->start),
 				PHYS_PFN(range_len(range)), pgmap);
-	percpu_ref_get_many(pgmap->ref, pfn_len(pgmap, range_id));
+	percpu_ref_get_many(&pgmap->ref, pfn_len(pgmap, range_id));
 	return 0;
 
 err_add_memory:
--- a/mm/zsmalloc.c~linux-next-rejects
+++ a/mm/zsmalloc.c
@@ -901,7 +901,7 @@ static void reset_page(struct page *page
 	set_page_private(page, 0);
 	page_mapcount_reset(page);
 	ClearPageHugeObject(page);
-	page->freelist = NULL;
+	page->index = 0;
 }
 
 static int trylock_zspage(struct zspage *zspage)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm.patch
documentation-vm-page_ownerrst-update-the-documentation-fix.patch
mm-mempolicy-convert-from-atomic_t-to-refcount_t-on-mempolicy-refcnt-fix.patch
linux-next-git-rejects.patch
arch-x86-include-asm-pgtableh-needs-spinlockh.patch
sysctl-move-some-boundary-constants-from-sysctlc-to-sysctl_vals-fix.patch
firmware_loader-move-firmware-sysctl-to-its-own-files-fix.patch
firmware_loader-move-firmware-sysctl-to-its-own-files-fix-fix.patch
sysctl-add-helper-to-register-a-sysctl-mount-point-fix.patch
sysctl-move-maxolduid-as-a-sysctl-specific-const-fix.patch
proc-remove-pde_data-completely-fix.patch
proc-remove-pde_data-completely-fix-fix.patch
mm-remove-cleancache-fix.patch
mm-simplify-try_to_unuse-fix.patch
mutex-subsystem-synchro-test-module-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

