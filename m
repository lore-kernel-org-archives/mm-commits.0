From: akpm@linux-foundation.org
Subject: [merged]
 arch-arm-mach-omap2-replace-strict_strto-with-kstrto.patch removed from -mm tree
Date: Tue, 12 Aug 2014 12:42:02 -0700
Message-ID: <53ea6e0a./kNCq8l1eXfRK8vz%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-oa0-f73.google.com ([209.85.219.73]:37582 "EHLO
	mail-oa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753505AbaHLTmD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 Aug 2014 15:42:03 -0400
Received: by mail-oa0-f73.google.com with SMTP id g18so1920379oah.0
        for <mm-commits@vger.kernel.org>; Tue, 12 Aug 2014 12:42:02 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dwalter@google.com, tony@atomide.com, mm-commits@vger.kernel.org


The patch titled
     Subject: arch/arm/mach-omap2: replace strict_strto* with kstrto*
has been removed from the -mm tree.  Its filename was
     arch-arm-mach-omap2-replace-strict_strto-with-kstrto.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Daniel Walter <dwalter@google.com>
Subject: arch/arm/mach-omap2: replace strict_strto* with kstrto*

Replace obsolete strict_strto call with kstrto calls.
Simplify copy_from_user/strict_strto by using kstrto_from_user

Signed-off-by: Daniel Walter <dwalter@google.com>
Cc: Tony Lindgren <tony@atomide.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/mach-omap2/board-omap3touchbook.c |    2 -
 arch/arm/mach-omap2/mux.c                  |   22 +++++--------------
 2 files changed, 7 insertions(+), 17 deletions(-)

diff -puN arch/arm/mach-omap2/board-omap3touchbook.c~arch-arm-mach-omap2-replace-strict_strto-with-kstrto arch/arm/mach-omap2/board-omap3touchbook.c
--- a/arch/arm/mach-omap2/board-omap3touchbook.c~arch-arm-mach-omap2-replace-strict_strto-with-kstrto
+++ a/arch/arm/mach-omap2/board-omap3touchbook.c
@@ -336,7 +336,7 @@ static int __init early_touchbook_revisi
 	if (!p)
 		return 0;
 
-	return strict_strtoul(p, 10, &touchbook_revision);
+	return kstrtoul(p, 10, &touchbook_revision);
 }
 early_param("tbr", early_touchbook_revision);
 
diff -puN arch/arm/mach-omap2/mux.c~arch-arm-mach-omap2-replace-strict_strto-with-kstrto arch/arm/mach-omap2/mux.c
--- a/arch/arm/mach-omap2/mux.c~arch-arm-mach-omap2-replace-strict_strto-with-kstrto
+++ a/arch/arm/mach-omap2/mux.c
@@ -681,29 +681,19 @@ static ssize_t omap_mux_dbg_signal_write
 					 const char __user *user_buf,
 					 size_t count, loff_t *ppos)
 {
-	char buf[OMAP_MUX_MAX_ARG_CHAR];
 	struct seq_file *seqf;
 	struct omap_mux *m;
-	unsigned long val;
-	int buf_size, ret;
+	u16 val;
+	int ret;
 	struct omap_mux_partition *partition;
 
 	if (count > OMAP_MUX_MAX_ARG_CHAR)
 		return -EINVAL;
 
-	memset(buf, 0, sizeof(buf));
-	buf_size = min(count, sizeof(buf) - 1);
-
-	if (copy_from_user(buf, user_buf, buf_size))
-		return -EFAULT;
-
-	ret = strict_strtoul(buf, 0x10, &val);
+	ret = kstrtou16_from_user(user_buf, count, 0x10, &val);
 	if (ret < 0)
 		return ret;
 
-	if (val > 0xffff)
-		return -EINVAL;
-
 	seqf = file->private_data;
 	m = seqf->private;
 
@@ -711,7 +701,7 @@ static ssize_t omap_mux_dbg_signal_write
 	if (!partition)
 		return -ENODEV;
 
-	omap_mux_write(partition, (u16)val, m->reg_offset);
+	omap_mux_write(partition, val, m->reg_offset);
 	*ppos += count;
 
 	return count;
@@ -917,14 +907,14 @@ static void __init omap_mux_set_cmdline_
 
 	while ((token = strsep(&next_opt, ",")) != NULL) {
 		char *keyval, *name;
-		unsigned long val;
+		u16 val;
 
 		keyval = token;
 		name = strsep(&keyval, "=");
 		if (name) {
 			int res;
 
-			res = strict_strtoul(keyval, 0x10, &val);
+			res = kstrtou16(keyval, 0x10, &val);
 			if (res < 0)
 				continue;
 
_

Patches currently in -mm which might be from dwalter@google.com are

origin.patch
linux-next.patch
include-linux-remove-strict_strto-definitions.patch

