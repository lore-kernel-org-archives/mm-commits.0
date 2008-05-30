From: akpm@linux-foundation.org
Subject: + cxgb3-fix-build-error-when-inet=n.patch added to -mm tree
Date: Fri, 30 May 2008 13:37:19 -0700
Message-ID: <200805302037.m4UKbJDp010279@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42437 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752653AbYE3Uht (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 30 May 2008 16:37:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, divy@chelsio.com, jeff@garzik.org, sfr@canb.auug.org.au


The patch titled
     cxgb3: fix build error when INET=n
has been added to the -mm tree.  Its filename is
     cxgb3-fix-build-error-when-inet=n.patch

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
Subject: cxgb3: fix build error when INET=n
From: Randy Dunlap <randy.dunlap@oracle.com>

cxgb3 uses lro_* functions and selects INET_LRO, but this doesn't help unless
INET is already enabled, so make the driver depend on INET also.

sge.c:(.text+0x9f09a): undefined reference to `lro_flush_all'
sge.c:(.text+0x9f62f): undefined reference to `lro_receive_skb'
sge.c:(.text+0x9f8a3): undefined reference to `lro_receive_frags'
sge.c:(.text+0x9fbe0): undefined reference to `lro_vlan_hwaccel_receive_skb'
sge.c:(.text+0x9ffcd): undefined reference to `lro_vlan_hwaccel_receive_frags'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Divy Le Ray <divy@chelsio.com>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/net/Kconfig~cxgb3-fix-build-error-when-inet=n drivers/net/Kconfig
--- a/drivers/net/Kconfig~cxgb3-fix-build-error-when-inet=n
+++ a/drivers/net/Kconfig
@@ -2407,7 +2407,7 @@ config CHELSIO_T1_NAPI
 
 config CHELSIO_T3
 	tristate "Chelsio Communications T3 10Gb Ethernet support"
-	depends on PCI
+	depends on PCI && INET
 	select FW_LOADER
 	select INET_LRO
 	help
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

linux-next.patch
fix-gregkh-driver-block-make-proc-files-seq_start-use-the-class_find_device.patch
documentation-build-source-files-in-documentation-sub-dir.patch
documentation-build-source-files-in-documentation-sub-dir-disable.patch
8390-split-8390-support-into-a-pausing-and-a-non-pausing-driver-core.patch
3c515-fix-using-pnp_get_resource-when-config_isapnp=n.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
netfilter-conntrack_helper-needs-to-include-rculisth.patch
git-scsi-misc-fix-scsi_dh-build-errors.patch
git-unionfs.patch
uwb-fix-kconfig-causing-undefined-references.patch
audit-fix-kernel-doc-parameter-notation.patch
cxgb3-fix-build-error-when-inet=n.patch
flag-parameters-signalfd-fix.patch
flag-parameters-eventfd-fix.patch
bsdacct-stir-up-comments-around-acct_process.patch
profile-likely-unlikely-macros.patch

