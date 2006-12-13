From: akpm@osdl.org
Subject: - time-uninline-jiffiesh-fix.patch removed from -mm tree
Date: Wed, 13 Dec 2006 14:48:23 -0800
Message-ID: <200612132248.kBDMmN3e023077@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:52776 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751720AbWLMWsd (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Dec 2006 17:48:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jeremy@goop.org, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Export jiffies_to_timespec()
has been removed from the -mm tree.  Its filename was
     time-uninline-jiffiesh-fix.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: Export jiffies_to_timespec()
From: Jeremy Fitzhardinge <jeremy@goop.org>

Export jiffies_to_timespec; previously modules used the inlined header
version.

Signed-off-by: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 kernel/time.c |    1 +
 1 files changed, 1 insertion(+)

diff -puN kernel/time.c~time-uninline-jiffiesh-fix kernel/time.c
--- a/kernel/time.c~time-uninline-jiffiesh-fix
+++ a/kernel/time.c
@@ -566,6 +566,7 @@ jiffies_to_timespec(const unsigned long 
 	u64 nsec = (u64)jiffies * TICK_NSEC;
 	value->tv_sec = div_long_long_rem(nsec, NSEC_PER_SEC, &value->tv_nsec);
 }
+EXPORT_SYMBOL(jiffies_to_timespec);
 
 /* Same for "timeval"
  *
_

Patches currently in -mm which might be from jeremy@goop.org are

origin.patch
use-activate_mm-in-fs-aiocuse_mm.patch
convert-i386-pda-code-to-use-%fs.patch
gtod-uninline-jiffiesh.patch

