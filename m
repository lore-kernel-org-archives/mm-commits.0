Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7B981F7066
	for <mm-commits@vger.kernel.org>; Thu, 13 Mar 2025 22:05:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741903520; cv=none; b=rxLPLbNE5C5+5omY7SEeh8G/rVf0zVlZPoamqe1oZP7xP+Fr/94K5oepEmwkjHvcsUWHsTjaHLoz+nLgertTDbkEgobenw526h3p0XoFFoTXTHIqxT7NiKjIcDmRn+uXlyDcdsgVHi9Prmz1y8MfooX1w54r9bfTPCS/uy4zm1M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741903520; c=relaxed/simple;
	bh=EEaLbo5rGW8oBQfXrAYDDpQiyKPXsLEO3IkjeRZgXmk=;
	h=Date:To:From:Subject:Message-Id; b=oc/yzIpACFGnepdWYDhQDc8rgnRkjyOoRBG90903fghFiWey2ZlialLVKKCPhk42aMfd+fzFulwY15E+cqyi3oDCqtd794xRqEkIpUQKBnMA73iUOi0fw5x4K6ZHpOzRGHS/Bp9uXQWmk28YZF65tOUfIrLRBkE6Ak1JD0pnyTc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=iUku7E4b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="iUku7E4b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23D9BC4CEDD;
	Thu, 13 Mar 2025 22:05:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1741903520;
	bh=EEaLbo5rGW8oBQfXrAYDDpQiyKPXsLEO3IkjeRZgXmk=;
	h=Date:To:From:Subject:From;
	b=iUku7E4bByists34Ww4yL+Zh3nSrY0rh8VuF20Gqp+XYBJVHteu/G18HkgPbq+Yev
	 A+GIsZmDsTGUvx49oOjJ70qFbPjTEdbVgn57XNbNR7vmwFa4dvGKEkxKCfIXAmSRoe
	 s9WzE/99m6KVeaBgILy+gcq9SI6t8esJKMKkCUqA=
Date: Thu, 13 Mar 2025 15:05:19 -0700
To: mm-commits@vger.kernel.org,ysato@users.sourceforge.jp,will@kernel.org,ville.syrjala@linux.intel.com,tzimmermann@suse.de,tglx@linutronix.de,rmoar@google.com,paul.walmsley@sifive.com,palmer@dabbelt.com,naresh.kamboju@linaro.org,mripard@kernel.org,mpe@ellerman.id.au,mingo@redhat.com,mcanal@igalia.com,maarten.lankhorst@linux.intel.com,lkft@linaro.org,keescook@chromium.org,jani.nikula@intel.com,horms@kernel.org,hca@linux.ibm.com,gor@linux.ibm.com,glaubitz@physik.fu-berlin.de,deller@gmx.de,davidgow@google.com,dave.hansen@linux.intel.com,daniel@ffwll.ch,daniel.diaz@linaro.org,dan.carpenter@linaro.org,dalias@libc.org,chenhuacai@kernel.org,charlie@rivosinc.com,catalin.marinas@arm.com,brendan.higgins@linux.dev,bp@alien8.de,arthurgrillo@riseup.net,arnd@arndb.de,aou@eecs.berkeley.edu,airlied@gmail.com,agordeev@linux.ibm.com,acarmina@redhat.com,linux@roeck-us.net,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kunit-bug-count-suppressed-warning-backtraces.patch added to mm-nonmm-unstable branch
Message-Id: <20250313220520.23D9BC4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kunit: bug: count suppressed warning backtraces
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kunit-bug-count-suppressed-warning-backtraces.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kunit-bug-count-suppressed-warning-backtraces.patch

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
Subject: kunit: bug: count suppressed warning backtraces
Date: Thu, 13 Mar 2025 11:43:17 +0000

Count suppressed warning backtraces to enable code which suppresses
warning backtraces to check if the expected backtrace(s) have been
observed.

Using atomics for the backtrace count resulted in build errors on some
architectures due to include file recursion, so use a plain integer for
now.

Link: https://lkml.kernel.org/r/20250313114329.284104-3-acarmina@redhat.com
Signed-off-by: Alessandro Carminati <acarmina@redhat.com>
Acked-by: Dan Carpenter <dan.carpenter@linaro.org>
Reviewed-by: Kees Cook <keescook@chromium.org>
Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Reviewed-by: David Gow <davidgow@google.com>
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

 include/kunit/bug.h |    7 ++++++-
 lib/kunit/bug.c     |    4 +++-
 2 files changed, 9 insertions(+), 2 deletions(-)

--- a/include/kunit/bug.h~kunit-bug-count-suppressed-warning-backtraces
+++ a/include/kunit/bug.h
@@ -20,6 +20,7 @@
 struct __suppressed_warning {
 	struct list_head node;
 	const char *function;
+	int counter;
 };
 
 void __kunit_start_suppress_warning(struct __suppressed_warning *warning);
@@ -28,7 +29,7 @@ bool __kunit_is_suppressed_warning(const
 
 #define DEFINE_SUPPRESSED_WARNING(func)	\
 	struct __suppressed_warning __kunit_suppress_##func = \
-		{ .function = __stringify(func) }
+		{ .function = __stringify(func), .counter = 0 }
 
 #define KUNIT_START_SUPPRESSED_WARNING(func) \
 	__kunit_start_suppress_warning(&__kunit_suppress_##func)
@@ -39,12 +40,16 @@ bool __kunit_is_suppressed_warning(const
 #define KUNIT_IS_SUPPRESSED_WARNING(func) \
 	__kunit_is_suppressed_warning(func)
 
+#define SUPPRESSED_WARNING_COUNT(func) \
+	(__kunit_suppress_##func.counter)
+
 #else /* CONFIG_KUNIT_SUPPRESS_BACKTRACE */
 
 #define DEFINE_SUPPRESSED_WARNING(func)
 #define KUNIT_START_SUPPRESSED_WARNING(func)
 #define KUNIT_END_SUPPRESSED_WARNING(func)
 #define KUNIT_IS_SUPPRESSED_WARNING(func) (false)
+#define SUPPRESSED_WARNING_COUNT(func) (0)
 
 #endif /* CONFIG_KUNIT_SUPPRESS_BACKTRACE */
 #endif /* __ASSEMBLY__ */
--- a/lib/kunit/bug.c~kunit-bug-count-suppressed-warning-backtraces
+++ a/lib/kunit/bug.c
@@ -32,8 +32,10 @@ bool __kunit_is_suppressed_warning(const
 		return false;
 
 	list_for_each_entry(warning, &suppressed_warnings, node) {
-		if (!strcmp(function, warning->function))
+		if (!strcmp(function, warning->function)) {
+			warning->counter++;
 			return true;
+		}
 	}
 	return false;
 }
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

