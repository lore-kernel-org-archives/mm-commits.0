From: akpm@osdl.org
Subject: + uml-audio-driver-locking.patch added to -mm tree
Date: Tue, 02 Jan 2007 14:55:51 -0800
Message-ID: <200701022255.l02MtqXn032702@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:41275 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965024AbXABW4H (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 2 Jan 2007 17:56:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jdike@addtoit.com, blaisorblade@yahoo.it


The patch titled
     uml: audio driver locking
has been added to the -mm tree.  Its filename is
     uml-audio-driver-locking.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: uml: audio driver locking
From: Jeff Dike <jdike@addtoit.com>

Comment the lack of locking and make a couple of variables static.

Signed-off-by: Jeff Dike <jdike@addtoit.com>
Cc: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/um/drivers/hostaudio_kern.c |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

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

x86_64-i386-kernel-mode-faults-pollute-current-thead.patch
uml-console-locking-fixes.patch
uml-return-hotplug-errors-to-host.patch
uml-console-whitespace-and-comment-tidying.patch
uml-lock-the-irqs_to_free-list.patch
uml-add-locking-to-network-transport-registration.patch
uml-network-driver-whitespace-and-style-fixes.patch
uml-watchdog-driver-locking.patch
uml-watchdog-driver-formatting.patch
uml-audio-driver-locking.patch
uml-audio-driver-formatting.patch
uml-mconsole-locking.patch
uml-make-two-variables-static.patch
uml-port-driver-formatting.patch
uml-kill-a-compilation-warning.patch
uml-fix-prototypes.patch
rewrite-unnecessary-duplicated-code-to-use-field_sizeof.patch
