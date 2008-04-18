From: akpm@linux-foundation.org
Subject: + provide-u64-version-of-jiffies_to_usecs-in-kernel-tsacctc-update.patch added to -mm tree
Date: Fri, 18 Apr 2008 16:23:35 -0700
Message-ID: <200804182323.m3INNZim021714@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46376 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756837AbYDRXX4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 18 Apr 2008 19:23:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jlim@sgi.com, rdunlap@xenotime.net, tglx@linutronix.de, zippel@linux-m68k.org


The patch titled
     Provide u64 version of jiffies_to_usecs() in kernel/tsacct.c (update)
has been added to the -mm tree.  Its filename is
     provide-u64-version-of-jiffies_to_usecs-in-kernel-tsacctc-update.patch

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
Subject: Provide u64 version of jiffies_to_usecs() in kernel/tsacct.c (update)
From: Jonathan Lim <jlim@sgi.com>

This version implements a correction to jiffies_64_to_usecs() based on
feedback from Randy Dunlap and Roman Zippel.

Signed-off-by: Jonathan Lim <jlim@sgi.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "Randy.Dunlap" <rdunlap@xenotime.net>
Cc: Roman Zippel <zippel@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/time.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN kernel/time.c~provide-u64-version-of-jiffies_to_usecs-in-kernel-tsacctc-update kernel/time.c
--- a/kernel/time.c~provide-u64-version-of-jiffies_to_usecs-in-kernel-tsacctc-update
+++ a/kernel/time.c
@@ -271,7 +271,11 @@ EXPORT_SYMBOL(jiffies_to_usecs);
 
 u64 jiffies_64_to_usecs(const u64 j)
 {
+# if BITS_PER_LONG == 32
+	return ((u64)HZ_TO_USEC_MUL32 * j) >> HZ_TO_USEC_SHR32;
+# else
 	return div64_64(j*HZ_TO_USEC_NUM + HZ_TO_USEC_DEN-1, HZ_TO_USEC_DEN);
+# endif
 }
 EXPORT_SYMBOL(jiffies_64_to_usecs);
 
_

Patches currently in -mm which might be from jlim@sgi.com are

provide-u64-version-of-jiffies_to_usecs-in-kernel-tsacctc.patch
provide-u64-version-of-jiffies_to_usecs-in-kernel-tsacctc-update.patch
use-find_task_by_vpid-in-taskstats.patch

