From: akpm@linux-foundation.org
Subject: + add-a-new-sysfs_streq-string-comparison-function.patch added to -mm tree
Date: Tue, 29 Apr 2008 12:10:31 -0700
Message-ID: <200804291910.m3TJAVEg004920@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54272 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754599AbYD2TKw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Apr 2008 15:10:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: david-b@pacbell.net, dbrownell@users.sourceforge.net, greg@kroah.com


The patch titled
     Add a new sysfs_streq() string comparison function
has been added to the -mm tree.  Its filename is
     add-a-new-sysfs_streq-string-comparison-function.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Add a new sysfs_streq() string comparison function
From: David Brownell <david-b@pacbell.net>

Add a new sysfs_streq() string comparison function, which ignores
the trailing newlines found in sysfs inputs.  By example:

	sysfs_streq("a", "b")	==> false
	sysfs_streq("a", "a")	==> true
	sysfs_streq("a", "a\n")	==> true
	sysfs_streq("a\n", "a")	==> true

This is intended to simplify parsing of sysfs inputs, letting them
avoid the need to manually strip off newlines from inputs.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/string.h |    2 ++
 lib/string.c           |   27 +++++++++++++++++++++++++++
 2 files changed, 29 insertions(+)

diff -puN include/linux/string.h~add-a-new-sysfs_streq-string-comparison-function include/linux/string.h
--- a/include/linux/string.h~add-a-new-sysfs_streq-string-comparison-function
+++ a/include/linux/string.h
@@ -109,5 +109,7 @@ extern void *kmemdup(const void *src, si
 extern char **argv_split(gfp_t gfp, const char *str, int *argcp);
 extern void argv_free(char **argv);
 
+extern bool sysfs_streq(const char *s1, const char *s2);
+
 #endif
 #endif /* _LINUX_STRING_H_ */
diff -puN lib/string.c~add-a-new-sysfs_streq-string-comparison-function lib/string.c
--- a/lib/string.c~add-a-new-sysfs_streq-string-comparison-function
+++ a/lib/string.c
@@ -493,6 +493,33 @@ char *strsep(char **s, const char *ct)
 EXPORT_SYMBOL(strsep);
 #endif
 
+/**
+ * sysfs_streq - return true if strings are equal, modulo trailing newline
+ * @s1: one string
+ * @s2: another string
+ *
+ * This routine returns true iff two strings are equal, treating both
+ * NUL and newline-then-NUL as equivalent string terminations.  It's
+ * geared for use with sysfs input strings, which generally terminate
+ * with newlines but are compared against values without newlines.
+ */
+bool sysfs_streq(const char *s1, const char *s2)
+{
+	while (*s1 && *s1 == *s2) {
+		s1++;
+		s2++;
+	}
+
+	if (*s1 == *s2)
+		return true;
+	if (!*s1 && *s2 == '\n' && !s2[1])
+		return true;
+	if (*s1 == '\n' && !s1[1] && !*s2)
+		return true;
+	return false;
+}
+EXPORT_SYMBOL(sysfs_streq);
+
 #ifndef __HAVE_ARCH_MEMSET
 /**
  * memset - Fill a region of memory with the given value
_

Patches currently in -mm which might be from david-b@pacbell.net are

origin.patch
remove-duplicated-unlikely-in-is_err.patch
rtc-rtc-rs5c372-smbus-conversion-support.patch
rtc-rtc-rs5c732-add-support-for-ricoh-r2025s-d-rtc.patch
git-acpi.patch
input-add-debouncing-for-generic-gpio-input-device-gpio_keyc.patch
git-mmc.patch
jffs2-summary-allocation-dont-use-vmalloc.patch
fix-gregkh-usb-usb-ohci-port-reset-paranoia-timeout.patch
add-a-new-sysfs_streq-string-comparison-function.patch

