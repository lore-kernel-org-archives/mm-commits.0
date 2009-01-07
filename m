From: akpm@linux-foundation.org
Subject: - oops-increment-the-oops-uuid-every-time-we-oops.patch removed from -mm tree
Date: Wed, 07 Jan 2009 14:15:39 -0800
Message-ID: <200901072215.n07MFdjU015433@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44224 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752388AbZAGWPl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Jan 2009 17:15:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arjan@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     oops: increment the oops UUID every time we oops
has been removed from the -mm tree.  Its filename was
     oops-increment-the-oops-uuid-every-time-we-oops.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -299,6 +299,8 @@ static int init_oops_id(void)
 {
 	if (!oops_id)
 		get_random_bytes(&oops_id, sizeof(oops_id));
+	else
+		oops_id++;
 
 	return 0;
 }
_

Patches currently in -mm which might be from arjan@linux.intel.com are

origin.patch
linux-next.patch
pci-use-pci_ioremap_bar-in-drivers-serial.patch

