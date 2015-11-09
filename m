From: akpm@linux-foundation.org
Subject: [folded-merged] remove-abs64-fix-fix.patch removed from -mm tree
Date: Mon, 09 Nov 2015 14:52:19 -0800
Message-ID: <564123a3.Z0AHT3KueKn8x4RH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33056 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751093AbbKIWwU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Nov 2015 17:52:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, dmitry.torokhov@gmail.com, sfr@canb.auug.org.au, mm-commits@vger.kernel.org


The patch titled
     Subject: remove-abs64-fix-fix
has been removed from the -mm tree.  Its filename was
     remove-abs64-fix-fix.patch

This patch was dropped because it was folded into remove-abs64.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: remove-abs64-fix-fix

Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/time/clocksource.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/time/clocksource.c~remove-abs64-fix-fix kernel/time/clocksource.c
--- a/kernel/time/clocksource.c~remove-abs64-fix-fix
+++ a/kernel/time/clocksource.c
@@ -217,7 +217,7 @@ static void clocksource_watchdog(unsigne
 			continue;
 
 		/* Check the deviation from the watchdog clocksource. */
-		if (abs64(cs_nsec - wd_nsec) > WATCHDOG_THRESHOLD) {
+		if (abs(cs_nsec - wd_nsec) > WATCHDOG_THRESHOLD) {
 			pr_warn("timekeeping watchdog: Marking clocksource '%s' as unstable because the skew is too large:\n",
 				cs->name);
 			pr_warn("                      '%s' wd_now: %llx wd_last: %llx mask: %llx\n",
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

remove-abs64.patch
remove-abs64-fix-fix-fix.patch
remove-abs64-fix-fix-fix-fix.patch

