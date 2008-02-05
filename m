From: akpm@linux-foundation.org
Subject: - drivers-pcmcia-add-missing-pci_dev_get.patch removed from -mm tree
Date: Tue, 05 Feb 2008 14:27:30 -0800
Message-ID: <200802052227.m15MRBgJ011757@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50768 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932072AbYBEWmt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Feb 2008 17:42:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: julia@diku.dk, mm-commits@vger.kernel.org


The patch titled
     drivers/pcmcia: add missing pci_dev_get
has been removed from the -mm tree.  Its filename was
     drivers-pcmcia-add-missing-pci_dev_get.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
drivers-cpufreq-add-calls-to-cpufreq_cpu_put.patch
arch-powerpc-platforms-pseries-add-missing-of_node_put.patch
arch-powerpc-sysdev-add-missing-of_node_put.patch
arch-powerpc-platforms-82xx-add-missing-of_node_put.patch
git-input.patch
git-mtd.patch
drivers-video-remove-unnecessary-pci_dev_put.patch
drivers-video-add-missing-pci_dev_get.patch
