Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1E191CD02
	for <mm-commits@vger.kernel.org>; Tue,  8 Oct 2024 01:53:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728352408; cv=none; b=J2iMH6FRoZBHgp8sqSaeFy8F6R43N0U5mBadN6vu7oK/pgYGv9BL8ERmq+Z4aZegTBPSi6K0mjvbL1V8E8TpDRQzjwYKrEGoP9xQLpL7QRWFtrKikTbFBz6l4pzCSxosLYqY2VkPNj/wCRfR9c4RYC/pCywv5mZmOCGSM5wYjWY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728352408; c=relaxed/simple;
	bh=lf3KAzt4vXNlJ2rhuRXh9AuzPCd22GeTux70AvmtAZg=;
	h=Date:To:From:Subject:Message-Id; b=Biehuc1BA5ip7PPwmeYq7KKw/JBSBFFemT4aIwxzftTP44BFbw7XpUlQkPTvz1nZB/Jq7FGmoRQE6KUNzim0llNaAPy0viwDNqyJK4IfFBR3ZUWOhigA7LZI6NF9A0HLVokk6KBD5HEzXLuLpw8RpdsF1GWxQk0Ethirs7Fi1xE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=VrYJbmiI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="VrYJbmiI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45401C4CEC6;
	Tue,  8 Oct 2024 01:53:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1728352408;
	bh=lf3KAzt4vXNlJ2rhuRXh9AuzPCd22GeTux70AvmtAZg=;
	h=Date:To:From:Subject:From;
	b=VrYJbmiIA03H8HUIMz4OlI4H+MpsoknmxuY4cb1RIdfUCPTHmhdo4giz+UNb1BMRJ
	 t9wxXzeFyuMwmphFLAwNf6ZrmbHz1keyYTsc82srs3Jq4tTLnP3HEFsBxrvpv3a4pw
	 4/C/q9tmc6zoz2Tw8angU/FKg6TAdeTgxEStiVJc=
Date: Mon, 07 Oct 2024 18:53:27 -0700
To: mm-commits@vger.kernel.org,skhan@linuxfoundation.org,luis.hernandez093@gmail.com,jserv@ccns.ncku.edu.tw,davidgow@google.com,visitorckw@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-kconfigdebug-move-int_pow-test-option-to-runtime-testing-section.patch added to mm-nonmm-unstable branch
Message-Id: <20241008015328.45401C4CEC6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib/Kconfig.debug: move int_pow test option to runtime testing section
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-kconfigdebug-move-int_pow-test-option-to-runtime-testing-section.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-kconfigdebug-move-int_pow-test-option-to-runtime-testing-section.patch

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

lib-kconfigdebug-move-int_pow-test-option-to-runtime-testing-section.patch

