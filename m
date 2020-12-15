Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61BD8C4361B
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 03:30:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1EB0C2246B
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 03:30:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726267AbgLODae (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 14 Dec 2020 22:30:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:36316 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726321AbgLODI0 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 14 Dec 2020 22:08:26 -0500
Date:   Mon, 14 Dec 2020 19:07:45 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608001666;
        bh=/6ffRlxpkLFXz5PrQneA1WOaJvJ/TqE7CRgMNJycWI8=;
        h=From:To:Subject:In-Reply-To:From;
        b=qnj699Vrx9N/1riOb3iV/0gVstUYmUDRe5+XmFHs2m5Gu36hazmj64Rapl57kKMoS
         ztuFXEr4Ofn+hUyJ+o/KVDz/gXNhVtXwRJYVLcHKtIZNKlQN6qszV2Tk6FtpSS1cIR
         B7/v1jMbqx/znOjnhkN6iYgO2Fg/ADgHQv00V4fY=
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, jhubbard@nvidia.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, oleg@redhat.com, rppt@linux.ibm.com,
        torvalds@linux-foundation.org
Subject:  [patch 078/200] mm: cleanup: remove unused tsk arg from
 __access_remote_vm
Message-ID: <20201215030745.DS6kWNPRK%akpm@linux-foundation.org>
In-Reply-To: <20201214190237.a17b70ae14f129e2dca3d204@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
