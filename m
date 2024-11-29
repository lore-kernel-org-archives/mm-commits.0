Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E94115AD9C
	for <mm-commits@vger.kernel.org>; Fri, 29 Nov 2024 10:56:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732877793; cv=none; b=SZegPbMy9/T6dNbr3AsygjI/7A5uaErczjd2wjEKOYrYiztwVWAVVZtguJnS1eqHGe94km+TGZcEpSmzHkKKiLjbuvxMQniLSSFuomVHuiHnOtbYz/fkJPF64w40tBnUwUD27barjzCtmm/Ffmi19+SCXSigXJV++b2AOfQ6KFA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732877793; c=relaxed/simple;
	bh=Wvxe7aofJUvEmbjRHsju7bN6rhkOG6gSuLk4Mp+zkUo=;
	h=Date:To:From:Subject:Message-Id; b=P949LFCAWvCUsGfxdRuje1jwF2wSgm7KjBEkoQI9EH1ruhaSAhUbtQLTEGOCwfTc+biaWz8AuEgjYHew1qkKzxWLhMHEWnLSC7NIgkmuE7/Vld16fH9hR6nkvJ2wjzFf+dnRdk3ms0Rc+pi7W5lLZ0VZDwPf5+V6yulXkIKilrk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=yPM8ga1D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="yPM8ga1D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3CF0C4CECF;
	Fri, 29 Nov 2024 10:56:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1732877793;
	bh=Wvxe7aofJUvEmbjRHsju7bN6rhkOG6gSuLk4Mp+zkUo=;
	h=Date:To:From:Subject:From;
	b=yPM8ga1Dpmi284WnzMGkWGRjCWo9dyOnI8R/GyZxs3WN6zCfWqQwXcvXP69e1qK3s
	 p8HqCSOOOPG2C9z0APf1i1O6Alo7tsD1kZD1iXC4GKWt9m4hoEfMoE4Sf9aNXhDPye
	 bCqJz/nJZZZXWlISDBOa5SVberWpWxYaa6DJ7A+A=
Date: Fri, 29 Nov 2024 02:56:32 -0800
To: mm-commits@vger.kernel.org,kees@kernel.org,jinb.park7@gmail.com,ptesarik@suse.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-rodata_test-use-read_once-to-read-const-variable.patch added to mm-unstable branch
Message-Id: <20241129105632.F3CF0C4CECF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/rodata_test: use READ_ONCE() to read const variable
has been added to the -mm mm-unstable branch.  Its filename is
     mm-rodata_test-use-read_once-to-read-const-variable.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-rodata_test-use-read_once-to-read-const-variable.patch

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

mm-rodata_test-use-read_once-to-read-const-variable.patch
mm-rodata_test-verify-test-data-is-unchanged-rather-than-non-zero.patch

