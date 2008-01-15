From: akpm@linux-foundation.org
Subject: + drivers-pcmcia-add-missing-pci_dev_get.patch added to -mm tree
Date: Tue, 15 Jan 2008 01:23:29 -0800
Message-ID: <200801150923.m0F9N9dw008702@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39786 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751912AbYAOJXU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Jan 2008 04:23:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: julia@diku.dk


The patch titled
     drivers/pcmcia: add missing pci_dev_get
has been added to the -mm tree.  Its filename is
     drivers-pcmcia-add-missing-pci_dev_get.patch

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
Subject: drivers/pcmcia: add missing pci_dev_get
From: Julia Lawall <julia@diku.dk>

pci_get_slot does a pci_dev_get, so pci_dev_put needs to be called in an
error case.

An extract of the semantic match used to find the problem is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@@
type find1.T,T1,T2;
identifier find1.E;
statement find1.S;
expression x1,x2,x3;
expression find1.test;
int ret != 0;
@@

  T E;
  ...
(
* E = pci_get_slot(...);
  if (E == NULL) S
|
* if ((E = pci_get_slot(...)) == NULL)
  S
)
  ... when != pci_dev_put(...,(T1)E,...)
      when != if (E != NULL) { ... pci_dev_put(...,(T1)E,...); ...}
      when != x1 = (T1)E
      when != E = x3;
      when any
  if (test) {
    ... when != pci_dev_put(...,(T2)E,...)
        when != if (E != NULL) { ... pci_dev_put(...,(T2)E,...); ...}
        when != x2 = (T2)E
(
*   return;
|
*   return ret;
)
  }
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pcmcia/cardbus.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN drivers/pcmcia/cardbus.c~drivers-pcmcia-add-missing-pci_dev_get drivers/pcmcia/cardbus.c
--- a/drivers/pcmcia/cardbus.c~drivers-pcmcia-add-missing-pci_dev_get
+++ a/drivers/pcmcia/cardbus.c
@@ -143,7 +143,7 @@ int read_cb_mem(struct pcmcia_socket * s
 	/* Config space? */
 	if (space == 0) {
 		if (addr + len > 0x100)
-			goto fail;
+			goto failput;
 		for (; len; addr++, ptr++, len--)
 			pci_read_config_byte(dev, addr, ptr);
 		return 0;
@@ -171,6 +171,8 @@ int read_cb_mem(struct pcmcia_socket * s
 	memcpy_fromio(ptr, s->cb_cis_virt + addr, len);
 	return 0;
 
+failput:
+	pci_dev_put(dev);
 fail:
 	memset(ptr, 0xff, len);
 	return -1;
_

Patches currently in -mm which might be from julia@diku.dk are

git-alsa.patch
git-agpgart.patch
git-powerpc.patch
arch-powerpc-platforms-pseries-add-missing-of_node_put.patch
arch-powerpc-sysdev-add-missing-of_node_put.patch
arch-powerpc-platforms-82xx-add-missing-of_node_put.patch
drivers-media-radio-use-video_device_release-rather-than-kfree.patch
drivers-media-common-add-missing-video_device_release.patch
git-input.patch
git-mtd.patch
git-net.patch
drivers-pcmcia-add-missing-iounmap.patch
drivers-pcmcia-add-missing-pci_dev_get.patch
git-x86.patch
arch-cris-added-a-missing-iounmap.patch
drivers-video-remove-unnecessary-pci_dev_put.patch
