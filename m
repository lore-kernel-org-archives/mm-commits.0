From: akpm@linux-foundation.org
Subject: + wireless-hostap-proc-print-properly-escaped-ssid.patch added to -mm tree
Date: Thu, 28 Aug 2014 14:09:13 -0700
Message-ID: <53ff9a79.1IXTQZT3Bvhnmsfe%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f201.google.com ([209.85.214.201]:61090 "EHLO
	mail-ob0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750894AbaH1VZd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 Aug 2014 17:25:33 -0400
Received: by mail-ob0-f201.google.com with SMTP id va2so402174obc.2
        for <mm-commits@vger.kernel.org>; Thu, 28 Aug 2014 14:25:33 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andriy.shevchenko@linux.intel.com, gregkh@linuxfoundation.org, joe@perches.com, johannes@sipsolutions.net, linville@tuxdriver.com, mm-commits@vger.kernel.org


The patch titled
     Subject: wireless: hostap: proc: print properly escaped SSID
has been added to the -mm tree.  Its filename is
     wireless-hostap-proc-print-properly-escaped-ssid.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/wireless-hostap-proc-print-properly-escaped-ssid.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/wireless-hostap-proc-print-properly-escaped-ssid.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: wireless: hostap: proc: print properly escaped SSID

Instead of substituting non-printable characters by '_' let's print SSID
properly escaped by using recently added %*pE specifier.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: "John W . Linville" <linville@tuxdriver.com>
Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/wireless/hostap/hostap_proc.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN drivers/net/wireless/hostap/hostap_proc.c~wireless-hostap-proc-print-properly-escaped-ssid drivers/net/wireless/hostap/hostap_proc.c
--- a/drivers/net/wireless/hostap/hostap_proc.c~wireless-hostap-proc-print-properly-escaped-ssid
+++ a/drivers/net/wireless/hostap/hostap_proc.c
@@ -181,9 +181,7 @@ static int prism2_bss_list_proc_show(str
 		   bss->bssid, bss->last_update,
 		   bss->count, bss->capab_info);
 
-	for (i = 0; i < bss->ssid_len; i++)
-		seq_putc(m,bss->ssid[i] >= 32 && bss->ssid[i] < 127 ?
-			   bss->ssid[i] : '_');
+	seq_printf(m, "%*pE", bss->ssid_len, bss->ssid);
 
 	seq_putc(m, '\t');
 	for (i = 0; i < bss->ssid_len; i++)
_

Patches currently in -mm which might be from andriy.shevchenko@linux.intel.com are

lib-string_helpers-move-documentation-to-c-file.patch
lib-string_helpers-refactoring-the-test-suite.patch
lib-string_helpers-introduce-string_escape_mem.patch
lib-vsprintf-add-%pe-format-specifier.patch
lib-vsprintf-add-%pe-format-specifier-fix.patch
wireless-libertas-print-esaped-string-via-%pe.patch
wireless-ipw2x00-print-ssid-via-%pe.patch
wireless-hostap-proc-print-properly-escaped-ssid.patch
lib80211-remove-unused-print_ssid.patch
staging-wlan-ng-use-%pehp-to-print-sn.patch
staging-rtl8192e-use-%pen-to-escape-buffer.patch
staging-rtl8192u-use-%pen-to-escape-buffer.patch
linux-next.patch

