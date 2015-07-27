From: akpm@linux-foundation.org
Subject: [nacked] parse_integer-convert-sound.patch removed from -mm tree
Date: Mon, 27 Jul 2015 13:41:28 -0700
Message-ID: <55b69778.E4QWEWaY58jgreP2%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48153 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753083AbbG0Ul3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 27 Jul 2015 16:41:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, tiwai@suse.de, mm-commits@vger.kernel.org


The patch titled
     Subject: parse_integer: convert sound/
has been removed from the -mm tree.  Its filename was
     parse_integer-convert-sound.patch

This patch was dropped because it was nacked

------------------------------------------------------
From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: parse_integer: convert sound/

Convert sound/ directory from deprecated simple_strto*()
to parse_integer()/kstrto*() functions.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 sound/core/oss/mixer_oss.c  |    2 +-
 sound/core/oss/pcm_oss.c    |    4 ++--
 sound/core/pcm.c            |    2 +-
 sound/core/pcm_memory.c     |    3 ++-
 sound/pci/ac97/ac97_codec.c |    8 ++++++--
 sound/soc/soc-core.c        |    9 ++++++---
 6 files changed, 18 insertions(+), 10 deletions(-)

diff -puN sound/core/oss/mixer_oss.c~parse_integer-convert-sound sound/core/oss/mixer_oss.c
--- a/sound/core/oss/mixer_oss.c~parse_integer-convert-sound
+++ a/sound/core/oss/mixer_oss.c
@@ -1200,7 +1200,7 @@ static void snd_mixer_oss_proc_write(str
 			continue;
 		}
 		snd_info_get_str(idxstr, cptr, sizeof(idxstr));
-		idx = simple_strtoul(idxstr, NULL, 10);
+		parse_integer(idxstr, 10, (unsigned int *)&idx);
 		if (idx >= 0x4000) { /* too big */
 			pr_err("ALSA: mixer_oss: invalid index %d\n", idx);
 			continue;
diff -puN sound/core/oss/pcm_oss.c~parse_integer-convert-sound sound/core/oss/pcm_oss.c
--- a/sound/core/oss/pcm_oss.c~parse_integer-convert-sound
+++ a/sound/core/oss/pcm_oss.c
@@ -2892,9 +2892,9 @@ static void snd_pcm_oss_proc_write(struc
 			}
 		}
 		ptr = snd_info_get_str(str, ptr, sizeof(str));
-		template.periods = simple_strtoul(str, NULL, 10);
+		parse_integer(str, 10, &template.periods);
 		ptr = snd_info_get_str(str, ptr, sizeof(str));
-		template.period_size = simple_strtoul(str, NULL, 10);
+		parse_integer(str, 10, &template.period_size);
 		for (idx1 = 31; idx1 >= 0; idx1--)
 			if (template.period_size & (1 << idx1))
 				break;
diff -puN sound/core/pcm.c~parse_integer-convert-sound sound/core/pcm.c
--- a/sound/core/pcm.c~parse_integer-convert-sound
+++ a/sound/core/pcm.c
@@ -507,7 +507,7 @@ static void snd_pcm_xrun_debug_write(str
 	struct snd_pcm_str *pstr = entry->private_data;
 	char line[64];
 	if (!snd_info_get_line(buffer, line, sizeof(line)))
-		pstr->xrun_debug = simple_strtoul(line, NULL, 10);
+		parse_integer(line, 10, &pstr->xrun_debug);
 }
 #endif
 
diff -puN sound/core/pcm_memory.c~parse_integer-convert-sound sound/core/pcm_memory.c
--- a/sound/core/pcm_memory.c~parse_integer-convert-sound
+++ a/sound/core/pcm_memory.c
@@ -167,7 +167,8 @@ static void snd_pcm_lib_preallocate_proc
 	}
 	if (!snd_info_get_line(buffer, line, sizeof(line))) {
 		snd_info_get_str(str, line, sizeof(str));
-		size = simple_strtoul(str, NULL, 10) * 1024;
+		parse_integer(str, 10, &size);
+		size *= 1024;
 		if ((size != 0 && size < 8192) || size > substream->dma_max) {
 			buffer->error = -EINVAL;
 			return;
diff -puN sound/pci/ac97/ac97_codec.c~parse_integer-convert-sound sound/pci/ac97/ac97_codec.c
--- a/sound/pci/ac97/ac97_codec.c~parse_integer-convert-sound
+++ a/sound/pci/ac97/ac97_codec.c
@@ -2884,8 +2884,12 @@ static int apply_quirk_str(struct snd_ac
 			return apply_quirk(ac97, i);
 	}
 	/* for compatibility, accept the numbers, too */
-	if (*typestr >= '0' && *typestr <= '9')
-		return apply_quirk(ac97, (int)simple_strtoul(typestr, NULL, 10));
+	if (*typestr >= '0' && *typestr <= '9') {
+		int type;
+
+		parse_integer(typestr, 10, &type);
+		return apply_quirk(ac97, type);
+	}
 	return -EINVAL;
 }
 
diff -puN sound/soc/soc-core.c~parse_integer-convert-sound sound/soc/soc-core.c
--- a/sound/soc/soc-core.c~parse_integer-convert-sound
+++ a/sound/soc/soc-core.c
@@ -250,7 +250,7 @@ static ssize_t codec_reg_write_file(stru
 	char buf[32];
 	size_t buf_size;
 	char *start = buf;
-	unsigned long reg, value;
+	unsigned int reg, value;
 	struct snd_soc_codec *codec = file->private_data;
 	int ret;
 
@@ -261,10 +261,13 @@ static ssize_t codec_reg_write_file(stru
 
 	while (*start == ' ')
 		start++;
-	reg = simple_strtoul(start, &start, 16);
+	ret = parse_integer(start, 16, &reg);
+	if (ret < 0)
+		return ret;
+	start += ret;
 	while (*start == ' ')
 		start++;
-	ret = kstrtoul(start, 16, &value);
+	ret = kstrtouint(start, 16, &value);
 	if (ret)
 		return ret;
 
_

Patches currently in -mm which might be from adobriyan@gmail.com are

kstrto-accept-0-for-signed-conversion.patch
add-parse_integer-replacement-for-simple_strto.patch
parse_integer-add-runtime-testsuite.patch
parse-integer-rewrite-kstrto.patch
parse_integer-convert-scanf.patch
scanf-fix-type-range-overflow.patch
parse_integer-convert-lib.patch
parse_integer-convert-mm.patch
parse_integer-convert-mm-fix.patch
parse_integer-convert-fs.patch
parse_integer-convert-fs-cachefiles.patch
parse_integer-convert-ext2-ext3-ext4.patch
parse_integer-convert-fs-ocfs2.patch
parse_integer-convert-fs-9p.patch
parse_integer-convert-fs-exofs.patch
parse_integer-add-checkpatchpl-notice.patch

