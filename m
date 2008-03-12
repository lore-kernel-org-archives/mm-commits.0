From: akpm@linux-foundation.org
Subject: + add-warn_on_secs-macro-fix.patch added to -mm tree
Date: Tue, 11 Mar 2008 22:40:57 -0700
Message-ID: <200803120540.m2C5evHv012470@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42765 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751796AbYCLFl1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 12 Mar 2008 01:41:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hidave.darkstar@gmail.com, marcin.slusarz@gmail.com


The patch titled
     do not check condition twice in WARN_ON_SECS
has been added to the -mm tree.  Its filename is
     add-warn_on_secs-macro-fix.patch

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
Subject: do not check condition twice in WARN_ON_SECS
From: Dave Young <hidave.darkstar@gmail.com>

Don't check condition twice, change WARN_ON(condition) to WARN_ON(1) Thanks
Marcin Slusarz for pointing this out.

Signed-off-by: Dave Young <hidave.darkstar@gmail.com>
Cc: Marcin Slusarz <marcin.slusarz@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/bug.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN include/asm-generic/bug.h~add-warn_on_secs-macro-fix include/asm-generic/bug.h
--- a/include/asm-generic/bug.h~add-warn_on_secs-macro-fix
+++ a/include/asm-generic/bug.h
@@ -80,7 +80,8 @@ extern void warn_on_slowpath(const char 
 	int __ret_warn_on = !!(condition);			\
 	if (unlikely(__ret_warn_on))				\
 		if (__ratelimit(secs * HZ, 1))			\
-			WARN_ON(condition);			\
+			WARN_ON(1);				\
+	unlikely(__ret_warn_on);				\
 })
 
 #ifdef CONFIG_SMP
_

Patches currently in -mm which might be from hidave.darkstar@gmail.com are

add-time_is_after_jiffies-and-others-which-compare-with-jiffies.patch
git-net.patch
isolate-ratelimit-from-printkc-for-other-use.patch
isolate-ratelimit-from-printkc-for-other-use-update.patch
add-warn_on_secs-macro.patch
add-warn_on_secs-macro-fix.patch
use-warn_on_secs-in-rcupreempth.patch

