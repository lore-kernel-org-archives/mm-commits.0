Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C1E145BE4
	for <mm-commits@vger.kernel.org>; Thu, 27 Jun 2024 20:09:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719518982; cv=none; b=qLLs1U20fTQOgH5pk8ZWZNaoUhKRFSZkNjuycGjzwDTjhL4pSXx72nRNxsdPycXBSyPYR4QogU9YohuCluL+RMgbH3JzCoUpmkqHC4+08/seLUbxP1P9uN1wzl9z8PcEq3oQ1uvJkWlUdUnAp0oj/6bbJsSh6QEFYePwJ+qlZOQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719518982; c=relaxed/simple;
	bh=jWVe7kqcCEW3MG9A13y8IEBEm9sqPCQLaWrwtJBkx2M=;
	h=Date:To:From:Subject:Message-Id; b=jhFdzp1fGhkZ/osbS/Y4rph40V4ZaMRZi5okhhNbc7Wjep4mx0jFYqDvbSdXg0j1cnv+boQakVL3PgbxSE14hS/Dg56sCvv4Q1f0NFVSv4SV2tZCT8vUOpXkzEmFgJoQ0+uH8yEQDv7IiA4NLm0d9LSR0/5221FojSVKNtxL2yw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=C6yiEx3V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="C6yiEx3V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6B5EC2BBFC;
	Thu, 27 Jun 2024 20:09:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719518981;
	bh=jWVe7kqcCEW3MG9A13y8IEBEm9sqPCQLaWrwtJBkx2M=;
	h=Date:To:From:Subject:From;
	b=C6yiEx3VuUPFMNirn+TR/lOxc+cjlB6+orZuVTuMCux3106l7UNcxEvcr0UBNkv/t
	 VQ+dW9gQajs2HLecjRkxl84KyTatMO4N6PCDvH6vv9D4EC9rFOBYSljcb0UCcpyS4b
	 9AAfgF/+Tk7aL78t8N+l1tnVCZyZmN9b+Yt3RJoU=
Date: Thu, 27 Jun 2024 13:09:40 -0700
To: mm-commits@vger.kernel.org,lkp@intel.com,glider@google.com,elver@google.com,dvyukov@google.com,iii@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kmsan-add-missing-__user-tags.patch added to mm-unstable branch
Message-Id: <20240627200940.E6B5EC2BBFC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kmsan: add missing __user tags
has been added to the -mm mm-unstable branch.  Its filename is
     kmsan-add-missing-__user-tags.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kmsan-add-missing-__user-tags.patch

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
From: Ilya Leoshkevich <iii@linux.ibm.com>
Subject: kmsan: add missing __user tags
Date: Thu, 27 Jun 2024 16:57:46 +0200

sparse complains that __user pointers are being passed to functions that
expect non-__user ones.  In all cases, these functions are in fact working
with user pointers, only the tag is missing.  Add it.

Link: https://lkml.kernel.org/r/20240627145754.27333-2-iii@linux.ibm.com
Signed-off-by: Ilya Leoshkevich <iii@linux.ibm.com>
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202406272033.KejtfLkw-lkp@intel.com/
Cc: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Marco Elver <elver@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kmsan/core.c   |    4 ++--
 mm/kmsan/kmsan.h  |    6 +++---
 mm/kmsan/report.c |    2 +-
 3 files changed, 6 insertions(+), 6 deletions(-)

--- a/mm/kmsan/core.c~kmsan-add-missing-__user-tags
+++ a/mm/kmsan/core.c
@@ -249,8 +249,8 @@ struct page *kmsan_vmalloc_to_page_or_nu
 		return NULL;
 }
 
