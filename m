From: akpm@linux-foundation.org
Subject: [merged] sound-use-printk_get_level-and-printk_skip_level.patch removed from -mm tree
Date: Tue, 31 Jul 2012 11:49:35 -0700
Message-ID: <20120731184936.1552720004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lpp01m010-f74.google.com ([209.85.215.74]:51872 "EHLO
	mail-lpp01m010-f74.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756254Ab2GaSth (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 31 Jul 2012 14:49:37 -0400
Received: by mail-lpp01m010-f74.google.com with SMTP id r15so292127lag.1
        for <mm-commits@vger.kernel.org>; Tue, 31 Jul 2012 11:49:37 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, kay.sievers@vrfy.org, tiwai@suse.de, mm-commits@vger.kernel.org


The patch titled
     Subject: sound: use printk_get_level and printk_skip_level
has been removed from the -mm tree.  Its filename was
     sound-use-printk_get_level-and-printk_skip_level.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: sound: use printk_get_level and printk_skip_level

Make the output logging routine independent of the KERN_<LEVEL> style.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Cc: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 sound/core/misc.c |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff -puN sound/core/misc.c~sound-use-printk_get_level-and-printk_skip_level sound/core/misc.c
--- a/sound/core/misc.c~sound-use-printk_get_level-and-printk_skip_level
+++ a/sound/core/misc.c
@@ -68,6 +68,7 @@ void __snd_printk(unsigned int level, co
 {
 	va_list args;
 #ifdef CONFIG_SND_VERBOSE_PRINTK
+	int kern_level;
 	struct va_format vaf;
 	char verbose_fmt[] = KERN_DEFAULT "ALSA %s:%d %pV";
 #endif
@@ -81,12 +82,16 @@ void __snd_printk(unsigned int level, co
 #ifdef CONFIG_SND_VERBOSE_PRINTK
 	vaf.fmt = format;
 	vaf.va = &args;
-	if (format[0] == '<' && format[2] == '>') {
-		memcpy(verbose_fmt, format, 3);
-		vaf.fmt = format + 3;
+
+	kern_level = printk_get_level(format);
+	if (kern_level) {
+		const char *end_of_header = printk_skip_level(format);
+		memcpy(verbose_fmt, format, end_of_header - format);
+		vaf.fmt = end_of_header;
 	} else if (level)
-		memcpy(verbose_fmt, KERN_DEBUG, 3);
+		memcpy(verbose_fmt, KERN_DEBUG, sizeof(KERN_DEBUG) - 1);
 	printk(verbose_fmt, sanity_file_name(path), line, &vaf);
+
 #else
 	vprintk(format, args);
 #endif
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
dynamic_debug-restore-dev_dbg-netdev_dbg-functionality-reduce-stack-use.patch
dynamic_debug-restore-dev_dbg-netdev_dbg-functionality-reduce-stack-use-v2.patch
linux-next.patch
thermal-add-renesas-r-car-thermal-sensor-support.patch

