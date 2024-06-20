Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 555C54685
	for <mm-commits@vger.kernel.org>; Thu, 20 Jun 2024 00:58:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718845118; cv=none; b=XZetneK+NOoXb2CawLCt0cWcaVxWhS3C+vvpXAP0BNTmJxhLo+ZH1PYHbHltby65im2V5O9DURL6I43d5TG57+MFTxUv7tXyE3NLF2zGyY15dGh7jhAi2RXnoK+dJcfTrrQO6a0ycRftr+EHu9we5t12ElSGuWzy9IAIgrtU9Vw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718845118; c=relaxed/simple;
	bh=RePY0SqLX2lBdtabvSjSxbHu6FFvZUJla2YZ8z8sRk4=;
	h=Date:To:From:Subject:Message-Id; b=FjUJYz7EaeegRiFbcFGp4Fj8EQcDsO9zsm/jzGf+tnEt7wb1btxiSrJpMQFDMjzyD0+O4kmo/kDzaq6qmOVTu1+I6A0sVRH/z9REO3rbD9+ky0kG1Lb0Gv0kbMqbAKRjrl62CpLfof4sjkyWgocpVpQwqTsRzm6o1aPPkcG1U7Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=u2fXjLcC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="u2fXjLcC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26F49C2BBFC;
	Thu, 20 Jun 2024 00:58:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1718845118;
	bh=RePY0SqLX2lBdtabvSjSxbHu6FFvZUJla2YZ8z8sRk4=;
	h=Date:To:From:Subject:From;
	b=u2fXjLcCDJ5lnx5JFScOp0h06lne/YC1LNB/rpnUqGfqepLjLa8WBWUkKETf+aK2V
	 K5nYVl+Y/aTdP4Bixqp1hIUJSVwO80XckKHYZoqgTmHkUe2AqRqvHV53xbgqvNJZdQ
	 R0LqT6ZotY4MWTLMRMu78ErYJAT3O9fxJPgn8dx4=
Date: Wed, 19 Jun 2024 17:58:37 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,svens@linux.ibm.com,rostedt@goodmis.org,roman.gushchin@linux.dev,rientjes@google.com,penberg@kernel.org,mhiramat@kernel.org,mark.rutland@arm.com,kasan-dev@googlegroups.com,iamjoonsoo.kim@lge.com,hca@linux.ibm.com,gor@linux.ibm.com,glider@google.com,elver@google.com,dvyukov@google.com,cl@linux.com,borntraeger@linux.ibm.com,agordeev@linux.ibm.com,42.hyeyoo@gmail.com,iii@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kmsan-introduce-memset_no_sanitize_memory.patch added to mm-unstable branch
Message-Id: <20240620005838.26F49C2BBFC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kmsan: introduce memset_no_sanitize_memory()
has been added to the -mm mm-unstable branch.  Its filename is
     kmsan-introduce-memset_no_sanitize_memory.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kmsan-introduce-memset_no_sanitize_memory.patch

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
Subject: kmsan: introduce memset_no_sanitize_memory()
Date: Wed, 19 Jun 2024 17:43:47 +0200

Add a wrapper for memset() that prevents unpoisoning.  This is useful for
filling memory allocator redzones.

Link: https://lkml.kernel.org/r/20240619154530.163232-13-iii@linux.ibm.com
Signed-off-by: Ilya Leoshkevich <iii@linux.ibm.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
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

 include/linux/kmsan.h |   13 +++++++++++++
 1 file changed, 13 insertions(+)

--- a/include/linux/kmsan.h~kmsan-introduce-memset_no_sanitize_memory
+++ a/include/linux/kmsan.h
@@ -255,6 +255,14 @@ void kmsan_enable_current(void);
  */
 void kmsan_disable_current(void);
 
+/*
+ * memset_no_sanitize_memory(): memset() without KMSAN instrumentation.
+ */
+static inline void *memset_no_sanitize_memory(void *s, int c, size_t n)
+{
+	return __memset(s, c, n);
+}
+
 #else
 
 static inline void kmsan_init_shadow(void)
@@ -362,6 +370,11 @@ static inline void kmsan_disable_current
 {
 }
 
+static inline void *memset_no_sanitize_memory(void *s, int c, size_t n)
+{
+	return memset(s, c, n);
+}
+
 #endif
 
 #endif /* _LINUX_KMSAN_H */
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

