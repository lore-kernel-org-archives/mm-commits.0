From: akpm@linux-foundation.org
Subject: + x86-implement-strict-user-copy-checks-for-x86_64.patch added to -mm tree
Date: Tue, 07 Jun 2011 16:43:49 -0700
Message-ID: <201106072343.p57NhnE1002518@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39351 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754951Ab1FGXnz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Jun 2011 19:43:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sboyd@codeaurora.org, hpa@zytor.com, mingo@elte.hu


The patch titled
     x86: implement strict user copy checks for x86_64
has been added to the -mm tree.  Its filename is
     x86-implement-strict-user-copy-checks-for-x86_64.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: x86: implement strict user copy checks for x86_64
From: Stephen Boyd <sboyd@codeaurora.org>

Strict user copy checks are only really supported on x86_32 even though
the config option is selectable on x86_64.  Add the necessary support to
the 64 bit code to trigger copy_from_user() warnings at compile time.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
Acked-by: Ingo Molnar <mingo@elte.hu>
Acked-by: H. Peter Anvin <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/uaccess_64.h |   12 +++++++++---
 arch/x86/lib/usercopy_64.c        |    6 ++++++
 2 files changed, 15 insertions(+), 3 deletions(-)

diff -puN arch/x86/include/asm/uaccess_64.h~x86-implement-strict-user-copy-checks-for-x86_64 arch/x86/include/asm/uaccess_64.h
--- a/arch/x86/include/asm/uaccess_64.h~x86-implement-strict-user-copy-checks-for-x86_64
+++ a/arch/x86/include/asm/uaccess_64.h
@@ -43,6 +43,14 @@ _copy_from_user(void *to, const void __u
 __must_check unsigned long
 copy_in_user(void __user *to, const void __user *from, unsigned len);
 
+extern void copy_from_user_overflow(void)
+#ifdef CONFIG_DEBUG_STRICT_USER_COPY_CHECKS
+	__compiletime_error("copy_from_user() buffer size is not provably correct")
+#else
+	__compiletime_warning("copy_from_user() buffer size is not provably correct")
+#endif
+;
+
 static inline unsigned long __must_check copy_from_user(void *to,
 					  const void __user *from,
 					  unsigned long n)
@@ -52,10 +60,8 @@ static inline unsigned long __must_check
 	might_fault();
 	if (likely(sz == -1 || sz >= n))
 		n = _copy_from_user(to, from, n);
-#ifdef CONFIG_DEBUG_VM
 	else
-		WARN(1, "Buffer overflow detected!\n");
-#endif
+		copy_from_user_overflow();
 	return n;
 }
 
diff -puN arch/x86/lib/usercopy_64.c~x86-implement-strict-user-copy-checks-for-x86_64 arch/x86/lib/usercopy_64.c
--- a/arch/x86/lib/usercopy_64.c~x86-implement-strict-user-copy-checks-for-x86_64
+++ a/arch/x86/lib/usercopy_64.c
@@ -181,3 +181,9 @@ copy_user_handle_tail(char *to, char *fr
 			break;
 	return len;
 }
+
+void copy_from_user_overflow(void)
+{
+	WARN(1, "Buffer overflow detected!\n");
+}
+EXPORT_SYMBOL(copy_from_user_overflow);
_

Patches currently in -mm which might be from sboyd@codeaurora.org are

linux-next.patch
lpfc-silence-debug_strict_user_copy_checks=y-warning.patch
kprobes-silence-debug_strict_user_copy_checks=y-warning.patch
x86-implement-strict-user-copy-checks-for-x86_64.patch
consolidate-config_debug_strict_user_copy_checks.patch

