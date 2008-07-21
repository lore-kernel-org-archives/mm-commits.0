From: akpm@linux-foundation.org
Subject: + lockd-trivial-sparse-endian-annotations.patch added to -mm tree
Date: Sun, 20 Jul 2008 23:41:24 -0700
Message-ID: <200807210641.m6L6fOFi021809@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34677 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756300AbYGUGle (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 21 Jul 2008 02:41:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: harvey.harrison@gmail.com, bfields@fieldses.org


The patch titled
     lockd: trivial sparse endian annotations
has been added to the -mm tree.  Its filename is
     lockd-trivial-sparse-endian-annotations.patch

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
Subject: lockd: trivial sparse endian annotations
From: Harvey Harrison <harvey.harrison@gmail.com>

fs/lockd/svcproc.c:115:11: warning: incorrect type in initializer (different base types)
fs/lockd/svcproc.c:115:11:    expected int [signed] rc
fs/lockd/svcproc.c:115:11:    got restricted __be32 [usertype] <noident>
... and so on...

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Cc: "J. Bruce Fields" <bfields@fieldses.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/lockd/svc4proc.c |    4 ++--
 fs/lockd/svcproc.c  |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff -puN fs/lockd/svc4proc.c~lockd-trivial-sparse-endian-annotations fs/lockd/svc4proc.c
--- a/fs/lockd/svc4proc.c~lockd-trivial-sparse-endian-annotations
+++ a/fs/lockd/svc4proc.c
@@ -83,7 +83,7 @@ nlm4svc_proc_test(struct svc_rqst *rqstp
 {
 	struct nlm_host	*host;
 	struct nlm_file	*file;
-	int rc = rpc_success;
+	__be32 rc = rpc_success;
 
 	dprintk("lockd: TEST4        called\n");
 	resp->cookie = argp->cookie;
@@ -116,7 +116,7 @@ nlm4svc_proc_lock(struct svc_rqst *rqstp
 {
 	struct nlm_host	*host;
 	struct nlm_file	*file;
-	int rc = rpc_success;
+	__be32 rc = rpc_success;
 
 	dprintk("lockd: LOCK          called\n");
 
diff -puN fs/lockd/svcproc.c~lockd-trivial-sparse-endian-annotations fs/lockd/svcproc.c
--- a/fs/lockd/svcproc.c~lockd-trivial-sparse-endian-annotations
+++ a/fs/lockd/svcproc.c
@@ -112,7 +112,7 @@ nlmsvc_proc_test(struct svc_rqst *rqstp,
 {
 	struct nlm_host	*host;
 	struct nlm_file	*file;
-	int rc = rpc_success;
+	__be32 rc = rpc_success;
 
 	dprintk("lockd: TEST          called\n");
 	resp->cookie = argp->cookie;
@@ -146,7 +146,7 @@ nlmsvc_proc_lock(struct svc_rqst *rqstp,
 {
 	struct nlm_host	*host;
 	struct nlm_file	*file;
-	int rc = rpc_success;
+	__be32 rc = rpc_success;
 
 	dprintk("lockd: LOCK          called\n");
 
_

Patches currently in -mm which might be from harvey.harrison@gmail.com are

origin.patch
linux-next.patch
cifs-remove-global_extern-macro.patch
mtd-diskonchipc-fix-sparse-endian-warnings.patch
lockd-trivial-sparse-endian-annotations.patch
pci-procc-sparse-endian-annotations.patch
scsi-replace-remaining-__function__-occurrences.patch
fusion-replace-remaining-__function__-occurrences.patch
scsi-replace-__inline-with-inline.patch
scsi-aic79xx_core-fix-shadowed-variables-add-statics.patch
scsi-aic79xx-aic79xx_pcic-fix-shadowed-variables.patch
xfs-use-get_unaligned_-helpers.patch
xtensa-replace-remaining-__function__-occurences.patch
fs-ldm-use-get_unaligned_-helpers.patch
include-use-get-put_unaligned_-helpers.patch
lzo-use-get-put_unaligned_-helpers.patch
asm-generic-int-ll64h-always-provide-__su64.patch
olpc-olpc_batteryc-sparse-endian-annotations.patch
ecryptfs-cryptoc-use-unaligned-byteorder-helpers.patch
ecryptfs-inodec-mmapc-use-unaligned-byteorder-helpers.patch
scsi-use-the-common-hex_asc-array-rather-than-a-private-one.patch
isdn-use-the-common-ascii-hex-helpers.patch
net-use-the-common-ascii-hex-helpers.patch
cris-use-the-common-ascii-hex-helpers.patch
frv-use-the-common-ascii-hex-helpers.patch
mips-use-the-common-ascii-hex-helpers.patch
ppc-use-the-common-ascii-hex-helpers.patch
ppc-use-the-common-ascii-hex-helpers-fix.patch
mn10300-use-the-common-ascii-hex-helpers.patch
byteorder-add-a-new-include-linux-swabh-to-define-byteswapping-functions.patch
byteorder-add-include-linux-byteorderh-to-define-endian-helpers.patch

