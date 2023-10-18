Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C6F7CDB484
	for <mm-commits@archiver.kernel.org>; Wed, 18 Oct 2023 21:36:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231470AbjJRVgy (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Oct 2023 17:36:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235261AbjJRVgG (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Oct 2023 17:36:06 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20B57182
        for <mm-commits@vger.kernel.org>; Wed, 18 Oct 2023 14:35:35 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 055DCC4167D;
        Wed, 18 Oct 2023 21:35:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1697664921;
        bh=yYuvXJXkLQg6D59+yRzv/bBhpY00rn5bJbKecYI7toY=;
        h=Date:To:From:Subject:From;
        b=O77diP3/pHrUS5p1ji/uwimk2tqqfwCld+5cLBCUZlRG0YW3nWm2h919NqCUMT1ew
         8e9dRRi6uEGQdSLWBrWSBmEKxGrLPzk8p3cBvfbAmN3WCGkk+dWyyG0MDzSqRxbTL+
         e1weka0NlyzHJOUeco30Lk7+ifEqHA8vsw+q1mmk=
Date:   Wed, 18 Oct 2023 14:35:20 -0700
To:     mm-commits@vger.kernel.org, will@kernel.org,
        richardcochran@gmail.com, peterz@infradead.org, oleg@redhat.com,
        namhyung@kernel.org, mingo@redhat.com, mark.rutland@arm.com,
        jolsa@kernel.org, jhubbard@nvidia.com, jgg@nvidia.com,
        irogers@google.com, david@redhat.com, catalin.marinas@arm.com,
        arnd@arndb.de, alexander.shishkin@linux.intel.com,
        adrian.hunter@intel.com, acme@kernel.org, lstoakes@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-make-__access_remote_vm-static.patch removed from -mm tree
Message-Id: <20231018213521.055DCC4167D@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: make __access_remote_vm() static
has been removed from the -mm tree.  Its filename was
     mm-make-__access_remote_vm-static.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Ian Rogers <irogers@google.com>
Cc: Ingo Molnar <mingo@redhat.com>
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
@@ -5791,8 +5791,8 @@ EXPORT_SYMBOL_GPL(generic_access_phys);
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


