Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9D4F5684
	for <mm-commits@vger.kernel.org>; Thu, 20 Jun 2024 00:58:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718845138; cv=none; b=GqDqllBjcbS37TAmuV5cswETc1M34soS201qazqKNqfVdkV/yFZl1gKD0TFAVHykI/i07FXxF8zt78ViBLRFtxZ3Xmd9UrlSmuAo3fYaIuH/QGcvT2JE/iEi7kEGZEyJXZGOkknXy/x5zWAVJYOoh7HxEyJqm29YUsSh5h+T4AY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718845138; c=relaxed/simple;
	bh=XVek1xwh40kVANS8VY0/p97R58qI5ayT5JNzZYWfCOY=;
	h=Date:To:From:Subject:Message-Id; b=Ci5RUtivWvV1dVe7ymvm/mlkrt7S6e0z7x+orO32iAPFq+8/IVxjUY4yvmthM/salqA8bMLc3LW5dQgV3O2b4aLP61TPEwn/QU/YDg7NH+/Zy/71cIOU4N866i8l9hZGAwsqhzv0G1UuQV4E+B3WdEeXCxmoCTsGXgURBI0ylyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=PhGN6wik; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="PhGN6wik"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92442C2BBFC;
	Thu, 20 Jun 2024 00:58:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1718845138;
	bh=XVek1xwh40kVANS8VY0/p97R58qI5ayT5JNzZYWfCOY=;
	h=Date:To:From:Subject:From;
	b=PhGN6wikRpGLELzDS4bOyjN8RzqlUbUMuhbGtGD3MFgqpIPUtFLJPFKyWZq/9VG8A
	 EyflH7edmh4fqDzPPj9Mn4iYEwACyXp9UybRcoFBbf0otVmVKWL97zLCFu7OrL2JZt
	 xaHj4Zf6ZbjuB2sf8/J5rEjI2DI580pZ4dzKcQDA=
Date: Wed, 19 Jun 2024 17:58:58 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,svens@linux.ibm.com,rostedt@goodmis.org,roman.gushchin@linux.dev,rientjes@google.com,penberg@kernel.org,mhiramat@kernel.org,mark.rutland@arm.com,kasan-dev@googlegroups.com,iamjoonsoo.kim@lge.com,hca@linux.ibm.com,gor@linux.ibm.com,glider@google.com,elver@google.com,dvyukov@google.com,cl@linux.com,borntraeger@linux.ibm.com,agordeev@linux.ibm.com,42.hyeyoo@gmail.com,iii@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + s390-use-a-larger-stack-for-kmsan.patch added to mm-unstable branch
Message-Id: <20240620005858.92442C2BBFC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: s390: use a larger stack for KMSAN
has been added to the -mm mm-unstable branch.  Its filename is
     s390-use-a-larger-stack-for-kmsan.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/s390-use-a-larger-stack-for-kmsan.patch

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
Subject: s390: use a larger stack for KMSAN
Date: Wed, 19 Jun 2024 17:43:57 +0200

Adjust the stack size for the KMSAN-enabled kernel like it was done for
the KASAN-enabled one in commit 7fef92ccadd7 ("s390/kasan: double the
stack size").  Both tools have similar requirements.

Link: https://lkml.kernel.org/r/20240619154530.163232-23-iii@linux.ibm.com
Signed-off-by: Ilya Leoshkevich <iii@linux.ibm.com>
Reviewed-by: Alexander Gordeev <agordeev@linux.ibm.com>
Reviewed-by: Alexander Potapenko <glider@google.com>
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

 arch/s390/Makefile                  |    2 +-
 arch/s390/include/asm/thread_info.h |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/arch/s390/include/asm/thread_info.h~s390-use-a-larger-stack-for-kmsan
+++ a/arch/s390/include/asm/thread_info.h
@@ -16,7 +16,7 @@
 /*
  * General size of kernel stacks
  */
-#ifdef CONFIG_KASAN
+#if defined(CONFIG_KASAN) || defined(CONFIG_KMSAN)
 #define THREAD_SIZE_ORDER 4
 #else
 #define THREAD_SIZE_ORDER 2
--- a/arch/s390/Makefile~s390-use-a-larger-stack-for-kmsan
+++ a/arch/s390/Makefile
@@ -36,7 +36,7 @@ KBUILD_CFLAGS_DECOMPRESSOR += $(if $(CON
 KBUILD_CFLAGS_DECOMPRESSOR += $(if $(CONFIG_CC_NO_ARRAY_BOUNDS),-Wno-array-bounds)
 
 UTS_MACHINE	:= s390x
-STACK_SIZE	:= $(if $(CONFIG_KASAN),65536,16384)
+STACK_SIZE	:= $(if $(CONFIG_KASAN),65536,$(if $(CONFIG_KMSAN),65536,16384))
 CHECKFLAGS	+= -D__s390__ -D__s390x__
 
 export LD_BFD
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

