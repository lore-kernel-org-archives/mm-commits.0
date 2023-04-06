Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A68A0C7618D
	for <mm-commits@archiver.kernel.org>; Thu,  6 Apr 2023 03:03:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232680AbjDFDDi (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 5 Apr 2023 23:03:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234826AbjDFDDg (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 5 Apr 2023 23:03:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEBBF8A7B
        for <mm-commits@vger.kernel.org>; Wed,  5 Apr 2023 20:03:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 569EE640CA
        for <mm-commits@vger.kernel.org>; Thu,  6 Apr 2023 03:03:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0FC1C433D2;
        Thu,  6 Apr 2023 03:03:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680750212;
        bh=StQU48sypcq2qGSX1vMlFmIgpcvOkWB9Ijwugn22ZMM=;
        h=Date:To:From:Subject:From;
        b=c/9VccuGmUK27e6D6uWLHZ0fAX85YxdIz28uh9nEvWwNALY5ZU/6DcmUooeoRVXcv
         FVpkl4iWY1T+Q4WXK4MOi+lfcO88fpSpsr9xROTlCiYKn6d+L8k773Rqbfnyt4SitD
         UZbT4/WTmy7+WJq9LxWjfdgMvPVQksHUm6RVzBd4=
Date:   Wed, 05 Apr 2023 20:03:32 -0700
To:     mm-commits@vger.kernel.org, surenb@google.com,
        michel@lespinasse.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-rcu-safe-vma-freeing.patch removed from -mm tree
Message-Id: <20230406030332.B0FC1C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: rcu safe VMA freeing
has been removed from the -mm tree.  Its filename was
     mm-rcu-safe-vma-freeing.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

 include/linux/mm_types.h |   13 ++++++++++---
 kernel/fork.c            |   20 +++++++++++++++++++-
 2 files changed, 29 insertions(+), 4 deletions(-)

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
 	pgprot_t vm_page_prot;          /* Access permissions of this VMA. */
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


