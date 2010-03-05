From: akpm@linux-foundation.org
Subject: [failures] deviceh-drivers-base-corec-convert-dev_level-macros-to-functions.patch removed from -mm tree
Date: Thu, 04 Mar 2010 16:30:33 -0800
Message-ID: <201003050056.o250ugMA007817@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40438 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756643Ab0CEA4r (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 4 Mar 2010 19:56:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, greg@kroah.com, kay.sievers@vrfy.org, nick@nick-andrew.net, torvalds@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     device.h, drivers/base/core.c: convert dev_<level> macros to functions
has been removed from the -mm tree.  Its filename was
     deviceh-drivers-base-corec-convert-dev_level-macros-to-functions.patch

This patch was dropped because it had testing failures

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: device.h, drivers/base/core.c: convert dev_<level> macros to functions
From: Joe Perches <joe@perches.com>

Save ~60k in a defconfig

Use %pV and struct va_format
Format arguments are verified before printk

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Nick Andrew <nick@nick-andrew.net>
Cc: Greg KH <greg@kroah.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/core.c    |  124 +++++++++++++++++++++++++++++++++++++++
 include/linux/device.h |  102 +++++++++++++++++++++++---------
 2 files changed, 200 insertions(+), 26 deletions(-)

diff -puN drivers/base/core.c~deviceh-drivers-base-corec-convert-dev_level-macros-to-functions drivers/base/core.c
--- a/drivers/base/core.c~deviceh-drivers-base-corec-convert-dev_level-macros-to-functions
+++ a/drivers/base/core.c
@@ -1742,3 +1742,127 @@ void device_shutdown(void)
 	}
 	async_synchronize_full();
 }
+
+/*
+ * Device logging functions
+ */
+
+#ifdef CONFIG_PRINTK
+
+static int __dev_printk(const char *level, const struct device *dev,
+			const char *fmt, va_list args)
+{
+	struct va_format vaf;
+
+	vaf.fmt = fmt;
+	vaf.va = &args;
+	return printk("%s%s %s: %pV",
+		      level, dev_driver_string(dev), dev_name(dev), &vaf);
+}
+
+int dev_printk(const char *level, const struct device *dev,
+	       const char *fmt, ...)
+{
+	int r;
+	va_list args;
+
+	va_start(args, fmt);
+	r = __dev_printk(level, dev, fmt, args);
+	va_end(args);
+
+	return r;
+}
+EXPORT_SYMBOL(dev_printk);
+
+int dev_emerg(const struct device *dev, const char *fmt, ...)
+{
+	int r;
+	va_list args;
+
+	va_start(args, fmt);
+	r = __dev_printk(KERN_EMERG, dev, fmt, args);
+	va_end(args);
+
+	return r;
+}
+EXPORT_SYMBOL(dev_emerg);
+
+int dev_alert(const struct device *dev, const char *fmt, ...)
+{
+	int r;
+	va_list args;
+
+	va_start(args, fmt);
+	r = __dev_printk(KERN_ALERT, dev, fmt, args);
+	va_end(args);
+
+	return r;
+}
+EXPORT_SYMBOL(dev_alert);
+
+int dev_crit(const struct device *dev, const char *fmt, ...)
+{
+	int r;
+	va_list args;
+
+	va_start(args, fmt);
+	r = __dev_printk(KERN_CRIT, dev, fmt, args);
+	va_end(args);
+
+	return r;
+}
+EXPORT_SYMBOL(dev_crit);
+
+int dev_err(const struct device *dev, const char *fmt, ...)
+{
+	int r;
+	va_list args;
+
+	va_start(args, fmt);
+	r = __dev_printk(KERN_ERR, dev, fmt, args);
+	va_end(args);
+
+	return r;
+}
+EXPORT_SYMBOL(dev_err);
+
+int dev_warn(const struct device *dev, const char *fmt, ...)
+{
+	int r;
+	va_list args;
+
+	va_start(args, fmt);
+	r = __dev_printk(KERN_WARNING, dev, fmt, args);
+	va_end(args);
+
+	return r;
+}
+EXPORT_SYMBOL(dev_warn);
+
+int dev_notice(const struct device *dev, const char *fmt, ...)
+{
+	int r;
+	va_list args;
+
+	va_start(args, fmt);
+	r = __dev_printk(KERN_NOTICE, dev, fmt, args);
+	va_end(args);
+
+	return r;
+}
+EXPORT_SYMBOL(dev_notice);
+
+int dev_info(const struct device *dev, const char *fmt, ...)
+{
+	int r;
+	va_list args;
+
+	va_start(args, fmt);
+	r = __dev_printk(KERN_INFO, dev, fmt, args);
+	va_end(args);
+
+	return r;
+}
+EXPORT_SYMBOL(dev_info);
+
+#endif
diff -puN include/linux/device.h~deviceh-drivers-base-corec-convert-dev_level-macros-to-functions include/linux/device.h
--- a/include/linux/device.h~deviceh-drivers-base-corec-convert-dev_level-macros-to-functions
+++ a/include/linux/device.h
@@ -623,43 +623,93 @@ extern void sysdev_shutdown(void);
 
 /* debugging and troubleshooting/diagnostic helpers. */
 extern const char *dev_driver_string(const struct device *dev);
