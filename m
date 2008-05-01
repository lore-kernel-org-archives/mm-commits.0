From: akpm@linux-foundation.org
Subject: - rapidio-fix-current-kernel-doc-notation.patch removed from -mm tree
Date: Thu, 01 May 2008 01:29:56 -0700
Message-ID: <200805010829.m418Tu2i028297@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44217 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754236AbYEAIat (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 May 2008 04:30:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, mm-commits@vger.kernel.org


The patch titled
     rapidio: fix current kernel-doc notation
has been removed from the -mm tree.  Its filename was
     rapidio-fix-current-kernel-doc-notation.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rapidio: fix current kernel-doc notation
From: Randy Dunlap <randy.dunlap@oracle.com>

Fix current (-git16) missing docbook/kernel-doc notation in RapidIO files.

Warning(linux-2.6.25-git16//include/linux/rio.h:187): No description found for parameter 'sys_size'
Warning(linux-2.6.25-git16//include/linux/rio.h:187): No description found for parameter 'phy_type'

Warning(linux-2.6.25-git16//arch/powerpc/sysdev/fsl_rio.c:188): No description found for parameter 'mport'
Warning(linux-2.6.25-git16//arch/powerpc/sysdev/fsl_rio.c:224): No description found for parameter 'mport'
Warning(linux-2.6.25-git16//arch/powerpc/sysdev/fsl_rio.c:245): No description found for parameter 'mport'
Warning(linux-2.6.25-git16//arch/powerpc/sysdev/fsl_rio.c:270): No description found for parameter 'mport'
Warning(linux-2.6.25-git16//arch/powerpc/sysdev/fsl_rio.c:311): No description found for parameter 'mport'
Warning(linux-2.6.25-git16//arch/powerpc/sysdev/fsl_rio.c:996): No description found for parameter 'dev'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/sysdev/fsl_rio.c |    9 +++++++--
 include/linux/rio.h           |    2 ++
 2 files changed, 9 insertions(+), 2 deletions(-)

diff -puN arch/powerpc/sysdev/fsl_rio.c~rapidio-fix-current-kernel-doc-notation arch/powerpc/sysdev/fsl_rio.c
--- a/arch/powerpc/sysdev/fsl_rio.c~rapidio-fix-current-kernel-doc-notation
+++ a/arch/powerpc/sysdev/fsl_rio.c
@@ -176,6 +176,7 @@ struct rio_priv {
 
 /**
  * fsl_rio_doorbell_send - Send a MPC85xx doorbell message
+ * @mport: RapidIO master port info
  * @index: ID of RapidIO interface
  * @destid: Destination ID of target device
  * @data: 16-bit info field of RapidIO doorbell message
@@ -211,6 +212,7 @@ static int fsl_rio_doorbell_send(struct 
 
 /**
  * fsl_local_config_read - Generate a MPC85xx local config space read
+ * @mport: RapidIO master port info
  * @index: ID of RapdiIO interface
  * @offset: Offset into configuration space
  * @len: Length (in bytes) of the maintenance transaction
@@ -232,6 +234,7 @@ static int fsl_local_config_read(struct 
 
 /**
  * fsl_local_config_write - Generate a MPC85xx local config space write
+ * @mport: RapidIO master port info
  * @index: ID of RapdiIO interface
  * @offset: Offset into configuration space
  * @len: Length (in bytes) of the maintenance transaction
@@ -254,6 +257,7 @@ static int fsl_local_config_write(struct
 
 /**
  * fsl_rio_config_read - Generate a MPC85xx read maintenance transaction
+ * @mport: RapidIO master port info
  * @index: ID of RapdiIO interface
  * @destid: Destination ID of transaction
  * @hopcount: Number of hops to target device
@@ -295,6 +299,7 @@ fsl_rio_config_read(struct rio_mport *mp
 
 /**
  * fsl_rio_config_write - Generate a MPC85xx write maintenance transaction
+ * @mport: RapidIO master port info
  * @index: ID of RapdiIO interface
  * @destid: Destination ID of transaction
  * @hopcount: Number of hops to target device
@@ -985,8 +990,8 @@ static inline void fsl_rio_info(struct d
 }
 
 /**
- * fsl_rio_setup - Setup MPC85xx RapidIO interface
- * @fsl_rio_setup - Setup Freescale PowerPC RapidIO interface
+ * fsl_rio_setup - Setup Freescale PowerPC RapidIO interface
+ * @dev: of_device pointer
  *
  * Initializes MPC85xx RapidIO hardware interface, configures
  * master port with system-specific info, and registers the
diff -puN include/linux/rio.h~rapidio-fix-current-kernel-doc-notation include/linux/rio.h
--- a/include/linux/rio.h~rapidio-fix-current-kernel-doc-notation
+++ a/include/linux/rio.h
@@ -161,6 +161,8 @@ enum rio_phy_type {
  * @ops: configuration space functions
  * @id: Port ID, unique among all ports
  * @index: Port index, unique among all port interfaces of the same type
+ * @sys_size: RapidIO common transport system size
+ * @phy_type: RapidIO phy type
  * @name: Port name string
  * @priv: Master port private data
  */
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
basic-braille-screen-reader-support.patch
add-macros-similar-to-min-max-min_t-max_t.patch
infrastructure-to-debug-dynamic-objects.patch
debugobjects-add-documentation.patch
debugobjects-add-timer-specific-object-debugging-code.patch
add-hrtimer-specific-debugobjects-code.patch
sysfs-sysfs_update_group-stub-for-config_sysfs=n.patch
docbook-fix-fatal-rapidio-yet-again-and-more-to-come.patch
docbook-fix-vmalloc-missing-parameter-notation.patch
pnp-fix-printk-format-warnings.patch
pnp-fix-printk-format-warnings-fix.patch
pnp-fix-printk-format-warnings-fix-checkpatch-fixes.patch
x86-fix-setup-printk-format-warning.patch
rapidio-fix-current-kernel-doc-notation.patch
git-kvm.patch
8390-split-8390-support-into-a-pausing-and-a-non-pausing-driver-core.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
git-ocfs2.patch
git-unionfs.patch
fix-gregkh-usb-usb-isp1760-hcd-driver.patch
uwb-fix-kconfig-causing-undefined-references.patch
docbook-some-kernel-locking-fixes.patch
documentation-build-source-files-in-documentation-sub-dir.patch
documentation-build-source-files-in-documentation-sub-dir-disable.patch
profile-likely-unlikely-macros.patch

