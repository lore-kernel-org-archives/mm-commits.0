From: akpm@linux-foundation.org
Subject: + mtd-unify-mtd-partition-device-registration.patch added to -mm tree
Date: Fri, 14 Nov 2008 13:41:24 -0800
Message-ID: <200811142141.mAELfOWD002311@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41483 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756759AbYKNVla (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 14 Nov 2008 16:41:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: vapier@gentoo.org, anemo@mba.ocn.ne.jp, dwmw2@infradead.org


The patch titled
     mtd: unify mtd partition/device registration
has been added to the -mm tree.  Its filename is
     mtd-unify-mtd-partition-device-registration.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mtd: unify mtd partition/device registration
From: Mike Frysinger <vapier@gentoo.org>

Rather than having every map/mtd driver doing the same sequence of
registering partitions and/or devices, implement common parse_mtd().

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Cc: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mtd/mtdcore.c   |   37 +++++++++++++++++++++++++++++++++++++
 include/linux/mtd/mtd.h |    3 +++
 2 files changed, 40 insertions(+)

diff -puN drivers/mtd/mtdcore.c~mtd-unify-mtd-partition-device-registration drivers/mtd/mtdcore.c
--- a/drivers/mtd/mtdcore.c~mtd-unify-mtd-partition-device-registration
+++ a/drivers/mtd/mtdcore.c
@@ -292,6 +292,43 @@ void put_mtd_device(struct mtd_info *mtd
 	module_put(mtd->owner);
 }
 
+#include <linux/mtd/partitions.h>
+
+/**
+ *	parse_mtd - add partitions / devices
+ *
+ *	If partitioning support is enabled, attempt to call parse_mtd_partitions()
+ *	and add_mtd_partitions() with all available parsers.  Otherwise just add
+ *	the MTD device.
+ */
+
+int parse_mtd(struct mtd_info *mtd, const char **probe_types,
+              struct mtd_partition *parts, int nr_parts)
+{
+#ifdef CONFIG_MTD_PARTITIONS
+	const char *default_part_probe_types[] = {
+		"cmdlinepart",
+		"RedBoot",
+		NULL
+	};
+	int ret;
+
+	if (!probe_types)
+		probe_types = default_part_probe_types;
+
+	ret = parse_mtd_partitions(mtd, probe_types, &parts, 0);
+	if (ret > 0) {
+		ret = add_mtd_partitions(mtd, parts, ret);
+		kfree(parts);
+		return ret;
+	} else if (nr_parts)
+		return add_mtd_partitions(mtd, parts, nr_parts);
+#endif
+
+	return add_mtd_device(mtd);
+}
+EXPORT_SYMBOL(parse_mtd);
+
 /* default_mtd_writev - default mtd writev method for MTD devices that
  *			don't implement their own
  */
diff -puN include/linux/mtd/mtd.h~mtd-unify-mtd-partition-device-registration include/linux/mtd/mtd.h
--- a/include/linux/mtd/mtd.h~mtd-unify-mtd-partition-device-registration
+++ a/include/linux/mtd/mtd.h
@@ -232,6 +232,9 @@ extern struct mtd_info *get_mtd_device_n
 
 extern void put_mtd_device(struct mtd_info *mtd);
 
+struct mtd_partition;
+int parse_mtd(struct mtd_info *mtd, const char **probe_types,
+              struct mtd_partition *parts, int nr_parts);
 
 struct mtd_notifier {
 	void (*add)(struct mtd_info *mtd);
_

Patches currently in -mm which might be from vapier@gentoo.org are

origin.patch
linux-next.patch
linux-timexh-cleanup-for-userspace.patch
m25p80-fix-detection-of-spi-parts.patch
m25p80-fix-detection-of-m25p16-flashes.patch
mtd-unify-mtd-partition-device-registration.patch
mtd-unify-mtd-partition-device-registration-fix.patch
mtd-physmap-use-parse_mtd.patch
mtd-bfin-async-flash-use-parse_mtd.patch
linux-serialh-touchup-for-userspace.patch

