Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 132B916FF45
	for <mm-commits@vger.kernel.org>; Wed,  6 Nov 2024 01:13:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730855619; cv=none; b=r+MobPE0H4C6/P7umW0+i4qbLO2YxzRGQvqWV3E3BlWdIZbmw5iRyYpMz2wu61cOILmHeE0oRhcWw8SVpzku8tV9zzySJmypiacs5+tMJTrSWuVZYgwfkj0E4izwTU/qhw70H2aOnKFmhUfX5Jgy+6jauYxPCWHQ9BXusPyA2KU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730855619; c=relaxed/simple;
	bh=JakbroUTpM0l32pg0r+I2AaXMg2ZfAQQOUU9meSHgL8=;
	h=Date:To:From:Subject:Message-Id; b=KW5nKhMzA4mtqdjH2N5OjCFQp+CgOIt6hiMFh02VCTBegEpddIi/RKDlnD1/NwleclSe0dYC5fegYxh4oSCXoy05dzv5Iqumk8MOPhO7Ete3sZuPRVlQ6R79YpTh6ZUg2wG5bdxtBTFesFswvPyRWjdRjGFIAwWHcs2HP/OqXbM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=hl8rzEuK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hl8rzEuK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D98A8C4CECF;
	Wed,  6 Nov 2024 01:13:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730855618;
	bh=JakbroUTpM0l32pg0r+I2AaXMg2ZfAQQOUU9meSHgL8=;
	h=Date:To:From:Subject:From;
	b=hl8rzEuKHACiHuY5B8nt8eKvN3UyDEeNxPQW1aVZV5YCTiQ4F1VefPbY3NZ/mGxyW
	 31p3F0zr2Lbs4YZX4B3YObOc9dDB3RYsphSH49ToKT/LPWKTvrka1YvXrH+7xAlrtS
	 kql5gKs4Rrli1Odmymy4UWmqrqPcXI14eZkqpD6M=
Date: Tue, 05 Nov 2024 17:13:38 -0800
To: mm-commits@vger.kernel.org,skhan@linuxfoundation.org,luis.hernandez093@gmail.com,jserv@ccns.ncku.edu.tw,davidgow@google.com,visitorckw@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] lib-kconfigdebug-move-int_pow-test-option-to-runtime-testing-section.patch removed from -mm tree
Message-Id: <20241106011338.D98A8C4CECF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib/Kconfig.debug: move int_pow test option to runtime testing section
has been removed from the -mm tree.  Its filename was
     lib-kconfigdebug-move-int_pow-test-option-to-runtime-testing-section.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kuan-Wei Chiu <visitorckw@gmail.com>
Subject: lib/Kconfig.debug: move int_pow test option to runtime testing section
Date: Sun, 6 Oct 2024 06:22:21 +0800

When executing 'make menuconfig' with KUNIT enabled, the int_pow test
option appears on the first page of the main menu instead of under the
runtime testing section.  Relocate the int_pow test configuration to the
appropriate runtime testing submenu, ensuring a more organized and logical
structure in the menu configuration.

Link: https://lkml.kernel.org/r/20241005222221.2154393-1-visitorckw@gmail.com
Fixes: 7fcc9b53216c ("lib/math: Add int_pow test suite")
Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
Cc: Ching-Chun (Jim) Huang <jserv@ccns.ncku.edu.tw>
Cc: David Gow <davidgow@google.com>
Cc: Luis Felipe Hernandez <luis.hernandez093@gmail.com>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Kconfig.debug |   32 ++++++++++++++++----------------
 1 file changed, 16 insertions(+), 16 deletions(-)

--- a/lib/Kconfig.debug~lib-kconfigdebug-move-int_pow-test-option-to-runtime-testing-section
+++ a/lib/Kconfig.debug
@@ -2993,6 +2993,22 @@ config TEST_OBJPOOL
 
 	  If unsure, say N.
 
+config INT_POW_TEST
+	tristate "Integer exponentiation (int_pow) test" if !KUNIT_ALL_TESTS
+	depends on KUNIT
+	default KUNIT_ALL_TESTS
+	help
+	  This option enables the KUnit test suite for the int_pow function,
+	  which performs integer exponentiation. The test suite is designed to
+	  verify that the implementation of int_pow correctly computes the power
+	  of a given base raised to a given exponent.
+
+	  Enabling this option will include tests that check various scenarios
+	  and edge cases to ensure the accuracy and reliability of the exponentiation
+	  function.
+
+	  If unsure, say N
+
 endif # RUNTIME_TESTING_MENU
 
 config ARCH_USE_MEMTEST
@@ -3088,19 +3104,3 @@ config RUST_KERNEL_DOCTESTS
 endmenu # "Rust"
 
 endmenu # Kernel hacking
-
-config INT_POW_TEST
-	tristate "Integer exponentiation (int_pow) test" if !KUNIT_ALL_TESTS
-	depends on KUNIT
-	default KUNIT_ALL_TESTS
-	help
-	  This option enables the KUnit test suite for the int_pow function,
-	  which performs integer exponentiation. The test suite is designed to
-	  verify that the implementation of int_pow correctly computes the power
-	  of a given base raised to a given exponent.
-
-	  Enabling this option will include tests that check various scenarios
-	  and edge cases to ensure the accuracy and reliability of the exponentiation
-	  function.
-
-	  If unsure, say N
_

Patches currently in -mm which might be from visitorckw@gmail.com are


