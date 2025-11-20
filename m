Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15ECF343D78
	for <mm-commits@vger.kernel.org>; Thu, 20 Nov 2025 22:04:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763676280; cv=none; b=RVzd4PpCv/mHSiNVQuamLljoWS3/IiXWc4hTj8JqkYtD7EFFt9tCmXv3d//xyEQWXnWn83NLXc8hSseUn+Um9Cw1UeSNpdqXFymz39ixqihy2R7vX3wyxGX6xk6i/UveL7u70aInTypl3lIBLALZtJsVWdajcHPkyAsHv6bL5Zo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763676280; c=relaxed/simple;
	bh=q61Zh4ef9krvxMlhmonnz6ivIH15pnPNfCy1yzNaaM0=;
	h=Date:To:From:Subject:Message-Id; b=hJMn0uW9MlQtqWKCtWGZoiq3jUJG5/vBQ2sMaUGoG9W8/wr43KkMzMhr0/OQZKoP5OIihuqvSGii2/nivB7LKZass2SdRrGND95gcvAbdfmlpTyCbiv0y98kFhlbRs2m05ELhYRt3j2RuclbfMAknXExewRcY/Uv25T4RG49GZ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wl1UxvvV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wl1UxvvV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 894DEC4CEF1;
	Thu, 20 Nov 2025 22:04:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763676279;
	bh=q61Zh4ef9krvxMlhmonnz6ivIH15pnPNfCy1yzNaaM0=;
	h=Date:To:From:Subject:From;
	b=wl1UxvvVWJ/9Jvw5UUbuqwNEGIJBfqgXnDumr/DICBVmm8K27gFTKB7HBKP+AVPwg
	 s1TPedp575aEIdYFgotfLMu/hKOVVo5wKYx5j54vWV+YMWjYVyM3nctxCGfZ+qhoS5
	 Z7G9wkJh6YGo0dOFRflgRq4RM97qWwvl/pE2Eglc=
Date: Thu, 20 Nov 2025 14:04:38 -0800
To: mm-commits@vger.kernel.org,will@kernel.org,nathan@kernel.org,morbo@google.com,masahiroy@kernel.org,maninder1.s@samsung.com,justinstitt@google.com,jack@suse.cz,qq570070308@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] fix-redundant-judgment-in-warn_once-with-clang.patch removed from -mm tree
Message-Id: <20251120220439.894DEC4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: include/linux/once_lite.h: fix judgment in WARN_ONCE with clang
has been removed from the -mm tree.  Its filename was
     fix-redundant-judgment-in-warn_once-with-clang.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


