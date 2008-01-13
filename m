From: akpm@linux-foundation.org
Subject: + memstick-initial-commit-for-sony-memorystick-support-fix.patch added to -mm tree
Date: Sun, 13 Jan 2008 15:37:23 -0800
Message-ID: <200801132337.m0DNb3oN002078@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50007 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754577AbYAMXhH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 13 Jan 2008 18:37:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mboton@gmail.commboton@gmail.co


The patch titled
     memstick-initial-commit-for-sony-memorystick-support fix
has been added to the -mm tree.  Its filename is
     memstick-initial-commit-for-sony-memorystick-support-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to =
find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: memstick-initial-commit-for-sony-memorystick-support fix
=46rom: Miguel Bot=C3=B3n <mboton@gmail.com>

This happens when trying to compile memory stick support inside the ker=
nel.

drivers/memstick/core/mspro_block.o: In function `memstick_priv':
mspro_block.c:(.text+0x0): multiple definition of `memstick_priv'
drivers/memstick/core/memstick.o:memstick.c:(.text+0x0): first defined =
here
drivers/memstick/core/mspro_block.o: In function `memstick_get_drvdata'=
:
mspro_block.c:(.text+0x6): multiple definition of `memstick_get_drvdata=
'
drivers/memstick/core/memstick.o:memstick.c:(.text+0x6): first defined =
here
drivers/memstick/core/mspro_block.o: In function `memstick_set_drvdata'=
:
mspro_block.c:(.text+0xd): multiple definition of `memstick_set_drvdata=
'
drivers/memstick/core/memstick.o:memstick.c:(.text+0xd): first defined =
here

This is because those three functions are not defined as static in "inc=
lude/linux/memstick.h".

Signed-off-by: Miguel Bot=C3=B3n <mboton@gmail.co>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memstick.h |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN include/linux/memstick.h~memstick-initial-commit-for-sony-mem=
orystick-support-fix include/linux/memstick.h
--- a/include/linux/memstick.h~memstick-initial-commit-for-sony-memorys=
tick-support-fix
+++ a/include/linux/memstick.h
@@ -271,17 +271,17 @@ void memstick_new_req(struct memstick_ho
=20
 int memstick_set_rw_addr(struct memstick_dev *card);
=20
-inline void *memstick_priv(struct memstick_host *host)
+static inline void *memstick_priv(struct memstick_host *host)
 {
 	return (void *)host->private;
 }
=20
-inline void *memstick_get_drvdata(struct memstick_dev *card)
+static inline void *memstick_get_drvdata(struct memstick_dev *card)
 {
 	return dev_get_drvdata(&card->dev);
 }
=20
-inline void memstick_set_drvdata(struct memstick_dev *card, void *data=
)
+static inline void memstick_set_drvdata(struct memstick_dev *card, voi=
d *data)
 {
 	dev_set_drvdata(&card->dev, data);
 }
_

Patches currently in -mm which might be from mboton@gmail.com are

acpi-remove-duplicated-warning-message.patch
alsa-fix-compilation-warning-in-gcc.patch
memstick-initial-commit-for-sony-memorystick-support-fix.patch
git-netdev-all.patch
ssb-add-ssb_pcihost_set_power_state-function.patch
b44-power-down-phy-when-interface-down.patch
git-x86.patch
