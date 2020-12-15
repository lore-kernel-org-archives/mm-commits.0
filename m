Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B01E8C2D0E4
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 00:00:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8217422DCC
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 00:00:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726225AbgLPAAn (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Dec 2020 19:00:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:34562 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726301AbgLOX3j (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 15 Dec 2020 18:29:39 -0500
Date:   Tue, 15 Dec 2020 15:19:14 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608074354;
        bh=z/rBS/nPwaGrhFIvO168Ce0PvvvWgwIC7JqM1fhzp/s=;
        h=From:To:Subject:From;
        b=IQBHMqN5/dE+cRJLH6rlxuJjXIHLio8Q2TGKl+4J+QKYu3r2AxV2DWs0a40SBxZDz
         xc/M3C9k+8tulC6Sfj2jfnfjjZHVnMJcuwoMrEpJCn7gI6SwULQ+F3ISYUEK030NDZ
         yD6mRd6ICxjVMQ63+lDah7ItaWdcd79ATVq5FoWA=
From:   akpm@linux-foundation.org
To:     jhubbard@nvidia.com, mm-commits@vger.kernel.org, oleg@redhat.com,
        rppt@linux.ibm.com
Subject:  [merged]
 mm-cleanup-remove-unused-tsk-arg-from-__access_remote_vm.patch removed from
 -mm tree
Message-ID: <20201215231914.1tZ5XdJDC%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: cleanup: remove unused tsk arg from __access_remote_vm
has been removed from the -mm tree.  Its filename was
     mm-cleanup-remove-unused-tsk-arg-from-__access_remote_vm.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: John Hubbard <jhubbard@nvidia.com>
Subject: mm: cleanup: remove unused tsk arg from __access_remote_vm

Despite a comment that said that page fault accounting would be charged to
whatever task_struct* was passed into __access_remote_vm(), the tsk
argument was actually unused.

Making page fault accounting actually use this task struct is quite a
project, so there is no point in keeping the tsk argument.

Delete both the comment, and the argument.

[rppt@linux.ibm.com: changelog addition]
Link: https://lkml.kernel.org/r/20201026074137.4147787-1-jhubbard@nvidia.com
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
Reviewed-by: Mike Rapoport <rppt@linux.ibm.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    4 ++--
 kernel/ptrace.c    |    2 +-
 mm/memory.c        |   11 +++++------
 mm/nommu.c         |    8 ++++----
 4 files changed, 12 insertions(+), 13 deletions(-)

--- a/include/linux/mm.h~mm-cleanup-remove-unused-tsk-arg-from-__access_remote_vm
+++ a/include/linux/mm.h
@@ -1716,8 +1716,8 @@ extern int access_process_vm(struct task
 		void *buf, int len, unsigned int gup_flags);
 extern int access_remote_vm(struct mm_struct *mm, unsigned long addr,
 		void *buf, int len, unsigned int gup_flags);
-extern int __access_remote_vm(struct task_struct *tsk, struct mm_struct *mm,
-		unsigned long addr, void *buf, int len, unsigned int gup_flags);
+extern int __access_remote_vm(struct mm_struct *mm, unsigned long addr,
+			      void *buf, int len, unsigned int gup_flags);
 
 long get_user_pages_remote(struct mm_struct *mm,
 			    unsigned long start, unsigned long nr_pages,
--- a/kernel/ptrace.c~mm-cleanup-remove-unused-tsk-arg-from-__access_remote_vm
+++ a/kernel/ptrace.c
@@ -57,7 +57,7 @@ int ptrace_access_vm(struct task_struct
 		return 0;
 	}
 
-	ret = __access_remote_vm(tsk, mm, addr, buf, len, gup_flags);
+	ret = __access_remote_vm(mm, addr, buf, len, gup_flags);
 	mmput(mm);
 
 	return ret;
--- a/mm/memory.c~mm-cleanup-remove-unused-tsk-arg-from-__access_remote_vm
+++ a/mm/memory.c
@@ -4885,11 +4885,10 @@ EXPORT_SYMBOL_GPL(generic_access_phys);
 #endif
 
 /*
- * Access another process' address space as given in mm.  If non-NULL, use the
- * given task for page fault accounting.
+ * Access another process' address space as given in mm.
  */
-int __access_remote_vm(struct task_struct *tsk, struct mm_struct *mm,
-		unsigned long addr, void *buf, int len, unsigned int gup_flags)
+int __access_remote_vm(struct mm_struct *mm, unsigned long addr, void *buf,
+		       int len, unsigned int gup_flags)
 {
 	struct vm_area_struct *vma;
 	void *old_buf = buf;
@@ -4966,7 +4965,7 @@ int __access_remote_vm(struct task_struc
 int access_remote_vm(struct mm_struct *mm, unsigned long addr,
 		void *buf, int len, unsigned int gup_flags)
 {
-	return __access_remote_vm(NULL, mm, addr, buf, len, gup_flags);
+	return __access_remote_vm(mm, addr, buf, len, gup_flags);
 }
 
 /*
@@ -4984,7 +4983,7 @@ int access_process_vm(struct task_struct
 	if (!mm)
 		return 0;
 
-	ret = __access_remote_vm(tsk, mm, addr, buf, len, gup_flags);
+	ret = __access_remote_vm(mm, addr, buf, len, gup_flags);
 
 	mmput(mm);
 
--- a/mm/nommu.c~mm-cleanup-remove-unused-tsk-arg-from-__access_remote_vm
+++ a/mm/nommu.c
@@ -1675,8 +1675,8 @@ void filemap_map_pages(struct vm_fault *
 }
 EXPORT_SYMBOL(filemap_map_pages);
 
-int __access_remote_vm(struct task_struct *tsk, struct mm_struct *mm,
-		unsigned long addr, void *buf, int len, unsigned int gup_flags)
+int __access_remote_vm(struct mm_struct *mm, unsigned long addr, void *buf,
+		       int len, unsigned int gup_flags)
 {
 	struct vm_area_struct *vma;
 	int write = gup_flags & FOLL_WRITE;
@@ -1722,7 +1722,7 @@ int __access_remote_vm(struct task_struc
 int access_remote_vm(struct mm_struct *mm, unsigned long addr,
 		void *buf, int len, unsigned int gup_flags)
 {
-	return __access_remote_vm(NULL, mm, addr, buf, len, gup_flags);
+	return __access_remote_vm(mm, addr, buf, len, gup_flags);
 }
 
 /*
@@ -1741,7 +1741,7 @@ int access_process_vm(struct task_struct
 	if (!mm)
 		return 0;
 
-	len = __access_remote_vm(tsk, mm, addr, buf, len, gup_flags);
+	len = __access_remote_vm(mm, addr, buf, len, gup_flags);
 
 	mmput(mm);
 	return len;
_

Patches currently in -mm which might be from jhubbard@nvidia.com are

secretmem-test-add-basic-selftest-for-memfd_secret2-fix.patch

