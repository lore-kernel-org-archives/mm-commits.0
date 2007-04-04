From: akpm@linux-foundation.org
Subject: + kernel-timec-add-missing-symbol-exports.patch added to -mm tree
Date: Wed, 04 Apr 2007 16:58:19 -0700
Message-ID: <200704042358.l34NwJUt002546@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:35075 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752893AbXDDX6g (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 4 Apr 2007 19:58:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: t.bittermann@online.de, johnstul@us.ibm.com, mingo@elte.hu, tglx@linutronix.de


The patch titled
     kernel/time.c: add missing symbol exports
has been added to the -mm tree.  Its filename is
     kernel-timec-add-missing-symbol-exports.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: kernel/time.c: add missing symbol exports
From: Thomas Bittermann <t.bittermann@online.de>

This patch adds 2 missing symbol exports:

jiffies_to_timeval
timeval_to_jiffies

I'm working on a Fedora 7 LiveCD which integrates dm-raid4-5
(http://people.redhat.com/~heinzm/sw/dm/dm-raid45/readme).  dm-raid4-5.c uses
jiffies_to_timeval() ...

It was inlined before and got lost somewhere between 2.6.20 and 2.6.21-rcX.

Signed-off-by: Thomas Bittermann <t.bittermann@online.de>
Acked-by: Ingo Molnar <mingo@elte.hu>
Acked-by: john stultz <johnstul@us.ibm.com>
Acked-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/time.c |    2 ++
 1 files changed, 2 insertions(+)

diff -puN kernel/time.c~kernel-timec-add-missing-symbol-exports kernel/time.c
--- a/kernel/time.c~kernel-timec-add-missing-symbol-exports
+++ a/kernel/time.c
@@ -635,6 +635,7 @@ timeval_to_jiffies(const struct timeval 
 		(((u64)usec * USEC_CONVERSION + USEC_ROUND) >>
 		 (USEC_JIFFIE_SC - SEC_JIFFIE_SC))) >> SEC_JIFFIE_SC;
 }
+EXPORT_SYMBOL(timeval_to_jiffies);
 
 void jiffies_to_timeval(const unsigned long jiffies, struct timeval *value)
 {
@@ -649,6 +650,7 @@ void jiffies_to_timeval(const unsigned l
 	tv_usec /= NSEC_PER_USEC;
 	value->tv_usec = tv_usec;
 }
+EXPORT_SYMBOL(jiffies_to_timeval);
 
 /*
  * Convert jiffies/jiffies_64 to clock_t and back.
_

Patches currently in -mm which might be from t.bittermann@online.de are

kernel-timec-add-missing-symbol-exports.patch
