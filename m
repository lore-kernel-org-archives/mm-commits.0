From: akpm@linux-foundation.org
Subject: + oops-increment-the-oops-uuid-every-time-we-oops.patch added to -mm tree
Date: Mon, 24 Nov 2008 16:12:27 -0800
Message-ID: <200811250012.mAP0CRbp016143@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54571 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753542AbYKYANA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 24 Nov 2008 19:13:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: arjan@linux.intel.com


The patch titled
     oops: increment the oops UUID every time we oops
has been added to the -mm tree.  Its filename is
     oops-increment-the-oops-uuid-every-time-we-oops.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: oops: increment the oops UUID every time we oops
From: Arjan van de Ven <arjan@linux.intel.com>

... because we do want repeated same-oops to be seen by automated
tools like kerneloops.org

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/panic.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN kernel/panic.c~oops-increment-the-oops-uuid-every-time-we-oops kernel/panic.c
--- a/kernel/panic.c~oops-increment-the-oops-uuid-every-time-we-oops
+++ a/kernel/panic.c
@@ -300,6 +300,8 @@ static int init_oops_id(void)
 {
 	if (!oops_id)
 		get_random_bytes(&oops_id, sizeof(oops_id));
+	else
+		oops_id++;
 
 	return 0;
 }
_

Patches currently in -mm which might be from arjan@linux.intel.com are

linux-next.patch
scripts-improve-the-decodecode-script.patch
pci-uninline-pci_ioremap_bar.patch
pci-use-pci_ioremap_bar-in-drivers-misc.patch
pci-use-pci_ioremap_bar-in-drivers-serial.patch
pci-use-pci_ioremap_bar-in-drivers-video.patch
pci-use-pci_ioremap_bar-in-drivers-edac.patch
oops-increment-the-oops-uuid-every-time-we-oops.patch
scripts-script-from-kerneloopsorg-to-pretty-print-oops-dumps.patch
vfs-expand-some-comments-d_path-seq_path.patch
resource-allow-mmio-exclusivity-for-device-drivers.patch

