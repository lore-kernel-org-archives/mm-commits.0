From: akpm@linux-foundation.org
Subject: + clocksource-remove-redundant-code.patch added to -mm tree
Date: Thu, 29 Nov 2007 15:49:57 -0800
Message-ID: <200711292349.lATNnvn0013574@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44308 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762728AbXK2XvM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 29 Nov 2007 18:51:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lizf@cn.fujitsu.com, johnstul@us.ibm.com, mingo@elte.hu, tglx@linutronix.de


The patch titled
     clocksource: remove redundant code
has been added to the -mm tree.  Its filename is
     clocksource-remove-redundant-code.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: clocksource: remove redundant code
From: Li Zefan <lizf@cn.fujitsu.com>

Flag CLOCK_SOURCE_WATCHDOG is cleared twice.  Note clocksource_change_rating()
won't do anyting with the cs flag.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: john stultz <johnstul@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/time/clocksource.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN kernel/time/clocksource.c~clocksource-remove-redundant-code kernel/time/clocksource.c
--- a/kernel/time/clocksource.c~clocksource-remove-redundant-code
+++ a/kernel/time/clocksource.c
@@ -91,7 +91,6 @@ static void clocksource_ratewd(struct cl
 	       cs->name, delta);
 	cs->flags &= ~(CLOCK_SOURCE_VALID_FOR_HRES | CLOCK_SOURCE_WATCHDOG);
 	clocksource_change_rating(cs, 0);
-	cs->flags &= ~CLOCK_SOURCE_WATCHDOG;
 	list_del(&cs->wd_list);
 }
 
_

Patches currently in -mm which might be from lizf@cn.fujitsu.com are

arm-fix-memset-size-error.patch
git-hid.patch
ia64-efi-make-full-use-of-macro-efi_md_size.patch
clocksource-remove-redundant-code.patch
clockevent-simplify-list-operations.patch
timekeeping-rename-timekeeping_is_continuous-to-timekeeping_valid_for_hres.patch
time-fix-typo-in-comments.patch
time-delete-comments-that-refer-to-noexistent-symbols.patch
