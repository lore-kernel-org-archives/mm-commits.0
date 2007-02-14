From: akpm@linux-foundation.org
Subject: - git-cifs-fix.patch removed from -mm tree
Date: Tue, 13 Feb 2007 21:49:09 -0800
Message-ID: <200702140549.l1E5n9ML022707@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:42459 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751262AbXBNFtY (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 14 Feb 2007 00:49:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, sfrench@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     git-cifs fix
has been removed from the -mm tree.  Its filename was
     git-cifs-fix.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: git-cifs fix
From: Andrew Morton <akpm@linux-foundation.org>

In file included from fs/cifs/cifsfs.c:39:
fs/cifs/cifspdu.h:2111: error: syntax error before '(' token
In file included from fs/cifs/cifssmb.c:35:
fs/cifs/cifspdu.h:2111: error: syntax error before '(' token

Cc: Steven French <sfrench@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/cifs/cifspdu.h |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff -puN fs/cifs/cifspdu.h~git-cifs-fix fs/cifs/cifspdu.h
--- a/fs/cifs/cifspdu.h~git-cifs-fix
+++ a/fs/cifs/cifspdu.h
@@ -35,9 +35,12 @@
 #define BAD_PROT 0xFFFF
 
 /* SMB command codes */
-/* Some commands have minimal (wct=0,bcc=0), or uninteresting, responses
- (ie which include no useful data other than the SMB error code itself).
- Knowing this helps avoid response buffer allocations and copy in some cases */
+/*
+ * Some commands have minimal (wct=0,bcc=0), or uninteresting, responses
+ * (ie which include no useful data other than the SMB error code itself).
+ * Knowing this helps avoid response buffer allocations and copy in some
+ * cases
+*/
 #define SMB_COM_CREATE_DIRECTORY      0x00 /* trivial response */
 #define SMB_COM_DELETE_DIRECTORY      0x01 /* trivial response */
 #define SMB_COM_CLOSE                 0x04 /* triv req/rsp, timestamp ignored */
@@ -2108,7 +2111,7 @@ typedef struct {
 
 typedef struct {
 	/* reply varies based on requested level */
-} __atribute__((packed)) OPEN_PSX_RSP; /* level 0x209 SetPathInfo data */
+} __attribute__((packed)) OPEN_PSX_RSP; /* level 0x209 SetPathInfo data */
 
 
 struct file_internal_info {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
git-acpi.patch
git-agpgart.patch
git-arm.patch
git-cifs-fix.patch
git-cpufreq.patch
fix-warning-in-device_add_attrs.patch
git-drm.patch
git-dvb.patch
git-dvb-fixup.patch
git-infiniband.patch
sis-warning-fixes.patch
sata_nv-add-back-some-verbosity-into-adma-error_handler-tidy.patch
git-md-accel-fixes.patch
git-md-accel-warning-fixes.patch
git-md-accel-fix.patch
git-mips-fixup.patch
git-mtd.patch
git-ubi.patch
git-netdev-all.patch
revert-drivers-net-tulip-dmfe-support-basic-carrier-detection.patch
git-backlight.patch
git-backlight-sony-fix.patch
git-nfs-fixup.patch
git-sh.patch
revert-md-avoid-possible-bug_on-in-md-bitmap-handling-for-git-block.patch
git-unionfs-fixup.patch
revert-x86_64-mm-msr-on-cpu.patch
x86_64-survive-having-no-irq-mapping-for-a-vector-fix.patch
smaps-add-clear_refs-file-to-clear-reference-fix.patch
fix-rmmod-read-write-races-in-proc-entries-fix.patch
kprobes-list-all-active-probes-in-the-system.patch
mm-shrink-parent-dentries-when-shrinking-slab.patch
add-epoll-compat-code-to-kernel-compatc-tidy.patch
spi-atmel_spi-driver-fix.patch
revert-x86_64-mm-putreg-check.patch
git-gccbug-fixup.patch
