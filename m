Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 754EB1F7569
	for <mm-commits@vger.kernel.org>; Thu, 13 Mar 2025 22:05:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741903537; cv=none; b=ppYZ2Wmbwih4ZGvmZhNl1EjwESqeeEYjE+jIwitLu5QHvCE6X2WCDhWJi1AsaIPkXHfM8Lmlmd56D4KxGmZE8jubHzbC/q0OwLMvkSw7Wvj27Esuig3VfFzoZ7ao8o9FPw/Qee/ptSU0OFxmaP26ObSV3XQtH/loOeYMpmaMHKA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741903537; c=relaxed/simple;
	bh=DCY/Oiwx3OHV/98luJlme4z4yEKYfpZPSl/xEFkJ0S0=;
	h=Date:To:From:Subject:Message-Id; b=SMvEt/7Euoe+YfRoPR17G3HWM07q5mKQ1w3KouMcMroaCgX9dTJ9dOel8FXEbSHxoDI8KxTejcG+bjPmRQCHRcAoQWO5+Vt4+xCseF14hT3+AD953pTLKOKb0ulHPSdsm0OjpRX7Aanly3atc2eqXjqOIxwuNfqgAF4AEfmpsPk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=TMyJKWnt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="TMyJKWnt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E388FC4CEDD;
	Thu, 13 Mar 2025 22:05:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1741903537;
	bh=DCY/Oiwx3OHV/98luJlme4z4yEKYfpZPSl/xEFkJ0S0=;
	h=Date:To:From:Subject:From;
	b=TMyJKWntiV65ntOG0iX8+gyg35jrRoHqz4MSdwX4vC/Ujkr6ObkskTBORFqZfIu7T
	 +mXjI6rHiYnneX7yRFhXnN4AM/bNCBwEuaBs8/tNoyv+Ff8cAndqoL2TpoayJWKjzG
	 Ay8rTUaAtNVx9MDCsUj1HMzFncUW53J5KYT7V4IE=
Date: Thu, 13 Mar 2025 15:05:36 -0700
To: mm-commits@vger.kernel.org,ysato@users.sourceforge.jp,will@kernel.org,ville.syrjala@linux.intel.com,tzimmermann@suse.de,tglx@linutronix.de,rmoar@google.com,paul.walmsley@sifive.com,palmer@dabbelt.com,naresh.kamboju@linaro.org,mripard@kernel.org,mpe@ellerman.id.au,mingo@redhat.com,mcanal@igalia.com,maarten.lankhorst@linux.intel.com,lkft@linaro.org,keescook@chromium.org,jani.nikula@intel.com,horms@kernel.org,hca@linux.ibm.com,gor@linux.ibm.com,glaubitz@physik.fu-berlin.de,deller@gmx.de,davidgow@google.com,dave.hansen@linux.intel.com,daniel@ffwll.ch,daniel.diaz@linaro.org,dan.carpenter@linaro.org,dalias@libc.org,chenhuacai@kernel.org,charlie@rivosinc.com,catalin.marinas@arm.com,brendan.higgins@linux.dev,bp@alien8.de,arthurgrillo@riseup.net,arnd@arndb.de,aou@eecs.berkeley.edu,airlied@gmail.com,agordeev@linux.ibm.com,acarmina@redhat.com,linux@roeck-us.net,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + sh-move-defines-needed-for-suppressing-warning-backtraces.patch added to mm-nonmm-unstable branch
Message-Id: <20250313220536.E388FC4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: sh: move defines needed for suppressing warning backtraces
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     sh-move-defines-needed-for-suppressing-warning-backtraces.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/sh-move-defines-needed-for-suppressing-warning-backtraces.patch

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
From: Guenter Roeck <linux@roeck-us.net>
Subject: sh: move defines needed for suppressing warning backtraces
Date: Thu, 13 Mar 2025 11:43:27 +0000

Declaring the defines needed for suppressing warning inside
'#ifdef CONFIG_DEBUG_BUGVERBOSE' results in a kerneldoc warning.

