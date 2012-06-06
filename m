From: akpm@linux-foundation.org
Subject: + sound-use-printk_get_level-and-printk_skip_level.patch added to -mm tree
Date: Wed, 06 Jun 2012 14:46:41 -0700
Message-ID: <20120606214641.D9782A0274@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:63666 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754317Ab2FFVqm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Jun 2012 17:46:42 -0400
Received: by ggeh3 with SMTP id h3so760933gge.1
        for <mm-commits@vger.kernel.org>; Wed, 06 Jun 2012 14:46:42 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com, kay.sievers@vrfy.org, tiwai@suse.de


The patch titled
     Subject: sound: use printk_get_level and printk_skip_level
has been added to the -mm tree.  Its filename is
     sound-use-printk_get_level-and-printk_skip_level.patch

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
Subject: Subject: sound: use printk_get_level and printk_skip_level

Patches currently in -mm which might be from joe@perches.com are

linux-next.patch
maintainers-whitespace-fixes.patch
printk-add-generic-functions-to-find-kern_level-headers.patch
printk-add-kern_levelsh-to-make-kern_level-available-for-asm-use.patch
arch-remove-direct-definitions-of-kern_level-uses.patch
btrfs-use-printk_get_level-and-printk_skip_level-add-__printf-fix-fallout.patch
btrfs-use-printk_get_level-and-printk_skip_level-add-__printf-fix-fallout-checkpatch-fixes.patch
sound-use-printk_get_level-and-printk_skip_level.patch
staging-wlags49_h2-remove-direct-declarations-of-kern_level-prefixes.patch
printk-convert-the-format-for-kern_level-to-a-2-byte-pattern.patch
printk-only-look-for-prefix-levels-in-kernel-messages.patch
printk-remove-the-now-unnecessary-c-annotation-for-kern_cont.patch

