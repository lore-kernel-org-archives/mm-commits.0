From: akpm@linux-foundation.org
Subject: - bnx2x-fix-logical-op.patch removed from -mm tree
Date: Fri, 08 Aug 2008 15:08:20 -0700
Message-ID: <200808082208.m78M8K9O031242@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54327 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765024AbYHHWML (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Aug 2008 18:12:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, eilong@broadcom.com, mm-commits@vger.kernel.org


The patch titled
     bnx2x: fix logical op
has been removed from the -mm tree.  Its filename was
     bnx2x-fix-logical-op.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: bnx2x: fix logical op
From: Randy Dunlap <randy.dunlap@oracle.com>

Fix dubious logical operation that was found by sparse:
linux-next-20080807/drivers/net/bnx2x_main.c:7205:27: warning: dubious: !x & y

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: <eilong@broadcom.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/bnx2x_main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/net/bnx2x_main.c~bnx2x-fix-logical-op drivers/net/bnx2x_main.c
--- a/drivers/net/bnx2x_main.c~bnx2x-fix-logical-op
+++ a/drivers/net/bnx2x_main.c
@@ -7202,7 +7202,7 @@ static void __devinit bnx2x_link_setting
 	bp->link_params.req_flow_ctrl = (bp->port.link_config &
 					 PORT_FEATURE_FLOW_CONTROL_MASK);
 	if ((bp->link_params.req_flow_ctrl == FLOW_CTRL_AUTO) &&
-	    (!bp->port.supported & SUPPORTED_Autoneg))
+	    !(bp->port.supported & SUPPORTED_Autoneg))
 		bp->link_params.req_flow_ctrl = FLOW_CTRL_NONE;
 
 	BNX2X_DEV_INFO("req_line_speed %d  req_duplex %d  req_flow_ctrl 0x%x"
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
gru-fix-preprocessor-symbol-for-sparse.patch
pci-calgary-fix-function-declaration.patch
linux-next.patch
drm-sis-depends-on-fb_sis.patch
genksyms-track-symbol-checksum-changes.patch
genksyms-allow-to-ignore-symbol-checksum-changes.patch
lkdtm-fix-for-config_scsi=n.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
netfilter-conntrack_helper-needs-to-include-rculisth.patch
ftrace-printk-formatting-infrastructure-fix.patch
git-unionfs.patch
docsrc-build-documentation-sources.patch
docsrc-fix-procfs-example.patch
docsrc-fix-ifenslave-type.patch
docsrc-fix-crc32hash-type.patch
docsrc-fix-getdelays-printk-formats.patch
rcu-fix-synchronize_rcu-so-that-kernel-doc-works.patch
w1-documentation-w1-masters-ds2490-update.patch
profile-likely-unlikely-macros.patch

