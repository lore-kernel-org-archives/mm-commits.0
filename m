From: akpm@linux-foundation.org
Subject: + atl1-fix-4g-memory-corruption-bug.patch added to -mm tree
Date: Thu, 15 May 2008 14:39:16 -0700
Message-ID: <200805152139.m4FLdGCl011799@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52049 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754271AbYEOVju (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 May 2008 17:39:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adobriyan@gmail.com, jacliburn@bellsouth.net


The patch titled
     atl1: fix 4G memory corruption bug
has been added to the -mm tree.  Its filename is
     atl1-fix-4g-memory-corruption-bug.patch

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
Subject: atl1: fix 4G memory corruption bug
From: Alexey Dobriyan <adobriyan@gmail.com>

When using 4+ GB RAM and SWIOTLB is active, the driver corrupts memory by
writing an skb after the relevant DMA page has been unmapped.  Although
this doesn't happen when *not* using bounce buffers, clearing the pointer
to the DMA page after unmapping it fixes the problem.

Signed-off-by: Jay Cliburn <jacliburn@bellsouth.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/atlx/atl1.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/net/atlx/atl1.c~atl1-fix-4g-memory-corruption-bug drivers/net/atlx/atl1.c
--- a/drivers/net/atlx/atl1.c~atl1-fix-4g-memory-corruption-bug
+++ a/drivers/net/atlx/atl1.c
@@ -2023,6 +2023,7 @@ rrd_ok:
 		/* Good Receive */
 		pci_unmap_page(adapter->pdev, buffer_info->dma,
 			       buffer_info->length, PCI_DMA_FROMDEVICE);
+		buffer_info->dma = 0;
 		skb = buffer_info->skb;
 		length = le16_to_cpu(rrd->xsz.xsum_sz.pkt_size);
 
_

Patches currently in -mm which might be from adobriyan@gmail.com are

origin.patch
linux-next.patch
cifs-switch-to-seq_files.patch
git-jfs.patch
git-kbuild-fixes.patch
atl1-fix-4g-memory-corruption-bug.patch
mpt-remove-unused-struct-mpt_proc_entry_t.patch
rndis-switch-to-seq_files.patch
move-proc_kmsg_operations-to-fs-proc-internalh.patch
proc-use-non-racy-method-for-proc-page_owner-creation-page_owner.patch
likely_prof-changed-to-use-proc_create.patch
proc-remove-proc_root-from-drivers-likelyprof.patch

