From: akpm@linux-foundation.org
Subject: + rename-div64_64-to-div64_u64-mm.patch added to -mm tree
Date: Fri, 14 Mar 2008 13:34:21 -0700
Message-ID: <200803142034.m2EKYLUg018094@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57758 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752580AbYCNUff (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 14 Mar 2008 16:35:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: zippel@linux-m68k.org, avi@qumranet.com, tglx@linutronix.de


The patch titled
     2.6.25-rc5-mm1 specifc div64_u64 fixes
has been added to the -mm tree.  Its filename is
     rename-div64_64-to-div64_u64-mm.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: 2.6.25-rc5-mm1 specifc div64_u64 fixes
From: Roman Zippel <zippel@linux-m68k.org>

Rename a few more div64_u64 which are only in -mm.

Signed-off-by: Roman Zippel <zippel@linux-m68k.org>
Cc: Avi Kivity <avi@qumranet.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kvm/i8254.c |    6 +++---
 kernel/time.c        |    2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff -puN arch/x86/kvm/i8254.c~rename-div64_64-to-div64_u64-mm arch/x86/kvm/i8254.c
--- a/arch/x86/kvm/i8254.c~rename-div64_64-to-div64_u64-mm
+++ a/arch/x86/kvm/i8254.c
@@ -35,7 +35,7 @@
 #include "i8254.h"
 
 #ifndef CONFIG_X86_64
-#define mod_64(x, y) ((x) - (y) * div64_64(x, y))
+#define mod_64(x, y) ((x) - (y) * div64_u64(x, y))
 #else
 #define mod_64(x, y) ((x) % (y))
 #endif
@@ -60,8 +60,8 @@ static u64 muldiv64(u64 a, u32 b, u32 c)
 	rl = (u64)u.l.low * (u64)b;
 	rh = (u64)u.l.high * (u64)b;
 	rh += (rl >> 32);
-	res.l.high = div64_64(rh, c);
-	res.l.low = div64_64(((mod_64(rh, c) << 32) + (rl & 0xffffffff)), c);
+	res.l.high = div64_u64(rh, c);
+	res.l.low = div64_u64(((mod_64(rh, c) << 32) + (rl & 0xffffffff)), c);
 	return res.ll;
 }
 
diff -puN kernel/time.c~rename-div64_64-to-div64_u64-mm kernel/time.c
--- a/kernel/time.c~rename-div64_64-to-div64_u64-mm
+++ a/kernel/time.c
@@ -273,7 +273,7 @@ EXPORT_SYMBOL(jiffies_to_usecs);
 
 u64 jiffies_64_to_usecs(const u64 j)
 {
-	return div64_64(j*HZ_TO_USEC_NUM + HZ_TO_USEC_DEN-1, HZ_TO_USEC_DEN);
+	return div64_u64(j*HZ_TO_USEC_NUM + HZ_TO_USEC_DEN-1, HZ_TO_USEC_DEN);
 }
 EXPORT_SYMBOL(jiffies_64_to_usecs);
 
_

Patches currently in -mm which might be from zippel@linux-m68k.org are

origin.patch
git-x86.patch
git-watchdog.patch
m68k-replace-remaining-__function__-occurences.patch
fs-hfsplus-proper-externs.patch
affs-handle-match_strdup-failure.patch
hfs-handle-match_strdup-failure.patch
hfsplus-handle-match_strdup-failure.patch
fs-affs-filec-use-bug_on.patch
affs-be_add_cpu-conversion.patch
hfs-hfsplus-be_add_cpu-conversion.patch
hfs-fix-warning-with-64k-page_size.patch
hfsplus-fix-warning-with-64k-page_size.patch
introduce-explicit-signed-unsigned-64bit-divide.patch
convert-a-few-do_div-user.patch
rename-div64_64-to-div64_u64.patch
rename-div64_64-to-div64_u64-mm.patch
remove-div_long_long_rem.patch

