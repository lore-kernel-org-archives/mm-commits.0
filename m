From: akpm@linux-foundation.org
Subject: - sound-pci-rme9652-hdspmc-stop-inlining-largish-static-functions.patch removed from -mm tree
Date: Tue, 15 Apr 2008 02:10:29 -0700
Message-ID: <200804150910.m3F9ATPG020632@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41988 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756081AbYDOJLG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Apr 2008 05:11:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vda.linux@googlemail.com, perex@suse.cz, tiwai@suse.de, mm-commits@vger.kernel.org


The patch titled
     sound/pci/rme9652/hdspm.c: stop inlining largish static functions
has been removed from the -mm tree.  Its filename was
     sound-pci-rme9652-hdspmc-stop-inlining-largish-static-functions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sound/pci/rme9652/hdspm.c: stop inlining largish static functions
From: Denys Vlasenko <vda.linux@googlemail.com>

sound/pci/rme9652/hdspm.c has unusually large number of static inline
functions - 22.

I looked through them and some of them seem to be too big to warrant inlining.

This patch removes "inline" from these static functions (regardless of number
of callsites - gcc nowadays auto-inlines statics with one callsite).

Size difference on 32bit x86:
   text    data     bss     dec     hex filename
  20437    2160     516   23113    5a49 linux-2.6-ALLYES/sound/pci/rme9652/hdspm.o
  18036    2160     516   20712    50e8 linux-2.6.inline-ALLYES/sound/pci/rme9652/hdspm.o

Signed-off-by: Denys Vlasenko <vda.linux@googlemail.com>
Cc: Jaroslav Kysela <perex@suse.cz>
Cc: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 sound/pci/rme9652/hdspm.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff -puN sound/pci/rme9652/hdspm.c~sound-pci-rme9652-hdspmc-stop-inlining-largish-static-functions sound/pci/rme9652/hdspm.c
--- a/sound/pci/rme9652/hdspm.c~sound-pci-rme9652-hdspmc-stop-inlining-largish-static-functions
+++ a/sound/pci/rme9652/hdspm.c
@@ -540,7 +540,7 @@ static void hdspm_set_sgbuf(struct hdspm
 
 static inline int HDSPM_bit2freq(int n)
 {
-	static int bit2freq_tab[] = { 0, 32000, 44100, 48000, 64000, 88200,
+	static const int bit2freq_tab[] = { 0, 32000, 44100, 48000, 64000, 88200,
 		96000, 128000, 176400, 192000 };
 	if (n < 1 || n > 9)
 		return 0;
@@ -582,7 +582,7 @@ static inline int hdspm_read_pb_gain(str
 	return hdspm->mixer->ch[chan].pb[pb];
 }
 
-static inline int hdspm_write_in_gain(struct hdspm * hdspm, unsigned int chan,
+static int hdspm_write_in_gain(struct hdspm * hdspm, unsigned int chan,
 				      unsigned int in, unsigned short data)
 {
 	if (chan >= HDSPM_MIXER_CHANNELS || in >= HDSPM_MIXER_CHANNELS)
@@ -595,7 +595,7 @@ static inline int hdspm_write_in_gain(st
 	return 0;
 }
 
-static inline int hdspm_write_pb_gain(struct hdspm * hdspm, unsigned int chan,
+static int hdspm_write_pb_gain(struct hdspm * hdspm, unsigned int chan,
 				      unsigned int pb, unsigned short data)
 {
 	if (chan >= HDSPM_MIXER_CHANNELS || pb >= HDSPM_MIXER_CHANNELS)
@@ -621,7 +621,7 @@ static inline void snd_hdspm_enable_out(
 }
 
 /* check if same process is writing and reading */
-static inline int snd_hdspm_use_is_exclusive(struct hdspm * hdspm)
+static int snd_hdspm_use_is_exclusive(struct hdspm * hdspm)
 {
 	unsigned long flags;
 	int ret = 1;
@@ -636,7 +636,7 @@ static inline int snd_hdspm_use_is_exclu
 }
 
 /* check for external sample rate */
-static inline int hdspm_external_sample_rate(struct hdspm * hdspm)
+static int hdspm_external_sample_rate(struct hdspm * hdspm)
 {
 	if (hdspm->is_aes32) {
 		unsigned int status2 = hdspm_read(hdspm, HDSPM_statusRegister2);
@@ -787,7 +787,7 @@ static inline void hdspm_stop_audio(stru
 }
 
 /* should I silence all or only opened ones ? doit all for first even is 4MB*/
-static inline void hdspm_silence_playback(struct hdspm * hdspm)
+static void hdspm_silence_playback(struct hdspm * hdspm)
 {
 	int i;
 	int n = hdspm->period_bytes;
@@ -1057,7 +1057,7 @@ static inline int snd_hdspm_midi_output_
 		return 0;
 }
 
-static inline void snd_hdspm_flush_midi_input (struct hdspm *hdspm, int id)
+static void snd_hdspm_flush_midi_input (struct hdspm *hdspm, int id)
 {
 	while (snd_hdspm_midi_input_available (hdspm, id))
 		snd_hdspm_midi_read_byte (hdspm, id);
_

Patches currently in -mm which might be from vda.linux@googlemail.com are

git-alsa-tiwai.patch
git-net.patch

