From: akpm@linux-foundation.org
Subject: + w1_therm_read_bin-suspicious-usage-of-flush_signals.patch added to -mm tree
Date: Tue, 26 Jun 2007 12:56:17 -0700
Message-ID: <200706261956.l5QJuHud001016@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58130 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757763AbXFZT4p (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Jun 2007 15:56:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: johnpol@2ka.mipt.ru, oleg@tv-sign.ru, roland@redhat.com


The patch titled
     w1_therm_read_bin: don't call flush_signals()
has been added to the -mm tree.  Its filename is
     w1_therm_read_bin-suspicious-usage-of-flush_signals.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: w1_therm_read_bin: don't call flush_signals()
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>

This can disrupt userspace signal management.

Signed-off-by: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Cc: Roland McGrath <roland@redhat.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/w1/slaves/w1_therm.c |    6 +-----
 1 files changed, 1 insertion(+), 5 deletions(-)

diff -puN drivers/w1/slaves/w1_therm.c~w1_therm_read_bin-suspicious-usage-of-flush_signals drivers/w1/slaves/w1_therm.c
--- a/drivers/w1/slaves/w1_therm.c~w1_therm_read_bin-suspicious-usage-of-flush_signals
+++ a/drivers/w1/slaves/w1_therm.c
@@ -193,11 +193,7 @@ static ssize_t w1_therm_read_bin(struct 
 
 			w1_write_8(dev, W1_CONVERT_TEMP);
 
-			while (tm) {
-				tm = msleep_interruptible(tm);
-				if (signal_pending(current))
-					flush_signals(current);
-			}
+			msleep(tm);
 
 			if (!w1_reset_select_slave(sl)) {
 
_

Patches currently in -mm which might be from johnpol@2ka.mipt.ru are

w1_therm_read_bin-suspicious-usage-of-flush_signals.patch
git-battery.patch
use-menuconfig-objects-connector.patch
use-menuconfig-objects-w1.patch
