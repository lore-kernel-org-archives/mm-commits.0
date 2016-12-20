From: akpm@linux-foundation.org
Subject: [patch 12/15] arm64: setup: introduce kaslr_offset()
Date: Mon, 19 Dec 2016 16:23:06 -0800
Message-ID: <585879ea.CZyC71bx2fZom0NB%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50632 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752993AbcLTAWH (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 19 Dec 2016 19:22:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, alex.popov@linux.com, andreyknvl@google.com, ard.biesheuvel@linaro.org, aryabinin@virtuozzo.com, catalin.marinas@arm.com, david.daney@cavium.com, dvyukov@google.com, gkulkarni@caviumnetworks.com, james.morse@arm.com, jcm@redhat.com, mark.rutland@arm.com, nicstange@gmail.com, robh@kernel.org, syzkaller@googlegroups.com, takahiro.akashi@linaro.org, wangkefeng.wang@huawei.com, will.deacon@arm.com

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
