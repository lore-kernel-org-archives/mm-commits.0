Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D971218EAD
	for <mm-commits@vger.kernel.org>; Tue,  5 Nov 2024 04:00:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730779241; cv=none; b=NsO0iB1TwzCssMMZWsqD9BP+6vpLrmLP6seaQoK5kSJN7yvSKUF2RxMxi3eZlw9kfc1OR2CRUeABkWy6jpQ3B0Li/cYfx4MJd69QuhbpgBYZJ8sgIo1qYjfIsMR8zxQXC5excwD1Vc0c4n+PJVVRxJKR/tCDVWppkTYDsKkkfM8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730779241; c=relaxed/simple;
	bh=GqJ/hFe0Nu5+qlszkQlU4iWd3KV/fo3eaKf4NSsDe7s=;
	h=Date:To:From:Subject:Message-Id; b=gkA2R6RwG6hdylT4Md/qQwBJzjvI2FwS8OZHdfP++VkfKx/qv9tBWJ6qQYXNass/017TWsNiagrZx+c6R2+tPOyZViUTQSb2TNSnNziukTsM/c4BtZk/jBkmr1UUwCPJIzR8PuMd9rs2wiuR1llWaK9yaYDDf0GW+BX4+Wb9Alk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1hAjwz5A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1hAjwz5A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99C1BC4CECF;
	Tue,  5 Nov 2024 04:00:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730779241;
	bh=GqJ/hFe0Nu5+qlszkQlU4iWd3KV/fo3eaKf4NSsDe7s=;
	h=Date:To:From:Subject:From;
	b=1hAjwz5ABHJQsxUkdzht+UBjFfOAYLaM4lwRNvLB+jMW16ebzCVIIrSosoAY3i2u3
	 fd3oLkMm7jd0uyfz/ab5iejpOWQBYFGPzLkZOmXNEclUdj1hBQoVjjaPg+ootytXoZ
	 UdeXy12LhqLWg8WZx9eILqMso5b+RMUNBuiB43xM=
Date: Mon, 04 Nov 2024 20:00:41 -0800
To: mm-commits@vger.kernel.org,natanielfarzan@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + improve-consistency-of-error-directive-messages.patch added to mm-nonmm-unstable branch
Message-Id: <20241105040041.99C1BC4CECF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: Improve consistency of '#error' directive messages
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     improve-consistency-of-error-directive-messages.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/improve-consistency-of-error-directive-messages.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: Nataniel Farzan <natanielfarzan@gmail.com>
Subject: Improve consistency of '#error' directive messages
Date: Mon, 4 Nov 2024 19:22:32 -0800

Remove the use of contractions and use proper punctuation in #error
directive messages that discourage the direct inclusion of header files.

Link: https://lkml.kernel.org/r/20241105032231.28833-1-natanielfarzan@gmail.com
Signed-off-by: Nataniel Farzan <natanielfarzan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/include/asm/spinlock_types.h          |    2 +-
 arch/arm/include/asm/spinlock_types.h            |    2 +-
 arch/arm64/include/asm/spinlock_types.h          |    2 +-
 arch/hexagon/include/asm/spinlock_types.h        |    2 +-
 arch/powerpc/include/asm/simple_spinlock_types.h |    2 +-
 arch/powerpc/include/asm/spinlock_types.h        |    2 +-
 arch/s390/include/asm/spinlock_types.h           |    2 +-
 arch/sh/include/asm/spinlock_types.h             |    2 +-
 arch/xtensa/include/asm/spinlock_types.h         |    2 +-
 include/acpi/platform/aclinux.h                  |    2 +-
 include/linux/compiler-clang.h                   |    2 +-
 include/linux/compiler-gcc.h                     |    2 +-
 include/linux/pm_wakeup.h                        |    2 +-
 include/linux/rwlock.h                           |    2 +-
 include/linux/rwlock_api_smp.h                   |    2 +-
 include/linux/spinlock_api_smp.h                 |    2 +-
 include/linux/spinlock_types_up.h                |    2 +-
 include/linux/spinlock_up.h                      |    2 +-
 tools/include/linux/compiler-gcc.h               |    2 +-
 19 files changed, 19 insertions(+), 19 deletions(-)

--- a/arch/alpha/include/asm/spinlock_types.h~improve-consistency-of-error-directive-messages
+++ a/arch/alpha/include/asm/spinlock_types.h
@@ -3,7 +3,7 @@
 #define _ALPHA_SPINLOCK_TYPES_H
 
 #ifndef __LINUX_SPINLOCK_TYPES_RAW_H
