From: akpm@linux-foundation.org
Subject: + loosen-dependancy-on-rtc-cmos.patch added to -mm tree
Date: Wed, 14 Feb 2007 19:33:44 -0800
Message-ID: <200702150333.l1F3Xir2018724@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:60619 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964887AbXBODdy (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 14 Feb 2007 22:33:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: davej@redhat.com, david-b@pacbell.net


The patch titled
     loosen dependancy on rtc cmos
has been added to the -mm tree.  Its filename is
     loosen-dependancy-on-rtc-cmos.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: loosen dependancy on rtc cmos
From: Dave Jones <davej@redhat.com>

This option is useful for all of the X86 subarchs afaik (and especially
X86_GENERICARCH).

Signed-off-by: Dave Jones <davej@redhat.com>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/rtc/Kconfig~loosen-dependancy-on-rtc-cmos drivers/rtc/Kconfig
--- a/drivers/rtc/Kconfig~loosen-dependancy-on-rtc-cmos
+++ a/drivers/rtc/Kconfig
@@ -101,7 +101,7 @@ comment "RTC drivers"
 
 config RTC_DRV_CMOS
 	tristate "PC-style 'CMOS' real time clock"
-	depends on RTC_CLASS && (X86_PC || ALPHA || ARM26 || ARM \
+	depends on RTC_CLASS && (X86 || ALPHA || ARM26 || ARM \
 		|| M32R || ATARI || POWERPC)
 	help
 	  Say "yes" here to get direct support for the real time clock
_

Patches currently in -mm which might be from davej@redhat.com are

origin.patch
git-agpgart.patch
git-cpufreq.patch
loosen-dependancy-on-rtc-cmos.patch
