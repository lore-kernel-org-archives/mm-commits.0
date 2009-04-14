From: akpm@linux-foundation.org
Subject: [merged] efifb-exit-if-framebuffer-address-is-invalid.patch removed from -mm tree
Date: Tue, 14 Apr 2009 12:48:46 -0700
Message-ID: <200904141948.n3EJmkn9019228@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57582 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754220AbZDNTxq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 14 Apr 2009 15:53:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mjg59@srcf.ucam.org, krzysztof.h1@poczta.fm, mjg@redhat.com, pjones@redhat.com, mm-commits@vger.kernel.org


The patch titled
     efifb: exit if framebuffer address is invalid
has been removed from the -mm tree.  Its filename was
     efifb-exit-if-framebuffer-address-is-invalid.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: efifb: exit if framebuffer address is invalid
From: Matthew Garrett <mjg59@srcf.ucam.org>

efifb will attempt to ioremap a framebuffer even if its starting address
is 0, failing and causing an ugly backtrace in the process.  Exit before
probing if this is the case.

Signed-off-by: Matthew Garrett <mjg@redhat.com>
Acked-by: Peter Jones <pjones@redhat.com>
Cc: Krzysztof Helt <krzysztof.h1@poczta.fm>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/efifb.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff -puN drivers/video/efifb.c~efifb-exit-if-framebuffer-address-is-invalid drivers/video/efifb.c
--- a/drivers/video/efifb.c~efifb-exit-if-framebuffer-address-is-invalid
+++ a/drivers/video/efifb.c
@@ -210,12 +210,15 @@ static int __init efifb_probe(struct pla
 	unsigned int size_total;
 	int request_succeeded = 0;
 
-	printk(KERN_INFO "efifb: probing for efifb\n");
