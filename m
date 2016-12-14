From: akpm@linux-foundation.org
Subject: + kcov-make-kcov-work-properly-with-kaslr-enabled.patch added to
 -mm tree
Date: Wed, 14 Dec 2016 12:57:09 -0800
Message-ID: <5851b225.Ea0ULq9fTIhkX2ne%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51956 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753117AbcLNU5b (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 14 Dec 2016 15:57:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alex.popov@linux.com, andreyknvl@google.com, ard.biesheuvel@linaro.org, aryabinin@virtuozzo.com, catalin.marinas@arm.com, david.daney@cavium.com, dvyukov@google.com, gkulkarni@caviumnetworks.com, james.morse@arm.com, jcm@redhat.com, mark.rutland@arm.com, nicstange@gmail.com, robh@kernel.org, syzkaller@googlegroups.com, takahiro.akashi@linaro.org, wangkefeng.wang@huawei.com, will.deacon@arm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kcov: make kcov work properly with KASLR enabled
has been added to the -mm tree.  Its filename is
     kcov-make-kcov-work-properly-with-kaslr-enabled.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kcov-make-kcov-work-properly-with-kaslr-enabled.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kcov-make-kcov-work-properly-with-kaslr-enabled.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Alexander Popov <alex.popov@linux.com>
Subject: kcov: make kcov work properly with KASLR enabled

Subtract KASLR offset from the kernel addresses reported by kcov.
Tested on x86_64 and AArch64 (Hikey LeMaker).

Link: http://lkml.kernel.org/r/1481417456-28826-3-git-send-email-alex.popov@linux.com
Signed-off-by: Alexander Popov <alex.popov@linux.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Rob Herring <robh@kernel.org>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: AKASHI Takahiro <takahiro.akashi@linaro.org>
Cc: Jon Masters <jcm@redhat.com>
Cc: David Daney <david.daney@cavium.com>
Cc: Ganapatrao Kulkarni <gkulkarni@caviumnetworks.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Nicolai Stange <nicstange@gmail.com>
Cc: James Morse <james.morse@arm.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Andrey Konovalov <andreyknvl@google.com>
Cc: Alexander Popov <alex.popov@linux.com>
Cc: syzkaller <syzkaller@googlegroups.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kcov.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff -puN kernel/kcov.c~kcov-make-kcov-work-properly-with-kaslr-enabled kernel/kcov.c
--- a/kernel/kcov.c~kcov-make-kcov-work-properly-with-kaslr-enabled
+++ a/kernel/kcov.c
@@ -14,6 +14,7 @@
 #include <linux/debugfs.h>
 #include <linux/uaccess.h>
 #include <linux/kcov.h>
+#include <asm/setup.h>
 
 /*
  * kcov descriptor (one per opened debugfs file).
@@ -68,6 +69,11 @@ void notrace __sanitizer_cov_trace_pc(vo
 	if (mode == KCOV_MODE_TRACE) {
 		unsigned long *area;
 		unsigned long pos;
+		unsigned long ip = _RET_IP_;
+
+#ifdef CONFIG_RANDOMIZE_BASE
+		ip -= kaslr_offset();
+#endif
 
 		/*
 		 * There is some code that runs in interrupts but for which
@@ -81,7 +87,7 @@ void notrace __sanitizer_cov_trace_pc(vo
 		/* The first word is number of subsequent PCs. */
 		pos = READ_ONCE(area[0]) + 1;
 		if (likely(pos < t->kcov_size)) {
-			area[pos] = _RET_IP_;
+			area[pos] = ip;
 			WRITE_ONCE(area[0], pos);
 		}
 	}
_

Patches currently in -mm which might be from alex.popov@linux.com are

arm64-setup-introduce-kaslr_offset.patch
kcov-make-kcov-work-properly-with-kaslr-enabled.patch

