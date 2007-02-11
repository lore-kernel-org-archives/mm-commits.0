From: akpm@linux-foundation.org
Subject: - uml-audio-driver-locking.patch removed from -mm tree
Date: Sun, 11 Feb 2007 14:48:31 -0800
Message-ID: <200702112248.l1BMmVaX015635@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:59732 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932661AbXBKWsd (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 11 Feb 2007 17:48:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jdike@addtoit.com, blaisorblade@yahoo.it, mm-commits@vger.kernel.org


The patch titled
     uml: audio driver locking
has been removed from the -mm tree.  Its filename was
     uml-audio-driver-locking.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: uml: audio driver locking
From: Jeff Dike <jdike@addtoit.com>

Comment the lack of locking and make a couple of variables static.

Signed-off-by: Jeff Dike <jdike@addtoit.com>
Cc: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/drivers/hostaudio_kern.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff -puN arch/um/drivers/hostaudio_kern.c~uml-audio-driver-locking arch/um/drivers/hostaudio_kern.c
--- a/arch/um/drivers/hostaudio_kern.c~uml-audio-driver-locking
+++ a/arch/um/drivers/hostaudio_kern.c
@@ -25,9 +25,12 @@ struct hostmixer_state {
 #define HOSTAUDIO_DEV_DSP "/dev/sound/dsp"
 #define HOSTAUDIO_DEV_MIXER "/dev/sound/mixer"
 
-/* Only changed from linux_main at boot time */
-char *dsp = HOSTAUDIO_DEV_DSP;
-char *mixer = HOSTAUDIO_DEV_MIXER;
+/* Changed either at boot time or module load time.  At boot, this is
+ * single-threaded; at module load, multiple modules would each have
+ * their own copy of these variables.
+ */
+static char *dsp = HOSTAUDIO_DEV_DSP;
+static char *mixer = HOSTAUDIO_DEV_MIXER;
 
 #define DSP_HELP \
 "    This is used to specify the host dsp device to the hostaudio driver.\n" \
_

Patches currently in -mm which might be from jdike@addtoit.com are

origin.patch
uml-fix-prototypes.patch
dynamic-kernel-command-line-common.patch
dynamic-kernel-command-line-um.patch
