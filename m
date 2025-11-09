Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F7D33043BC
	for <mm-commits@vger.kernel.org>; Sun,  9 Nov 2025 17:04:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762707875; cv=none; b=gXWXKViC91kYpbzUeRUmAn6Mzt50vByGarhMLI7nwO2cqkTNLvjDVXnng0KXB+mVJn76hg41kwUC/bo0+pEw+3oG+opDJCsNDhPKtdIt+i9n/8+tsOv1Z+CiaKzREo5z8i8Gl9hI7G56Smtp57p+LeYl6Ili+24dJ20Xua/vxC4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762707875; c=relaxed/simple;
	bh=dLTc5r0hBnhhvXYB2Jbw0zsEUPp2BKiLZFcnooj2DGs=;
	h=Date:To:From:Subject:Message-Id; b=IgqRqPBRwexzbAch6SjvrnrjoQ2IoWYcdrDcHCWbByI/PiQ+4VltwD24EUK4gqlrJzFBMLbngP1lePPrltNEHODWLWKBdOZbXPtDUo3rCaC5D/3RMTFEnw9BZIAbiBt8dVKbsHP9rKx4O0RUBDpJhdw4DF51Qbb5P9HGYYr78qc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DSzTP2A4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DSzTP2A4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A660C2BCC7;
	Sun,  9 Nov 2025 17:04:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1762707874;
	bh=dLTc5r0hBnhhvXYB2Jbw0zsEUPp2BKiLZFcnooj2DGs=;
	h=Date:To:From:Subject:From;
	b=DSzTP2A4wRLoLYsUHar67Zzo8gQj2YfJEo5mNZvtRJJuEKx3bA3JUapq4Gyf6u2/x
	 hXW/30QH+CAES4DldHmne68zVIADvX4wtLz0c717MuqBYQHHISLQth6GooV1+GYZr6
	 i03ZbY68NXlbYxrccU7UxUVEC0swpa70/VsvxTvA=
Date: Sun, 09 Nov 2025 09:04:33 -0800
To: mm-commits@vger.kernel.org,will@kernel.org,nathan@kernel.org,morbo@google.com,masahiroy@kernel.org,maninder1.s@samsung.com,justinstitt@google.com,jack@suse.cz,qq570070308@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + fix-redundant-judgment-in-warn_once-with-clang.patch added to mm-nonmm-unstable branch
Message-Id: <20251109170434.8A660C2BCC7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: include/linux/once_lite.h: fix judgment in WARN_ONCE with clang
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     fix-redundant-judgment-in-warn_once-with-clang.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fix-redundant-judgment-in-warn_once-with-clang.patch

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
From: Xie Yuanbin <qq570070308@gmail.com>
Subject: include/linux/once_lite.h: fix judgment in WARN_ONCE with clang
Date: Sun, 9 Nov 2025 16:37:15 +0800

For c code:
```c
extern int xx;
void test(void)
{
	if (WARN_ONCE(xx, "x"))
		__asm__ volatile ("nop":::);
}
```

Clang will generate the following assembly code:
```assemble
test:
	movl	xx(%rip), %eax // Assume xx == 0 (likely case)
	testl	%eax, %eax // judge once
	je	.LBB0_3    // jump to .LBB0_3
	testb	$1, test.__already_done(%rip)
	je	.LBB0_2
.LBB0_3:
	testl	%eax, %eax // judge again
	je	.LBB0_5    // jump to .LBB0_5
.LBB0_4:
	nop
.LBB0_5:
	retq
	// omit
```

In the above code, `xx == 0` should be a likely case, but in this case,
xx has been judged twice.

Test info:
1. kernel source:
linux-next
commit 9c0826a5d9aa4d52206d ("Add linux-next specific files for 20251107")
2. compiler:
clang: Debian clang version 21.1.4 (8) with
Debian LLD 21.1.4 (compatible with GNU linkers)
3. config:
base on default x86_64_defconfig, and setting:
CONFIG_MITIGATION_RETHUNK=n
CONFIG_STACKPROTECTOR=n

Add unlikely to __ret_cond to help the compiler optimize correctly.

[akpm@linux-foundation.org: undo whitespace changes]
Link: https://lkml.kernel.org/r/20251109083715.24495-1-qq570070308@gmail.com
Signed-off-by: Xie Yuanbin <qq570070308@gmail.com>
Cc: Bill Wendling <morbo@google.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Justin Stitt <justinstitt@google.com>
Cc: Maninder Singh <maninder1.s@samsung.com>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/once_lite.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/once_lite.h~fix-redundant-judgment-in-warn_once-with-clang
+++ a/include/linux/once_lite.h
@@ -16,7 +16,7 @@
 		bool __ret_cond = !!(condition);			\
 		bool __ret_once = false;				\
 									\
-		if (unlikely(__ret_cond && !__already_done)) {		\
+		if (unlikely(__ret_cond) && unlikely(!__already_done)) {\
 			__already_done = true;				\
 			__ret_once = true;				\
 		}							\
_

Patches currently in -mm which might be from qq570070308@gmail.com are

fix-redundant-judgment-in-warn_once-with-clang.patch

