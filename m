Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D819E7AD78
	for <mm-commits@archiver.kernel.org>; Tue,  3 Oct 2023 17:15:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230245AbjJCRPR (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 3 Oct 2023 13:15:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230119AbjJCRPQ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 3 Oct 2023 13:15:16 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 716329B
        for <mm-commits@vger.kernel.org>; Tue,  3 Oct 2023 10:15:13 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F083AC433C8;
        Tue,  3 Oct 2023 17:15:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696353313;
        bh=gElz2LbMU57pNEpDNsOgSKWXrGiuPYbFzCcrVoTgE+g=;
        h=Date:To:From:Subject:From;
        b=bVA1Sn9QOGXSk6Xc+yDLT9NBWVDM49oqAShVrwEkpzK0Q0ts6uuIPsCEF/6qucw9z
         W3ByjGJ0Y6ZbFUXdBf+6ajXnLVNDcbpXcOaeQ7Zyx0CVIU7duQOZXg7tqFBJSmHyzb
         w5Ek3fjl+jghVs+BAlrjpzhNA7pQPVJnxx3q/ZiU=
Date:   Tue, 03 Oct 2023 10:15:12 -0700
To:     mm-commits@vger.kernel.org, will@kernel.org,
        richardcochran@gmail.com, peterz@infradead.org, oleg@redhat.com,
        namhyung@kernel.org, mingo@redhat.com, mark.rutland@arm.com,
        jolsa@kernel.org, jhubbard@nvidia.com, jgg@nvidia.com,
        irogers@google.com, david@redhat.com, catalin.marinas@arm.com,
        arnd@arndb.de, alexander.shishkin@linux.intel.com,
        adrian.hunter@intel.com, acme@kernel.org, lstoakes@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-make-__access_remote_vm-static.patch added to mm-unstable branch
Message-Id: <20231003171512.F083AC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: make __access_remote_vm() static
has been added to the -mm mm-unstable branch.  Its filename is
     mm-make-__access_remote_vm-static.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-make-__access_remote_vm-static.patch

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
From: Lorenzo Stoakes <lstoakes@gmail.com>
Subject: mm: make __access_remote_vm() static
Date: Tue, 3 Oct 2023 00:14:51 +0100

Patch series "various improvements to the GUP interface", v2.

A series of fixes to simplify and improve the GUP interface with an eye to
providing groundwork to future improvements:-

* __access_remote_vm() and access_remote_vm() are functionally identical,
  so make the former static such that in future we can potentially change
  the external-facing implementation details of this function.

* Extend is_valid_gup_args() to cover the missing FOLL_TOUCH case, and
  simplify things by defining INTERNAL_GUP_FLAGS to check against.

* Adjust __get_user_pages_locked() to explicitly treat a failure to pin any
  pages as an error in all circumstances other than FOLL_NOWAIT being
  specified, bringing it in line with the nommu implementation of this
  function.

* (With many thanks to Arnd who suggested this in the first instance)
  Update get_user_page_vma_remote() to explicitly only return a page or an
  error, simplifying the interface and avoiding the questionable
  IS_ERR_OR_NULL() pattern.


This patch (of 4):

access_remote_vm() passes through parameters to __access_remote_vm()
directly, so remove the __access_remote_vm() function from mm.h and use
access_remote_vm() in the one caller that needs it (ptrace_access_vm()).

This allows future adjustments to the GUP-internal __access_remote_vm()
function while keeping the access_remote_vm() function stable.

Link: https://lkml.kernel.org/r/cover.1696288092.git.lstoakes@gmail.com
Link: https://lkml.kernel.org/r/f7877c5039ce1c202a514a8aeeefc5cdd5e32d19.1696288092.git.lstoakes@gmail.com
Signed-off-by: Lorenzo Stoakes <lstoakes@gmail.com>
Reviewed-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Ian Rogers <irogers@google.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Richard Cochran <richardcochran@gmail.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    2 --
 kernel/ptrace.c    |    2 +-
 mm/memory.c        |    4 ++--
 mm/nommu.c         |    4 ++--
 4 files changed, 5 insertions(+), 7 deletions(-)

--- a/include/linux/mm.h~mm-make-__access_remote_vm-static
+++ a/include/linux/mm.h
@@ -2415,8 +2415,6 @@ extern int access_process_vm(struct task
 		void *buf, int len, unsigned int gup_flags);
 extern int access_remote_vm(struct mm_struct *mm, unsigned long addr,
 		void *buf, int len, unsigned int gup_flags);
-extern int __access_remote_vm(struct mm_struct *mm, unsigned long addr,
-			      void *buf, int len, unsigned int gup_flags);
 
 long get_user_pages_remote(struct mm_struct *mm,
 			   unsigned long start, unsigned long nr_pages,
--- a/kernel/ptrace.c~mm-make-__access_remote_vm-static
+++ a/kernel/ptrace.c
@@ -59,7 +59,7 @@ int ptrace_access_vm(struct task_struct
 		return 0;
 	}
 
-	ret = __access_remote_vm(mm, addr, buf, len, gup_flags);
+	ret = access_remote_vm(mm, addr, buf, len, gup_flags);
 	mmput(mm);
 
 	return ret;
--- a/mm/memory.c~mm-make-__access_remote_vm-static
+++ a/mm/memory.c
@@ -5881,8 +5881,8 @@ EXPORT_SYMBOL_GPL(generic_access_phys);
 /*
  * Access another process' address space as given in mm.
  */
-int __access_remote_vm(struct mm_struct *mm, unsigned long addr, void *buf,
-		       int len, unsigned int gup_flags)
+static int __access_remote_vm(struct mm_struct *mm, unsigned long addr,
+			      void *buf, int len, unsigned int gup_flags)
 {
 	void *old_buf = buf;
 	int write = gup_flags & FOLL_WRITE;
--- a/mm/nommu.c~mm-make-__access_remote_vm-static
+++ a/mm/nommu.c
@@ -1651,8 +1651,8 @@ vm_fault_t filemap_map_pages(struct vm_f
 }
 EXPORT_SYMBOL(filemap_map_pages);
 
-int __access_remote_vm(struct mm_struct *mm, unsigned long addr, void *buf,
-		       int len, unsigned int gup_flags)
+static int __access_remote_vm(struct mm_struct *mm, unsigned long addr,
+			      void *buf, int len, unsigned int gup_flags)
 {
 	struct vm_area_struct *vma;
 	int write = gup_flags & FOLL_WRITE;
_

Patches currently in -mm which might be from lstoakes@gmail.com are

mm-refactor-si_mem_available.patch
mm-filemap-clarify-filemap_fault-comments-for-not-uptodate-case.patch
mm-filemap-clarify-filemap_fault-comments-for-not-uptodate-case-fix.patch
mm-make-__access_remote_vm-static.patch
mm-gup-explicitly-define-and-check-internal-gup-flags-disallow-foll_touch.patch
mm-gup-make-failure-to-pin-an-error-if-foll_nowait-not-specified.patch
mm-gup-adapt-get_user_page_vma_remote-to-never-return-null.patch

