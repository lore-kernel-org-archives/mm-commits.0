From: akpm@linux-foundation.org
Subject: + ioc3-fix-section-missmatch.patch added to -mm tree
Date: Mon, 10 Mar 2008 12:34:54 -0700
Message-ID: <200803101934.m2AJYs2q001758@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46062 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751241AbYCJTfw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 10 Mar 2008 15:35:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ralf@linux-mips.org


The patch titled
     ioc3: fix section missmatch
has been added to the -mm tree.  Its filename is
     ioc3-fix-section-missmatch.patch

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
Subject: ioc3: fix section missmatch
From: Ralf Baechle <ralf@linux-mips.org>

  LD      drivers/net/built-in.o
WARNING: drivers/net/built-in.o(.text+0x3468): Section mismatch in reference fro
m the function ioc3_probe() to the function .devinit.text:ioc3_serial_probe()
The function ioc3_probe() references
the function __devinit ioc3_serial_probe().
This is often because ioc3_probe lacks a __devinit
annotation or the annotation of ioc3_serial_probe is wrong.

Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/ioc3-eth.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/net/ioc3-eth.c~ioc3-fix-section-missmatch drivers/net/ioc3-eth.c
--- a/drivers/net/ioc3-eth.c~ioc3-fix-section-missmatch
+++ a/drivers/net/ioc3-eth.c
@@ -1221,7 +1221,8 @@ static void __devinit ioc3_serial_probe(
 }
 #endif
 
-static int ioc3_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
+static int __devinit ioc3_probe(struct pci_dev *pdev,
+	const struct pci_device_id *ent)
 {
 	unsigned int sw_physid1, sw_physid2;
 	struct net_device *dev = NULL;
_

Patches currently in -mm which might be from ralf@linux-mips.org are

git-mips.patch
mips-replace-remaining-__function__-occurences.patch
alchemy-semi-au1000-pcmcia-driver-convert-pcmcia_sockets_lock-in-a-mutex.patch
ioc3-fix-section-missmatch.patch
mm-try-both-endianess-when-checking-for-endianess.patch
ioc3c-replace-remaining-__function__-occurrences.patch
elf-use-elf_core_eflags-for-kcore-elf-header-flags.patch
asm-futexh-should-include-linux-uaccessh.patch

