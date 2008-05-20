From: akpm@linux-foundation.org
Subject: + restore-multicast-settings-on-resume.patch added to -mm tree
Date: Tue, 20 May 2008 00:25:43 -0700
Message-ID: <200805200725.m4K7Ph2t010882@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40124 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752514AbYETHZw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 20 May 2008 03:25:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ranma+kernel@tdiedrich.de, aabdulla@nvidia.com


The patch titled
     forcedeth: restore multicast settings on resume
has been added to the -mm tree.  Its filename is
     restore-multicast-settings-on-resume.patch

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
Subject: forcedeth: restore multicast settings on resume
From: Tobias Diedrich <ranma+kernel@tdiedrich.de>

nv_open() resets multicast settings, call nv_set_multicast(dev) to restore
them.  (Maybe this should rather be moved into nv_open())

Signed-off-by: Tobias Diedrich <ranma+kernel@tdiedrich.de>
Cc: Ayaz Abdulla <aabdulla@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/forcedeth.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/net/forcedeth.c~restore-multicast-settings-on-resume drivers/net/forcedeth.c
--- a/drivers/net/forcedeth.c~restore-multicast-settings-on-resume
+++ a/drivers/net/forcedeth.c
@@ -5831,6 +5831,7 @@ static int nv_resume(struct pci_dev *pde
 	writel(txreg, base + NvRegTransmitPoll);
 
 	rc = nv_open(dev);
+	nv_set_multicast(dev);
 out:
 	return rc;
 }
_

Patches currently in -mm which might be from ranma+kernel@tdiedrich.de are

restore-multicast-settings-on-resume.patch
setup-wake-on-lan-before-shutting-down.patch
save-restore-device-configuration-space.patch
reorder-suspend-resume-code.patch

