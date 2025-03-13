Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3D141F75A9
	for <mm-commits@vger.kernel.org>; Thu, 13 Mar 2025 22:05:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741903522; cv=none; b=Osv2TE8Yyn45vRt/y8HhkoIWJsefv3KsCmbB00+53rpLp84j0yi1K/IqPTfpGDzLMiGkj2NDXfW9kJV9gAO5IYvfoeioNayklIKj3r4jYJgowNKlZrUFnGk9sXYpKTxqAw41+TvJAn9L7lrwaIeIANZwHSmNEXeRhTwYuOcxaRs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741903522; c=relaxed/simple;
	bh=gEDrrXbaRO/tY0RJ1ZG/IWNQUxfiXb+Px9ESYDUxo+g=;
	h=Date:To:From:Subject:Message-Id; b=C8vsrpKMSaJY2HfYQHpFzlIqXVNDre7LNJM4lDtXMcmpKmFwZC1IALBy1x/BzWOzZQXDhjXGkJY9EbKqjG/QbRct80DcS4c96DbL8MEoGg1LqmEo+McdbSSiCuPj5wpnZm4wY4lVEejfxHdQK7D586xRdszpSJ7J2KOmtvtnkEM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=sVucXAi3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="sVucXAi3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5171C4CEEB;
	Thu, 13 Mar 2025 22:05:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1741903521;
	bh=gEDrrXbaRO/tY0RJ1ZG/IWNQUxfiXb+Px9ESYDUxo+g=;
	h=Date:To:From:Subject:From;
	b=sVucXAi3ZNse7feoXIikUZaspaNPaRIxTXq/vxIbKscG1EuQ0wB3eKCJHmJs/QoCg
	 oFnYv/the4DJCzKUP1vS13SdvwIpJzi/htFOejWmkx3p1R8JcSW6bRocx/nqYrBcyj
	 ifGVJztaGe3cEs+VCGZw6dFSlm4769hMWfdWPgrI=
Date: Thu, 13 Mar 2025 15:05:21 -0700
To: mm-commits@vger.kernel.org,ysato@users.sourceforge.jp,will@kernel.org,ville.syrjala@linux.intel.com,tzimmermann@suse.de,tglx@linutronix.de,rmoar@google.com,paul.walmsley@sifive.com,palmer@dabbelt.com,naresh.kamboju@linaro.org,mripard@kernel.org,mpe@ellerman.id.au,mingo@redhat.com,mcanal@igalia.com,maarten.lankhorst@linux.intel.com,lkft@linaro.org,keescook@chromium.org,jani.nikula@intel.com,horms@kernel.org,hca@linux.ibm.com,gor@linux.ibm.com,glaubitz@physik.fu-berlin.de,deller@gmx.de,davidgow@google.com,dave.hansen@linux.intel.com,daniel@ffwll.ch,daniel.diaz@linaro.org,dan.carpenter@linaro.org,dalias@libc.org,chenhuacai@kernel.org,charlie@rivosinc.com,catalin.marinas@arm.com,brendan.higgins@linux.dev,bp@alien8.de,arthurgrillo@riseup.net,arnd@arndb.de,aou@eecs.berkeley.edu,airlied@gmail.com,agordeev@linux.ibm.com,acarmina@redhat.com,linux@roeck-us.net,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kunit-add-test-cases-for-backtrace-warning-suppression.patch added to mm-nonmm-unstable branch
Message-Id: <20250313220521.A5171C4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kunit: add test cases for backtrace warning suppression
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kunit-add-test-cases-for-backtrace-warning-suppression.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kunit-add-test-cases-for-backtrace-warning-suppression.patch

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
Subject: kunit: add test cases for backtrace warning suppression
Date: Thu, 13 Mar 2025 11:43:18 +0000

Add unit tests to verify that warning backtrace suppression works.

If backtrace suppression does _not_ work, the unit tests will likely
trigger unsuppressed backtraces, which should actually help to get the
affected architectures / platforms fixed.

Link: https://lkml.kernel.org/r/20250313114329.284104-4-acarmina@redhat.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Alessandro Carminati <acarmina@redhat.com>
Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>
Acked-by: Dan Carpenter <dan.carpenter@linaro.org>
Reviewed-by: Kees Cook <keescook@chromium.org>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Arthur Grillo <arthurgrillo@riseup.net>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Charlie Jenkins <charlie@rivosinc.com>
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
Cc: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Cc: Maíra Canal <mcanal@igalia.com>
Cc: Maxime Ripard <mripard@kernel.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Naresh Kamboju <naresh.kamboju@linaro.org>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Rae Moar <rmoar@google.com>
Cc: Rich Felker <dalias@libc.org>
Cc: Simon Horman <horms@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Thomas Zimemrmann <tzimmermann@suse.de>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Ville Syrjala <ville.syrjala@linux.intel.com>
Cc: Will Deacon <will@kernel.org>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/kunit/Makefile                     |    7 +
 lib/kunit/backtrace-suppression-test.c |  104 +++++++++++++++++++++++
 2 files changed, 109 insertions(+), 2 deletions(-)

