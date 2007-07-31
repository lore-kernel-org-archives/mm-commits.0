From: akpm@linux-foundation.org
Subject: + introduce-strtol_check_range.patch added to -mm tree
Date: Tue, 31 Jul 2007 12:02:28 -0700
Message-ID: <200707311902.l6VJ2Sf6017367@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60214 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933607AbXGaTDP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 31 Jul 2007 15:03:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: satyam@infradead.org


The patch titled
     Introduce strtol_check_range()
has been added to the -mm tree.  Its filename is
     introduce-strtol_check_range.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Introduce strtol_check_range()
From: Satyam Sharma <satyam@infradead.org>

Callers (especially "store" functions for sysfs or configfs attributes)
that want to convert an input string to a number may often also want to
check for simple input sanity or allowable range.  strtol10_check_range()
of netconsole does this, so extract it out into lib/vsprintf.c, make it
generic w.r.t.  base, and export it to the rest of the kernel and modules.

Signed-off-by: Satyam Sharma <satyam@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/netconsole.c |   46 +++++++++----------------------------
 include/linux/kernel.h   |    1 
 lib/vsprintf.c           |   30 ++++++++++++++++++++++++
 3 files changed, 43 insertions(+), 34 deletions(-)

diff -puN drivers/net/netconsole.c~introduce-strtol_check_range drivers/net/netconsole.c
--- a/drivers/net/netconsole.c~introduce-strtol_check_range
+++ a/drivers/net/netconsole.c
@@ -242,34 +242,6 @@ static struct netconsole_target *to_targ
 }
 
 /*
- * Wrapper over simple_strtol (base 10) with sanity and range checking.
- * We return (signed) long only because we may want to return errors.
- * Do not use this to convert numbers that are allowed to be negative.
- */
-static long strtol10_check_range(const char *cp, long min, long max)
-{
-	long ret;
-	char *p = (char *) cp;
-
-	WARN_ON(min < 0);
-	WARN_ON(max < min);
-
-	ret = simple_strtol(p, &p, 10);
-
-	if (*p && (*p != '\n')) {
-		printk(KERN_ERR "netconsole: invalid input\n");
-		return -EINVAL;
-	}
-	if ((ret < min) || (ret > max)) {
-		printk(KERN_ERR "netconsole: input %ld must be between "
-				"%ld and %ld\n", ret, min, max);
-		return -EINVAL;
-	}
-
-	return ret;
-}
-
-/*
  * Attribute operations for netconsole_target.
  */
 
@@ -335,9 +307,11 @@ static ssize_t store_enabled(struct netc
 	int err;
 	long enabled;
 
-	enabled = strtol10_check_range(buf, 0, 1);
-	if (enabled < 0)
+	enabled = strtol_check_range(buf, 0, 1, 10);
+	if (enabled < 0) {
+		printk(KERN_ERR "netconsole: invalid input\n");
 		return enabled;
+	}
 
 	if (enabled) {	/* 1 */
 
@@ -398,9 +372,11 @@ static ssize_t store_local_port(struct n
 		return -EINVAL;
 	}
 
-	local_port = strtol10_check_range(buf, 0, U16_MAX);
-	if (local_port < 0)
+	local_port = strtol_check_range(buf, 0, U16_MAX, 10);
+	if (local_port < 0) {
+		printk(KERN_ERR "netconsole: invalid input\n");
 		return local_port;
+	}
 
 	nt->np.local_port = local_port;
 
@@ -420,9 +396,11 @@ static ssize_t store_remote_port(struct 
 		return -EINVAL;
 	}
 
-	remote_port = strtol10_check_range(buf, 0, U16_MAX);
-	if (remote_port < 0)
+	remote_port = strtol_check_range(buf, 0, U16_MAX, 10);
+	if (remote_port < 0) {
+		printk(KERN_ERR "netconsole: invalid input\n");
 		return remote_port;
+	}
 
 	nt->np.remote_port = remote_port;
 
diff -puN include/linux/kernel.h~introduce-strtol_check_range include/linux/kernel.h
--- a/include/linux/kernel.h~introduce-strtol_check_range
+++ a/include/linux/kernel.h
@@ -121,6 +121,7 @@ extern unsigned long simple_strtoul(cons
 extern long simple_strtol(const char *,char **,unsigned int);
 extern unsigned long long simple_strtoull(const char *,char **,unsigned int);
 extern long long simple_strtoll(const char *,char **,unsigned int);
+extern long strtol_check_range(const char *,long,long,unsigned int);
 extern int sprintf(char * buf, const char * fmt, ...)
 	__attribute__ ((format (printf, 2, 3)));
 extern int vsprintf(char *buf, const char *, va_list)
diff -puN lib/vsprintf.c~introduce-strtol_check_range lib/vsprintf.c
--- a/lib/vsprintf.c~introduce-strtol_check_range
+++ a/lib/vsprintf.c
@@ -126,6 +126,36 @@ long long simple_strtoll(const char *cp,
 	return simple_strtoull(cp,endp,base);
 }
 
+/**
+ * strtol_check_range - wrapper over simple_strtol with input and range checking
+ * @cp: The start of the string
+ * @min: Minimum value allowed
+ * @max: Maximum value allowed
+ * @base: The number base to use
+ *
+ * We return (signed) long only because we may want to return errors.
+ * Do not use this to convert numbers that are allowed to be negative.
+ */
+long strtol_check_range(const char *cp, long min, long max, unsigned int base)
+{
+	long ret;
+	char *p = (char *) cp;
+
+	WARN_ON(min < 0);
+	WARN_ON(max < min);
+
+	ret = simple_strtol(p, &p, base);
+
+	if (*p && (*p != '\n'))
+		return -EINVAL;
+	if ((ret < min) || (ret > max))
+		return -EINVAL;
+
+	return ret;
+}
+
+EXPORT_SYMBOL(strtol_check_range);
+
 static int skip_atoi(const char **s)
 {
 	int i=0;
_

Patches currently in -mm which might be from satyam@infradead.org are

fix-a-typo-in-documentation-keystxt.patch
netconsole-cleanups-codingstyle-prettyfication.patch
netconsole-remove-bogus-check.patch
netconsole-simplify-boot-module-option-setup-logic.patch
netconsole-use-netif_running-in-write_msg.patch
netconsole-add-some-useful-tips-to-documentation.patch
netconsole-introduce-netconsole_target.patch
netconsole-introduce-netconsole_netdev_notifier.patch
netconsole-support-multiple-logging-targets.patch
netconsole-support-dynamic-reconfiguration-using-configfs.patch
introduce-u16_max-and-u32_max.patch
introduce-u16_max-and-u32_max-fix.patch
introduce-strtol_check_range.patch
introduce-strtol_check_range-fix.patch
use-mutex-instead-of-semaphore-in-the-onstream-scsi-tape-driver.patch
use-mutex-instead-of-semaphore-in-the-scsi-tape-driver.patch
use-mutex-instead-of-semaphore-in-the-host-ap-driver.patch
