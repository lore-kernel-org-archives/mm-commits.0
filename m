From: akpm@linux-foundation.org
Subject: - es1968-fix-sleep-while-holding-lock-bug.patch removed from -mm tree
Date: Thu, 10 Apr 2008 13:00:54 -0700
Message-ID: <200804102000.m3AK0s33014929@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56701 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757485AbYDJUCd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 10 Apr 2008 16:02:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arjan@linux.intel.com, perex@suse.cz, tiwai@suse.de, mm-commits@vger.kernel.org


The patch titled
     es1968: fix sleep-while-holding-lock bug
has been removed from the -mm tree.  Its filename was
     es1968-fix-sleep-while-holding-lock-bug.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: es1968: fix sleep-while-holding-lock bug
From: Arjan van de Ven <arjan@linux.intel.com>

snd_es1968_ac97_read() calls snd_es1968_ac97_wait() first outside a locked
area, and later, while holding a lock.

snd_es1968_ac97_wait() has a polling loop with a cond_resched() inside it.. 
which sleeps, so the second call is invalid.

This patch adds a version of the wait function that just pure polls.  While
this is not very elegant in principle, it's very likely the easiest thing to
do here, we already checked if the chip was ready (while yielding) just
before, so it is very unlikely to take a long time here.

[akpm@linux-foundation.org: coding-style fixes]
Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
Cc: Jaroslav Kysela <perex@suse.cz>
Cc: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 sound/pci/es1968.c |   14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff -puN sound/pci/es1968.c~es1968-fix-sleep-while-holding-lock-bug sound/pci/es1968.c
--- a/sound/pci/es1968.c~es1968-fix-sleep-while-holding-lock-bug
+++ a/sound/pci/es1968.c
@@ -617,6 +617,18 @@ static int snd_es1968_ac97_wait(struct e
 	return 1; /* timeout */
 }
 
+static int snd_es1968_ac97_wait_poll(struct es1968 *chip)
+{
+	int timeout = 100000;
+
+	while (timeout-- > 0) {
+		if (!(inb(chip->io_port + ESM_AC97_INDEX) & 1))
+			return 0;
+	}
+	snd_printd("es1968: ac97 timeout\n");
+	return 1; /* timeout */
+}
+
 static void snd_es1968_ac97_write(struct snd_ac97 *ac97, unsigned short reg, unsigned short val)
 {
 	struct es1968 *chip = ac97->private_data;
@@ -645,7 +657,7 @@ static unsigned short snd_es1968_ac97_re
 	outb(reg | 0x80, chip->io_port + ESM_AC97_INDEX);
 	/*msleep(1);*/
 
-	if (! snd_es1968_ac97_wait(chip)) {
+	if (!snd_es1968_ac97_wait_poll(chip)) {
 		data = inw(chip->io_port + ESM_AC97_DATA);
 		/*msleep(1);*/
 	}
_

Patches currently in -mm which might be from arjan@linux.intel.com are

origin.patch
git-x86.patch
git-hrt.patch
make-dev-kmem-a-config-option.patch
make-dev-kmem-a-config-option-fix.patch
proc-print-more-information-when-removing-non-empty-directories.patch

