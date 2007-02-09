From: akpm@linux-foundation.org
Subject: + git-cifs-fix.patch added to -mm tree
Date: Thu, 08 Feb 2007 16:47:05 -0800
Message-ID: <200702090048.l190mCBN032543@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:47452 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423187AbXBIAsT (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 8 Feb 2007 19:48:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, sfrench@us.ibm.com


The patch titled
     git-cifs fix
has been added to the -mm tree.  Its filename is
     git-cifs-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
acpi-bay-driver-warning-fix.patch
fix-warning-in-device_add_attrs.patch
git-dvb.patch
kthread-api-conversion-for-dvb_frontend-and-av7110-fix.patch
git-libata-all.patch
sis-warning-fixes.patch
git-libata-all-lib-iomapc-fix-for-config_pci=n.patch
git-md-accel-fixes.patch
git-md-accel-warning-fixes.patch
revert-drivers-net-tulip-dmfe-support-basic-carrier-detection.patch
git-net.patch
git-backlight-acpi-fix.patch
git-sh.patch
git-scsi-misc.patch
git-scsi-misc-fixup.patch
revert-md-avoid-possible-bug_on-in-md-bitmap-handling-for-git-block.patch
git-block.patch
x86_64-survive-having-no-irq-mapping-for-a-vector-fix.patch
git-cryptodev-fixup.patch
mm-vm_insert_pfn-tidy.patch
swiotlb-uninlinings.patch
knfsd-sunrpc-teach-svc_sendto-to-deal-with-ipv6-addresses-tidy.patch
knfsd-sunrpc-support-ipv6-addresses-in-rpc-servers-udp-receive-path-tidy.patch
revert-x86_64-mm-putreg-check.patch
fix-utrace-utrace-ptrace-compat.patch
deprecate-sa_interrupt-and-friends.patch
git-backlight-progearbl-fix.patch
git-cifs-fix.patch
