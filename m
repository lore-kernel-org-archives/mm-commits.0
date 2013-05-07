From: akpm@linux-foundation.org
Subject: [merged] staging-speakup-remove-custom-string_unescape_any_inplace.patch removed from -mm tree
Date: Tue, 07 May 2013 10:47:47 -0700
Message-ID: <20130507174747.84FB531C1EC@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qe0-f73.google.com ([209.85.128.73]:45936 "EHLO
	mail-qe0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756141Ab3EGRrs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 May 2013 13:47:48 -0400
Received: by mail-qe0-f73.google.com with SMTP id a11so85199qen.0
        for <mm-commits@vger.kernel.org>; Tue, 07 May 2013 10:47:48 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andriy.shevchenko@linux.intel.com, chris@the-brannons.com, gregkh@linuxfoundation.org, kirk@braille.uwo.ca, samuel.thibault@ens-lyon.org, w.d.hubbs@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: staging: speakup: remove custom string_unescape_any_inplace
has been removed from the -mm tree.  Its filename was
     staging-speakup-remove-custom-string_unescape_any_inplace.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: staging: speakup: remove custom string_unescape_any_inplace

There is generic implementation of the function to unescape strings.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Samuel Thibault <samuel.thibault@ens-lyon.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: William Hubbs <w.d.hubbs@gmail.com>
Cc: Chris Brannon <chris@the-brannons.com>
Cc: Kirk Reiser <kirk@braille.uwo.ca>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/staging/speakup/kobjects.c    |    6 ++-
 drivers/staging/speakup/speakup.h     |    1 
 drivers/staging/speakup/varhandlers.c |   46 ------------------------
 3 files changed, 4 insertions(+), 49 deletions(-)

diff -puN drivers/staging/speakup/kobjects.c~staging-speakup-remove-custom-string_unescape_any_inplace drivers/staging/speakup/kobjects.c
--- a/drivers/staging/speakup/kobjects.c~staging-speakup-remove-custom-string_unescape_any_inplace
+++ a/drivers/staging/speakup/kobjects.c
@@ -15,6 +15,7 @@
 #include <linux/kernel.h>
 #include <linux/kobject.h>
 #include <linux/string.h>
+#include <linux/string_helpers.h>
 #include <linux/sysfs.h>
 #include <linux/ctype.h>
 
@@ -417,7 +418,7 @@ static ssize_t synth_direct_store(struct
 		bytes = min_t(size_t, len, 250);
 		strncpy(tmp, ptr, bytes);
 		tmp[bytes] = '\0';
-		spk_xlate(tmp);
+		string_unescape_any_inplace(tmp);
 		synth_printf("%s", tmp);
 		ptr += bytes;
 		len -= bytes;
@@ -605,7 +606,8 @@ ssize_t spk_var_store(struct kobject *ko
 	if (param->data == NULL)
 		return 0;
 	ret = 0;
-	cp = spk_xlate((char *) buf);
+	cp = (char *)buf;
+	string_unescape_any_inplace(cp);
 
 	spk_lock(flags);
 	switch (param->var_type) {
diff -puN drivers/staging/speakup/speakup.h~staging-speakup-remove-custom-string_unescape_any_inplace drivers/staging/speakup/speakup.h
--- a/drivers/staging/speakup/speakup.h~staging-speakup-remove-custom-string_unescape_any_inplace
+++ a/drivers/staging/speakup/speakup.h
@@ -54,7 +54,6 @@ void spk_get_index_count(int *linecount,
 extern int spk_set_key_info(const u_char *key_info, u_char *k_buffer);
 extern char *spk_strlwr(char *s);
 extern char *spk_s2uchar(char *start, char *dest);
-extern char *spk_xlate(char *s);
 extern int speakup_kobj_init(void);
 extern void speakup_kobj_exit(void);
 extern int spk_chartab_get_value(char *keyword);
diff -puN drivers/staging/speakup/varhandlers.c~staging-speakup-remove-custom-string_unescape_any_inplace drivers/staging/speakup/varhandlers.c
--- a/drivers/staging/speakup/varhandlers.c~staging-speakup-remove-custom-string_unescape_any_inplace
+++ a/drivers/staging/speakup/varhandlers.c
@@ -328,49 +328,3 @@ char *spk_s2uchar(char *start, char *des
 	*dest = (u_char)val;
 	return start;
 }
-
-char *spk_xlate(char *s)
-{
-	static const char finds[] = "nrtvafe";
-	static const char subs[] = "\n\r\t\013\001\014\033";
-	static const char hx[] = "0123456789abcdefABCDEF";
-	char *p = s, *p1, *p2, c;
-	int num;
-	while ((p = strchr(p, '\\'))) {
-		p1 = p+1;
-		p2 = strchr(finds, *p1);
-		if (p2) {
-			*p++ = subs[p2-finds];
-			p1++;
-		} else if (*p1 >= '0' && *p1 <= '7') {
-			num = (*p1++)&7;
-			while (num < 32 && *p1 >= '0' && *p1 <= '7') {
-				num <<= 3;
-				num += (*p1++)&7;
-			}
-			*p++ = num;
-		} else if (*p1 == 'x' &&
-				strchr(hx, p1[1]) && strchr(hx, p1[2])) {
-			p1++;
-			c = *p1++;
-			if (c > '9')
-				c = (c - '7') & 0x0f;
-			else
-				c -= '0';
-			num = c << 4;
-			c = *p1++;
-			if (c > '9')
-				c = (c-'7')&0x0f;
-			else
-				c -= '0';
-			num += c;
-			*p++ = num;
-		} else
-			*p++ = *p1++;
-		p2 = p;
-		while (*p1)
-			*p2++ = *p1++;
-		*p2 = '\0';
-	}
-	return s;
-}
_

Patches currently in -mm which might be from andriy.shevchenko@linux.intel.com are

origin.patch
linux-next.patch

