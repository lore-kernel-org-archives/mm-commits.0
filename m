From: akpm@linux-foundation.org
Subject: + ipmi-fix-platform-return-check.patch added to -mm tree
Date: Tue, 03 Mar 2009 13:22:29 -0800
Message-ID: <200903032122.n23LMT64004948@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53729 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754396AbZCCVWf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 Mar 2009 16:22:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: minyard@acm.org


The patch titled
     ipmi: fix platform return check
has been added to the -mm tree.  Its filename is
     ipmi-fix-platform-return-check.patch

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

ipmi-fix-platform-return-check.patch
ipmi-test-for-event-buffer-before-using.patch

