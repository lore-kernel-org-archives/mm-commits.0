Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F1352629D
	for <mm-commits@vger.kernel.org>; Wed,  6 Nov 2024 01:00:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730854815; cv=none; b=Zq2UZsI2pbp66I5zGrSLnEPH+fcDZfGTTKSf/7TiOR/UuPCqBW3xcR82SpvmS4FAQlvZfYzByv59Se3TuZs8C8yKgI4g8AdQndJmQRXl4xMr6FM18L2QlKO1qF8sJa5Ldtl4T1huB6rwd4edynhRzkCeQHaebxzTHBHW+TyU40A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730854815; c=relaxed/simple;
	bh=DyBU34VEgIyVPE0Tu1WJc9k+hrPnXDYPZb9Lu8pGEuM=;
	h=Date:To:From:Subject:Message-Id; b=q5BavUQqQvWWnegwtGoXXTzWwjbcaKlXiBUoJonHSvnegk5TdHJgrJgGyo7kXZ72zrr/0y9k9xisIvSZ0ekd/1/NmxqktePpRb6lIQLIzOprmeXiRwCzAEP0CaFgNN2snXDrFcg3cq87L5PWy6ddE9ptWJ4kCUMwdnSZqJV9u2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=KxGgTTVj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KxGgTTVj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 924B4C4CECF;
	Wed,  6 Nov 2024 01:00:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730854814;
	bh=DyBU34VEgIyVPE0Tu1WJc9k+hrPnXDYPZb9Lu8pGEuM=;
	h=Date:To:From:Subject:From;
	b=KxGgTTVjiO61EfJfOUHUkrckjFALGHf7rCzd0hy6eCIBllmvVQrHgR2G1F2h+cMel
	 nd/5Tur45ann5b/hYDlzN5XK8LKIhAjlgFwiEyUrQkYb9BGMxuRqj4B1hkWA9Qj1VY
	 0jYkCXItHog9HT7Xtxm776uwZaYhcwdo9Cc8RYz8=
Date: Tue, 05 Nov 2024 17:00:14 -0800
To: mm-commits@vger.kernel.org,ubizjak@gmail.com,tj@kernel.org,tglx@linutronix.de,mingo@redhat.com,mingo@kernel.org,hpa@zytor.com,dennis@kernel.org,dave.hansen@linux.intel.com,cl@linux.com,bp@alien8.de,andriy.shevchenko@linux.intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] percpu-add-a-test-case-for-the-specific-64-bit-value-addition.patch removed from -mm tree
Message-Id: <20241106010014.924B4C4CECF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: percpu: add a test case for the specific 64-bit value addition
has been removed from the -mm tree.  Its filename was
     percpu-add-a-test-case-for-the-specific-64-bit-value-addition.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

resource-replace-open-coded-resource_intersection.patch
resource-introduce-is_type_match-helper-and-use-it.patch

