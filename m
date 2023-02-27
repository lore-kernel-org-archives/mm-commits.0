Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4AF37C7EE2E
	for <mm-commits@archiver.kernel.org>; Mon, 27 Feb 2023 22:06:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229849AbjB0WGe (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 27 Feb 2023 17:06:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230187AbjB0WGQ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 27 Feb 2023 17:06:16 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA83628D3E
        for <mm-commits@vger.kernel.org>; Mon, 27 Feb 2023 14:06:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8E13FB80DC3
        for <mm-commits@vger.kernel.org>; Mon, 27 Feb 2023 22:06:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 400BDC433EF;
        Mon, 27 Feb 2023 22:06:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1677535572;
        bh=V7xFCHvU1qg+04AzGriSW/QRisTDmUdOjFelgkx9Zuk=;
        h=Date:To:From:Subject:From;
        b=kNiFCluLMuTRTgkQl45AJGLunZkJCmUvEuRNseQs7VL/I//Y4FAa2L8FwVZZKaMIa
         emEVkg5PVugIEjBvxSvP2XJEHB7Jw31BpD02XR2aDntm0F39ZPEIB8nU+ZzJoIaj0y
         4T33hsvIa+aTQd11K9xS++FUjXdbJWTKK5s1sX3k=
Date:   Mon, 27 Feb 2023 14:06:11 -0800
To:     mm-commits@vger.kernel.org, surenb@google.com,
        michel@lespinasse.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-rcu-safe-vma-freeing.patch added to mm-unstable branch
Message-Id: <20230227220612.400BDC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: rcu safe VMA freeing
has been added to the -mm mm-unstable branch.  Its filename is
     mm-rcu-safe-vma-freeing.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-rcu-safe-vma-freeing.patch

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
From: Michel Lespinasse <michel@lespinasse.org>
Subject: mm: rcu safe VMA freeing
Date: Mon, 27 Feb 2023 09:36:09 -0800

This prepares for page faults handling under VMA lock, looking up VMAs
under protection of an rcu read lock, instead of the usual mmap read lock.

Link: https://lkml.kernel.org/r/20230227173632.3292573-11-surenb@google.com
Signed-off-by: Michel Lespinasse <michel@lespinasse.org>
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/include/linux/mm_types.h~mm-rcu-safe-vma-freeing
+++ a/include/linux/mm_types.h
@@ -480,9 +480,16 @@ struct anon_vma_name {
 struct vm_area_struct {
 	/* The first cache line has the info for VMA tree walking. */
 
-	unsigned long vm_start;		/* Our start address within vm_mm. */
-	unsigned long vm_end;		/* The first byte after our end address
-					   within vm_mm. */
+	union {
+		struct {
+			/* VMA covers [vm_start; vm_end) addresses within mm */
+			unsigned long vm_start;
+			unsigned long vm_end;
+		};
+#ifdef CONFIG_PER_VMA_LOCK
+		struct rcu_head vm_rcu;	/* Used for deferred freeing. */
+#endif
+	};
 
 	struct mm_struct *vm_mm;	/* The address space we belong to. */
 
--- a/kernel/fork.c~mm-rcu-safe-vma-freeing
+++ a/kernel/fork.c
@@ -479,12 +479,30 @@ struct vm_area_struct *vm_area_dup(struc
 	return new;
 }
 
-void vm_area_free(struct vm_area_struct *vma)
+static void __vm_area_free(struct vm_area_struct *vma)
 {
 	free_anon_vma_name(vma);
 	kmem_cache_free(vm_area_cachep, vma);
 }
 
+#ifdef CONFIG_PER_VMA_LOCK
+static void vm_area_free_rcu_cb(struct rcu_head *head)
+{
+	struct vm_area_struct *vma = container_of(head, struct vm_area_struct,
+						  vm_rcu);
+	__vm_area_free(vma);
+}
+#endif
+
+void vm_area_free(struct vm_area_struct *vma)
+{
+#ifdef CONFIG_PER_VMA_LOCK
+	call_rcu(&vma->vm_rcu, vm_area_free_rcu_cb);
+#else
+	__vm_area_free(vma);
+#endif
+}
+
 static void account_kernel_stack(struct task_struct *tsk, int account)
 {
 	if (IS_ENABLED(CONFIG_VMAP_STACK)) {
_

Patches currently in -mm which might be from michel@lespinasse.org are

mm-rcu-safe-vma-freeing.patch

