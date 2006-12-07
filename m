From: akpm@osdl.org
Subject: - i2o-handle-__copy_from_user.patch removed from -mm tree
Date: Thu, 07 Dec 2006 15:06:04 -0800
Message-ID: <200612072306.kB7N64fS030209@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:52659 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163794AbWLGXGi (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 18:06:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, Markus.Lidel@shadowconnect.com, mm-commits@vger.kernel.org


The patch titled
     I2O: handle __copy_from_user
has been removed from the -mm tree.  Its filename was
     i2o-handle-__copy_from_user.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: I2O: handle __copy_from_user
From: Randy Dunlap <randy.dunlap@oracle.com>

Handle __copy_from_user() return value.

Noticed by inspection, not from build warning.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Markus Lidel <Markus.Lidel@shadowconnect.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/message/i2o/i2o_config.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff -puN drivers/message/i2o/i2o_config.c~i2o-handle-__copy_from_user drivers/message/i2o/i2o_config.c
--- a/drivers/message/i2o/i2o_config.c~i2o-handle-__copy_from_user
+++ a/drivers/message/i2o/i2o_config.c
@@ -265,7 +265,11 @@ static int i2o_cfg_swdl(unsigned long ar
 		return -ENOMEM;
 	}
 
-	__copy_from_user(buffer.virt, kxfer.buf, fragsize);
+	if (__copy_from_user(buffer.virt, kxfer.buf, fragsize)) {
+		i2o_msg_nop(c, msg);
+		i2o_dma_free(&c->pdev->dev, &buffer);
+		return -EFAULT;
+	}
 
 	msg->u.head[0] = cpu_to_le32(NINE_WORD_MSG_SIZE | SGL_OFFSET_7);
 	msg->u.head[1] =
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
git-acpi.patch
git-alsa.patch
cpufreq-select-consistently-re-2619-rc5-mm1.patch
git-ieee1394.patch
git-input.patch
git-mtd.patch
mtd-esb2rom-uses-pci.patch
parisc-fix-module_param-iommu-permission.patch
scsi-advansys-wrap-pci-table-inside-ifdef-config_pci.patch
generic-bug-implementation-handle-bug=n.patch
reiser4-use-null-for-pointers.patch
visws-sgivwfb-is-module-needs-exports.patch
linux-fbdev-devel-is-subscribers-only.patch
extend-notifier_call_chain-to-count-nr_calls-made-fixes.patch
kvm-fix-null-and-c99-init-sparse-warnings.patch
profile_likely-export-do_check_likely.patch

