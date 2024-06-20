Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9F635661
	for <mm-commits@vger.kernel.org>; Thu, 20 Jun 2024 00:59:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718845166; cv=none; b=bXFth3RaeFv4Bt+brO0CG//CoPXoAh5S2Jn0aMrxv2qRG+A9t1Y4bFHnd68UovU1sXJVVC7SbmKNoU9H+spj4WzFcerDzurgYOG8U6WqLd928kv7492C5jDhTwD/sjWG0i32wAKmuyBCApm9Ov7Qkb79ae9NGdPXyObZO9X8pLk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718845166; c=relaxed/simple;
	bh=CpgWItqpK4qoRkYQxsGAl07Yoro1ARWMI1SbG/mX0oI=;
	h=Date:To:From:Subject:Message-Id; b=kouAE40jFabJi2jotaTQCt8OPZJ5brhJDUfBTW3zAhQIgMVC3qIDw9aflZ7MvgRBRQkLa+B6QZlc688xiDkYCLE7z3q+SW0Mi8P6YByXPXsPAfhGSc2GaN7xUzmF5HpxhS6jd9ps0tm0nFkl6aOkE+wQd0r7XCZrNSjqpa5W0NQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=uv/DHq0Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="uv/DHq0Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4CFCC2BBFC;
	Thu, 20 Jun 2024 00:59:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1718845166;
	bh=CpgWItqpK4qoRkYQxsGAl07Yoro1ARWMI1SbG/mX0oI=;
	h=Date:To:From:Subject:From;
	b=uv/DHq0QiL/9lyu/Af7O95i1Gu1OpYQyhW6aiVDm/on35CxsS4hOtHGqi0xD7Iozz
	 gQcho/R2RklNGSZbjT80FpDb//l4LAaCrvjxXjO0hnjdI2bBU3o1/ctIeQXUwoXaB+
	 hryqi4CyRoozvXwxjUS7LJcIAU5aybsZWxRxNSQA=
Date: Wed, 19 Jun 2024 17:59:26 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,svens@linux.ibm.com,rostedt@goodmis.org,roman.gushchin@linux.dev,rientjes@google.com,penberg@kernel.org,mhiramat@kernel.org,mark.rutland@arm.com,kasan-dev@googlegroups.com,iamjoonsoo.kim@lge.com,hca@linux.ibm.com,gor@linux.ibm.com,glider@google.com,elver@google.com,dvyukov@google.com,cl@linux.com,borntraeger@linux.ibm.com,agordeev@linux.ibm.com,42.hyeyoo@gmail.com,iii@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + s390-unwind-disable-kmsan-checks.patch added to mm-unstable branch
Message-Id: <20240620005926.A4CFCC2BBFC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: s390/unwind: disable KMSAN checks
has been added to the -mm mm-unstable branch.  Its filename is
     s390-unwind-disable-kmsan-checks.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/s390-unwind-disable-kmsan-checks.patch

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
Subject: s390/unwind: disable KMSAN checks
Date: Wed, 19 Jun 2024 17:44:10 +0200

The unwind code can read uninitialized frames.  Furthermore, even in the
good case, KMSAN does not emit shadow for backchains.  Therefore disable
it for the unwinding functions.

Link: https://lkml.kernel.org/r/20240619154530.163232-36-iii@linux.ibm.com
Signed-off-by: Ilya Leoshkevich <iii@linux.ibm.com>
Reviewed-by: Alexander Potapenko <glider@google.com>
Acked-by: Heiko Carstens <hca@linux.ibm.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: <kasan-dev@googlegroups.com>
Cc: Marco Elver <elver@google.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Steven Rostedt (Google) <rostedt@goodmis.org>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/s390/kernel/unwind_bc.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/arch/s390/kernel/unwind_bc.c~s390-unwind-disable-kmsan-checks
+++ a/arch/s390/kernel/unwind_bc.c
@@ -49,6 +49,8 @@ static inline bool is_final_pt_regs(stru
 	       READ_ONCE_NOCHECK(regs->psw.mask) & PSW_MASK_PSTATE;
 }
 
+/* Avoid KMSAN false positives from touching uninitialized frames. */
+__no_kmsan_checks
 bool unwind_next_frame(struct unwind_state *state)
 {
 	struct stack_info *info = &state->stack_info;
@@ -118,6 +120,8 @@ out_stop:
 }
 EXPORT_SYMBOL_GPL(unwind_next_frame);
 
+/* Avoid KMSAN false positives from touching uninitialized frames. */
+__no_kmsan_checks
 void __unwind_start(struct unwind_state *state, struct task_struct *task,
 		    struct pt_regs *regs, unsigned long first_frame)
 {
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

