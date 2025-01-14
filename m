Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93CD023A113
	for <mm-commits@vger.kernel.org>; Tue, 14 Jan 2025 06:42:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736836949; cv=none; b=aB2B38mRlh3+35WsiebXmuif1b1Ezn9S3WwuAQR4FX1ZYV0c5SB95voUTUQzZDmn0QM9k73Ta/Kt0lvSB8Ch0EWqTitFgle1wWiYZsm0HpBKjibBQc702BPmWa5k1KwWMfvZ/SeoO0bOuEYL6D4RNzWVy/RdOaoTr1RKbRmkx5Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736836949; c=relaxed/simple;
	bh=h+YoSrTuCUg3P2fyzcb5ihDtDmloEuUSMoHwLAHq9xE=;
	h=Date:To:From:Subject:Message-Id; b=tiah57YAQt6qWszBZPeCepm+aXxvx3lOSpgpSZVzjkAAlEWKfKYSemyGkJfiphIvIyghBkJqh7T3UaldPwt3nSOPoUjctJi9Z3drJeCONJRn83KlFd8kwnHWqgX6fg2BTpawOjFDQXoDLbCWnaK/GuYe2m3j/iN2CxVR53N2Xn0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=BhFSTqar; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="BhFSTqar"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68BFCC4CEDD;
	Tue, 14 Jan 2025 06:42:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736836949;
	bh=h+YoSrTuCUg3P2fyzcb5ihDtDmloEuUSMoHwLAHq9xE=;
	h=Date:To:From:Subject:From;
	b=BhFSTqar6tTsrENYGSa6jx/c0Zy54EXmqvUVes0k0llY0bN87bDZtTQjF9QJecmw6
	 WVxnBnmb33NTv0JyBHmetHx0okhcaYVtM8Zoe2xsX9TzYFEePvZzjsSQNaePrqDP2y
	 ZOvu9uKfCoftJHFw1AW25FTNyJMalMwIZZuZAa5I=
Date: Mon, 13 Jan 2025 22:42:28 -0800
To: mm-commits@vger.kernel.org,kees@kernel.org,jinb.park7@gmail.com,ptesarik@suse.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-rodata_test-verify-test-data-is-unchanged-rather-than-non-zero.patch removed from -mm tree
Message-Id: <20250114064229.68BFCC4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/rodata_test: verify test data is unchanged, rather than non-zero
has been removed from the -mm tree.  Its filename was
     mm-rodata_test-verify-test-data-is-unchanged-rather-than-non-zero.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Petr Tesarik <ptesarik@suse.com>
Subject: mm/rodata_test: verify test data is unchanged, rather than non-zero
Date: Tue, 19 Nov 2024 12:37:39 +0100

Verify that the test variable holds the initialization value, rather than
any non-zero value.

Link: https://lkml.kernel.org/r/386ffda192eb4a26f68c526c496afd48a5cd87ce.1732016064.git.ptesarik@suse.com
Signed-off-by: Petr Tesarik <ptesarik@suse.com>
Reviewed-by: Kees Cook <kees@kernel.org>
Cc: Jinbum Park <jinb.park7@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rodata_test.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/mm/rodata_test.c~mm-rodata_test-verify-test-data-is-unchanged-rather-than-non-zero
+++ a/mm/rodata_test.c
@@ -12,7 +12,8 @@
 #include <linux/mm.h>
 #include <asm/sections.h>
 
-static const int rodata_test_data = 0xC3;
+#define TEST_VALUE 0xC3
+static const int rodata_test_data = TEST_VALUE;
 
 void rodata_test(void)
 {
@@ -20,7 +21,7 @@ void rodata_test(void)
 
 	/* test 1: read the value */
 	/* If this test fails, some previous testrun has clobbered the state */
-	if (!READ_ONCE(rodata_test_data)) {
+	if (unlikely(READ_ONCE(rodata_test_data) != TEST_VALUE)) {
 		pr_err("test 1 fails (start data)\n");
 		return;
 	}
@@ -33,7 +34,7 @@ void rodata_test(void)
 	}
 
 	/* test 3: check the value hasn't changed */
-	if (READ_ONCE(rodata_test_data) == zero) {
+	if (unlikely(READ_ONCE(rodata_test_data) != TEST_VALUE)) {
 		pr_err("test data was changed\n");
 		return;
 	}
_

Patches currently in -mm which might be from ptesarik@suse.com are


