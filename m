From: akpm@linux-foundation.org
Subject: [merged] ipmi-fix-platform-return-check.patch removed from -mm tree
Date: Wed, 22 Apr 2009 11:29:31 -0700
Message-ID: <200904221829.n3MITVJb005695@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53896 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753271AbZDVSbV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 22 Apr 2009 14:31:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minyard@acm.org, mm-commits@vger.kernel.org


The patch titled
     ipmi: fix platform return check
has been removed from the -mm tree.  Its filename was
     ipmi-fix-platform-return-check.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ipmi: fix platform return check
From: Corey Minyard <minyard@acm.org>

The wrong return value is being tested when allocating a platform device
in the IPMI SI code.  Check the right value.

Signed-off-by: Corey Minyard <minyard@acm.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/ipmi/ipmi_si_intf.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/char/ipmi/ipmi_si_intf.c~ipmi-fix-platform-return-check drivers/char/ipmi/ipmi_si_intf.c
--- a/drivers/char/ipmi/ipmi_si_intf.c~ipmi-fix-platform-return-check
+++ a/drivers/char/ipmi/ipmi_si_intf.c
@@ -2863,7 +2863,7 @@ static int try_smi_init(struct smi_info 
 		 */
 		new_smi->pdev = platform_device_alloc("ipmi_si",
 						      new_smi->intf_num);
-		if (rv) {
+		if (!new_smi->pdev) {
 			printk(KERN_ERR
 			       "ipmi_si_intf:"
 			       " Unable to allocate platform device\n");
_

Patches currently in -mm which might be from minyard@acm.org are


