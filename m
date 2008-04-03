From: akpm@linux-foundation.org
Subject: + es1968-fix-sleep-while-holding-lock-bug.patch added to -mm tree
Date: Thu, 03 Apr 2008 12:08:11 -0700
Message-ID: <200804031908.m33J8Bqf017754@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52120 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752856AbYDCTIU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 3 Apr 2008 15:08:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: arjan@linux.intel.com, perex@suse.cz, tiwai@suse.de


The patch titled
     es1968: fix sleep-while-holding-lock bug
has been added to the -mm tree.  Its filename is
     es1968-fix-sleep-while-holding-lock-bug.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
+	if (! snd_es1968_ac97_wait_poll(chip)) {
 		data = inw(chip->io_port + ESM_AC97_DATA);
 		/*msleep(1);*/
 	}
_

Patches currently in -mm which might be from arjan@linux.intel.com are

git-x86.patch
git-hrt.patch
make-dev-kmem-a-config-option.patch
make-dev-kmem-a-config-option-fix.patch
proc-print-more-information-when-removing-non-empty-directories.patch
es1968-fix-sleep-while-holding-lock-bug.patch

