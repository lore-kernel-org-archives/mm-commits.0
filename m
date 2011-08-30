From: akpm@linux-foundation.org
Subject: + kernelh-checkpatch-mark-strict_strtofoo-and-simple_strtofoo-as-obsolete.patch added to -mm tree
Date: Mon, 29 Aug 2011 19:21:05 -0700
Message-ID: <201108300217.p7U2HWQt019705@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49177 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751580Ab1H3CSL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 29 Aug 2011 22:18:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com


The patch titled
     kernel.h/checkpatch: mark strict_strto<foo> and simple_strto<foo> as obsolete
has been added to the -mm tree.  Its filename is
     kernelh-checkpatch-mark-strict_strtofoo-and-simple_strtofoo-as-obsolete.patch

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
Subject: kernel.h/checkpatch: mark strict_strto<foo> and simple_strto<foo> as obsolete
From: Joe Perches <joe@perches.com>

Mark obsolete/deprecated strict_strto<foo> and simple_strto<foo> functions
and macros as obsolete.

Update checkpatch to warn about their use.

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kernel.h |    4 ++++
 scripts/checkpatch.pl  |    6 +++---
 2 files changed, 7 insertions(+), 3 deletions(-)

diff -puN include/linux/kernel.h~kernelh-checkpatch-mark-strict_strtofoo-and-simple_strtofoo-as-obsolete include/linux/kernel.h
--- a/include/linux/kernel.h~kernelh-checkpatch-mark-strict_strtofoo-and-simple_strtofoo-as-obsolete
+++ a/include/linux/kernel.h
@@ -287,6 +287,8 @@ static inline int __must_check kstrtos32
 	return kstrtoint_from_user(s, count, base, res);
 }
 
+/* Obsolete, do not use.  Use kstrto<foo> instead */
+
 extern unsigned long simple_strtoul(const char *,char **,unsigned int);
 extern long simple_strtol(const char *,char **,unsigned int);
 extern unsigned long long simple_strtoull(const char *,char **,unsigned int);
@@ -296,6 +298,8 @@ extern long long simple_strtoll(const ch
 #define strict_strtoull	kstrtoull
 #define strict_strtoll	kstrtoll
 
+/* lib/printf utilities */
+
 extern __printf(2, 3) int sprintf(char *buf, const char * fmt, ...);
 extern __printf(2, 0) int vsprintf(char *buf, const char *, va_list);
 extern __printf(3, 4)
diff -puN scripts/checkpatch.pl~kernelh-checkpatch-mark-strict_strtofoo-and-simple_strtofoo-as-obsolete scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~kernelh-checkpatch-mark-strict_strtofoo-and-simple_strtofoo-as-obsolete
+++ a/scripts/checkpatch.pl
@@ -3151,10 +3151,10 @@ sub process {
 			     "consider using a completion\n" . $herecurr);
 
 		}
-# recommend kstrto* over simple_strto*
-		if ($line =~ /\bsimple_(strto.*?)\s*\(/) {
+# recommend kstrto* over simple_strto* and strict_strto*
+		if ($line =~ /\b((simple|strict)_(strto(l|ll|ul|ull)))\s*\(/) {
 			WARN("CONSIDER_KSTRTO",
-			     "consider using kstrto* in preference to simple_$1\n" . $herecurr);
+			     "$1 is obsolete, use k$3 instead\n" . $herecurr);
 		}
 # check for __initcall(), use device_initcall() explicitly please
 		if ($line =~ /^.\s*__initcall\s*\(/) {
_

Patches currently in -mm which might be from joe@perches.com are

linux-next.patch
mm-neaten-warn_alloc_failed.patch
mm-neaten-warn_alloc_failed-fix.patch
treewide-use-__printf-not-__attribute__formatprintf.patch
treewide-use-__printf-not-__attribute__formatprintf-checkpatch-fixes.patch
kernelh-checkpatch-mark-strict_strtofoo-and-simple_strtofoo-as-obsolete.patch

