From: akpm@linux-foundation.org
Subject: - compat_ioctl-handle-block=n-scsi=n.patch removed from -mm tree
Date: Wed, 16 Jul 2008 14:35:38 -0700
Message-ID: <200807162135.m6GLZcpp014109@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53198 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756486AbYGPVhz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 Jul 2008 17:37:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, James.Bottomley@HansenPartnership.com, jens.axboe@oracle.com, mm-commits@vger.kernel.org


The patch titled
     compat_ioctl: handle BLOCK=n, SCSI=n
has been removed from the -mm tree.  Its filename was
     compat_ioctl-handle-block=n-scsi=n.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: compat_ioctl: handle BLOCK=n, SCSI=n
From: Randy Dunlap <randy.dunlap@oracle.com>

Fix fs/compat_ioctl.c to handle CONFIG_BLOCK=n, CONFIG_SCSI=n
to avoid build errors:

In file included from linux-next-20080708/include/scsi/scsi.h:12,
                 from linux-next-20080708/fs/compat_ioctl.c:71:
linux-next-20080708/include/scsi/scsi_cmnd.h:27:25: warning: "BLK_MAX_CDB" is not defined
linux-next-20080708/include/scsi/scsi_cmnd.h:28:3: error: #error MAX_COMMAND_SIZE can not be bigger than BLK_MAX_CDB
In file included from linux-next-20080708/include/scsi/scsi.h:12,
                 from linux-next-20080708/fs/compat_ioctl.c:71:
linux-next-20080708/include/scsi/scsi_cmnd.h: In function 'scsi_bidi_cmnd':
linux-next-20080708/include/scsi/scsi_cmnd.h:182: error: implicit declaration of function 'blk_bidi_rq'
linux-next-20080708/include/scsi/scsi_cmnd.h:183: error: dereferencing pointer to incomplete type
linux-next-20080708/include/scsi/scsi_cmnd.h: In function 'scsi_in':
linux-next-20080708/include/scsi/scsi_cmnd.h:189: error: dereferencing pointer to incomplete type

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/compat_ioctl.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN fs/compat_ioctl.c~compat_ioctl-handle-block=n-scsi=n fs/compat_ioctl.c
--- a/fs/compat_ioctl.c~compat_ioctl-handle-block=n-scsi=n
+++ a/fs/compat_ioctl.c
@@ -68,9 +68,11 @@
 #include <linux/capi.h>
 #include <linux/gigaset_dev.h>
 
+#ifdef CONFIG_BLOCK
 #include <scsi/scsi.h>
 #include <scsi/scsi_ioctl.h>
 #include <scsi/sg.h>
+#endif
 
 #include <asm/uaccess.h>
 #include <linux/ethtool.h>
@@ -1965,6 +1967,7 @@ COMPATIBLE_IOCTL(GIO_UNISCRNMAP)
 COMPATIBLE_IOCTL(PIO_UNISCRNMAP)
 COMPATIBLE_IOCTL(PIO_FONTRESET)
 COMPATIBLE_IOCTL(PIO_UNIMAPCLR)
+#ifdef CONFIG_BLOCK
 /* Big S */
 COMPATIBLE_IOCTL(SCSI_IOCTL_GET_IDLUN)
 COMPATIBLE_IOCTL(SCSI_IOCTL_DOORLOCK)
@@ -1974,6 +1977,7 @@ COMPATIBLE_IOCTL(SCSI_IOCTL_GET_BUS_NUMB
 COMPATIBLE_IOCTL(SCSI_IOCTL_SEND_COMMAND)
 COMPATIBLE_IOCTL(SCSI_IOCTL_PROBE_HOST)
 COMPATIBLE_IOCTL(SCSI_IOCTL_GET_PCI)
+#endif
 /* Big T */
 COMPATIBLE_IOCTL(TUNSETNOCSUM)
 COMPATIBLE_IOCTL(TUNSETDEBUG)
@@ -2044,6 +2048,7 @@ COMPATIBLE_IOCTL(SIOCGIFVLAN)
 COMPATIBLE_IOCTL(SIOCSIFVLAN)
 COMPATIBLE_IOCTL(SIOCBRADDBR)
 COMPATIBLE_IOCTL(SIOCBRDELBR)
+#ifdef CONFIG_BLOCK
 /* SG stuff */
 COMPATIBLE_IOCTL(SG_SET_TIMEOUT)
 COMPATIBLE_IOCTL(SG_GET_TIMEOUT)
@@ -2068,6 +2073,7 @@ COMPATIBLE_IOCTL(SG_SCSI_RESET)
 COMPATIBLE_IOCTL(SG_GET_REQUEST_TABLE)
 COMPATIBLE_IOCTL(SG_SET_KEEP_ORPHAN)
 COMPATIBLE_IOCTL(SG_GET_KEEP_ORPHAN)
+#endif
 /* PPP stuff */
 COMPATIBLE_IOCTL(PPPIOCGFLAGS)
 COMPATIBLE_IOCTL(PPPIOCSFLAGS)
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
linux-next.patch
acpi-utmisc-use-warn_on-instead-of-warn_on_slowpath.patch
documentation-build-source-files-in-documentation-sub-dir.patch
documentation-build-source-files-in-documentation-sub-dir-disable.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
firmware-fix-memmap-printk-format-warnings.patch
netfilter-conntrack_helper-needs-to-include-rculisth.patch
lkdtm-fix-for-config_scsi=n.patch
git-unionfs.patch
vmallocinfo-add-numa-information.patch
vmallocinfo-add-numa-information-fix.patch
pm-remove-obsolete-piece-of-pm-documentation-rev-2.patch
init-versionc-silenced-sparse-warning-by-declaring-the-version-string.patch
init-versionc-define-version_string-only-if-config_kallsyms-is-not-defined.patch
flag-parameters-signalfd-fix.patch
flag-parameters-eventfd-fix.patch
kallsyms-unify-32-and-64-bit-code.patch
procfs-guide-drop-pointless-nbsp-entities.patch
bsdacct-stir-up-comments-around-acct_process.patch
documentation-cleanup-trivial-misspelling-punctuation-and-grammar-corrections.patch
profile-likely-unlikely-macros.patch