diff --git a/lib/kunit/backtrace-suppression-test.c a/lib/kunit/backtrace-suppression-test.c
new file mode 100644
--- /dev/null
+++ a/lib/kunit/backtrace-suppression-test.c
@@ -0,0 +1,104 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * KUnit test for suppressing warning tracebacks
+ *
+ * Copyright (C) 2024, Guenter Roeck
+ * Author: Guenter Roeck <linux@roeck-us.net>
+ */
+
+#include <kunit/test.h>
+#include <linux/bug.h>
+
+static void backtrace_suppression_test_warn_direct(struct kunit *test)
+{
+	DEFINE_SUPPRESSED_WARNING(backtrace_suppression_test_warn_direct);
+
+	KUNIT_START_SUPPRESSED_WARNING(backtrace_suppression_test_warn_direct);
+	WARN(1, "This backtrace should be suppressed");
+	KUNIT_END_SUPPRESSED_WARNING(backtrace_suppression_test_warn_direct);
+
+	KUNIT_EXPECT_EQ(test, SUPPRESSED_WARNING_COUNT(backtrace_suppression_test_warn_direct), 1);
+}
+
+static void trigger_backtrace_warn(void)
+{
+	WARN(1, "This backtrace should be suppressed");
+}
+
+static void backtrace_suppression_test_warn_indirect(struct kunit *test)
+{
+	DEFINE_SUPPRESSED_WARNING(trigger_backtrace_warn);
+
+	KUNIT_START_SUPPRESSED_WARNING(trigger_backtrace_warn);
+	trigger_backtrace_warn();
+	KUNIT_END_SUPPRESSED_WARNING(trigger_backtrace_warn);
+
+	KUNIT_EXPECT_EQ(test, SUPPRESSED_WARNING_COUNT(trigger_backtrace_warn), 1);
+}
+
+static void backtrace_suppression_test_warn_multi(struct kunit *test)
+{
+	DEFINE_SUPPRESSED_WARNING(trigger_backtrace_warn);
+	DEFINE_SUPPRESSED_WARNING(backtrace_suppression_test_warn_multi);
+
+	KUNIT_START_SUPPRESSED_WARNING(backtrace_suppression_test_warn_multi);
+	KUNIT_START_SUPPRESSED_WARNING(trigger_backtrace_warn);
+	WARN(1, "This backtrace should be suppressed");
+	trigger_backtrace_warn();
+	KUNIT_END_SUPPRESSED_WARNING(trigger_backtrace_warn);
+	KUNIT_END_SUPPRESSED_WARNING(backtrace_suppression_test_warn_multi);
+
+	KUNIT_EXPECT_EQ(test, SUPPRESSED_WARNING_COUNT(backtrace_suppression_test_warn_multi), 1);
+	KUNIT_EXPECT_EQ(test, SUPPRESSED_WARNING_COUNT(trigger_backtrace_warn), 1);
+}
+
+static void backtrace_suppression_test_warn_on_direct(struct kunit *test)
+{
+	DEFINE_SUPPRESSED_WARNING(backtrace_suppression_test_warn_on_direct);
+
+	if (!IS_ENABLED(CONFIG_DEBUG_BUGVERBOSE) && !IS_ENABLED(CONFIG_KALLSYMS))
+		kunit_skip(test, "requires CONFIG_DEBUG_BUGVERBOSE or CONFIG_KALLSYMS");
+
+	KUNIT_START_SUPPRESSED_WARNING(backtrace_suppression_test_warn_on_direct);
+	WARN_ON(1);
+	KUNIT_END_SUPPRESSED_WARNING(backtrace_suppression_test_warn_on_direct);
+
+	KUNIT_EXPECT_EQ(test,
+			SUPPRESSED_WARNING_COUNT(backtrace_suppression_test_warn_on_direct), 1);
+}
+
+static void trigger_backtrace_warn_on(void)
+{
+	WARN_ON(1);
+}
+
+static void backtrace_suppression_test_warn_on_indirect(struct kunit *test)
+{
+	DEFINE_SUPPRESSED_WARNING(trigger_backtrace_warn_on);
+
+	if (!IS_ENABLED(CONFIG_DEBUG_BUGVERBOSE))
+		kunit_skip(test, "requires CONFIG_DEBUG_BUGVERBOSE");
+
+	KUNIT_START_SUPPRESSED_WARNING(trigger_backtrace_warn_on);
+	trigger_backtrace_warn_on();
+	KUNIT_END_SUPPRESSED_WARNING(trigger_backtrace_warn_on);
+
+	KUNIT_EXPECT_EQ(test, SUPPRESSED_WARNING_COUNT(trigger_backtrace_warn_on), 1);
+}
+
+static struct kunit_case backtrace_suppression_test_cases[] = {
+	KUNIT_CASE(backtrace_suppression_test_warn_direct),
+	KUNIT_CASE(backtrace_suppression_test_warn_indirect),
+	KUNIT_CASE(backtrace_suppression_test_warn_multi),
+	KUNIT_CASE(backtrace_suppression_test_warn_on_direct),
+	KUNIT_CASE(backtrace_suppression_test_warn_on_indirect),
+	{}
+};
+
+static struct kunit_suite backtrace_suppression_test_suite = {
+	.name = "backtrace-suppression-test",
+	.test_cases = backtrace_suppression_test_cases,
+};
+kunit_test_suites(&backtrace_suppression_test_suite);
+
+MODULE_LICENSE("GPL");
--- a/lib/kunit/Makefile~kunit-add-test-cases-for-backtrace-warning-suppression
+++ a/lib/kunit/Makefile
@@ -18,11 +18,14 @@ endif
 
 # KUnit 'hooks' and bug handling are built-in even when KUnit is built
 # as a module.
-obj-y +=				hooks.o \
-					bug.o
+obj-y +=				hooks.o
+obj-$(CONFIG_KUNIT_SUPPRESS_BACKTRACE) += bug.o
 
 obj-$(CONFIG_KUNIT_TEST) +=		kunit-test.o
 obj-$(CONFIG_KUNIT_TEST) +=		platform-test.o
+ifeq ($(CONFIG_KUNIT_SUPPRESS_BACKTRACE),y)
+obj-$(CONFIG_KUNIT_TEST) +=		backtrace-suppression-test.o
+endif
 
 # string-stream-test compiles built-in only.
 ifeq ($(CONFIG_KUNIT_TEST),y)
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

