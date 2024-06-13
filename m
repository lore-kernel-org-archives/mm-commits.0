Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D09B83CF74
	for <mm-commits@vger.kernel.org>; Thu, 13 Jun 2024 20:31:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718310675; cv=none; b=goxu0dCdvUfKv8wxx/NKhSWg+meCqRtsWTaqHZLgcsUpBtUjHQdAq7Sj2P7TZJ8ImDk77+EEXOXUBC7ybAq473lUufn7PuK6TH9vsBCL1t8JUsL4VkgC8jLX4gb5TochtR3g5hUGGDV61r5n7wRxTP+QpIXr7VhHUF25XzRH4bI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718310675; c=relaxed/simple;
	bh=UHbqHggRAfQ9sS1W0w7/bGiuCZC+Kw6Hv4w1cdGe51U=;
	h=Date:To:From:Subject:Message-Id; b=qKtmQnao8PQwDCMKl17OUCF+ubp/PHeRPaJ4OCm20D8PeDtou0gZHhjq1bQ7LzT0DgoZw3j/Jr0HlrEV6zyzN2i4QCn5qomY3x+lxkoJ3Fm6T5SrHQBaJErSFvg6W+4JL3iH/k/vm84qUDw6CMkNjouscXDCDxefBQRxVYbOG4o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Fpl0LuzU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Fpl0LuzU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B44FC2BBFC;
	Thu, 13 Jun 2024 20:31:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1718310675;
	bh=UHbqHggRAfQ9sS1W0w7/bGiuCZC+Kw6Hv4w1cdGe51U=;
	h=Date:To:From:Subject:From;
	b=Fpl0LuzUui1Cm4jiu6gN6A+BL+TgaY8xFosnA53lfw3S8XqxQB/djMfZ3Jlfa6paL
	 AbAMAJN6wY87PX060uZTSUNSrx9jxLkt/0ld5HrZK3IyF37JnzEGynui+rk35rDJdc
	 N5ctXkNEPhwqH37LC+bOr8X7FZEpurfDhrbUXkNE=
Date: Thu, 13 Jun 2024 13:31:15 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,svens@linux.ibm.com,rostedt@goodmis.org,roman.gushchin@linux.dev,rientjes@google.com,penberg@kernel.org,mhiramat@kernel.org,mark.rutland@arm.com,iamjoonsoo.kim@lge.com,hca@linux.ibm.com,gor@linux.ibm.com,glider@google.com,elver@google.com,dvyukov@google.com,cl@linux.com,borntraeger@linux.ibm.com,agordeev@linux.ibm.com,42.hyeyoo@gmail.com,iii@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + s390-checksum-add-a-kmsan-check.patch added to mm-unstable branch
Message-Id: <20240613203115.9B44FC2BBFC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: s390/checksum: add a KMSAN check
has been added to the -mm mm-unstable branch.  Its filename is
     s390-checksum-add-a-kmsan-check.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/s390-checksum-add-a-kmsan-check.patch

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
Subject: s390/checksum: add a KMSAN check
Date: Thu, 13 Jun 2024 17:34:25 +0200

Add a KMSAN check to the CKSM inline assembly, similar to how it was
done for ASAN in commit e42ac7789df6 ("s390/checksum: always use cksm
instruction").

Link: https://lkml.kernel.org/r/20240613153924.961511-24-iii@linux.ibm.com
Signed-off-by: Ilya Leoshkevich <iii@linux.ibm.com>
Acked-by: Alexander Gordeev <agordeev@linux.ibm.com>
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
Cc: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Steven Rostedt (Google) <rostedt@goodmis.org>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/s390/include/asm/checksum.h |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/s390/include/asm/checksum.h~s390-checksum-add-a-kmsan-check
+++ a/arch/s390/include/asm/checksum.h
@@ -13,6 +13,7 @@
 #define _S390_CHECKSUM_H
 
 #include <linux/instrumented.h>
+#include <linux/kmsan-checks.h>
 #include <linux/in6.h>
 
 static inline __wsum cksm(const void *buff, int len, __wsum sum)
@@ -23,6 +24,7 @@ static inline __wsum cksm(const void *bu
 	};
 
 	instrument_read(buff, len);
+	kmsan_check_memory(buff, len);
 	asm volatile("\n"
 		"0:	cksm	%[sum],%[rp]\n"
 		"	jo	0b\n"
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

