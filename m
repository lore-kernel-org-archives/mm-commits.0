From: akpm@linux-foundation.org
Subject: - provide-u64-version-of-jiffies_to_usecs-in-kernel-tsacctc-update.patch removed from -mm tree
Date: Wed, 30 Apr 2008 10:20:37 -0700
Message-ID: <200804301720.m3UHKbJt025337@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60137 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757788AbYD3RUx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 13:20:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jlim@sgi.com, rdunlap@xenotime.net, tglx@linutronix.de, zippel@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     Provide u64 version of jiffies_to_usecs() in kernel/tsacct.c (update)
has been removed from the -mm tree.  Its filename was
     provide-u64-version-of-jiffies_to_usecs-in-kernel-tsacctc-update.patch

This patch was dropped because an updated version will be merged

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
@@ -273,7 +273,11 @@ EXPORT_SYMBOL(jiffies_to_usecs);
 
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

use-find_task_by_vpid-in-taskstats.patch
provide-u64-version-of-jiffies_to_usecs-in-kernel-tsacctc-update.patch

