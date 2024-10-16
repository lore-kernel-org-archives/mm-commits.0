Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E92281D2780
	for <mm-commits@vger.kernel.org>; Wed, 16 Oct 2024 22:06:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729116367; cv=none; b=VRyGlMXXw9Nr5MqVGfaiOYVPmIJj5LnFA8zfIKWx99gtbjHi+8Mij7yOMjybmYhMJBP+Zx/SHsss5cm/2/qTzeQnc83gmaCBniQKTd4Tcb9Jwqx7vq2Kt7uWGIpsEtUShcMc2Y/WtICCSVQzbU3OJhpyeA3hQxeXVhQ4yWnftKc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729116367; c=relaxed/simple;
	bh=a3oojhTLIy7j2x+orK9dThEXbnQ9y4Na8GjBWrhvBr4=;
	h=Date:To:From:Subject:Message-Id; b=j8cqlpYEaELLGGOPRyRejwBQdmRY5Fa8+mMJcKBEvdk4ghIXP1xZtKwe44v1wr9gZqepW0XWt+EQzlB+PPgnuYSKkNHwGvrYY3Dr7pXl9dq5eKh01NQrmE5Z4U+qmuRVc/qgGonK+CV5Q6BMV90bsbvtec0wkguOUaP4ffipwaI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=k/bDeUIZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="k/bDeUIZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64643C4CEC5;
	Wed, 16 Oct 2024 22:06:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1729116366;
	bh=a3oojhTLIy7j2x+orK9dThEXbnQ9y4Na8GjBWrhvBr4=;
	h=Date:To:From:Subject:From;
	b=k/bDeUIZckeVus4OF4ItyKuGiNHFfg6PkBbDF5i+S97b+6JgMJUxM21dL0+lAoPRo
	 q9Fa43wClBWuNbHNxrgtAnwdgpw13bLl/ZDiEhdmdbm2V02duoPnHThOgGuZKtQCYv
	 KB5C66CdH4KfFMeExsUQv11LkRz3EDYs7slMldjo=
Date: Wed, 16 Oct 2024 15:06:05 -0700
To: mm-commits@vger.kernel.org,ubizjak@gmail.com,tj@kernel.org,tglx@linutronix.de,mingo@redhat.com,mingo@kernel.org,hpa@zytor.com,dennis@kernel.org,dave.hansen@linux.intel.com,cl@linux.com,bp@alien8.de,andriy.shevchenko@linux.intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + percpu-add-a-test-case-for-the-specific-64-bit-value-addition.patch added to mm-unstable branch
Message-Id: <20241016220606.64643C4CEC5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: percpu: add a test case for the specific 64-bit value addition
has been added to the -mm mm-unstable branch.  Its filename is
     percpu-add-a-test-case-for-the-specific-64-bit-value-addition.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/percpu-add-a-test-case-for-the-specific-64-bit-value-addition.patch

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
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: percpu: add a test case for the specific 64-bit value addition
Date: Wed, 16 Oct 2024 21:23:52 +0300

It might be a corner case when we add UINT_MAX as 64-bit unsigned value to
the percpu variable as it's not the same as -1 (ULONG_LONG_MAX).  Add a
test case for that.

Link: https://lkml.kernel.org/r/20241016182635.1156168-3-andriy.shevchenko@linux.intel.com
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Borislav Petkov (AMD) <bp@alien8.de>
Cc: Christoph Lameter <cl@linux.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Dennis Zhou <dennis@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Uros Bizjak <ubizjak@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/percpu_test.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

--- a/lib/percpu_test.c~percpu-add-a-test-case-for-the-specific-64-bit-value-addition
+++ a/lib/percpu_test.c
@@ -1,4 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0-only
+#include <linux/limits.h>
 #include <linux/module.h>
 
 /* validate @native and @pcp counter values match @expected */
@@ -24,8 +25,9 @@ static int __init percpu_test_init(void)
 	 * +ul_one/-ul_one below would replace with inc/dec instructions.
 	 */
 	volatile unsigned int ui_one = 1;
-	long l = 0;
+	unsigned long long ull = 0;
 	unsigned long ul = 0;
+	long l = 0;
 
 	pr_info("percpu test start\n");
 
@@ -112,6 +114,13 @@ static int __init percpu_test_init(void)
 	CHECK(ul, ulong_counter, -1);
 	CHECK(ul, ulong_counter, ULONG_MAX);
 
+	ul = ull = 0;
+	__this_cpu_write(ulong_counter, 0);
+
+	ul = ull += UINT_MAX;
+	__this_cpu_add(ulong_counter, ull);
+	CHECK(ul, ulong_counter, UINT_MAX);
+
 	ul = 3;
 	__this_cpu_write(ulong_counter, 3);
 
_

Patches currently in -mm which might be from andriy.shevchenko@linux.intel.com are

mm-remove-unused-stub-for-can_swapin_thp.patch
x86-percpu-fix-clang-warning-when-dealing-with-unsigned-types.patch
percpu-add-a-test-case-for-the-specific-64-bit-value-addition.patch
resource-replace-open-coded-resource_intersection.patch
resource-introduce-is_type_match-helper-and-use-it.patch

