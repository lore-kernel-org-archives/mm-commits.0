From: akpm@linux-foundation.org
Subject: - try-harder-to-probe-some-finicky-mice.patch removed from -mm tree
Date: Mon, 30 Jul 2007 23:33:25 -0700
Message-ID: <200707310633.l6V6XP4w019703@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60638 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752114AbXGaGe0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 31 Jul 2007 02:34:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alonz@nolaviz.org, dtor@mail.ru, jkosina@suse.cz, lkml@nolaviz.org, mm-commits@vger.kernel.org


The patch titled
     Try harder to probe some finicky mice
has been removed from the -mm tree.  Its filename was
     try-harder-to-probe-some-finicky-mice.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Try harder to probe some finicky mice
From: Alon Ziv <alonz@nolaviz.org>

Some rodents appear to be extra-finicky, and require both a PSMOUSE_RESET_DIS
and a PSMOUSE_RESET_BAT before they are unconfused enough to be probed.

Signed-off-by: Alon Ziv <lkml@nolaviz.org>
Cc: Jiri Kosina <jkosina@suse.cz>
Cc: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/input/mouse/psmouse-base.c |    1 +
 1 files changed, 1 insertion(+)

diff -puN drivers/input/mouse/psmouse-base.c~try-harder-to-probe-some-finicky-mice drivers/input/mouse/psmouse-base.c
--- a/drivers/input/mouse/psmouse-base.c~try-harder-to-probe-some-finicky-mice
+++ a/drivers/input/mouse/psmouse-base.c
@@ -651,6 +651,7 @@ static int psmouse_extensions(struct psm
  * protocol probes. Note that we do full reset becuase some mice
  * put themselves to sleep when see PSMOUSE_RESET_DIS.
  */
+	ps2_command(&psmouse->ps2dev, NULL, PSMOUSE_CMD_RESET_DIS);
 	psmouse_reset(psmouse);
 
 	if (max_proto >= PSMOUSE_IMEX && im_explorer_detect(psmouse, set_properties) == 0)
_

Patches currently in -mm which might be from alonz@nolaviz.org are

git-input.patch
