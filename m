From: akpm@linux-foundation.org
Subject: + staging-rtl8192u-use-%pen-to-escape-buffer.patch added to -mm
 tree
Date: Thu, 28 Aug 2014 14:09:17 -0700
Message-ID: <53ff9a7d.pEhB3yfrSfowF4v3%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f201.google.com ([209.85.220.201]:55531 "EHLO
	mail-vc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751506AbaH1WF4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 Aug 2014 18:05:56 -0400
Received: by mail-vc0-f201.google.com with SMTP id le20so202558vcb.4
        for <mm-commits@vger.kernel.org>; Thu, 28 Aug 2014 15:05:55 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andriy.shevchenko@linux.intel.com, gregkh@linuxfoundation.org, joe@perches.com, johannes@sipsolutions.net, linville@tuxdriver.com, mm-commits@vger.kernel.org


The patch titled
     Subject: staging: rtl8192u: use %*pEn to escape buffer
has been added to the -mm tree.  Its filename is
     staging-rtl8192u-use-%pen-to-escape-buffer.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/staging-rtl8192u-use-%pen-to-escape-buffer.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/staging-rtl8192u-use-%pen-to-escape-buffer.patch

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
Subject: staging: rtl8192u: use %*pEn to escape buffer

Let's use kernel's native specifier to escape a buffer.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: "John W . Linville" <linville@tuxdriver.com>
Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/staging/rtl8192u/ieee80211/ieee80211.h |   14 +-------------
 1 file changed, 1 insertion(+), 13 deletions(-)

diff -puN drivers/staging/rtl8192u/ieee80211/ieee80211.h~staging-rtl8192u-use-%pen-to-escape-buffer drivers/staging/rtl8192u/ieee80211/ieee80211.h
--- a/drivers/staging/rtl8192u/ieee80211/ieee80211.h~staging-rtl8192u-use-%pen-to-escape-buffer
+++ a/drivers/staging/rtl8192u/ieee80211/ieee80211.h
@@ -2576,25 +2576,13 @@ static inline int ieee80211_get_scans(st
 
 static inline const char *escape_essid(const char *essid, u8 essid_len) {
 	static char escaped[IW_ESSID_MAX_SIZE * 2 + 1];
-	const char *s = essid;
-	char *d = escaped;
 
 	if (ieee80211_is_empty_essid(essid, essid_len)) {
 		memcpy(escaped, "<hidden>", sizeof("<hidden>"));
 		return escaped;
 	}
 
-	essid_len = min(essid_len, (u8)IW_ESSID_MAX_SIZE);
-	while (essid_len--) {
-		if (*s == '\0') {
-			*d++ = '\\';
-			*d++ = '0';
-			s++;
-		} else {
-			*d++ = *s++;
-		}
-	}
-	*d = '\0';
+	snprintf(escaped, sizeof(escaped), "%*pEn", essid_len, essid);
 	return escaped;
 }
 
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

