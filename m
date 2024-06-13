Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1150513A3F2
	for <mm-commits@vger.kernel.org>; Thu, 13 Jun 2024 20:31:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718310701; cv=none; b=QvUEqfwcdRrU8S+8v32dyY1ST9ay3FuLp1IS6eg+RRWxmYLa9pc8PIl2BzVmeRA+SW7o3HJ8Eju21TWhZ5+KW4Oq/dfdMIyRfc1OGr8FWRhzKf+we7RCzLxqMGTCBmPjDDv4WVN3moAqBkzjjxdZdOO/oZHsb+ILlWw5TOmzq/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718310701; c=relaxed/simple;
	bh=xcGiykI/LM6gsf56dESquRav6lA/mqcbKZUlGXQ4hAI=;
	h=Date:To:From:Subject:Message-Id; b=rspzjysXUg+D1okpBPqAAp2rYFP2SUCf5jwedSjV98J6dJ1o7KhqqsMzDq4+A5JuCEcSQujyAcYUmvfzXZNB8n75N6hEbZm9FxX3UporhL3ZdT+pg2IEA4Rhmm7NtmXYsIowLHD1hFQgv7TkEQyupkRhI+P98J3VZO8AIEeGVtw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0LsK/n5b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0LsK/n5b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7848C2BBFC;
	Thu, 13 Jun 2024 20:31:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1718310700;
	bh=xcGiykI/LM6gsf56dESquRav6lA/mqcbKZUlGXQ4hAI=;
	h=Date:To:From:Subject:From;
	b=0LsK/n5bcsbOdWgelZIHmucWoEuG88SWvjTLThMBEY/Rdh/ruHsK9chGpZmKomPnp
	 SNVzCCBL2EkAHp2i37N+qpzYFk200H1kHqDFRlbNZW8JUrKzuDFXtxXu4/nSOjhkm7
	 3PIAK+euokleS+vXaKS9jtJm5//oCqLfaJ618yLU=
Date: Thu, 13 Jun 2024 13:31:40 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,svens@linux.ibm.com,rostedt@goodmis.org,roman.gushchin@linux.dev,rientjes@google.com,penberg@kernel.org,mhiramat@kernel.org,mark.rutland@arm.com,iamjoonsoo.kim@lge.com,hca@linux.ibm.com,gor@linux.ibm.com,glider@google.com,elver@google.com,dvyukov@google.com,cl@linux.com,borntraeger@linux.ibm.com,agordeev@linux.ibm.com,42.hyeyoo@gmail.com,iii@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + s390-unwind-disable-kmsan-checks.patch added to mm-unstable branch
Message-Id: <20240613203140.D7848C2BBFC@smtp.kernel.org>
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
Date: Thu, 13 Jun 2024 17:34:35 +0200

The unwind code can read uninitialized frames. Furthermore, even in
the good case, KMSAN does not emit shadow for backchains. Therefore
disable it for the unwinding functions.

Link: https://lkml.kernel.org/r/20240613153924.961511-34-iii@linux.ibm.com
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
kmsan-support-slab_poison.patch
kmsan-use-align_down-in-kmsan_get_metadata.patch
kmsan-do-not-round-up-pg_data_t-size.patch
mm-slub-let-kmsan-access-metadata.patch
mm-slub-unpoison-the-memchr_inv-return-value.patch
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
s390-unwind-disable-kmsan-checks.patch
s390-implement-the-architecture-specific-kmsan-functions.patch
kmsan-enable-on-s390.patch

