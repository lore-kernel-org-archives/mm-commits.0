From: akpm@linux-foundation.org
Subject: - implement-file-posix-capabilities-update.patch removed from -mm tree
Date: Fri, 08 Jun 2007 11:45:23 -0700
Message-ID: <200706081845.l58IjNNi008303@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57067 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S969733AbXFHSpm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Jun 2007 14:45:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: serge@hallyn.com, chrisw@sous-sol.org, jmorris@namei.org, sds@tycho.nsa.gov, serue@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     implement-file-posix-capabilities update
has been removed from the -mm tree.  Its filename was
     implement-file-posix-capabilities-update.patch

This patch was dropped because it was folded into implement-file-posix-capabilities.patch

------------------------------------------------------
Subject: implement-file-posix-capabilities update
From: "Serge E. Hallyn" <serge@hallyn.com>

So here is a new consolidated patch without the STRICTXATTR config
option.

Signed-off-by: Serge E. Hallyn <serue@us.ibm.com>
Cc: Stephen Smalley <sds@tycho.nsa.gov>
Cc: James Morris <jmorris@namei.org>
Cc: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 security/Kconfig     |   10 --------
 security/commoncap.c |   51 ++---------------------------------------
 2 files changed, 3 insertions(+), 58 deletions(-)

diff -puN security/Kconfig~implement-file-posix-capabilities-update security/Kconfig
--- a/security/Kconfig~implement-file-posix-capabilities-update
+++ a/security/Kconfig
@@ -90,16 +90,6 @@ config SECURITY_FILE_CAPABILITIES
 
 	  If in doubt, answer N.
 
-config SECURITY_FILE_CAPABILITIES_STRICTXATTR
-	bool "Refuse to run files with unknown caps"
-	depends on SECURITY_FILE_CAPABILITIES
-	default y
-	help
-	  Refuse to run files which have unknown capabilities set
-	  in the security.capability xattr.  This could prevent
-	  running important binaries from an updated distribution
-	  on an older kernel.
-
 config SECURITY_ROOTPLUG
 	tristate "Root Plug Support"
 	depends on USB && SECURITY
diff -puN security/commoncap.c~implement-file-posix-capabilities-update security/commoncap.c
--- a/security/commoncap.c~implement-file-posix-capabilities-update
+++ a/security/commoncap.c
@@ -111,51 +111,10 @@ void cap_capset_set (struct task_struct 
 
 #ifdef CONFIG_SECURITY_FILE_CAPABILITIES
 
-#ifdef CONFIG_SECURITY_FILE_CAPABILITIES_STRICTXATTR
-static int check_cap_sanity(struct vfs_cap_data_disk *dcap, int size)
-{
-	int word, bit;
-	u32 eff, inh, perm;
-	int sz = (size-1)/3;
-
-	word = CAP_NUMCAPS / 32;
-	bit = CAP_NUMCAPS % 32;
-
-	eff  = le32_to_cpu(dcap->data[3*word]);
-	perm = le32_to_cpu(dcap->data[3*word+1]);
-	inh  = le32_to_cpu(dcap->data[3*word+2]);
-
-	while (word < sz) {
-		if (bit == 32) {
-			bit = 0;
-			word++;
-			if (word >= sz)
-				break;
-			eff  = le32_to_cpu(dcap->data[3*word]);
-			perm = le32_to_cpu(dcap->data[3*word+1]);
-			inh  = le32_to_cpu(dcap->data[3*word+2]);
-			continue;
-		}
-		if (eff & CAP_TO_MASK(bit))
-			return -EINVAL;
-		if (inh & CAP_TO_MASK(bit))
-			return -EINVAL;
-		if (perm & CAP_TO_MASK(bit))
-			return -EINVAL;
-		bit++;
-	}
-
-	return 0;
-}
-#else
-static int check_cap_sanity(struct vfs_cap_data_disk *dcap, int sz)
-{ return 0; }
-#endif
-
 static inline int cap_from_disk(struct vfs_cap_data_disk *dcap,
 					struct linux_binprm *bprm, int size)
 {
-	int rc, version;
+	int version;
 
 	version = le32_to_cpu(dcap->version);
 	if (version != _LINUX_CAPABILITY_VERSION)
@@ -163,15 +122,11 @@ static inline int cap_from_disk(struct v
 
 	size /= sizeof(u32);
 	if ((size-1)%3) {
-		printk(KERN_WARNING "%s: size is an invalid size (%d)\n",
-						__FUNCTION__, size);
+		printk(KERN_WARNING "%s: size is an invalid size %d for %s\n",
+						__FUNCTION__, size, bprm->filename);
 		return -EINVAL;
 	}
 
-	rc = check_cap_sanity(dcap, size);
-	if (rc)
-		return rc;
-
 	bprm->cap_effective = le32_to_cpu(dcap->data[0]);
 	bprm->cap_permitted = le32_to_cpu(dcap->data[1]);
 	bprm->cap_inheritable = le32_to_cpu(dcap->data[2]);
_

Patches currently in -mm which might be from serge@hallyn.com are

implement-file-posix-capabilities.patch
implement-file-posix-capabilities-update.patch
