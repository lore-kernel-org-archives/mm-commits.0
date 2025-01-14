Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BB8923A103
	for <mm-commits@vger.kernel.org>; Tue, 14 Jan 2025 06:42:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736836948; cv=none; b=XXUFAO6aq2kOZkeu6cPmzpMTsiM126kJP9SQbSGTvuLfqzhM0wvUtSfFBGJlsoamd/a1O+iKyQRYg8BgUfNc5LAeqyHPO3coi0dikiPitO2NKRTYLwt1wXG52CsavGhOlmhCbdQK8CogtkGTIFZziZaMTkPXzTBFLxifjsiCgLs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736836948; c=relaxed/simple;
	bh=Bj0nbPe+jIYtO0q8gUVxDd3/Onx18YSdzZREDJp+f+s=;
	h=Date:To:From:Subject:Message-Id; b=aCaUqUnY7xYznQaXXkVBtobUv46/s3PUhtBj/0OvABXFXMuUH8X0CqOAKg32T09ZtzC8V8QGRaz7OQX6vBySWacAmPB57+1iats40ryZfWHTIaxVMoxRQkGIpWUD1SBFoY8dW5WDYcO+l5bJx8/JvDU/81CmezXu3MwbNgOYyPs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=D1HMqpPL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="D1HMqpPL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52478C4CEDD;
	Tue, 14 Jan 2025 06:42:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736836948;
	bh=Bj0nbPe+jIYtO0q8gUVxDd3/Onx18YSdzZREDJp+f+s=;
	h=Date:To:From:Subject:From;
	b=D1HMqpPLx/ZuRBABLhxBRSfK1bdnvkI5Itg0HGxTHtz/8k8LUa+8z5Hu8oCE4MHNg
	 4wL3z5WMmQn6aUViDmO23YA8eyaBo6ziUOxEJfTsAMJFYY0PHqsiQFfWYN0XRCipP/
	 DiYPo52gho0F5jNNZGMdl8a6byvGh250RwFOL9bA=
Date: Mon, 13 Jan 2025 22:42:27 -0800
To: mm-commits@vger.kernel.org,kees@kernel.org,jinb.park7@gmail.com,ptesarik@suse.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-rodata_test-use-read_once-to-read-const-variable.patch removed from -mm tree
Message-Id: <20250114064228.52478C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/rodata_test: use READ_ONCE() to read const variable
has been removed from the -mm tree.  Its filename was
     mm-rodata_test-use-read_once-to-read-const-variable.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Petr Tesarik <ptesarik@suse.com>
Subject: mm/rodata_test: use READ_ONCE() to read const variable
Date: Tue, 19 Nov 2024 12:37:38 +0100

Patch series "Fix mm/rodata_test", v2.

Make sure that the test actually reads the read-only memory location.
Verify that the variable contains the expected value rather than any
non-zero value.


This patch (of 2):

The C compiler may optimize away the memory read of a const variable if
its value is known at compile time.

In particular, GCC14 with -O2 generates no code at all for test 1, and it
generates the following x86_64 instructions for test 3:

	cmpl	$195, 4(%rsp)
	je	.L14

That is, it replaces the read of rodata_test_data with an immediate value
and compares it to the value of the local variable "zero".

Use READ_ONCE() to undo any such compiler optimizations and enforce a
memory read.

Link: https://lkml.kernel.org/r/cover.1732016064.git.ptesarik@suse.com
Link: https://lkml.kernel.org/r/2a66dee010151b25cb143efb39091ef7530aa00a.1732016064.git.ptesarik@suse.com
Fixes: 2959a5f726f6 ("mm: add arch-independent testcases for RODATA")
Signed-off-by: Petr Tesarik <ptesarik@suse.com>
Reviewed-by: Kees Cook <kees@kernel.org>
Cc: Jinbum Park <jinb.park7@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rodata_test.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/rodata_test.c~mm-rodata_test-use-read_once-to-read-const-variable
+++ a/mm/rodata_test.c
@@ -20,7 +20,7 @@ void rodata_test(void)
 
 	/* test 1: read the value */
 	/* If this test fails, some previous testrun has clobbered the state */
-	if (!rodata_test_data) {
+	if (!READ_ONCE(rodata_test_data)) {
 		pr_err("test 1 fails (start data)\n");
 		return;
 	}
@@ -33,7 +33,7 @@ void rodata_test(void)
 	}
 
 	/* test 3: check the value hasn't changed */
-	if (rodata_test_data == zero) {
+	if (READ_ONCE(rodata_test_data) == zero) {
 		pr_err("test data was changed\n");
 		return;
 	}
_

Patches currently in -mm which might be from ptesarik@suse.com are


