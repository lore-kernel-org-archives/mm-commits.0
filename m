Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CE77145344
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 05:26:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719293205; cv=none; b=Y1Bbi2cpGX3D3LWlX0k3srL0Y6dDqu2B8ejpH3SX0k1FKLKGrB0aQ6XX5rzsbViYipqFauYF4pQVIIbfaqsUAwOMK9qhnF1ahwnChb2BJ3NWVeu3zsdksEnnbuEA2cOTuvU8QEguwqgTOWkczjvd4G8TezQ8a8USfoR9RnUDKFw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719293205; c=relaxed/simple;
	bh=M+Ho1PpH/526qL9cWfhW/2QIzYjgxzjY0PtooFywXfE=;
	h=Date:To:From:Subject:Message-Id; b=tKNxOl3Cz72T1OJmp6KM7qXxIZGhbCBtLgTTeITiLPz82A15asG9Gd8wInPd32HrVrsb1xUDPNaaPBip3yoTd+pl/wKBFPvmfhEHjY6SP1PIGNJm4xhcZr+WKkbKu5E+pCWRDRhkX/LumZD+fxX0cHGfWueQTppG0mtsmtWcj7g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=tuqUee8G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="tuqUee8G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42265C32782;
	Tue, 25 Jun 2024 05:26:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719293205;
	bh=M+Ho1PpH/526qL9cWfhW/2QIzYjgxzjY0PtooFywXfE=;
	h=Date:To:From:Subject:From;
	b=tuqUee8GIJLrZT49V6HA3rXxWv1QFrCW2jVbWw8SETGiS5bChlGQeXGshqRsB016e
	 KhFL626SqVecPu3wTigHMU0aO2g4u5ZhsNU8HkqxqoHfPijSxSEvsS1TT6dJba3nKg
	 s0sScx8qBtR6/hwKZKuanb9mpdJ4Fi5ZYRBAQHT0=
Date: Mon, 24 Jun 2024 22:26:44 -0700
To: mm-commits@vger.kernel.org,quic_jjohnson@quicinc.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] kunit-add-missing-module_description-macros-to-lib-_kunitc.patch removed from -mm tree
Message-Id: <20240625052645.42265C32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kunit: add missing MODULE_DESCRIPTION() macros to lib/*.c
has been removed from the -mm tree.  Its filename was
     kunit-add-missing-module_description-macros-to-lib-_kunitc.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -1237,4 +1237,5 @@ static struct kunit_suite overflow_test_
 
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

kfifo-add-missing-module_description-macros.patch
resource-add-missing-module_description.patch
selftests-fpu-add-missing-module_description-macro.patch

