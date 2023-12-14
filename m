Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C3C76DD0E
	for <mm-commits@vger.kernel.org>; Thu, 14 Dec 2023 22:43:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="OmiBxkRT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD045C433CB;
	Thu, 14 Dec 2023 22:43:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702593823;
	bh=Y/C0+BI+rvZJ3qFGNf/UIDNGNXpbzslh5/R4CNyl8eg=;
	h=Date:To:From:Subject:From;
	b=OmiBxkRT/RGCPK73hhzORIeL/g3tsWaww3ahY+gAqs+woNw2cbRJd1k0fi5W2QVCl
	 opobMtb9Ik0VaBHDZban+153Nq7GEi7bXoD6senA+Lh3Tw7Ebr0T1Z/TwwH/dAOwVo
	 ojXvaZ0jf4utMt2SgoJdTAK4hNgwcRF5IwOYhHrA=
Date: Thu, 14 Dec 2023 14:43:43 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,svens@linux.ibm.com,rostedt@goodmis.org,roman.gushchin@linux.dev,rientjes@google.com,penberg@kernel.org,mhiramat@kernel.org,mark.rutland@arm.com,iamjoonsoo.kim@lge.com,hca@linux.ibm.com,gor@linux.ibm.com,glider@google.com,elver@google.com,dvyukov@google.com,cl@linux.com,borntraeger@linux.ibm.com,agordeev@linux.ibm.com,42.hyeyoo@gmail.com,iii@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-kfence-disable-kmsan-when-checking-the-canary.patch added to mm-unstable branch
Message-Id: <20231214224343.CD045C433CB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: kfence: disable KMSAN when checking the canary
has been added to the -mm mm-unstable branch.  Its filename is
     mm-kfence-disable-kmsan-when-checking-the-canary.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-kfence-disable-kmsan-when-checking-the-canary.patch

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
Subject: mm: kfence: disable KMSAN when checking the canary
Date: Thu, 14 Dec 2023 00:24:36 +0100

KMSAN warns about check_canary() accessing the canary.

The reason is that, even though set_canary() is properly instrumented and
sets shadow, slub explicitly poisons the canary's address range
afterwards.

Unpoisoning the canary is not the right thing to do: only
check_canary() is supposed to ever touch it. Instead, disable KMSAN
checks around canary read accesses.

Link: https://lkml.kernel.org/r/20231213233605.661251-17-iii@linux.ibm.com
Signed-off-by: Ilya Leoshkevich <iii@linux.ibm.com>
Reviewed-by: Alexander Potapenko <glider@google.com>
Tested-by: Alexander Potapenko <glider@google.com>
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
Cc: Steven Rostedt (Google) <rostedt@goodmis.org>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kfence/core.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

--- a/mm/kfence/core.c~mm-kfence-disable-kmsan-when-checking-the-canary
+++ a/mm/kfence/core.c
@@ -305,8 +305,14 @@ metadata_update_state(struct kfence_meta
 	WRITE_ONCE(meta->state, next);
 }
 
+#ifdef CONFIG_KMSAN
+#define CHECK_CANARY_ATTRIBUTES noinline __no_kmsan_checks
+#else
+#define CHECK_CANARY_ATTRIBUTES inline
+#endif
+
 /* Check canary byte at @addr. */
-static inline bool check_canary_byte(u8 *addr)
+static CHECK_CANARY_ATTRIBUTES bool check_canary_byte(u8 *addr)
 {
 	struct kfence_metadata *meta;
 	unsigned long flags;
@@ -341,7 +347,8 @@ static inline void set_canary(const stru
 		*((u64 *)addr) = KFENCE_CANARY_PATTERN_U64;
 }
 
-static inline void check_canary(const struct kfence_metadata *meta)
+static CHECK_CANARY_ATTRIBUTES void
+check_canary(const struct kfence_metadata *meta)
 {
 	const unsigned long pageaddr = ALIGN_DOWN(meta->addr, PAGE_SIZE);
 	unsigned long addr = pageaddr;
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

