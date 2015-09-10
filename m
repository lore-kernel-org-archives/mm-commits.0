From: akpm@linux-foundation.org
Subject: [nacked] sound-convert-to-parse_integer.patch removed from -mm
 tree
Date: Thu, 10 Sep 2015 16:26:33 -0700
Message-ID: <55f211a9.sPfxkEct+XooKNOP%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52599 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750743AbbIJX0e (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 10 Sep 2015 19:26:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, tiwai@suse.de, mm-commits@vger.kernel.org


The patch titled
     Subject: sound: convert to parse_integer()
has been removed from the -mm tree.  Its filename was
     sound-convert-to-parse_integer.patch

This patch was dropped because it was nacked

------------------------------------------------------
From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: sound: convert to parse_integer()

Convert away from deprecated simple_strto*() interfaces to parse_integer()
and kstrto*().

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 sound/core/oss/mixer_oss.c  |    7 ++++---
 sound/core/oss/pcm_oss.c    |   13 +++++++++++--
 sound/core/pcm.c            |   13 +++++++++++--
 sound/core/pcm_memory.c     |   11 +++++++++--
 sound/pci/ac97/ac97_codec.c |    9 ++++++---
 sound/soc/soc-core.c        |    9 ++++++---
 6 files changed, 47 insertions(+), 15 deletions(-)

diff -puN sound/core/oss/mixer_oss.c~sound-convert-to-parse_integer sound/core/oss/mixer_oss.c
--- a/sound/core/oss/mixer_oss.c~sound-convert-to-parse_integer
+++ a/sound/core/oss/mixer_oss.c
@@ -1180,6 +1180,7 @@ static void snd_mixer_oss_proc_write(str
 	int ch, idx;
 	struct snd_mixer_oss_assign_table *tbl;
 	struct slot *slot;
+	int rv;
 
 	while (!snd_info_get_line(buffer, line, sizeof(line))) {
 		cptr = snd_info_get_str(str, line, sizeof(str));
@@ -1200,9 +1201,9 @@ static void snd_mixer_oss_proc_write(str
 			continue;
 		}
 		snd_info_get_str(idxstr, cptr, sizeof(idxstr));
-		idx = simple_strtoul(idxstr, NULL, 10);
-		if (idx >= 0x4000) { /* too big */
-			pr_err("ALSA: mixer_oss: invalid index %d\n", idx);
+		rv = parse_integer(idxstr, 10, (unsigned int *)&idx);
+		if (rv < 0 || idxstr[rv] || idx >= 0x4000) { /* too big */
+			pr_err("ALSA: mixer_oss: invalid index %s\n", idxstr);
 			continue;
 		}
 		mutex_lock(&mixer->reg_mutex);
diff -puN sound/core/oss/pcm_oss.c~sound-convert-to-parse_integer sound/core/oss/pcm_oss.c
--- a/sound/core/oss/pcm_oss.c~sound-convert-to-parse_integer
+++ a/sound/core/oss/pcm_oss.c
@@ -2875,6 +2875,7 @@ static void snd_pcm_oss_proc_write(struc
 	const char *ptr;
 	int idx1;
 	struct snd_pcm_oss_setup *setup, *setup1, template;
+	int rv;
 
 	while (!snd_info_get_line(buffer, line, sizeof(line))) {
 		mutex_lock(&pstr->oss.setup_mutex);
@@ -2892,9 +2893,17 @@ static void snd_pcm_oss_proc_write(struc
 			}
 		}
 		ptr = snd_info_get_str(str, ptr, sizeof(str));
-		template.periods = simple_strtoul(str, NULL, 10);
+		rv = parse_integer(str, 10, &template.periods);
+		if (rv < 0 || str[rv]) {
+			mutex_unlock(&pstr->oss.setup_mutex);
+			continue;
+		}
 		ptr = snd_info_get_str(str, ptr, sizeof(str));
-		template.period_size = simple_strtoul(str, NULL, 10);
+		rv = parse_integer(str, 10, &template.period_size);
+		if (rv < 0 || str[rv]) {
+			mutex_unlock(&pstr->oss.setup_mutex);
+			continue;
+		}
 		for (idx1 = 31; idx1 >= 0; idx1--)
 			if (template.period_size & (1 << idx1))
 				break;
diff -puN sound/core/pcm.c~sound-convert-to-parse_integer sound/core/pcm.c
--- a/sound/core/pcm.c~sound-convert-to-parse_integer
+++ a/sound/core/pcm.c
@@ -506,8 +506,17 @@ static void snd_pcm_xrun_debug_write(str
 {
 	struct snd_pcm_str *pstr = entry->private_data;
 	char line[64];
-	if (!snd_info_get_line(buffer, line, sizeof(line)))
-		pstr->xrun_debug = simple_strtoul(line, NULL, 10);
+	int rv;
+
+	if (!snd_info_get_line(buffer, line, sizeof(line))) {
+		rv = parse_integer(line, 10, &pstr->xrun_debug);
+		if (rv >= 0 && line[rv])
+			rv = -EINVAL;
+		if (rv < 0) {
+			buffer->error = rv;
+			return;
+		}
+	}
 }
 #endif
 
diff -puN sound/core/pcm_memory.c~sound-convert-to-parse_integer sound/core/pcm_memory.c
--- a/sound/core/pcm_memory.c~sound-convert-to-parse_integer
+++ a/sound/core/pcm_memory.c
@@ -160,6 +160,7 @@ static void snd_pcm_lib_preallocate_proc
 	char line[64], str[64];
 	size_t size;
 	struct snd_dma_buffer new_dmab;
+	int rv;
 
 	if (substream->runtime) {
 		buffer->error = -EBUSY;
@@ -167,8 +168,14 @@ static void snd_pcm_lib_preallocate_proc
 	}
 	if (!snd_info_get_line(buffer, line, sizeof(line))) {
 		snd_info_get_str(str, line, sizeof(str));
-		size = simple_strtoul(str, NULL, 10) * 1024;
-		if ((size != 0 && size < 8192) || size > substream->dma_max) {
+		rv = parse_integer(str, 10, &size);
+		if (rv < 0) {
+			buffer->error = rv;
+			return;
+		}
+		size *= 1024;
+		if (str[rv] ||
+		    (size != 0 && size < 8192) || size > substream->dma_max) {
 			buffer->error = -EINVAL;
 			return;
 		}
diff -puN sound/pci/ac97/ac97_codec.c~sound-convert-to-parse_integer sound/pci/ac97/ac97_codec.c
--- a/sound/pci/ac97/ac97_codec.c~sound-convert-to-parse_integer
+++ a/sound/pci/ac97/ac97_codec.c
@@ -2877,6 +2877,8 @@ static int apply_quirk_str(struct snd_ac
 {
 	int i;
 	struct quirk_table *q;
+	unsigned int type;
+	int rv;
 
 	for (i = 0; i < ARRAY_SIZE(applicable_quirks); i++) {
 		q = &applicable_quirks[i];
@@ -2884,9 +2886,10 @@ static int apply_quirk_str(struct snd_ac
 			return apply_quirk(ac97, i);
 	}
 	/* for compatibility, accept the numbers, too */
-	if (*typestr >= '0' && *typestr <= '9')
-		return apply_quirk(ac97, (int)simple_strtoul(typestr, NULL, 10));
-	return -EINVAL;
+	rv = parse_integer(typestr, 10, &type);
+	if (rv < 0)
+		return rv;
+	return apply_quirk(ac97, type);
 }
 
 /**
diff -puN sound/soc/soc-core.c~sound-convert-to-parse_integer sound/soc/soc-core.c
--- a/sound/soc/soc-core.c~sound-convert-to-parse_integer
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

