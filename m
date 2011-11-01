From: akpm@linux-foundation.org
Subject: [merged] kernelh-checkpatch-mark-strict_strtofoo-and-simple_strtofoo-as-obsolete.patch removed from -mm tree
Date: Tue, 01 Nov 2011 14:16:52 -0700
Message-ID: <201111012116.pA1LGqRK003618@hpaq12.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:30320 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753117Ab1KAVQ6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Nov 2011 17:16:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel.h/checkpatch: mark strict_strto<foo> and simple_strto<foo> as obsolete
has been removed from the -mm tree.  Its filename was
     kernelh-checkpatch-mark-strict_strtofoo-and-simple_strtofoo-as-obsolete.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: kernel.h/checkpatch: mark strict_strto<foo> and simple_strto<foo> as obsolete

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

origin.patch
linux-next.patch

