Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7706715AD9C
	for <mm-commits@vger.kernel.org>; Fri, 29 Nov 2024 10:56:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732877795; cv=none; b=gU+B7XefVXtBNvc3n/jA7/wazYtjlod+0HK/1JwULolp20E91ZcXK/Cvo+UqsTkepZA/n0MYG+VmJmqTrt42EOJdCxq5BIN3CErfzFZAXKaFVA2DgUTQ54yUS8O0IZ2hR2pebeGDR9DBkMiqsM986HMGZmU0sqfR+SOWWvKozAE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732877795; c=relaxed/simple;
	bh=ZbQ6fzW/hCsEL0O97RFiuZft7dJEsannEUD4dEra+nQ=;
	h=Date:To:From:Subject:Message-Id; b=YJRBvUeNsxugC+sbTI4hfIWANN0N/WOV7ayGkt5Fde4IYidEUarzhYLISZu+SB1lClkmVbQyH+bN/DatN7kk7Epw1fV/4H74aWWa+ki/YUEbnPLG+o0PRnlyjE0WqWPjgsP6b/ZtaJL2wDiTRkrRUAHlCZISC+5eYEynNoObq8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DuYKVMXp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DuYKVMXp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9331C4CECF;
	Fri, 29 Nov 2024 10:56:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1732877794;
	bh=ZbQ6fzW/hCsEL0O97RFiuZft7dJEsannEUD4dEra+nQ=;
	h=Date:To:From:Subject:From;
	b=DuYKVMXpFRgmKIFXqEHr5YggebKn+HSjXnRBxkPx0UNXFjubfhDhbsDXOhndnqndW
	 wZYPPmLBrHyVyKytIKw45R1yPr6Gj+/cF3Mk+NlfKCQJyTLUABdNIfyJNTsApLOUzm
	 tcpWiiubo2aOMwQms8wdjAllpvl2vUfppMq8sTcY=
Date: Fri, 29 Nov 2024 02:56:34 -0800
To: mm-commits@vger.kernel.org,kees@kernel.org,jinb.park7@gmail.com,ptesarik@suse.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-rodata_test-verify-test-data-is-unchanged-rather-than-non-zero.patch added to mm-unstable branch
Message-Id: <20241129105634.D9331C4CECF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/rodata_test: verify test data is unchanged, rather than non-zero
has been added to the -mm mm-unstable branch.  Its filename is
     mm-rodata_test-verify-test-data-is-unchanged-rather-than-non-zero.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-rodata_test-verify-test-data-is-unchanged-rather-than-non-zero.patch

This patch will later appear in the mm-unstable branch at
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

mm-rodata_test-use-read_once-to-read-const-variable.patch
mm-rodata_test-verify-test-data-is-unchanged-rather-than-non-zero.patch

