Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A750C19AA56
	for <mm-commits@vger.kernel.org>; Thu, 27 Jun 2024 20:09:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719518982; cv=none; b=X+EmfEa9vKU7C6BFBP0cO2e3WmwQ2coVHB8FOyKq5DxvXgtGTKUL2kEOUgRVKvFWShv9UO4isQpidHH+9Ld5F7yLp0gzA1GJs+4Z2WEMac5Guja+QDNq9o30KfFLiuNPzJNmNMkQxzn5Xd9W5k++tigXv5TidIxS8oacPy7zlV4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719518982; c=relaxed/simple;
	bh=sizotHo5xNFztHuNNzsHaFxghnbt7RhqH6PPim6FePI=;
	h=Date:To:From:Subject:Message-Id; b=lMuexUGQkc2qmhRjaZYxt0v5rQbUhjbZUfCI+n+kA+qlNZTluzNr7jMi7NLoMYmkXAAFulmcF1CkzfQglq9oKTaEHlmRB3vSZS7lSEXi9gprpt5VJ1EmT+3ddr5EapwEBp/3YVDOMSOtLyIMv3fWVW3CbZ7GbzRjaXc9ylKPYls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=UVjZNh7x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="UVjZNh7x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C56EC2BD10;
	Thu, 27 Jun 2024 20:09:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719518982;
	bh=sizotHo5xNFztHuNNzsHaFxghnbt7RhqH6PPim6FePI=;
	h=Date:To:From:Subject:From;
	b=UVjZNh7x/OvQHMBv+bnrFDndTXkLNczZdWQT8FSkTjKtShEVLiKAAuxdTUSLEnQtO
	 cYzFfc5/O8qoIvdu50CDNeUYjn51d9e970bYrH3nKg34D5FvKIVggMIpc+e4erks8U
	 zPmiY7WcYnPwNDRnRUk4FSzLZfY0mn1C05yEtsaM=
Date: Thu, 27 Jun 2024 13:09:41 -0700
To: mm-commits@vger.kernel.org,lkp@intel.com,glider@google.com,elver@google.com,dvyukov@google.com,iii@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kmsan-do-not-pass-null-pointers-as-0.patch added to mm-unstable branch
Message-Id: <20240627200942.5C56EC2BD10@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kmsan: do not pass NULL pointers as 0
has been added to the -mm mm-unstable branch.  Its filename is
     kmsan-do-not-pass-null-pointers-as-0.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kmsan-do-not-pass-null-pointers-as-0.patch

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
Subject: kmsan: do not pass NULL pointers as 0
Date: Thu, 27 Jun 2024 16:57:47 +0200

sparse complains about passing NULL pointers as 0.  Fix all instances.

Link: https://lkml.kernel.org/r/20240627145754.27333-3-iii@linux.ibm.com
Signed-off-by: Ilya Leoshkevich <iii@linux.ibm.com>
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202406272033.KejtfLkw-lkp@intel.com/
Cc: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Marco Elver <elver@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kmsan/hooks.c           |   15 ++++++++-------
 mm/kmsan/instrumentation.c |    4 ++--
 2 files changed, 10 insertions(+), 9 deletions(-)

--- a/mm/kmsan/hooks.c~kmsan-do-not-pass-null-pointers-as-0
+++ a/mm/kmsan/hooks.c
@@ -303,7 +303,8 @@ void kmsan_handle_urb(const struct urb *
 	if (is_out)
 		kmsan_internal_check_memory(urb->transfer_buffer,
 					    urb->transfer_buffer_length,
-					    /*user_addr*/ 0, REASON_SUBMIT_URB);
+					    /*user_addr*/ NULL,
+					    REASON_SUBMIT_URB);
 	else
 		kmsan_internal_unpoison_memory(urb->transfer_buffer,
 					       urb->transfer_buffer_length,
@@ -316,14 +317,14 @@ static void kmsan_handle_dma_page(const
 {
 	switch (dir) {
 	case DMA_BIDIRECTIONAL:
-		kmsan_internal_check_memory((void *)addr, size, /*user_addr*/ 0,
-					    REASON_ANY);
+		kmsan_internal_check_memory((void *)addr, size,
+					    /*user_addr*/ NULL, REASON_ANY);
 		kmsan_internal_unpoison_memory((void *)addr, size,
 					       /*checked*/ false);
 		break;
 	case DMA_TO_DEVICE:
-		kmsan_internal_check_memory((void *)addr, size, /*user_addr*/ 0,
-					    REASON_ANY);
+		kmsan_internal_check_memory((void *)addr, size,
+					    /*user_addr*/ NULL, REASON_ANY);
 		break;
 	case DMA_FROM_DEVICE:
 		kmsan_internal_unpoison_memory((void *)addr, size,
@@ -418,8 +419,8 @@ void kmsan_check_memory(const void *addr
 {
 	if (!kmsan_enabled)
 		return;
-	return kmsan_internal_check_memory((void *)addr, size, /*user_addr*/ 0,
-					   REASON_ANY);
+	return kmsan_internal_check_memory((void *)addr, size,
+					   /*user_addr*/ NULL, REASON_ANY);
 }
 EXPORT_SYMBOL(kmsan_check_memory);
 
--- a/mm/kmsan/instrumentation.c~kmsan-do-not-pass-null-pointers-as-0
+++ a/mm/kmsan/instrumentation.c
@@ -315,8 +315,8 @@ void __msan_warning(u32 origin)
 	if (!kmsan_enabled || kmsan_in_runtime())
 		return;
 	kmsan_enter_runtime();
-	kmsan_report(origin, /*address*/ 0, /*size*/ 0,
-		     /*off_first*/ 0, /*off_last*/ 0, /*user_addr*/ 0,
+	kmsan_report(origin, /*address*/ NULL, /*size*/ 0,
+		     /*off_first*/ 0, /*off_last*/ 0, /*user_addr*/ NULL,
 		     REASON_ANY);
 	kmsan_leave_runtime();
 }
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

