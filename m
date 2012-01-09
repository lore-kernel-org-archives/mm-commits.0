From: akpm@linux-foundation.org
Subject: - x86-implement-strict-user-copy-checks-for-x86_64.patch removed from -mm tree
Date: Mon, 09 Jan 2012 13:59:10 -0800
Message-ID: <20120109224122.CCEF610004D@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gy0-f202.google.com ([209.85.160.202]:39661 "EHLO
	mail-gy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755899Ab2AIWlX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jan 2012 17:41:23 -0500
Received: by ghrr15 with SMTP id r15so476842ghr.1
        for <mm-commits@vger.kernel.org>; Mon, 09 Jan 2012 14:41:23 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sboyd@codeaurora.org, hpa@zytor.com, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     Subject: x86: implement strict user copy checks for x86_64
has been removed from the -mm tree.  Its filename was
     x86-implement-strict-user-copy-checks-for-x86_64.patch

This patch was dropped because I got tired of all the warnings

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Stephen Boyd <sboyd@codeaurora.org>
Subject: x86: implement strict user copy checks for x86_64

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

origin.patch
linux-next.patch
debugobjects-fix-selftest-for-static-warnings.patch
drivers-scsi-sgc-convert-to-kstrtoul_from_user.patch
kprobes-silence-debug_strict_user_copy_checks=y-warning.patch
consolidate-config_debug_strict_user_copy_checks.patch

