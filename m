From: akpm@linux-foundation.org
Subject: + arch-arm-mach-omap2-replace-strict_strto-with-kstrto.patch
 added to -mm tree
Date: Mon, 23 Jun 2014 16:29:44 -0700
Message-ID: <53a8b868.Nwd8vVCv5FhQAMdQ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53942 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750931AbaFWX3p (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 Jun 2014 19:29:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dwalter@google.com, tony@atomide.com, mm-commits@vger.kernel.org


The patch titled
     Subject: arch/arm/mach-omap2: replace strict_strto* with kstrto*
has been added to the -mm tree.  Its filename is
     arch-arm-mach-omap2-replace-strict_strto-with-kstrto.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/arch-arm-mach-omap2-replace-strict_strto-with-kstrto.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/arch-arm-mach-omap2-replace-strict_strto-with-kstrto.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -679,29 +679,19 @@ static ssize_t omap_mux_dbg_signal_write
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
 
@@ -709,7 +699,7 @@ static ssize_t omap_mux_dbg_signal_write
 	if (!partition)
 		return -ENODEV;
 
-	omap_mux_write(partition, (u16)val, m->reg_offset);
+	omap_mux_write(partition, val, m->reg_offset);
 	*ppos += count;
 
 	return count;
@@ -915,14 +905,14 @@ static void __init omap_mux_set_cmdline_
 
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

arch-arm-mach-omap2-replace-strict_strto-with-kstrto.patch
arch-arm-mach-pxa-replace-strict_strto-call-with-kstrto.patch
arch-arm-mach-s3c24xx-mach-jivec-replace-strict_strto-with-kstrto.patch
arch-arm-mach-w90x900-cpuc-replace-obsolete-strict_strto.patch
arch-powerpc-replace-obsolete-strict_strto-calls.patch
arch-x86-replace-strict_strto-calls.patch
drivers-scsi-replace-strict_strto-calls.patch
net-sunrpc-replace-strict_strto-calls.patch
include-linux-remove-strict_strto-definitions.patch