.../bug.h:29: warning: expecting prototype for _EMIT_BUG_ENTRY().
	Prototype was for HAVE_BUG_FUNCTION() instead

Move the defines above the kerneldoc entry for _EMIT_BUG_ENTRY
to make kerneldoc happy.

Link: https://lkml.kernel.org/r/20250313114329.284104-13-acarmina@redhat.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Alessandro Carminati <acarmina@redhat.com>
Reported-by: Simon Horman <horms@kernel.org>
Cc: Simon Horman <horms@kernel.org>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Cc: Rich Felker <dalias@libc.org>
Cc: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Arthur Grillo <arthurgrillo@riseup.net>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Charlie Jenkins <charlie@rivosinc.com>
Cc: Dan Carpenter <dan.carpenter@linaro.org>
Cc: Daniel Diaz <daniel.diaz@linaro.org>
Cc: Daniel Vetter <daniel@ffwll.ch>
Cc: Dave Airlie <airlied@gmail.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David Gow <davidgow@google.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Helge Deller <deller@gmx.de>
Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jani Nikula <jani.nikula@intel.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Linux Kernel Functional Testing <lkft@linaro.org>
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Cc: Maíra Canal <mcanal@igalia.com>
Cc: Maxime Ripard <mripard@kernel.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Naresh Kamboju <naresh.kamboju@linaro.org>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Rae Moar <rmoar@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Thomas Zimemrmann <tzimmermann@suse.de>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Ville Syrjala <ville.syrjala@linux.intel.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sh/include/asm/bug.h |   16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

--- a/arch/sh/include/asm/bug.h~sh-move-defines-needed-for-suppressing-warning-backtraces
+++ a/arch/sh/include/asm/bug.h
@@ -11,6 +11,15 @@
 #define HAVE_ARCH_BUG
 #define HAVE_ARCH_WARN_ON
 
+#ifdef CONFIG_DEBUG_BUGVERBOSE
+#ifdef CONFIG_KUNIT_SUPPRESS_BACKTRACE
+# define HAVE_BUG_FUNCTION
+# define __BUG_FUNC_PTR	"\t.long %O2\n"
+#else
+# define __BUG_FUNC_PTR
+#endif /* CONFIG_KUNIT_SUPPRESS_BACKTRACE */
+#endif /* CONFIG_DEBUG_BUGVERBOSE */
+
 /**
  * _EMIT_BUG_ENTRY
  * %1 - __FILE__
@@ -25,13 +34,6 @@
  */
 #ifdef CONFIG_DEBUG_BUGVERBOSE
 
-#ifdef CONFIG_KUNIT_SUPPRESS_BACKTRACE
-# define HAVE_BUG_FUNCTION
-# define __BUG_FUNC_PTR	"\t.long %O2\n"
-#else
-# define __BUG_FUNC_PTR
-#endif /* CONFIG_KUNIT_SUPPRESS_BACKTRACE */
-
 #define _EMIT_BUG_ENTRY				\
 	"\t.pushsection __bug_table,\"aw\"\n"	\
 	"2:\t.long 1b, %O1\n"			\
_

Patches currently in -mm which might be from linux@roeck-us.net are

bug-kunit-core-support-for-suppressing-warning-backtraces.patch
kunit-bug-count-suppressed-warning-backtraces.patch
kunit-add-test-cases-for-backtrace-warning-suppression.patch
kunit-add-documentation-for-warning-backtrace-suppression-api.patch
drm-suppress-intentional-warning-backtraces-in-scaling-unit-tests.patch
x86-add-support-for-suppressing-warning-backtraces.patch
arm64-add-support-for-suppressing-warning-backtraces.patch
loongarch-add-support-for-suppressing-warning-backtraces.patch
parisc-add-support-for-suppressing-warning-backtraces.patch
s390-add-support-for-suppressing-warning-backtraces.patch
sh-add-support-for-suppressing-warning-backtraces.patch
sh-move-defines-needed-for-suppressing-warning-backtraces.patch
riscv-add-support-for-suppressing-warning-backtraces.patch
powerpc-add-support-for-suppressing-warning-backtraces.patch

