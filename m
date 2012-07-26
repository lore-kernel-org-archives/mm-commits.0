From: akpm@linux-foundation.org
Subject: + dynamic_debug-restore-dev_dbg-netdev_dbg-functionality-reduce-stack-use.patch added to -mm tree
Date: Thu, 26 Jul 2012 13:08:26 -0700
Message-ID: <20120726200827.4FF4F5C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:45029 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752209Ab2GZUIa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 26 Jul 2012 16:08:30 -0400
Received: by eaao12 with SMTP id o12so52328eaa.1
        for <mm-commits@vger.kernel.org>; Thu, 26 Jul 2012 13:08:28 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com, davem@davemloft.net, gregkh@linuxfoundation.org, jbaron@redhat.com, jim.cromie@gmail.com, kay@vrfy.org


The patch titled
     Subject: dynamic_debug: restore dev_dbg/netdev_dbg functionality, reduce stack use
has been added to the -mm tree.  Its filename is
     dynamic_debug-restore-dev_dbg-netdev_dbg-functionality-reduce-stack-use.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: dynamic_debug: restore dev_dbg/netdev_dbg functionality, reduce stack use

commit c4e00daaa9 ("driver-core: extend dev_printk() to pass structured
data") changed __dev_printk and broke dynamic-debug's ability to control
the dynamic prefix of dev_dbg(dev,..).

dynamic_emit_prefix() adds "[tid] module:func:line:" to the output and
those additions got lost.

In addition, the current dynamic debug code uses up to 3 recursion levels
via %pV.  This can consume quite a bit of stack.  Directly call
printk_emit to reduce the recursion by one depth.

These changes include:

o Remove KERN_DEBUG from dynamic_emit_prefix
o Create and use function create_syslog_header to format the syslog
  header for printk_emit uses.
o Call create_syslog_header and neaten __dev_printk
o Call create_syslog_header and printk_emit from dynamic_dev_dbg
o Call create_syslog_header and printk_emit from dynamic_netdev_dbg
o Make __dev_printk and __netdev_printk static not global
o Remove include header declarations of __dev_printk and __netdev_printk
o Remove now unused EXPORT_SYMBOL()s of __dev_printk and __netdev_printk
o Whitespace neatening

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Acked-by: "David S. Miller" <davem@davemloft.net>	[networking parts]
Cc: Jason Baron <jbaron@redhat.com>
Cc: Kay Sievers <kay@vrfy.org>
Cc: Jim Cromie <jim.cromie@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/core.c       |   57 +++++++++++++++++++--------------
 include/linux/device.h    |   11 ++----
 include/linux/netdevice.h |    3 -
 lib/dynamic_debug.c       |   61 ++++++++++++++++++++++++++++--------
 net/core/dev.c            |    5 +-
 5 files changed, 89 insertions(+), 48 deletions(-)

diff -puN drivers/base/core.c~dynamic_debug-restore-dev_dbg-netdev_dbg-functionality-reduce-stack-use drivers/base/core.c
--- a/drivers/base/core.c~dynamic_debug-restore-dev_dbg-netdev_dbg-functionality-reduce-stack-use
+++ a/drivers/base/core.c
@@ -1861,25 +1861,19 @@ void device_shutdown(void)
  */
 
 #ifdef CONFIG_PRINTK
-int __dev_printk(const char *level, const struct device *dev,
-		 struct va_format *vaf)
+int create_syslog_header(const struct device *dev, char *hdr, size_t hdrlen)
 {
-	char dict[128];
-	size_t dictlen = 0;
 	const char *subsys;
-
-	if (!dev)
-		return printk("%s(NULL device *): %pV", level, vaf);
+	size_t pos = 0;
 
 	if (dev->class)
 		subsys = dev->class->name;
 	else if (dev->bus)
 		subsys = dev->bus->name;
 	else
-		goto skip;
+		return 0;
 
-	dictlen += snprintf(dict + dictlen, sizeof(dict) - dictlen,
-			    "SUBSYSTEM=%s", subsys);
+	pos += snprintf(hdr + pos, hdrlen - pos, "SUBSYSTEM=%s", subsys);
 
 	/*
 	 * Add device identifier DEVICE=:
@@ -1895,28 +1889,41 @@ int __dev_printk(const char *level, cons
 			c = 'b';
 		else
 			c = 'c';
-		dictlen++;
-		dictlen += snprintf(dict + dictlen, sizeof(dict) - dictlen,
-				   "DEVICE=%c%u:%u",
-				   c, MAJOR(dev->devt), MINOR(dev->devt));
+		pos++;
+		pos += snprintf(hdr + pos, hdrlen - pos,
+				"DEVICE=%c%u:%u",
+				c, MAJOR(dev->devt), MINOR(dev->devt));
 	} else if (strcmp(subsys, "net") == 0) {
 		struct net_device *net = to_net_dev(dev);
 
-		dictlen++;
-		dictlen += snprintf(dict + dictlen, sizeof(dict) - dictlen,
-				    "DEVICE=n%u", net->ifindex);
+		pos++;
+		pos += snprintf(hdr + pos, hdrlen - pos,
+				"DEVICE=n%u", net->ifindex);
 	} else {
-		dictlen++;
-		dictlen += snprintf(dict + dictlen, sizeof(dict) - dictlen,
-				    "DEVICE=+%s:%s", subsys, dev_name(dev));
+		pos++;
+		pos += snprintf(hdr + pos, hdrlen - pos,
+				"DEVICE=+%s:%s", subsys, dev_name(dev));
 	}
-skip:
-	return printk_emit(0, level[1] - '0',
-			   dictlen ? dict : NULL, dictlen,
+
+	return pos;
+}
+EXPORT_SYMBOL(create_syslog_header);
+
+static int __dev_printk(const char *level, const struct device *dev,
+			struct va_format *vaf)
+{
+	char hdr[128];
+	size_t hdrlen;
+
+	if (!dev)
+		return printk("%s(NULL device *): %pV", level, vaf);
+
+	hdrlen = create_syslog_header(dev, hdr, sizeof(hdr));
+
+	return printk_emit(0, level[1] - '0', hdrlen ? hdr : NULL, hdrlen,
 			   "%s %s: %pV",
 			   dev_driver_string(dev), dev_name(dev), vaf);
 }
-EXPORT_SYMBOL(__dev_printk);
 
 int dev_printk(const char *level, const struct device *dev,
 	       const char *fmt, ...)
@@ -1931,6 +1938,7 @@ int dev_printk(const char *level, const 
 	vaf.va = &args;
 
 	r = __dev_printk(level, dev, &vaf);
+
 	va_end(args);
 
 	return r;
@@ -1950,6 +1958,7 @@ int func(const struct device *dev, const
 	vaf.va = &args;						\
 								\
 	r = __dev_printk(kern_level, dev, &vaf);		\
+								\
 	va_end(args);						\
 								\
 	return r;						\
diff -puN include/linux/device.h~dynamic_debug-restore-dev_dbg-netdev_dbg-functionality-reduce-stack-use include/linux/device.h
--- a/include/linux/device.h~dynamic_debug-restore-dev_dbg-netdev_dbg-functionality-reduce-stack-use
+++ a/include/linux/device.h
@@ -891,12 +891,12 @@ extern const char *dev_driver_string(con
 
 #ifdef CONFIG_PRINTK
 
-extern int __dev_printk(const char *level, const struct device *dev,
-			struct va_format *vaf);
+extern int create_syslog_header(const struct device *dev,
+				char *hdr, size_t hdrlen);
+
 extern __printf(3, 4)
 int dev_printk(const char *level, const struct device *dev,
-	       const char *fmt, ...)
-	;
+	       const char *fmt, ...);
 extern __printf(2, 3)
 int dev_emerg(const struct device *dev, const char *fmt, ...);
 extern __printf(2, 3)
@@ -914,9 +914,6 @@ int _dev_info(const struct device *dev, 
 
 #else
 
-static inline int __dev_printk(const char *level, const struct device *dev,
-			       struct va_format *vaf)
-{ return 0; }
 static inline __printf(3, 4)
 int dev_printk(const char *level, const struct device *dev,
 	       const char *fmt, ...)
diff -puN include/linux/netdevice.h~dynamic_debug-restore-dev_dbg-netdev_dbg-functionality-reduce-stack-use include/linux/netdevice.h
--- a/include/linux/netdevice.h~dynamic_debug-restore-dev_dbg-netdev_dbg-functionality-reduce-stack-use
+++ a/include/linux/netdevice.h
@@ -2715,9 +2715,6 @@ static inline const char *netdev_name(co
 	return dev->name;
 }
 
-extern int __netdev_printk(const char *level, const struct net_device *dev,
-			struct va_format *vaf);
-
 extern __printf(3, 4)
 int netdev_printk(const char *level, const struct net_device *dev,
 		  const char *format, ...);
diff -puN lib/dynamic_debug.c~dynamic_debug-restore-dev_dbg-netdev_dbg-functionality-reduce-stack-use lib/dynamic_debug.c
--- a/lib/dynamic_debug.c~dynamic_debug-restore-dev_dbg-netdev_dbg-functionality-reduce-stack-use
+++ a/lib/dynamic_debug.c
@@ -521,25 +521,23 @@ static char *dynamic_emit_prefix(const s
 	int pos_after_tid;
 	int pos = 0;
 
-	pos += snprintf(buf + pos, remaining(pos), "%s", KERN_DEBUG);
 	if (desc->flags & _DPRINTK_FLAGS_INCL_TID) {
 		if (in_interrupt())
-			pos += snprintf(buf + pos, remaining(pos), "%s ",
-						"<intr>");
+			pos += snprintf(buf + pos, remaining(pos), "<intr> ");
 		else
 			pos += snprintf(buf + pos, remaining(pos), "[%d] ",
-						task_pid_vnr(current));
+					task_pid_vnr(current));
 	}
 	pos_after_tid = pos;
 	if (desc->flags & _DPRINTK_FLAGS_INCL_MODNAME)
 		pos += snprintf(buf + pos, remaining(pos), "%s:",
-					desc->modname);
+				desc->modname);
 	if (desc->flags & _DPRINTK_FLAGS_INCL_FUNCNAME)
 		pos += snprintf(buf + pos, remaining(pos), "%s:",
-					desc->function);
+				desc->function);
 	if (desc->flags & _DPRINTK_FLAGS_INCL_LINENO)
 		pos += snprintf(buf + pos, remaining(pos), "%d:",
-					desc->lineno);
+				desc->lineno);
 	if (pos - pos_after_tid)
 		pos += snprintf(buf + pos, remaining(pos), " ");
 	if (pos >= PREFIX_SIZE)
@@ -559,9 +557,13 @@ int __dynamic_pr_debug(struct _ddebug *d
 	BUG_ON(!fmt);
 
 	va_start(args, fmt);
+
 	vaf.fmt = fmt;
 	vaf.va = &args;
-	res = printk("%s%pV", dynamic_emit_prefix(descriptor, buf), &vaf);
+
+	res = printk(KERN_DEBUG "%s%pV",
+		     dynamic_emit_prefix(descriptor, buf), &vaf);
+
 	va_end(args);
 
 	return res;
@@ -580,9 +582,24 @@ int __dynamic_dev_dbg(struct _ddebug *de
 	BUG_ON(!fmt);
 
 	va_start(args, fmt);
+
 	vaf.fmt = fmt;
 	vaf.va = &args;
-	res = __dev_printk(dynamic_emit_prefix(descriptor, buf), dev, &vaf);
+
+	if (!dev) {
+		res = printk(KERN_DEBUG "(NULL device *): %pV", &vaf);
+	} else {
+		char dict[128];
+		size_t dictlen;
+
+		dictlen = create_syslog_header(dev, dict, sizeof(dict));
+
+		res = printk_emit(0, 7, dictlen ? dict : NULL, dictlen,
+				  "%s%s %s: %pV",
+				  dynamic_emit_prefix(descriptor, buf),
+				  dev_driver_string(dev), dev_name(dev), &vaf);
+	}
+
 	va_end(args);
 
 	return res;
@@ -592,20 +609,40 @@ EXPORT_SYMBOL(__dynamic_dev_dbg);
 #ifdef CONFIG_NET
 
 int __dynamic_netdev_dbg(struct _ddebug *descriptor,
-		      const struct net_device *dev, const char *fmt, ...)
+			 const struct net_device *dev, const char *fmt, ...)
 {
 	struct va_format vaf;
 	va_list args;
 	int res;
-	char buf[PREFIX_SIZE];
 
 	BUG_ON(!descriptor);
 	BUG_ON(!fmt);
 
 	va_start(args, fmt);
+
 	vaf.fmt = fmt;
 	vaf.va = &args;
-	res = __netdev_printk(dynamic_emit_prefix(descriptor, buf), dev, &vaf);
+
+	if (dev && dev->dev.parent) {
+		char buf[PREFIX_SIZE];
+		char dict[128];
+		size_t dictlen;
+
+		dictlen = create_syslog_header(dev->dev.parent,
+					       dict, sizeof(dict));
+
+		res = printk_emit(0, 7, dictlen ? dict : NULL, dictlen,
+				  "%s%s %s: %pV",
+				  dynamic_emit_prefix(descriptor, buf),
+				  dev_driver_string(dev->dev.parent),
+				  netdev_name(dev), &vaf);
+
+	} else if (dev) {
+		res = printk(KERN_DEBUG "%s: %pV", netdev_name(dev), &vaf);
+	} else {
+		res = printk(KERN_DEBUG "(NULL net_device): %pV", &vaf);
+	}
+
 	va_end(args);
 
 	return res;
diff -puN net/core/dev.c~dynamic_debug-restore-dev_dbg-netdev_dbg-functionality-reduce-stack-use net/core/dev.c
--- a/net/core/dev.c~dynamic_debug-restore-dev_dbg-netdev_dbg-functionality-reduce-stack-use
+++ a/net/core/dev.c
@@ -6402,7 +6402,7 @@ const char *netdev_drivername(const stru
 	return empty;
 }
 
-int __netdev_printk(const char *level, const struct net_device *dev,
+static int __netdev_printk(const char *level, const struct net_device *dev,
 			   struct va_format *vaf)
 {
 	int r;
@@ -6417,7 +6417,6 @@ int __netdev_printk(const char *level, c
 
 	return r;
 }
-EXPORT_SYMBOL(__netdev_printk);
 
 int netdev_printk(const char *level, const struct net_device *dev,
 		  const char *format, ...)
@@ -6432,6 +6431,7 @@ int netdev_printk(const char *level, con
 	vaf.va = &args;
 
 	r = __netdev_printk(level, dev, &vaf);
+
 	va_end(args);
 
 	return r;
@@ -6451,6 +6451,7 @@ int func(const struct net_device *dev, c
 	vaf.va = &args;						\
 								\
 	r = __netdev_printk(level, dev, &vaf);			\
+								\
 	va_end(args);						\
 								\
 	return r;						\
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
linux-next.patch
thermal-add-renesas-r-car-thermal-sensor-support.patch
dynamic_debug-restore-dev_dbg-netdev_dbg-functionality-reduce-stack-use.patch
printk-add-generic-functions-to-find-kern_level-headers.patch
printk-add-generic-functions-to-find-kern_level-headers-fix.patch
printk-add-kern_levelsh-to-make-kern_level-available-for-asm-use.patch
arch-remove-direct-definitions-of-kern_level-uses.patch
btrfs-use-printk_get_level-and-printk_skip_level-add-__printf-fix-fallout.patch
btrfs-use-printk_get_level-and-printk_skip_level-add-__printf-fix-fallout-fix.patch
btrfs-use-printk_get_level-and-printk_skip_level-add-__printf-fix-fallout-checkpatch-fixes.patch
sound-use-printk_get_level-and-printk_skip_level.patch
printk-convert-the-format-for-kern_level-to-a-2-byte-pattern.patch
printk-only-look-for-prefix-levels-in-kernel-messages.patch
printk-remove-the-now-unnecessary-c-annotation-for-kern_cont.patch
vsprintf-add-%pmr-for-bluetooth-mac-address.patch
vsprintf-add-%pmr-for-bluetooth-mac-address-fix.patch
vsprintf-add-support-of-%ph.patch
checkpatch-update-alignment-check.patch
checkpatch-test-for-non-standard-signatures.patch
checkpatch-check-usleep_range-arguments.patch
checkpatch-add-check-for-use-of-sizeof-without-parenthesis.patch
checkpatch-add-check-for-use-of-sizeof-without-parenthesis-v2.patch
checkpatch-add-checks-for-do-while-0-macro-misuses.patch

