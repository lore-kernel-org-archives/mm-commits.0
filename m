From: akpm@linux-foundation.org
Subject: - uml-pcap-devices-should-get-macs-from-command-line.patch removed from -mm tree
Date: Tue, 08 May 2007 19:55:44 -0700
Message-ID: <200705090255.l492tiMT009960@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:38926 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1032352AbXEICzr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 22:55:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jdike@addtoit.com, blaisorblade@yahoo.it, jdike@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     uml: pcap devices should get MACs from command line
has been removed from the -mm tree.  Its filename was
     uml-pcap-devices-should-get-macs-from-command-line.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: uml: pcap devices should get MACs from command line
From: Jeff Dike <jdike@addtoit.com>

Allow a pcap device to be assigned a MAC on the command line.  They don't
really need one, but it is handy to be able to do when your distro assigns a
new ethernet device whenever it sees a new MAC.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Cc: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/drivers/pcap_kern.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/um/drivers/pcap_kern.c~uml-pcap-devices-should-get-macs-from-command-line arch/um/drivers/pcap_kern.c
--- a/arch/um/drivers/pcap_kern.c~uml-pcap-devices-should-get-macs-from-command-line
+++ a/arch/um/drivers/pcap_kern.c
@@ -70,7 +70,7 @@ int pcap_setup(char *str, char **mac_out
 		  .filter 	= NULL });
 
 	remain = split_if_spec(str, &host_if, &init->filter,
-			       &options[0], &options[1], NULL);
+			       &options[0], &options[1], mac_out, NULL);
 	if(remain != NULL){
 		printk(KERN_ERR "pcap_setup - Extra garbage on "
 		       "specification : '%s'\n", remain);
_

Patches currently in -mm which might be from jdike@addtoit.com are

origin.patch
uml-fix-build-breakage.patch
uml-mark-a-tt-only-function.patch
fix-linuxdoc-comment.patch
