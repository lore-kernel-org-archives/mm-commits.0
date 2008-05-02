From: akpm@linux-foundation.org
Subject: - pcmcia-silence-section-mismatch-warnings-from-class_interface-variables.patch removed from -mm tree
Date: Fri, 02 May 2008 12:42:34 -0700
Message-ID: <200805021942.m42JgYZl011202@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38724 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932207AbYEBTmt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 2 May 2008 15:42:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sam@ravnborg.org, linux@dominikbrodowski.net, mm-commits@vger.kernel.org


The patch titled
     pcmcia: silence section mismatch warnings from class_interface variables
has been removed from the -mm tree.  Its filename was
     pcmcia-silence-section-mismatch-warnings-from-class_interface-variables.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pcmcia: silence section mismatch warnings from class_interface variables
From: Sam Ravnborg <sam@ravnborg.org>

Silence the following warnings:
WARNING: drivers/pcmcia/built-in.o(.data+0x6e8): Section mismatch in reference from the variable pcmcia_bus_interface to the function .devinit.text:pcmcia_bus_add_socket()
WARNING: drivers/pcmcia/built-in.o(.data+0xa88): Section mismatch in reference from the variable pccard_rsrc_interface to the function .devinit.text:pccard_sysfs_add_rsrc()
WARNING: drivers/pcmcia/built-in.o(.data+0xa90): Section mismatch in reference from the variable pccard_rsrc_interface to the function .devexit.text:pccard_sysfs_remove_rsrc()

The variables of type class_interface contains references
to __devinit and __devexit functions which is OK.
Silence warnings by annotating the variables with __refdata.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Dominik Brodowski <linux@dominikbrodowski.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pcmcia/ds.c             |    2 +-
 drivers/pcmcia/rsrc_nonstatic.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/pcmcia/ds.c~pcmcia-silence-section-mismatch-warnings-from-class_interface-variables drivers/pcmcia/ds.c
--- a/drivers/pcmcia/ds.c~pcmcia-silence-section-mismatch-warnings-from-class_interface-variables
+++ a/drivers/pcmcia/ds.c
@@ -1520,7 +1520,7 @@ static void pcmcia_bus_remove_socket(str
 
 
 /* the pcmcia_bus_interface is used to handle pcmcia socket devices */
-static struct class_interface pcmcia_bus_interface = {
+static struct class_interface pcmcia_bus_interface __refdata = {
 	.class = &pcmcia_socket_class,
 	.add_dev = &pcmcia_bus_add_socket,
 	.remove_dev = &pcmcia_bus_remove_socket,
diff -puN drivers/pcmcia/rsrc_nonstatic.c~pcmcia-silence-section-mismatch-warnings-from-class_interface-variables drivers/pcmcia/rsrc_nonstatic.c
--- a/drivers/pcmcia/rsrc_nonstatic.c~pcmcia-silence-section-mismatch-warnings-from-class_interface-variables
+++ a/drivers/pcmcia/rsrc_nonstatic.c
@@ -1045,7 +1045,7 @@ static void __devexit pccard_sysfs_remov
 		device_remove_file(dev, *attr);
 }
 
-static struct class_interface pccard_rsrc_interface = {
+static struct class_interface pccard_rsrc_interface __refdata = {
 	.class = &pcmcia_socket_class,
 	.add_dev = &pccard_sysfs_add_rsrc,
 	.remove_dev = __devexit_p(&pccard_sysfs_remove_rsrc),
_

Patches currently in -mm which might be from sam@ravnborg.org are

origin.patch
git-pci-current.patch
git-sh.patch
git-scsi-misc.patch
git-watchdog.patch
documentation-build-source-files-in-documentation-sub-dir.patch

