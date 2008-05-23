From: akpm@linux-foundation.org
Subject: - restore-multicast-settings-on-resume.patch removed from -mm tree
Date: Fri, 23 May 2008 11:59:29 -0700
Message-ID: <200805231859.m4NIxTsO004243@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34978 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753327AbYEWS7g (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 23 May 2008 14:59:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ranma+kernel@tdiedrich.de, aabdulla@nvidia.com, mm-commits@vger.kernel.org


The patch titled
     forcedeth: restore multicast settings on resume
has been removed from the -mm tree.  Its filename was
     restore-multicast-settings-on-resume.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

git-net.patch
setup-wake-on-lan-before-shutting-down.patch
save-restore-device-configuration-space.patch
reorder-suspend-resume-code.patch

