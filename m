Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E858B1F63D6
	for <mm-commits@vger.kernel.org>; Thu, 13 Mar 2025 22:05:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741903524; cv=none; b=obFxhL64dCmIOFmY1EVrm9EKpWYfgiuGAppJ8OzjoP+XLeDK4w+SBLg2seuU5feQTUYiris6gUC02L9A8kgdDUR9FriqMhjkW1Z+vvs2k+2jq0CaDdC04nAokh3gi8/XcAr9oUxvU6OeQ7NvheZS7UO6n88Znu0ceYhwY6ZojdE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741903524; c=relaxed/simple;
	bh=kgNYcCtxsyyb7TzGli5WJvpnn7/8V+L80P23x4qbZNE=;
	h=Date:To:From:Subject:Message-Id; b=EcGEzflJPqpWT5tEdlnAYfy57PTaNpxjNkxXw9KFcIGCO5jKLzusigS8IH9tgMgYYVNVjJMW2MMCtZdw/mLdr5XHapIjccxTleo6gGyUTOe/vW4Ce4Sz9+x+JJ43zdOXQeeXZTmb94hh0iufEnqNHvD71TsRp8L3lhV+F60cZio=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=SZSXu854; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="SZSXu854"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 561EBC4CEDD;
	Thu, 13 Mar 2025 22:05:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1741903523;
	bh=kgNYcCtxsyyb7TzGli5WJvpnn7/8V+L80P23x4qbZNE=;
	h=Date:To:From:Subject:From;
	b=SZSXu854gX+rKZjsvBVKIREaGz7Fb3ergNCFSDuEmS2sWMU0ACDmrtu2ZE4QkTSXM
	 AgSmKo1QMdwQ6glE2iCuCp79Z3ccwixCL/EYt8OblkQGrHJbUe915JYRPLzwkcxZ5W
	 t7vzU1Np1zqIHYaOb13plIH5Gr5oFAMnDbuCMr9g=
Date: Thu, 13 Mar 2025 15:05:22 -0700
To: mm-commits@vger.kernel.org,ysato@users.sourceforge.jp,will@kernel.org,ville.syrjala@linux.intel.com,tzimmermann@suse.de,tglx@linutronix.de,rmoar@google.com,paul.walmsley@sifive.com,palmer@dabbelt.com,naresh.kamboju@linaro.org,mripard@kernel.org,mpe@ellerman.id.au,mingo@redhat.com,mcanal@igalia.com,maarten.lankhorst@linux.intel.com,lkft@linaro.org,keescook@chromium.org,jani.nikula@intel.com,horms@kernel.org,hca@linux.ibm.com,gor@linux.ibm.com,glaubitz@physik.fu-berlin.de,deller@gmx.de,davidgow@google.com,dave.hansen@linux.intel.com,daniel@ffwll.ch,daniel.diaz@linaro.org,dan.carpenter@linaro.org,dalias@libc.org,chenhuacai@kernel.org,charlie@rivosinc.com,catalin.marinas@arm.com,brendan.higgins@linux.dev,bp@alien8.de,arthurgrillo@riseup.net,arnd@arndb.de,aou@eecs.berkeley.edu,airlied@gmail.com,agordeev@linux.ibm.com,acarmina@redhat.com,linux@roeck-us.net,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kunit-add-documentation-for-warning-backtrace-suppression-api.patch added to mm-nonmm-unstable branch
Message-Id: <20250313220523.561EBC4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kunit: add documentation for warning backtrace suppression API
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kunit-add-documentation-for-warning-backtrace-suppression-api.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kunit-add-documentation-for-warning-backtrace-suppression-api.patch

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
Subject: kunit: add documentation for warning backtrace suppression API
Date: Thu, 13 Mar 2025 11:43:19 +0000

Document API functions for suppressing warning backtraces.

Link: https://lkml.kernel.org/r/20250313114329.284104-5-acarmina@redhat.com
Signed-off-by: Alessandro Carminati <acarmina@redhat.com>
Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>
Acked-by: Dan Carpenter <dan.carpenter@linaro.org>
Reviewed-by: Kees Cook <keescook@chromium.org>
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

 Documentation/dev-tools/kunit/usage.rst |   30 +++++++++++++++++++++-
 1 file changed, 29 insertions(+), 1 deletion(-)

--- a/Documentation/dev-tools/kunit/usage.rst~kunit-add-documentation-for-warning-backtrace-suppression-api
+++ a/Documentation/dev-tools/kunit/usage.rst
@@ -157,6 +157,34 @@ Alternatively, one can take full control
 	if (some_setup_function())
 		KUNIT_FAIL(test, "Failed to setup thing for testing");
 
+Suppressing warning backtraces
+------------------------------
+
+Some unit tests trigger warning backtraces either intentionally or as side
+effect. Such backtraces are normally undesirable since they distract from
+the actual test and may result in the impression that there is a problem.
+
+Such backtraces can be suppressed. To suppress a backtrace in some_function(),
+use the following code.
+
+.. code-block:: c
+
+	static void some_test(struct kunit *test)
+	{
+		DEFINE_SUPPRESSED_WARNING(some_function);
+
+		KUNIT_START_SUPPRESSED_WARNING(some_function);
+		trigger_backtrace();
+		KUNIT_END_SUPPRESSED_WARNING(some_function);
+	}
+
+SUPPRESSED_WARNING_COUNT() returns the number of suppressed backtraces. If the
+suppressed backtrace was triggered on purpose, this can be used to check if
+the backtrace was actually triggered.
+
+.. code-block:: c
+
+	KUNIT_EXPECT_EQ(test, SUPPRESSED_WARNING_COUNT(some_function), 1);
 
 Test Suites
 ~~~~~~~~~~~
@@ -857,4 +885,4 @@ For example:
 		dev_managed_string = devm_kstrdup(fake_device, "Hello, World!");
 
 		// Everything is cleaned up automatically when the test ends.
-	}
\ No newline at end of file
+	}
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

