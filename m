From: akpm@linux-foundation.org
Subject: + pcmcia-fix-kernel-doc-comments.patch added to -mm tree
Date: Wed, 05 Dec 2007 13:12:04 -0800
Message-ID: <200712052112.lB5LC4wb025615@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59968 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751564AbXLEVNg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 5 Dec 2007 16:13:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com


The patch titled
     pcmcia: fix kernel-doc comments
has been added to the -mm tree.  Its filename is
     pcmcia-fix-kernel-doc-comments.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: pcmcia: fix kernel-doc comments
From: Randy Dunlap <randy.dunlap@oracle.com>

Fix kernel-doc comments in drivers/pcmcia/:

- ti113x.h does not contain kernel-doc, so don't use /** to begin a doc
  comment
- yenta_socket.c: remove /** on non-kernel-doc comments;
  escape the ':' in an "http:" comment so that it won't be treated as a
  section heading;
- cs.c: remove /** on non-kernel-doc comments & add function parameter info
- ds.c: fix function parameter info

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pcmcia/cs.c           |    8 +++++---
 drivers/pcmcia/ds.c           |    6 ++++--
 drivers/pcmcia/ti113x.h       |    2 +-
 drivers/pcmcia/yenta_socket.c |    6 +++---
 4 files changed, 13 insertions(+), 9 deletions(-)

diff -puN drivers/pcmcia/cs.c~pcmcia-fix-kernel-doc-comments drivers/pcmcia/cs.c
--- a/drivers/pcmcia/cs.c~pcmcia-fix-kernel-doc-comments
+++ a/drivers/pcmcia/cs.c
@@ -89,7 +89,7 @@ DECLARE_RWSEM(pcmcia_socket_list_rwsem);
 EXPORT_SYMBOL(pcmcia_socket_list_rwsem);
 
 
-/**
+/*
  * Low-level PCMCIA socket drivers need to register with the PCCard
  * core using pcmcia_register_socket.
  *
@@ -174,6 +174,7 @@ static int pccardd(void *__skt);
 
 /**
  * pcmcia_register_socket - add a new pcmcia socket device
+ * @socket: the &socket to register
  */
 int pcmcia_register_socket(struct pcmcia_socket *socket)
 {
@@ -268,6 +269,7 @@ EXPORT_SYMBOL(pcmcia_register_socket);
 
 /**
  * pcmcia_unregister_socket - remove a pcmcia socket device
+ * @socket: the &socket to unregister
  */
 void pcmcia_unregister_socket(struct pcmcia_socket *socket)
 {
@@ -311,7 +313,7 @@ struct pcmcia_socket * pcmcia_get_socket
 }
 EXPORT_SYMBOL(pcmcia_get_socket_by_nr);
 
-/**
+/*
  * The central event handler.  Send_event() sends an event to the
  * 16-bit subsystem, which then calls the relevant device drivers.
  * Parse_events() interprets the event bits from
@@ -380,7 +382,7 @@ static int socket_reset(struct pcmcia_so
 	return CS_GENERAL_FAILURE;
 }
 
-/**
+/*
  * socket_setup() and socket_shutdown() are called by the main event handler
  * when card insertion and removal events are received.
  * socket_setup() turns on socket power and resets the socket, in two stages.
diff -puN drivers/pcmcia/ds.c~pcmcia-fix-kernel-doc-comments drivers/pcmcia/ds.c
--- a/drivers/pcmcia/ds.c~pcmcia-fix-kernel-doc-comments
+++ a/drivers/pcmcia/ds.c
@@ -320,6 +320,7 @@ pcmcia_create_newid_file(struct pcmcia_d
 
 /**
  * pcmcia_register_driver - register a PCMCIA driver with the bus core
+ * @driver: the &driver being registered
  *
  * Registers a PCMCIA driver with the PCMCIA bus core.
  */
@@ -354,6 +355,7 @@ EXPORT_SYMBOL(pcmcia_register_driver);
 
 /**
  * pcmcia_unregister_driver - unregister a PCMCIA driver with the bus core
+ * @driver: the &driver being unregistered
  */
 void pcmcia_unregister_driver(struct pcmcia_driver *driver)
 {
@@ -840,8 +842,8 @@ static void pcmcia_bus_rescan(struct pcm
 
 /**
  * pcmcia_load_firmware - load CIS from userspace if device-provided is broken
- * @dev - the pcmcia device which needs a CIS override
- * @filename - requested filename in /lib/firmware/
+ * @dev: the pcmcia device which needs a CIS override
+ * @filename: requested filename in /lib/firmware/
  *
  * This uses the in-kernel firmware loading mechanism to use a "fake CIS" if
  * the one provided by the card is broken. The firmware files reside in
diff -puN drivers/pcmcia/ti113x.h~pcmcia-fix-kernel-doc-comments drivers/pcmcia/ti113x.h
--- a/drivers/pcmcia/ti113x.h~pcmcia-fix-kernel-doc-comments
+++ a/drivers/pcmcia/ti113x.h
@@ -874,7 +874,7 @@ static int ti1250_override(struct yenta_
  */
 
 #ifdef CONFIG_YENTA_ENE_TUNE
-/**
+/*
  * set/clear various test bits:
  * Defaults to clear the bit.
  * - mask (u8) defines what bits to change
diff -puN drivers/pcmcia/yenta_socket.c~pcmcia-fix-kernel-doc-comments drivers/pcmcia/yenta_socket.c
--- a/drivers/pcmcia/yenta_socket.c~pcmcia-fix-kernel-doc-comments
+++ a/drivers/pcmcia/yenta_socket.c
@@ -48,7 +48,7 @@ MODULE_PARM_DESC(pwr_irqs_off, "Force IR
 #define to_cycles(ns)	((ns)/120)
 #define to_ns(cycles)	((cycles)*120)
 
-/**
+/*
  * yenta PCI irq probing.
  * currently only used in the TI/EnE initialization code
  */
@@ -888,7 +888,7 @@ static unsigned int yenta_probe_irq(stru
 }
 
 
-/**
+/*
  * yenta PCI irq probing.
  * currently only used in the TI/EnE initialization code
  */
@@ -1012,7 +1012,7 @@ static void yenta_config_init(struct yen
  * invisible during PCI scans because of a misconfigured subordinate number
  * of the parent brige - some BIOSes seem to be too lazy to set it right.
  * Does the fixup carefully by checking how far it can go without conflicts.
- * See http://bugzilla.kernel.org/show_bug.cgi?id=2944 for more information.
+ * See http\://bugzilla.kernel.org/show_bug.cgi?id=2944 for more information.
  */
 static void yenta_fixup_parent_bridge(struct pci_bus *cardbus_bridge)
 {
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

pcmcia-fix-kernel-doc-comments.patch
git-dvb.patch
git-kbuild.patch
pcmcia-include-bad-cis-filename-in-error-message.patch
git-scsi-misc.patch
advansys-fix-section-mismatch-warning.patch
aic94-fix-section-mismatches.patch
sym2-fix-section-mismatch-warning.patch
git-unionfs.patch
git-ipwireless_cs.patch
git-x86.patch
register_cpu-__devinit-or-__cpuinit.patch
cciss-use-upper_32_bits-macro-to-eliminate-warnings.patch
move-kprobes-examples-to-samples-resend.patch
move-kprobes-examples-to-samples-resend-checkpatch-fixes.patch
move-kprobes-examples-to-samples-resend-vs-git-x86.patch
fs-menu-small-reorg.patch
profile-likely-unlikely-macros.patch
