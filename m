Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F3A78C04
	for <mm-commits@vger.kernel.org>; Thu, 20 Jun 2024 00:58:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718845124; cv=none; b=a//wzaarLSlSKwec0N6ok3OTvitBrYLBD8bBjjmKu3+rHrrFxOJLMJ+Oeo8WQ6Mbhgc5H/Cs8PhimdLVeU1NtyMTd/vkdwhzxY0jgjEgQ1CHZfdG+OJ4Ez0sYEhvOB+bgb3iXrl2Gsh1YHmJkBc8K9LCBhHlt6hBzZv0gNcn2JA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718845124; c=relaxed/simple;
	bh=E9bT0FT65z0KWxbGxz9YMh0UYuPR2t1JUBapcm+zn2k=;
	h=Date:To:From:Subject:Message-Id; b=fs6LoRg5Bo2m399DXCp9YoKjGZCBHzeVlAFNHsvdTQ8p6I0kUyuWsaOIGsexn6rPtHq8uBZtC+22uGnUSTIpkMS5XJ8MVtBd/6OLj719ghIMDYfMSdS471EDOSpaBqjAvbnbuThvyNkBvXZHYFYXhaOLWrc7Vsq2C2jdfN1PGNQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=b/W2jgy/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="b/W2jgy/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63957C2BBFC;
	Thu, 20 Jun 2024 00:58:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1718845124;
	bh=E9bT0FT65z0KWxbGxz9YMh0UYuPR2t1JUBapcm+zn2k=;
	h=Date:To:From:Subject:From;
	b=b/W2jgy/aYGVY9uxwvPshrY5jNnTEqpzmuwZqmj5KXHFrAVUAl2U4Rav9B5J+6vBT
	 cdSRcGLAEw2lvO2XUs/Bd9ezxAI8m1eSVRFPAZFKx/qB8s68NGofE/V/blT8OYraOi
	 w3X3qA/TcoQxNEy4UtVTu/JLN+M6uI7aeex5XB5Y=
Date: Wed, 19 Jun 2024 17:58:43 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,svens@linux.ibm.com,rostedt@goodmis.org,roman.gushchin@linux.dev,rientjes@google.com,penberg@kernel.org,mhiramat@kernel.org,mark.rutland@arm.com,kasan-dev@googlegroups.com,iamjoonsoo.kim@lge.com,hca@linux.ibm.com,gor@linux.ibm.com,glider@google.com,elver@google.com,dvyukov@google.com,cl@linux.com,borntraeger@linux.ibm.com,agordeev@linux.ibm.com,42.hyeyoo@gmail.com,iii@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kmsan-do-not-round-up-pg_data_t-size.patch added to mm-unstable branch
Message-Id: <20240620005844.63957C2BBFC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kmsan: do not round up pg_data_t size
has been added to the -mm mm-unstable branch.  Its filename is
     kmsan-do-not-round-up-pg_data_t-size.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kmsan-do-not-round-up-pg_data_t-size.patch

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
Subject: kmsan: do not round up pg_data_t size
Date: Wed, 19 Jun 2024 17:43:50 +0200

x86's alloc_node_data() rounds up node data size to PAGE_SIZE.  It's not
explained why it's needed, but it's most likely for performance reasons,
since the padding bytes are not used anywhere.  Some other architectures
do it as well, e.g., mips rounds it up to the cache line size.

kmsan_init_shadow() initializes metadata for each node data and assumes
the x86 rounding, which does not match other architectures.  This may
cause the range end to overshoot the end of available memory, in turn
causing virt_to_page_or_null() in kmsan_init_alloc_meta_for_range() to
return NULL, which leads to kernel panic shortly after.

Since the padding bytes are not used, drop the rounding.

Link: https://lkml.kernel.org/r/20240619154530.163232-16-iii@linux.ibm.com
Signed-off-by: Ilya Leoshkevich <iii@linux.ibm.com>
Reviewed-by: Alexander Potapenko <glider@google.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
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

 mm/kmsan/init.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/kmsan/init.c~kmsan-do-not-round-up-pg_data_t-size
+++ a/mm/kmsan/init.c
@@ -72,7 +72,7 @@ static void __init kmsan_record_future_s
  */
 void __init kmsan_init_shadow(void)
 {
-	const size_t nd_size = roundup(sizeof(pg_data_t), PAGE_SIZE);
+	const size_t nd_size = sizeof(pg_data_t);
 	phys_addr_t p_start, p_end;
 	u64 loop;
 	int nid;
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

