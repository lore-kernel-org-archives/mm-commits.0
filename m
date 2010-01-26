From: akpm@linux-foundation.org
Subject: + rtc-twl-storage-class-should-be-before-const-qualifier.patch added to -mm tree
Date: Tue, 26 Jan 2010 14:28:08 -0800
Message-ID: <201001262228.o0QMS8a1024619@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48751 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752621Ab0AZW3a (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Jan 2010 17:29:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tklauser@distanz.ch, a.zummo@towertech.it


The patch titled
     rtc-twl: Storage class should be before const qualifier
has been added to the -mm tree.  Its filename is
     rtc-twl-storage-class-should-be-before-const-qualifier.patch

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
Subject: rtc-twl: Storage class should be before const qualifier
From: Tobias Klauser <tklauser@distanz.ch>

The C99 specification states in section 6.11.5:

The placement of a storage-class specifier other than at the beginning of
the declaration specifiers in a declaration is an obsolescent feature.

Signed-off-by: Tobias Klauser <tklauser@distanz.ch>
Signed-off-by: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-twl.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/rtc/rtc-twl.c~rtc-twl-storage-class-should-be-before-const-qualifier drivers/rtc/rtc-twl.c
--- a/drivers/rtc/rtc-twl.c~rtc-twl-storage-class-should-be-before-const-qualifier
+++ a/drivers/rtc/rtc-twl.c
@@ -57,7 +57,7 @@ enum {
 	REG_RTC_COMP_LSB_REG,
 	REG_RTC_COMP_MSB_REG,
 };
-const static u8 twl4030_rtc_reg_map[] = {
+static const u8 twl4030_rtc_reg_map[] = {
 	[REG_SECONDS_REG] = 0x00,
 	[REG_MINUTES_REG] = 0x01,
 	[REG_HOURS_REG] = 0x02,
@@ -80,7 +80,7 @@ const static u8 twl4030_rtc_reg_map[] = 
 	[REG_RTC_COMP_LSB_REG] = 0x10,
 	[REG_RTC_COMP_MSB_REG] = 0x11,
 };
-const static u8 twl6030_rtc_reg_map[] = {
+static const u8 twl6030_rtc_reg_map[] = {
 	[REG_SECONDS_REG] = 0x00,
 	[REG_MINUTES_REG] = 0x01,
 	[REG_HOURS_REG] = 0x02,
_

Patches currently in -mm which might be from tklauser@distanz.ch are

linux-next.patch
rtc-twl-storage-class-should-be-before-const-qualifier.patch

