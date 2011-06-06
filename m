From: akpm@linux-foundation.org
Subject: + build_bug_on_zero-fix-sparse-breakage.patch added to -mm tree
Date: Mon, 06 Jun 2011 15:46:36 -0700
Message-ID: <201106062246.p56MkaPZ027604@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44137 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752014Ab1FFWrN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Jun 2011 18:47:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: linux@treblig.org, kosaki.motohiro@jp.fujitsu.com


The patch titled
     BUILD_BUG_ON_ZERO: fix sparse breakage
has been added to the -mm tree.  Its filename is
     build_bug_on_zero-fix-sparse-breakage.patch

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
Subject: BUILD_BUG_ON_ZERO: fix sparse breakage
From: "Dr. David Alan Gilbert" <linux@treblig.org>

BUILD_BUG_ON_ZERO and BUILD_BUG_ON_NULL must return values, even in the
CHECKER case otherwise various users of it become syntactically invalid.

Signed-off-by: Dr. David Alan Gilbert <linux@treblig.org>
Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kernel.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN include/linux/kernel.h~build_bug_on_zero-fix-sparse-breakage include/linux/kernel.h
--- a/include/linux/kernel.h~build_bug_on_zero-fix-sparse-breakage
+++ a/include/linux/kernel.h
@@ -671,8 +671,8 @@ struct sysinfo {
 
 #ifdef __CHECKER__
 #define BUILD_BUG_ON_NOT_POWER_OF_2(n)
-#define BUILD_BUG_ON_ZERO(e)
-#define BUILD_BUG_ON_NULL(e)
+#define BUILD_BUG_ON_ZERO(e) (0)
+#define BUILD_BUG_ON_NULL(e) ((void*)0)
 #define BUILD_BUG_ON(condition)
 #else /* __CHECKER__ */
 
_

Patches currently in -mm which might be from linux@treblig.org are

build_bug_on_zero-fix-sparse-breakage.patch