-void kmsan_internal_check_memory(void *addr, size_t size, const void *user_addr,
-				 int reason)
+void kmsan_internal_check_memory(void *addr, size_t size,
+				 const void __user *user_addr, int reason)
 {
 	depot_stack_handle_t cur_origin = 0, new_origin = 0;
 	unsigned long addr64 = (unsigned long)addr;
--- a/mm/kmsan/kmsan.h~kmsan-add-missing-__user-tags
+++ a/mm/kmsan/kmsan.h
@@ -73,7 +73,7 @@ void kmsan_print_origin(depot_stack_hand
  * @off_last corresponding to different @origin values.
  */
 void kmsan_report(depot_stack_handle_t origin, void *address, int size,
-		  int off_first, int off_last, const void *user_addr,
+		  int off_first, int off_last, const void __user *user_addr,
 		  enum kmsan_bug_reason reason);
 
 DECLARE_PER_CPU(struct kmsan_ctx, kmsan_percpu_ctx);
@@ -163,8 +163,8 @@ depot_stack_handle_t kmsan_internal_chai
 void kmsan_internal_task_create(struct task_struct *task);
 
 bool kmsan_metadata_is_contiguous(void *addr, size_t size);
-void kmsan_internal_check_memory(void *addr, size_t size, const void *user_addr,
-				 int reason);
+void kmsan_internal_check_memory(void *addr, size_t size,
+				 const void __user *user_addr, int reason);
 
 struct page *kmsan_vmalloc_to_page_or_null(void *vaddr);
 void kmsan_setup_meta(struct page *page, struct page *shadow,
--- a/mm/kmsan/report.c~kmsan-add-missing-__user-tags
+++ a/mm/kmsan/report.c
@@ -148,7 +148,7 @@ void kmsan_print_origin(depot_stack_hand
 }
 
 void kmsan_report(depot_stack_handle_t origin, void *address, int size,
-		  int off_first, int off_last, const void *user_addr,
+		  int off_first, int off_last, const void __user *user_addr,
 		  enum kmsan_bug_reason reason)
 {
 	unsigned long stack_entries[KMSAN_STACK_DEPTH];
_

Patches currently in -mm which might be from iii@linux.ibm.com are

ftrace-unpoison-ftrace_regs-in-ftrace_ops_list_func.patch
kmsan-make-the-tests-compatible-with-kmsanpanic=1.patch
kmsan-disable-kmsan-when-deferred_struct_page_init-is-enabled.patch
kmsan-increase-the-maximum-store-size-to-4096.patch
kmsan-fix-is_bad_asm_addr-on-arches-with-overlapping-address-spaces.patch
kmsan-fix-kmsan_copy_to_user-on-arches-with-overlapping-address-spaces.patch
kmsan-remove-a-useless-assignment-from-kmsan_vmap_pages_range_noflush.patch
kmsan-remove-an-x86-specific-include-from-kmsanh.patch
kmsan-expose-kmsan_get_metadata.patch
kmsan-export-panic_on_kmsan.patch
kmsan-allow-disabling-kmsan-checks-for-the-current-task.patch
kmsan-introduce-memset_no_sanitize_memory.patch
kmsan-support-slab_poison.patch
kmsan-use-align_down-in-kmsan_get_metadata.patch
kmsan-do-not-round-up-pg_data_t-size.patch
kmsan-expose-kmsan_warn_on.patch
mm-slub-let-kmsan-access-metadata.patch
mm-slub-disable-kmsan-when-checking-the-padding-bytes.patch
mm-kfence-disable-kmsan-when-checking-the-canary.patch
lib-zlib-unpoison-dfltcc-output-buffers.patch
kmsan-accept-ranges-starting-with-0-on-s390.patch
s390-boot-turn-off-kmsan.patch
s390-use-a-larger-stack-for-kmsan.patch
s390-boot-add-the-kmsan-runtime-stub.patch
s390-checksum-add-a-kmsan-check.patch
s390-cpacf-unpoison-the-results-of-cpacf_trng.patch
s390-cpumf-unpoison-stcctm-output-buffer.patch
s390-diag-unpoison-diag224-output-buffer.patch
s390-ftrace-unpoison-ftrace_regs-in-kprobe_ftrace_handler.patch
s390-irqflags-do-not-instrument-arch_local_irq_-with-kmsan.patch
s390-mm-define-kmsan-metadata-for-vmalloc-and-modules.patch
s390-string-add-kmsan-support.patch
s390-traps-unpoison-the-kernel_stack_overflows-pt_regs.patch
s390-uaccess-add-kmsan-support-to-put_user-and-get_user.patch
s390-uaccess-add-the-missing-linux-instrumentedh-include.patch
s390-unwind-disable-kmsan-checks.patch
s390-kmsan-implement-the-architecture-specific-functions.patch
kmsan-enable-on-s390.patch
kmsan-add-missing-__user-tags.patch
kmsan-do-not-pass-null-pointers-as-0.patch

