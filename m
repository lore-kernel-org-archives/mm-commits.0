Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A1786D1D6
	for <mm-commits@vger.kernel.org>; Thu, 14 Dec 2023 22:43:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1P2r4xdr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3660C433C8;
	Thu, 14 Dec 2023 22:43:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702593827;
	bh=nE0PaTvN9faawp+4qR+shijRdZMnVVhqlNLYks2eQHg=;
	h=Date:To:From:Subject:From;
	b=1P2r4xdrwFb0xD16K3UUXeE6gotuECSEzAvAnKDxsnGcukpHsY+bzz+gvtsqZaQXA
	 3d0M14VzUYkwT/uCMKJCKVyTF5oRE4sYSR9GKHWl8pvrVaoK2hOIeShseelRgZUBoj
	 cWPzfPF8cz/0/rk9GG+1nLwHNkdBxOAGFFyE1cGY=
Date: Thu, 14 Dec 2023 14:43:47 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,svens@linux.ibm.com,rostedt@goodmis.org,roman.gushchin@linux.dev,rientjes@google.com,penberg@kernel.org,mhiramat@kernel.org,mark.rutland@arm.com,iamjoonsoo.kim@lge.com,hca@linux.ibm.com,gor@linux.ibm.com,glider@google.com,elver@google.com,dvyukov@google.com,cl@linux.com,borntraeger@linux.ibm.com,agordeev@linux.ibm.com,42.hyeyoo@gmail.com,iii@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + s390-turn-off-kmsan-for-boot-vdso-and-purgatory.patch added to mm-unstable branch
Message-Id: <20231214224347.D3660C433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: s390: turn off KMSAN for boot, vdso and purgatory
has been added to the -mm mm-unstable branch.  Its filename is
     s390-turn-off-kmsan-for-boot-vdso-and-purgatory.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/s390-turn-off-kmsan-for-boot-vdso-and-purgatory.patch

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
Subject: s390: turn off KMSAN for boot, vdso and purgatory
Date: Thu, 14 Dec 2023 00:24:39 +0100

All other sanitizers are disabled for these components as well.  While at
it, add a comment to boot and purgatory.

Link: https://lkml.kernel.org/r/20231213233605.661251-20-iii@linux.ibm.com
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
Cc: Marco Elver <elver@google.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Steven Rostedt (Google) <rostedt@goodmis.org>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/s390/boot/Makefile          |    2 ++
 arch/s390/kernel/vdso32/Makefile |    3 ++-
 arch/s390/kernel/vdso64/Makefile |    3 ++-
 arch/s390/purgatory/Makefile     |    2 ++
 4 files changed, 8 insertions(+), 2 deletions(-)

--- a/arch/s390/boot/Makefile~s390-turn-off-kmsan-for-boot-vdso-and-purgatory
+++ a/arch/s390/boot/Makefile
@@ -3,11 +3,13 @@
 # Makefile for the linux s390-specific parts of the memory manager.
 #
 
+# Tooling runtimes are unavailable and cannot be linked for early boot code
 KCOV_INSTRUMENT := n
 GCOV_PROFILE := n
 UBSAN_SANITIZE := n
 KASAN_SANITIZE := n
 KCSAN_SANITIZE := n
+KMSAN_SANITIZE := n
 
 KBUILD_AFLAGS := $(KBUILD_AFLAGS_DECOMPRESSOR)
 KBUILD_CFLAGS := $(KBUILD_CFLAGS_DECOMPRESSOR)
--- a/arch/s390/kernel/vdso32/Makefile~s390-turn-off-kmsan-for-boot-vdso-and-purgatory
+++ a/arch/s390/kernel/vdso32/Makefile
@@ -32,11 +32,12 @@ obj-y += vdso32_wrapper.o
 targets += vdso32.lds
 CPPFLAGS_vdso32.lds += -P -C -U$(ARCH)
 
-# Disable gcov profiling, ubsan and kasan for VDSO code
+# Disable gcov profiling, ubsan, kasan and kmsan for VDSO code
 GCOV_PROFILE := n
 UBSAN_SANITIZE := n
 KASAN_SANITIZE := n
 KCSAN_SANITIZE := n
+KMSAN_SANITIZE := n
 
 # Force dependency (incbin is bad)
 $(obj)/vdso32_wrapper.o : $(obj)/vdso32.so
--- a/arch/s390/kernel/vdso64/Makefile~s390-turn-off-kmsan-for-boot-vdso-and-purgatory
+++ a/arch/s390/kernel/vdso64/Makefile
@@ -36,11 +36,12 @@ obj-y += vdso64_wrapper.o
 targets += vdso64.lds
 CPPFLAGS_vdso64.lds += -P -C -U$(ARCH)
 
-# Disable gcov profiling, ubsan and kasan for VDSO code
+# Disable gcov profiling, ubsan, kasan and kmsan for VDSO code
 GCOV_PROFILE := n
 UBSAN_SANITIZE := n
 KASAN_SANITIZE := n
 KCSAN_SANITIZE := n
+KMSAN_SANITIZE := n
 
 # Force dependency (incbin is bad)
 $(obj)/vdso64_wrapper.o : $(obj)/vdso64.so
--- a/arch/s390/purgatory/Makefile~s390-turn-off-kmsan-for-boot-vdso-and-purgatory
+++ a/arch/s390/purgatory/Makefile
@@ -15,11 +15,13 @@ CFLAGS_sha256.o := -D__DISABLE_EXPORTS -
 $(obj)/mem.o: $(srctree)/arch/s390/lib/mem.S FORCE
 	$(call if_changed_rule,as_o_S)
 
+# Tooling runtimes are unavailable and cannot be linked for purgatory code
 KCOV_INSTRUMENT := n
 GCOV_PROFILE := n
 UBSAN_SANITIZE := n
 KASAN_SANITIZE := n
 KCSAN_SANITIZE := n
+KMSAN_SANITIZE := n
 
 KBUILD_CFLAGS := -fno-strict-aliasing -Wall -Wstrict-prototypes
 KBUILD_CFLAGS += -Wno-pointer-sign -Wno-sign-compare
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

