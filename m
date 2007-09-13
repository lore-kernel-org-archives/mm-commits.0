From: akpm@linux-foundation.org
Subject: + pcmcia-convert-io_req_t-to-use-kio_addr_t.patch added to -mm tree
Date: Thu, 13 Sep 2007 15:06:09 -0700
Message-ID: <200709132206.l8DM69eX008237@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53583 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752173AbXIMWGc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Sep 2007 18:06:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: olof@lixom.net, benh@kernel.crashing.org, hch@lst.de, linux@dominikbrodowski.net, paulus@samba.org, rmk@arm.linux.org.uk


The patch titled
     pcmcia: convert io_req_t to use kio_addr_t
has been added to the -mm tree.  Its filename is
     pcmcia-convert-io_req_t-to-use-kio_addr_t.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: pcmcia: convert io_req_t to use kio_addr_t
From: Olof Johansson <olof@lixom.net>

Convert the io_req_t members to kio_addr_t, to allow use on machines with
more than 16 bits worth of IO port address space (ppc64 in this case,
but it applies to others as well).

Signed-off-by: Olof Johansson <olof@lixom.net>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Dominik Brodowski <linux@dominikbrodowski.net>
Cc: Russell King <rmk@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pcmcia/pcmcia_resource.c |   12 ++++++------
 include/pcmcia/cs.h              |    8 ++++----
 2 files changed, 10 insertions(+), 10 deletions(-)

diff -puN drivers/pcmcia/pcmcia_resource.c~pcmcia-convert-io_req_t-to-use-kio_addr_t drivers/pcmcia/pcmcia_resource.c
--- a/drivers/pcmcia/pcmcia_resource.c~pcmcia-convert-io_req_t-to-use-kio_addr_t
+++ a/drivers/pcmcia/pcmcia_resource.c
@@ -65,8 +65,8 @@ extern int ds_pc_debug;
  * Special stuff for managing IO windows, because they are scarce
  */
 
-static int alloc_io_space(struct pcmcia_socket *s, u_int attr, ioaddr_t *base,
-			  ioaddr_t num, u_int lines)
+static int alloc_io_space(struct pcmcia_socket *s, u_int attr, kio_addr_t *base,
+			  kio_addr_t num, u_int lines)
 {
 	int i;
 	kio_addr_t try, align;
@@ -74,14 +74,14 @@ static int alloc_io_space(struct pcmcia_
 	align = (*base) ? (lines ? 1<<lines : 0) : 1;
 	if (align && (align < num)) {
 		if (*base) {
-			ds_dbg(s, 0, "odd IO request: num %#x align %#lx\n",
+			ds_dbg(s, 0, "odd IO request: num %#lx align %#lx\n",
 			       num, align);
 			align = 0;
 		} else
 			while (align && (align < num)) align <<= 1;
 	}
 	if (*base & ~(align-1)) {
-		ds_dbg(s, 0, "odd IO request: base %#x align %#lx\n",
+		ds_dbg(s, 0, "odd IO request: base %#lx align %#lx\n",
 		       *base, align);
 		align = 0;
 	}
@@ -132,8 +132,8 @@ static int alloc_io_space(struct pcmcia_
 } /* alloc_io_space */
 
 
-static void release_io_space(struct pcmcia_socket *s, ioaddr_t base,
-			     ioaddr_t num)
+static void release_io_space(struct pcmcia_socket *s, kio_addr_t base,
+			     kio_addr_t num)
 {
 	int i;
 
diff -puN include/pcmcia/cs.h~pcmcia-convert-io_req_t-to-use-kio_addr_t include/pcmcia/cs.h
--- a/include/pcmcia/cs.h~pcmcia-convert-io_req_t-to-use-kio_addr_t
+++ a/include/pcmcia/cs.h
@@ -147,11 +147,11 @@ typedef struct config_req_t {
 
 /* For RequestIO and ReleaseIO */
 typedef struct io_req_t {
-    ioaddr_t	BasePort1;
-    ioaddr_t	NumPorts1;
+    kio_addr_t	BasePort1;
+    kio_addr_t	NumPorts1;
     u_int	Attributes1;
-    ioaddr_t	BasePort2;
-    ioaddr_t	NumPorts2;
+    kio_addr_t	BasePort2;
+    kio_addr_t	NumPorts2;
     u_int	Attributes2;
     u_int	IOAddrLines;
 } io_req_t;
_

Patches currently in -mm which might be from olof@lixom.net are

git-powerpc.patch
git-netdev-all.patch
pcmcia-convert-io_req_t-to-use-kio_addr_t.patch
pcmcia-compactflash-driver-for-pa-semi-electra-boards.patch
pcmcia-compactflash-driver-for-pa-semi-electra-boards-fix.patch
