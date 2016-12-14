From: akpm@linux-foundation.org
Subject: + arm64-setup-introduce-kaslr_offset.patch added to -mm tree
Date: Wed, 14 Dec 2016 12:57:06 -0800
Message-ID: <5851b222.HbMJUrn1uIklzqG4%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51930 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753080AbcLNU5b (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 14 Dec 2016 15:57:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alex.popov@linux.com, andreyknvl@google.com, ard.biesheuvel@linaro.org, aryabinin@virtuozzo.com, catalin.marinas@arm.com, david.daney@cavium.com, dvyukov@google.com, gkulkarni@caviumnetworks.com, james.morse@arm.com, jcm@redhat.com, mark.rutland@arm.com, nicstange@gmail.com, robh@kernel.org, syzkaller@googlegroups.com, takahiro.akashi@linaro.org, wangkefeng.wang@huawei.com, will.deacon@arm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: arm64: setup: introduce kaslr_offset()
has been added to the -mm tree.  Its filename is
     arm64-setup-introduce-kaslr_offset.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/arm64-setup-introduce-kaslr_offset.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/arm64-setup-introduce-kaslr_offset.patch

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
Subject: arm64: setup: introduce kaslr_offset()

Introduce kaslr_offset() similar to x86_64 to fix kcov.

Link: http://lkml.kernel.org/r/1481417456-28826-2-git-send-email-alex.popov@linux.com
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

 arch/arm64/include/asm/setup.h      |   19 +++++++++++++++++++
 arch/arm64/include/uapi/asm/setup.h |    4 ++--
 arch/arm64/kernel/setup.c           |    8 ++++----
 3 files changed, 25 insertions(+), 6 deletions(-)

diff -puN /dev/null arch/arm64/include/asm/setup.h
--- /dev/null
+++ a/arch/arm64/include/asm/setup.h
@@ -0,0 +1,19 @@
+/*
+ * arch/arm64/include/asm/setup.h
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef __ASM_SETUP_H
+#define __ASM_SETUP_H
+
+#include <uapi/asm/setup.h>
+
+static inline unsigned long kaslr_offset(void)
+{
+	return kimage_vaddr - KIMAGE_VADDR;
+}
+
+#endif
diff -puN arch/arm64/include/uapi/asm/setup.h~arm64-setup-introduce-kaslr_offset arch/arm64/include/uapi/asm/setup.h
--- a/arch/arm64/include/uapi/asm/setup.h~arm64-setup-introduce-kaslr_offset
+++ a/arch/arm64/include/uapi/asm/setup.h
@@ -16,8 +16,8 @@
  * You should have received a copy of the GNU General Public License
  * along with this program.  If not, see <http://www.gnu.org/licenses/>.
  */
-#ifndef __ASM_SETUP_H
-#define __ASM_SETUP_H
+#ifndef _UAPI__ASM_SETUP_H
+#define _UAPI__ASM_SETUP_H
 
 #include <linux/types.h>
 
diff -puN arch/arm64/kernel/setup.c~arm64-setup-introduce-kaslr_offset arch/arm64/kernel/setup.c
--- a/arch/arm64/kernel/setup.c~arm64-setup-introduce-kaslr_offset
+++ a/arch/arm64/kernel/setup.c
@@ -338,11 +338,11 @@ subsys_initcall(topology_init);
 static int dump_kernel_offset(struct notifier_block *self, unsigned long v,
 			      void *p)
 {
-	u64 const kaslr_offset = kimage_vaddr - KIMAGE_VADDR;
+	const unsigned long offset = kaslr_offset();
 
-	if (IS_ENABLED(CONFIG_RANDOMIZE_BASE) && kaslr_offset > 0) {
-		pr_emerg("Kernel Offset: 0x%llx from 0x%lx\n",
-			 kaslr_offset, KIMAGE_VADDR);
+	if (IS_ENABLED(CONFIG_RANDOMIZE_BASE) && offset > 0) {
+		pr_emerg("Kernel Offset: 0x%lx from 0x%lx\n",
+			 offset, KIMAGE_VADDR);
 	} else {
 		pr_emerg("Kernel Offset: disabled\n");
 	}
_

Patches currently in -mm which might be from alex.popov@linux.com are

arm64-setup-introduce-kaslr_offset.patch
kcov-make-kcov-work-properly-with-kaslr-enabled.patch

