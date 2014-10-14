From: akpm@linux-foundation.org
Subject: [merged] lib80211-remove-unused-print_ssid.patch removed from -mm tree
Date: Tue, 14 Oct 2014 11:23:00 -0700
Message-ID: <543d6a04.WW8Y3ywCCAMtoOKb%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44599 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754524AbaJNSW7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 14 Oct 2014 14:22:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andriy.shevchenko@linux.intel.com, gregkh@linuxfoundation.org, joe@perches.com, johannes@sipsolutions.net, linville@tuxdriver.com, mm-commits@vger.kernel.org


The patch titled
     Subject: lib80211: remove unused print_ssid()
has been removed from the -mm tree.  Its filename was
     lib80211-remove-unused-print_ssid.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
