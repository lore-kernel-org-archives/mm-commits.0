From: akpm@linux-foundation.org
Subject: [merged] staging-rtl8192u-use-%pen-to-escape-buffer.patch removed from -mm tree
Date: Tue, 14 Oct 2014 11:23:06 -0700
Message-ID: <543d6a0a.01P5vULm4Ry3HpFs%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44617 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754524AbaJNSXF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 14 Oct 2014 14:23:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andriy.shevchenko@linux.intel.com, gregkh@linuxfoundation.org, joe@perches.com, johannes@sipsolutions.net, linville@tuxdriver.com, mm-commits@vger.kernel.org


The patch titled
     Subject: staging: rtl8192u: use %*pEn to escape buffer
has been removed from the -mm tree.  Its filename was
     staging-rtl8192u-use-%pen-to-escape-buffer.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -2593,25 +2593,13 @@ static inline int ieee80211_get_scans(st
 
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

origin.patch
linux-next.patch