-#define dev_printk(level, dev, format, arg...)	\
-	printk(level "%s %s: " format , dev_driver_string(dev) , \
-	       dev_name(dev) , ## arg)
-
-#define dev_emerg(dev, format, arg...)		\
-	dev_printk(KERN_EMERG , dev , format , ## arg)
-#define dev_alert(dev, format, arg...)		\
-	dev_printk(KERN_ALERT , dev , format , ## arg)
-#define dev_crit(dev, format, arg...)		\
-	dev_printk(KERN_CRIT , dev , format , ## arg)
-#define dev_err(dev, format, arg...)		\
-	dev_printk(KERN_ERR , dev , format , ## arg)
-#define dev_warn(dev, format, arg...)		\
-	dev_printk(KERN_WARNING , dev , format , ## arg)
-#define dev_notice(dev, format, arg...)		\
-	dev_printk(KERN_NOTICE , dev , format , ## arg)
-#define dev_info(dev, format, arg...)		\
-	dev_printk(KERN_INFO , dev , format , ## arg)
+
+#ifdef CONFIG_PRINTK
+
+extern int dev_printk(const char *level, const struct device *dev,
+		      const char *fmt, ...)
+	__attribute__ ((format (printf, 3, 4)));
+extern int dev_emerg(const struct device *dev, const char *fmt, ...)
+	__attribute__ ((format (printf, 2, 3)));
+extern int dev_alert(const struct device *dev, const char *fmt, ...)
+	__attribute__ ((format (printf, 2, 3)));
+extern int dev_crit(const struct device *dev, const char *fmt, ...)
+	__attribute__ ((format (printf, 2, 3)));
+extern int dev_err(const struct device *dev, const char *fmt, ...)
+	__attribute__ ((format (printf, 2, 3)));
+extern int dev_warn(const struct device *dev, const char *fmt, ...)
+	__attribute__ ((format (printf, 2, 3)));
+extern int dev_notice(const struct device *dev, const char *fmt, ...)
+	__attribute__ ((format (printf, 2, 3)));
+extern int dev_info(const struct device *dev, const char *fmt, ...)
+	__attribute__ ((format (printf, 2, 3)));
+
+#else
+
+static inline int dev_printk(const char *level, const struct device *dev,
+		      const char *fmt, ...)
+	__attribute__ ((format (printf, 3, 4)));
+static inline int dev_printk(const char *level, const struct device *dev,
+		      const char *fmt, ...)
+	 { return 0; }
+
+static inline int dev_emerg(const struct device *dev, const char *s, ...)
+	__attribute__ ((format (printf, 2, 3)));
+static inline int dev_emerg(const struct device *dev, const char *s, ...)
+	{ return 0; }
+static inline int dev_crit(const struct device *dev, const char *s, ...)
+	__attribute__ ((format (printf, 2, 3)));
+static inline int dev_crit(const struct device *dev, const char *s, ...)
+	{ return 0; }
+static inline int dev_alert(const struct device *dev, const char *s, ...)
+	__attribute__ ((format (printf, 2, 3)));
+static inline int dev_alert(const struct device *dev, const char *s, ...)
+	{ return 0; }
+static inline int dev_err(const struct device *dev, const char *s, ...)
+	__attribute__ ((format (printf, 2, 3)));
+static inline int dev_err(const struct device *dev, const char *s, ...)
+	{ return 0; }
+static inline int dev_warn(const struct device *dev, const char *s, ...)
+	__attribute__ ((format (printf, 2, 3)));
+static inline int dev_warn(const struct device *dev, const char *s, ...)
+	{ return 0; }
+static inline int dev_notice(const struct device *dev, const char *s, ...)
+	__attribute__ ((format (printf, 2, 3)));
+static inline int dev_notice(const struct device *dev, const char *s, ...)
+	{ return 0; }
+static inline int dev_info(const struct device *dev, const char *s, ...)
+	__attribute__ ((format (printf, 2, 3)));
+static inline int dev_info(const struct device *dev, const char *s, ...)
+	{ return 0; }
+
+#endif
 
 #if defined(DEBUG)
 #define dev_dbg(dev, format, arg...)		\
-	dev_printk(KERN_DEBUG , dev , format , ## arg)
+	dev_printk(KERN_DEBUG, dev, format, ##arg)
 #elif defined(CONFIG_DYNAMIC_DEBUG)
-#define dev_dbg(dev, format, ...) do { \
+#define dev_dbg(dev, format, ...)		     \
+do {						     \
 	dynamic_dev_dbg(dev, format, ##__VA_ARGS__); \
-	} while (0)
+} while (0)
 #else
-#define dev_dbg(dev, format, arg...)		\
-	({ if (0) dev_printk(KERN_DEBUG, dev, format, ##arg); 0; })
+#define dev_dbg(dev, format, arg...)				\
+({								\
+	if (0)							\
+		dev_printk(KERN_DEBUG, dev, format, ##arg);	\
+	0;							\
+})
 #endif
 
 #ifdef VERBOSE_DEBUG
 #define dev_vdbg	dev_dbg
 #else
-
-#define dev_vdbg(dev, format, arg...)		\
-	({ if (0) dev_printk(KERN_DEBUG, dev, format, ##arg); 0; })
+#define dev_vdbg(dev, format, arg...)				\
+({								\
+	if (0)							\
+		dev_printk(KERN_DEBUG, dev, format, ##arg);	\
+	0;							\
+})
 #endif
 
 /*
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
linux-next.patch
drivers-gpu-drm-i915-intel_biosc-fix-continuation-line-formats.patch
net-sunrpc-remove-uses-of-nipquad-use-%pi4.patch
fs-ocfs2-cluster-tcpc-remove-use-of-nipquad-use-%pi4.patch
drivers-scsi-correct-the-size-argument-to-kmalloc.patch
drivers-scsi-qla2xxx-qla_osc-fix-continuation-line-formats.patch
drivers-staging-fix-continuation-line-formats.patch
drivers-block-floppyc-convert-some-include-asm-to-include-linux.patch
drivers-block-floppyc-define-space-and-column-neatening.patch
drivers-block-floppyc-use-pr_level.patch
drivers-block-floppyc-remove-unnecessary-braces.patch
drivers-block-floppyc-remove-used-once-check_ready-macro.patch
drivers-block-floppyc-hoist-assigns-from-ifs-neatening.patch
drivers-block-floppyc-remove-last_out-macro.patch
drivers-block-floppyc-comment-neatening-and-remove-naked.patch
drivers-block-floppyc-remove-clearstruct-macro-use-memset.patch
drivers-block-floppyc-indent-a-comment.patch
drivers-block-floppyc-remove-in-out-macros-indent-switch-case.patch
drivers-block-floppyc-remove-a-few-spaces-from-function-casts.patch
drivers-block-floppyc-remove-macro-lock_fdc.patch
drivers-block-floppyc-add-debug_dcl-macro.patch
drivers-block-floppyc-remove-clearf-setf-and-testf-macros.patch
drivers-block-floppyc-remove-most-uses-of-call-and-ecall-macros.patch
drivers-block-floppyc-remove-copyin-copyout-and-ecall-macros.patch
drivers-block-floppyc-remove-macros-call-wait-and-iwait.patch
drivers-block-floppyc-convert-int-1-0-to-bool-true-false.patch
drivers-block-floppyc-move-leading-and-to-preceding-line.patch
drivers-block-floppyc-remove-define-device_name-floppy.patch
drivers-block-floppyc-convert-int-initialising-to-bool-initialized.patch
drivers-block-floppyc-add-function-is_ready_state.patch
drivers-block-floppyc-remove-unnecessary-return-and-braces.patch
drivers-block-floppyc-remove-repeat-macro.patch
drivers-block-floppyc-unclutter-redo_fd_request-logic.patch
drivers-block-floppyc-remove-unnecessary-argument-from-reschedule_timeout.patch
drivers-block-floppyc-remove-define-floppy_sanity_check.patch
drivers-block-floppyc-dprint-neatening.patch
drivers-block-floppyc-use-__func__-where-appropriate.patch
drivers-block-floppyc-use-%pf-in-logging-messages.patch
drivers-block-floppyc-remove-some-unnecessary-casting.patch
drivers-block-floppyc-convert-raw_cmd_copyin-from-while1-to-label-goto.patch
drivers-block-floppyc-add-__func__-to-debugt.patch
drivers-block-floppyc-remove-obfuscating-code2size-macro.patch
drivers-block-floppyc-remove-misleading-used-once-fd_ioctl_allowed-macro.patch
drivers-block-floppyc-remove-unnecessary-casting-in-fd_ioctl.patch
deviceh-drivers-base-corec-convert-dev_level-macros-to-functions.patch
scripts-get_maintainerpl-add-file-emails-find-embedded-email-addresses.patch
scripts-get_maintainerpl-add-file-emails-find-embedded-email-addresses-v2.patch
scripts-get_maintainerpl-add-sections-print-entire-matched-subsystem.patch
scripts-get_maintainerpl-change-sections-to-print-in-the-same-style-as-maintainers.patch
scripts-get_maintainerpl-add-ability-to-read-from-stdin.patch
get_maintainer-fix-perlcritic-warnings.patch
get_maintainer-quote-email-address-with-period.patch
scripts-get_maintainerpl-fix-possible-infinite-loop.patch
maintainers-remove-amd-geode-f-arch-x86-kernel-geode_32c.patch
maintainers-remove-hayes-esp-serial-driver.patch
maintainers-update-performance-events-f-patterns.patch
maintainers-starmode-radio-ip-strip-moved-to-staging.patch
maintainers-wavelan-moved-to-staging.patch
maintainers-document-and-add-q-patchwork-queue-entries.patch
lib-stringc-simplify-stricmp.patch
lib-stringc-simplify-strnstr.patch
scripts-checkpatchpl-add-warn-on-sizeof.patch
checkpatchpl-allow-80-char-lines-for-logging-functions-not-just-printk.patch
checkpatch-warn-on-unnecessary-spaces-before-quoted-newlines.patch
drivers-hwmon-vt8231c-fix-continuation-line-formats.patch
drivers-video-via-fix-continuation-line-formats.patch

