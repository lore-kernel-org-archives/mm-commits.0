From: akpm@linux-foundation.org
Subject: + lib80211-remove-unused-print_ssid.patch added to -mm tree
Date: Thu, 28 Aug 2014 14:09:14 -0700
Message-ID: <53ff9a7a.lt5N2Iaf7ZE4j7DQ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:41294 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750894AbaH1VZf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 Aug 2014 17:25:35 -0400
Received: by mail-qa0-f74.google.com with SMTP id j15so267323qaq.3
        for <mm-commits@vger.kernel.org>; Thu, 28 Aug 2014 14:25:34 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andriy.shevchenko@linux.intel.com, gregkh@linuxfoundation.org, joe@perches.com, johannes@sipsolutions.net, linville@tuxdriver.com, mm-commits@vger.kernel.org


The patch titled
     Subject: lib80211: remove unused print_ssid()
has been added to the -mm tree.  Its filename is
     lib80211-remove-unused-print_ssid.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib80211-remove-unused-print_ssid.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib80211-remove-unused-print_ssid.patch

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
Subject: lib80211: remove unused print_ssid()

In kernel we have %*pE specifier to print an escaped buffer.  All users
now switched to that approach.

This fixes a bug as well.  The current implementation wrongly prints octal
numbers: only two first digits are used in case when 3 are required and
the rest of the string ends up cut off.

Additionally by default the \f, \v, \a, and \e are escaped to their
alphabetic representation.  It's safe to do since it is currently used for
messaging only.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: "John W . Linville" <linville@tuxdriver.com>
Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/net/lib80211.h  |    5 -----
 net/wireless/lib80211.c |   32 --------------------------------
 2 files changed, 37 deletions(-)

diff -puN include/net/lib80211.h~lib80211-remove-unused-print_ssid include/net/lib80211.h
--- a/include/net/lib80211.h~lib80211-remove-unused-print_ssid
+++ a/include/net/lib80211.h
@@ -32,11 +32,6 @@
 #include <linux/timer.h>
 #include <linux/seq_file.h>
 
-/* print_ssid() is intended to be used in debug (and possibly error)
- * messages. It should never be used for passing ssid to user space. */
-const char *print_ssid(char *buf, const char *ssid, u8 ssid_len);
-#define DECLARE_SSID_BUF(var) char var[IEEE80211_MAX_SSID_LEN * 4 + 1] __maybe_unused
-
 #define NUM_WEP_KEYS	4
 
 enum {
diff -puN net/wireless/lib80211.c~lib80211-remove-unused-print_ssid net/wireless/lib80211.c
--- a/net/wireless/lib80211.c~lib80211-remove-unused-print_ssid
+++ a/net/wireless/lib80211.c
@@ -46,38 +46,6 @@ static void lib80211_crypt_deinit_entrie
 static void lib80211_crypt_quiescing(struct lib80211_crypt_info *info);
 static void lib80211_crypt_deinit_handler(unsigned long data);
 
-const char *print_ssid(char *buf, const char *ssid, u8 ssid_len)
-{
-	const char *s = ssid;
-	char *d = buf;
-
-	ssid_len = min_t(u8, ssid_len, IEEE80211_MAX_SSID_LEN);
-	while (ssid_len--) {
-		if (isprint(*s)) {
-			*d++ = *s++;
-			continue;
-		}
-
-		*d++ = '\\';
-		if (*s == '\0')
-			*d++ = '0';
-		else if (*s == '\n')
-			*d++ = 'n';
-		else if (*s == '\r')
-			*d++ = 'r';
-		else if (*s == '\t')
-			*d++ = 't';
-		else if (*s == '\\')
-			*d++ = '\\';
-		else
-			d += snprintf(d, 3, "%03o", *s);
-		s++;
-	}
-	*d = '\0';
-	return buf;
-}
-EXPORT_SYMBOL(print_ssid);
