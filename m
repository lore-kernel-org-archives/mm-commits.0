From: akpm@linux-foundation.org
Subject: - tridentfb-remove-warning-message-that-cyblafb-driver-should-be-used.patch removed from -mm tree
Date: Thu, 24 Jul 2008 16:31:37 -0700
Message-ID: <200807242331.m6ONVbeT011651@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48721 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756373AbYGXXbj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Jul 2008 19:31:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: krzysztof.h1@wp.pl, mm-commits@vger.kernel.org


The patch titled
     tridentfb: remove warning message that cyblafb driver should be used
has been removed from the -mm tree.  Its filename was
     tridentfb-remove-warning-message-that-cyblafb-driver-should-be-used.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: tridentfb: remove warning message that cyblafb driver should be used
From: Krzysztof Helt <krzysztof.h1@wp.pl>

The tridentfb driver should handle now all chipsets handled by the cyblafb
driver.  Remove the message which claims that support will be removed.

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/tridentfb.c |    4 ----
 1 file changed, 4 deletions(-)

diff -puN drivers/video/tridentfb.c~tridentfb-remove-warning-message-that-cyblafb-driver-should-be-used drivers/video/tridentfb.c
--- a/drivers/video/tridentfb.c~tridentfb-remove-warning-message-that-cyblafb-driver-should-be-used
+++ a/drivers/video/tridentfb.c
@@ -1359,10 +1359,6 @@ static int __devinit trident_pci_probe(s
 
 	chip_id = id->device;
 
-	if (chip_id == CYBERBLADEi1)
-		output("*** Please do use cyblafb, Cyberblade/i1 support "
-		       "will soon be removed from tridentfb!\n");
