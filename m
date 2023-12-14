Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 662BD944C
	for <mm-commits@vger.kernel.org>; Thu, 14 Dec 2023 22:43:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gW4knbG6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B48C1C433C8;
	Thu, 14 Dec 2023 22:43:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702593804;
	bh=6KfG+MAYIu4HH9+kX/+skN7Pvxz5I+y5ZucMcXVZ08g=;
	h=Date:To:From:Subject:From;
	b=gW4knbG6Vc2KHyII4YUX8x3wP6jOOYGNQuAPqOD2ejMZi//OOdDXzz74Uz/r2D0gW
	 y/O0GtkhN9bgtGdEFTfLeqOnG7mNq6zYzA7Q2jdVGAfkJ+K/f2L8E9SByZEO/mJwwb
	 DxoSsyBecHC+d8RO7dtouP7NvPxl1j/bvpBIsBGQ=
Date: Thu, 14 Dec 2023 14:43:24 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,svens@linux.ibm.com,rostedt@goodmis.org,roman.gushchin@linux.dev,rientjes@google.com,penberg@kernel.org,mhiramat@kernel.org,mark.rutland@arm.com,iamjoonsoo.kim@lge.com,hca@linux.ibm.com,gor@linux.ibm.com,glider@google.com,elver@google.com,dvyukov@google.com,cl@linux.com,borntraeger@linux.ibm.com,agordeev@linux.ibm.com,42.hyeyoo@gmail.com,iii@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ftrace-unpoison-ftrace_regs-in-ftrace_ops_list_func.patch added to mm-unstable branch
Message-Id: <20231214224324.B48C1C433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ftrace: unpoison ftrace_regs in ftrace_ops_list_func()
has been added to the -mm mm-unstable branch.  Its filename is
     ftrace-unpoison-ftrace_regs-in-ftrace_ops_list_func.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ftrace-unpoison-ftrace_regs-in-ftrace_ops_list_func.patch

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
Subject: ftrace: unpoison ftrace_regs in ftrace_ops_list_func()
Date: Thu, 14 Dec 2023 00:24:21 +0100

Patch series "kmsan: Enable on s390", v3.

This series provides the minimal support for Kernel Memory Sanitizer on
s390.  Kernel Memory Sanitizer is clang-only instrumentation for finding
accesses to uninitialized memory.  The clang support for s390 has already
been merged [1].

With this series, I can successfully boot s390 defconfig and
debug_defconfig with kmsan.panic=1.  The tool found one real s390-specific
bug (fixed in master).


This patch (of 34):

Architectures use assembly code to initialize ftrace_regs and call
ftrace_ops_list_func().  Therefore, from the KMSAN's point of view,
ftrace_regs is poisoned on ftrace_ops_list_func entry().  This causes
KMSAN warnings when running the ftrace testsuite.

Fix by trusting the architecture-specific assembly code and always
unpoisoning ftrace_regs in ftrace_ops_list_func.

Link: https://lkml.kernel.org/r/20231213233605.661251-1-iii@linux.ibm.com
Link: https://lkml.kernel.org/r/20231213233605.661251-2-iii@linux.ibm.com
Link: https://reviews.llvm.org/D148596 [1]
Signed-off-by: Ilya Leoshkevich <iii@linux.ibm.com>
Acked-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Reviewed-by: Alexander Potapenko <glider@google.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Marco Elver <elver@google.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/trace/ftrace.c |    1 +
 1 file changed, 1 insertion(+)

--- a/kernel/trace/ftrace.c~ftrace-unpoison-ftrace_regs-in-ftrace_ops_list_func
+++ a/kernel/trace/ftrace.c
@@ -7399,6 +7399,7 @@ out:
 void arch_ftrace_ops_list_func(unsigned long ip, unsigned long parent_ip,
 			       struct ftrace_ops *op, struct ftrace_regs *fregs)
 {
+	kmsan_unpoison_memory(fregs, sizeof(*fregs));
 	__ftrace_ops_list_func(ip, parent_ip, NULL, fregs);
 }
 #else
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
kmsan-support-slab_poison.patch
kmsan-use-align_down-in-kmsan_get_metadata.patch
mm-slub-let-kmsan-access-metadata.patch
mm-slub-unpoison-the-memchr_inv-return-value.patch
mm-kfence-disable-kmsan-when-checking-the-canary.patch
lib-zlib-unpoison-dfltcc-output-buffers.patch
kmsan-accept-ranges-starting-with-0-on-s390.patch
s390-turn-off-kmsan-for-boot-vdso-and-purgatory.patch
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
s390-unwind-disable-kmsan-checks.patch
s390-implement-the-architecture-specific-kmsan-functions.patch
kmsan-enable-on-s390.patch

