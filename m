Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D24ABA38
	for <mm-commits@vger.kernel.org>; Wed,  5 Jun 2024 23:04:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717628667; cv=none; b=jDpRoB60eozaEh0z0kXDLEM8MHFfP+NTZN4r/q5r6Loou5FSY/ppvT/gFKRC3kbhhixglci6kZcLDRKcRZnaEqOLTdzRNlkU54lqJg7OxfkqBwIvmGIH4lxO/+R6ba9V9yTUEuaNy7DIKZ6xfoN/rEl6/iPMTXASy/3y/xQJOoY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717628667; c=relaxed/simple;
	bh=jE87IZYfkK+fEWcpgXQT0hkPeBtW+TtPlHXHosRmpv8=;
	h=Date:To:From:Subject:Message-Id; b=WpBBBg0c6o+ALklvJMT8bNrdnSZL82tOtsKwy+X/Mw4LGCROVmGfOVti+31Hkl7BjvOuxmueBhSeLTmysp2Zo9UOS7SIljPEMjcNxJ2QsUx58RtAfJTdpJfaK5uGZq+16a9M6ZL6V6IBm1gVHWRlNv/5Q8TAe6Oxr9vpQfcvFxw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=S4TL4/9Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="S4TL4/9Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A38D0C2BD11;
	Wed,  5 Jun 2024 23:04:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1717628664;
	bh=jE87IZYfkK+fEWcpgXQT0hkPeBtW+TtPlHXHosRmpv8=;
	h=Date:To:From:Subject:From;
	b=S4TL4/9QzKs+xxgGGSUW/Mxh+LhzALFuVSZcdvfC2jKMti5dOyRej19zFZYS4HpQT
	 dyR87RkeElh9GSAEd4f8OLMLOAQS7DJDnM1TpD4vafEC6Qocek1E5qcV/02ML7tHXK
	 dbiTO60a84eB6HUr/FtJIEZHaS1nHvKSKaFR7U0A=
Date: Wed, 05 Jun 2024 16:04:24 -0700
To: mm-commits@vger.kernel.org,quic_jjohnson@quicinc.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kunit-add-missing-module_description-macros-to-lib-_kunitc.patch added to mm-nonmm-unstable branch
Message-Id: <20240605230424.A38D0C2BD11@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kunit: add missing MODULE_DESCRIPTION() macros to lib/*.c
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kunit-add-missing-module_description-macros-to-lib-_kunitc.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kunit-add-missing-module_description-macros-to-lib-_kunitc.patch

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
From: Jeff Johnson <quic_jjohnson@quicinc.com>
Subject: kunit: add missing MODULE_DESCRIPTION() macros to lib/*.c
Date: Sat, 1 Jun 2024 10:53:34 -0700

make allmodconfig && make W=1 C=1 reports for lib/*kunit:
WARNING: modpost: missing MODULE_DESCRIPTION() in lib/bitfield_kunit.o
WARNING: modpost: missing MODULE_DESCRIPTION() in lib/checksum_kunit.o
WARNING: modpost: missing MODULE_DESCRIPTION() in lib/cmdline_kunit.o
WARNING: modpost: missing MODULE_DESCRIPTION() in lib/is_signed_type_kunit.o
WARNING: modpost: missing MODULE_DESCRIPTION() in lib/overflow_kunit.o
WARNING: modpost: missing MODULE_DESCRIPTION() in lib/stackinit_kunit.o

Add the missing invocations of the MODULE_DESCRIPTION() macro.

Link: https://lkml.kernel.org/r/20240601-md-lib-kunit-tests-v1-1-4493fe0032b9@quicinc.com
Signed-off-by: Jeff Johnson <quic_jjohnson@quicinc.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/bitfield_kunit.c       |    1 +
 lib/checksum_kunit.c       |    1 +
 lib/cmdline_kunit.c        |    1 +
 lib/is_signed_type_kunit.c |    1 +
 lib/overflow_kunit.c       |    1 +
 lib/stackinit_kunit.c      |    1 +
 6 files changed, 6 insertions(+)

--- a/lib/bitfield_kunit.c~kunit-add-missing-module_description-macros-to-lib-_kunitc
+++ a/lib/bitfield_kunit.c
@@ -151,4 +151,5 @@ static struct kunit_suite bitfields_test
 kunit_test_suites(&bitfields_test_suite);
 
 MODULE_AUTHOR("Johannes Berg <johannes@sipsolutions.net>");
+MODULE_DESCRIPTION("Test cases for bitfield helpers");
 MODULE_LICENSE("GPL");
--- a/lib/checksum_kunit.c~kunit-add-missing-module_description-macros-to-lib-_kunitc
+++ a/lib/checksum_kunit.c
@@ -639,4 +639,5 @@ static struct kunit_suite checksum_test_
 kunit_test_suites(&checksum_test_suite);
 
 MODULE_AUTHOR("Noah Goldstein <goldstein.w.n@gmail.com>");
+MODULE_DESCRIPTION("Test cases csum_* APIs");
 MODULE_LICENSE("GPL");
--- a/lib/cmdline_kunit.c~kunit-add-missing-module_description-macros-to-lib-_kunitc
+++ a/lib/cmdline_kunit.c
@@ -153,4 +153,5 @@ static struct kunit_suite cmdline_test_s
 };
 kunit_test_suite(cmdline_test_suite);
 
+MODULE_DESCRIPTION("Test cases for API provided by cmdline.c");
 MODULE_LICENSE("GPL");
--- a/lib/is_signed_type_kunit.c~kunit-add-missing-module_description-macros-to-lib-_kunitc
+++ a/lib/is_signed_type_kunit.c
@@ -46,4 +46,5 @@ static struct kunit_suite is_signed_type
 
 kunit_test_suite(is_signed_type_test_suite);
 
+MODULE_DESCRIPTION("is_signed_type() KUnit test suite");
 MODULE_LICENSE("Dual MIT/GPL");
--- a/lib/overflow_kunit.c~kunit-add-missing-module_description-macros-to-lib-_kunitc
+++ a/lib/overflow_kunit.c
@@ -1223,4 +1223,5 @@ static struct kunit_suite overflow_test_
 
 kunit_test_suite(overflow_test_suite);
 
+MODULE_DESCRIPTION("Test cases for arithmetic overflow checks");
 MODULE_LICENSE("Dual MIT/GPL");
--- a/lib/stackinit_kunit.c~kunit-add-missing-module_description-macros-to-lib-_kunitc
+++ a/lib/stackinit_kunit.c
@@ -471,4 +471,5 @@ static struct kunit_suite stackinit_test
 
 kunit_test_suites(&stackinit_test_suite);
 
+MODULE_DESCRIPTION("Test cases for compiler-based stack variable zeroing");
 MODULE_LICENSE("GPL");
_

Patches currently in -mm which might be from quic_jjohnson@quicinc.com are

mm-hwpoison-add-module_description.patch
mm-dmapool-add-module_description.patch
mm-kfence-add-module_description.patch
mm-zsmalloc-add-module_description.patch
kmemleak-test-add-missing-module_description-macro.patch
backtracetest-add-module_description.patch
dyndbg-add-missing-module_description-macro.patch
lib-ts-add-missing-module_description-macros.patch
kunit-fortify-add-missing-module_description-macros.patch
kunit-add-missing-module_description-macros-for-lib-_testko.patch
lib-asn1_encoder-add-missing-module_description-macro.patch
kunit-add-missing-module_description-macros-to-lib-_kunitc.patch