-# error "please don't include this file directly"
+# error "Please do not include this file directly."
 #endif
 
 typedef struct {
--- a/arch/arm64/include/asm/spinlock_types.h~improve-consistency-of-error-directive-messages
+++ a/arch/arm64/include/asm/spinlock_types.h
@@ -6,7 +6,7 @@
 #define __ASM_SPINLOCK_TYPES_H
 
 #if !defined(__LINUX_SPINLOCK_TYPES_RAW_H) && !defined(__ASM_SPINLOCK_H)
-# error "please don't include this file directly"
+# error "Please do not include this file directly."
 #endif
 
 #include <asm-generic/qspinlock_types.h>
--- a/arch/arm/include/asm/spinlock_types.h~improve-consistency-of-error-directive-messages
+++ a/arch/arm/include/asm/spinlock_types.h
@@ -3,7 +3,7 @@
 #define __ASM_SPINLOCK_TYPES_H
 
 #ifndef __LINUX_SPINLOCK_TYPES_RAW_H
-# error "please don't include this file directly"
+# error "Please do not include this file directly."
 #endif
 
 #define TICKET_SHIFT	16
--- a/arch/hexagon/include/asm/spinlock_types.h~improve-consistency-of-error-directive-messages
+++ a/arch/hexagon/include/asm/spinlock_types.h
@@ -9,7 +9,7 @@
 #define _ASM_SPINLOCK_TYPES_H
 
 #ifndef __LINUX_SPINLOCK_TYPES_RAW_H
-# error "please don't include this file directly"
+# error "Please do not include this file directly."
 #endif
 
 typedef struct {
--- a/arch/powerpc/include/asm/simple_spinlock_types.h~improve-consistency-of-error-directive-messages
+++ a/arch/powerpc/include/asm/simple_spinlock_types.h
@@ -3,7 +3,7 @@
 #define _ASM_POWERPC_SIMPLE_SPINLOCK_TYPES_H
 
 #ifndef __LINUX_SPINLOCK_TYPES_RAW_H
-# error "please don't include this file directly"
+# error "Please do not include this file directly."
 #endif
 
 typedef struct {
--- a/arch/powerpc/include/asm/spinlock_types.h~improve-consistency-of-error-directive-messages
+++ a/arch/powerpc/include/asm/spinlock_types.h
@@ -3,7 +3,7 @@
 #define _ASM_POWERPC_SPINLOCK_TYPES_H
 
 #ifndef __LINUX_SPINLOCK_TYPES_RAW_H
-# error "please don't include this file directly"
+# error "Please do not include this file directly."
 #endif
 
 #ifdef CONFIG_PPC_QUEUED_SPINLOCKS
--- a/arch/s390/include/asm/spinlock_types.h~improve-consistency-of-error-directive-messages
+++ a/arch/s390/include/asm/spinlock_types.h
@@ -3,7 +3,7 @@
 #define __ASM_SPINLOCK_TYPES_H
 
 #ifndef __LINUX_SPINLOCK_TYPES_RAW_H
-# error "please don't include this file directly"
+# error "Please do not include this file directly."
 #endif
 
 typedef struct {
--- a/arch/sh/include/asm/spinlock_types.h~improve-consistency-of-error-directive-messages
+++ a/arch/sh/include/asm/spinlock_types.h
@@ -3,7 +3,7 @@
 #define __ASM_SH_SPINLOCK_TYPES_H
 
 #ifndef __LINUX_SPINLOCK_TYPES_RAW_H
-# error "please don't include this file directly"
+# error "Please do not include this file directly."
 #endif
 
 typedef struct {
--- a/arch/xtensa/include/asm/spinlock_types.h~improve-consistency-of-error-directive-messages
+++ a/arch/xtensa/include/asm/spinlock_types.h
@@ -3,7 +3,7 @@
 #define __ASM_SPINLOCK_TYPES_H
 
 #if !defined(__LINUX_SPINLOCK_TYPES_RAW_H) && !defined(__ASM_SPINLOCK_H)
-# error "please don't include this file directly"
+# error "Please do not include this file directly."
 #endif
 
 #include <asm-generic/qspinlock_types.h>
--- a/include/acpi/platform/aclinux.h~improve-consistency-of-error-directive-messages
+++ a/include/acpi/platform/aclinux.h
@@ -15,7 +15,7 @@
 /* ACPICA external files should not include ACPICA headers directly. */
 
 #if !defined(BUILDING_ACPICA) && !defined(_LINUX_ACPI_H)
-#error "Please don't include <acpi/acpi.h> directly, include <linux/acpi.h> instead."
+#error "Please do not include <acpi/acpi.h> directly, include <linux/acpi.h> instead."
 #endif
 
 #endif
--- a/include/linux/compiler-clang.h~improve-consistency-of-error-directive-messages
+++ a/include/linux/compiler-clang.h
@@ -1,6 +1,6 @@
 /* SPDX-License-Identifier: GPL-2.0 */
 #ifndef __LINUX_COMPILER_TYPES_H
-#error "Please don't include <linux/compiler-clang.h> directly, include <linux/compiler.h> instead."
+#error "Please do not include <linux/compiler-clang.h> directly, include <linux/compiler.h> instead."
 #endif
 
 /* Compiler specific definitions for Clang compiler */
--- a/include/linux/compiler-gcc.h~improve-consistency-of-error-directive-messages
+++ a/include/linux/compiler-gcc.h
@@ -1,6 +1,6 @@
 /* SPDX-License-Identifier: GPL-2.0 */
 #ifndef __LINUX_COMPILER_TYPES_H
-#error "Please don't include <linux/compiler-gcc.h> directly, include <linux/compiler.h> instead."
+#error "Please do not include <linux/compiler-gcc.h> directly, include <linux/compiler.h> instead."
 #endif
 
 /*
--- a/include/linux/pm_wakeup.h~improve-consistency-of-error-directive-messages
+++ a/include/linux/pm_wakeup.h
@@ -10,7 +10,7 @@
 #define _LINUX_PM_WAKEUP_H
 
 #ifndef _DEVICE_H_
-# error "please don't include this file directly"
+# error "Please do not include this file directly."
 #endif
 
 #include <linux/types.h>
--- a/include/linux/rwlock_api_smp.h~improve-consistency-of-error-directive-messages
+++ a/include/linux/rwlock_api_smp.h
@@ -2,7 +2,7 @@
 #define __LINUX_RWLOCK_API_SMP_H
 
 #ifndef __LINUX_SPINLOCK_API_SMP_H
-# error "please don't include this file directly"
+# error "Please do not include this file directly."
 #endif
 
 /*
--- a/include/linux/rwlock.h~improve-consistency-of-error-directive-messages
+++ a/include/linux/rwlock.h
@@ -2,7 +2,7 @@
 #define __LINUX_RWLOCK_H
 
 #ifndef __LINUX_INSIDE_SPINLOCK_H
-# error "please don't include this file directly"
+# error "Please do not include this file directly."
 #endif
 
 /*
--- a/include/linux/spinlock_api_smp.h~improve-consistency-of-error-directive-messages
+++ a/include/linux/spinlock_api_smp.h
@@ -2,7 +2,7 @@
 #define __LINUX_SPINLOCK_API_SMP_H
 
 #ifndef __LINUX_INSIDE_SPINLOCK_H
-# error "please don't include this file directly"
+# error "Please do not include this file directly."
 #endif
 
 /*
--- a/include/linux/spinlock_types_up.h~improve-consistency-of-error-directive-messages
+++ a/include/linux/spinlock_types_up.h
@@ -2,7 +2,7 @@
 #define __LINUX_SPINLOCK_TYPES_UP_H
 
 #ifndef __LINUX_SPINLOCK_TYPES_RAW_H
-# error "please don't include this file directly"
+# error "Please do not include this file directly."
 #endif
 
 /*
--- a/include/linux/spinlock_up.h~improve-consistency-of-error-directive-messages
+++ a/include/linux/spinlock_up.h
@@ -2,7 +2,7 @@
 #define __LINUX_SPINLOCK_UP_H
 
 #ifndef __LINUX_INSIDE_SPINLOCK_H
-# error "please don't include this file directly"
+# error "Please do not include this file directly."
 #endif
 
 #include <asm/processor.h>	/* for cpu_relax() */
--- a/tools/include/linux/compiler-gcc.h~improve-consistency-of-error-directive-messages
+++ a/tools/include/linux/compiler-gcc.h
@@ -1,6 +1,6 @@
 /* SPDX-License-Identifier: GPL-2.0 */
 #ifndef _TOOLS_LINUX_COMPILER_H_
-#error "Please don't include <linux/compiler-gcc.h> directly, include <linux/compiler.h> instead."
+#error "Please do not include <linux/compiler-gcc.h> directly, include <linux/compiler.h> instead."
 #endif
 
 /*
_

Patches currently in -mm which might be from natanielfarzan@gmail.com are

improve-consistency-of-error-directive-messages.patch

