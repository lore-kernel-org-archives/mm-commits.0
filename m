From: akpm@linux-foundation.org
Subject: - sound-core-memallocc-add-missing-pci_dev_put.patch removed from -mm tree
Date: Tue, 04 Dec 2007 14:11:41 -0800
Message-ID: <200712042211.lB4MBfuD008015@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43187 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753051AbXLDWMb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Dec 2007 17:12:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: julia@diku.dk, perex@suse.cz, tiwai@suse.de, mm-commits@vger.kernel.org


The patch titled
     sound/core/memalloc.c: Add missing pci_dev_put
has been removed from the -mm tree.  Its filename was
     sound-core-memallocc-add-missing-pci_dev_put.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: sound/core/memalloc.c: Add missing pci_dev_put
From: Julia Lawall <julia@diku.dk>

There should be a pci_dev_put when breaking out of a loop that iterates
over calls to pci_get_device and similar functions.

In this case, the return under the initial if needs a pci_dev_put in the
same way that the return under the subsequent for loop has a pci_dev_put.

This was fixed using the following semantic patch.

// <smpl>
@@
type T;
identifier d;
expression e;
@@

T *d;
...
while ((d = \(pci_get_device\|pci_get_device_reverse\|pci_get_subsys\|pci_get_class\)(..., d)) != NULL)
  {... when != pci_dev_put(d)
       when != e = d
(
    return d;
|
+  pci_dev_put(d);
?  return ...;
)
...}
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
Cc: Jaroslav Kysela <perex@suse.cz>
Cc: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 sound/core/memalloc.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN sound/core/memalloc.c~sound-core-memallocc-add-missing-pci_dev_put sound/core/memalloc.c
--- a/sound/core/memalloc.c~sound-core-memallocc-add-missing-pci_dev_put
+++ a/sound/core/memalloc.c
@@ -568,6 +568,7 @@ static ssize_t snd_mem_proc_write(struct
 				if (pci_set_dma_mask(pci, mask) < 0 ||
 				    pci_set_consistent_dma_mask(pci, mask) < 0) {
 					printk(KERN_ERR "snd-page-alloc: cannot set DMA mask %lx for pci %04x:%04x\n", mask, vendor, device);
+					pci_dev_put(pci);
 					return count;
 				}
 			}
_

Patches currently in -mm which might be from julia@diku.dk are

git-alsa.patch
drivers-char-remove-unnecessary-pci_dev_put.patch
arch-ppc-remove-an-unnecessary-pci_dev_put.patch
git-input.patch
git-sparc64.patch
drivers-video-remove-unnecessary-pci_dev_put.patch
