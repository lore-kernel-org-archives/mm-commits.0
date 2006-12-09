From: akpm@osdl.org
Subject: + file-capabilities-honor-secure_noroot.patch added to -mm tree
Date: Fri, 08 Dec 2006 21:55:19 -0800
Message-ID: <200612090555.kB95tJAl017785@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:48121 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759115AbWLIF7B (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sat, 9 Dec 2006 00:59:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: serue@us.ibm.com, chrisw@sous-sol.org, jmorris@namei.org, sds@tycho.nsa.gov


The patch titled
     file capabilities: honor !SECURE_NOROOT
has been added to the -mm tree.  Its filename is
     file-capabilities-honor-secure_noroot.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: file capabilities: honor !SECURE_NOROOT
From: Serge E. Hallyn <serue@us.ibm.com>

When the SECURE_NOROOT securebit is not set, allow root to keep it's
capabilities over exec, rather than compute the capabilities based on file
capabilities.

Signed-off-by: Serge E. Hallyn <serue@us.ibm.com>
Cc: Stephen Smalley <sds@tycho.nsa.gov>
Cc: James Morris <jmorris@namei.org>
Cc: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 security/commoncap.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff -puN security/commoncap.c~file-capabilities-honor-secure_noroot security/commoncap.c
--- a/security/commoncap.c~file-capabilities-honor-secure_noroot
+++ a/security/commoncap.c
@@ -202,12 +202,16 @@ static inline int set_file_caps(struct l
 
 int cap_bprm_set_security (struct linux_binprm *bprm)
 {
+	int ret;
+
 	/* Copied from fs/exec.c:prepare_binprm. */
 
 	cap_clear (bprm->cap_inheritable);
 	cap_clear (bprm->cap_permitted);
 	cap_clear (bprm->cap_effective);
 
+	ret = set_file_caps(bprm);
+
 	/*  To support inheritance of root-permissions and suid-root
 	 *  executables under compatibility mode, we raise all three
 	 *  capability sets for the file.
@@ -225,7 +229,7 @@ int cap_bprm_set_security (struct linux_
 			cap_set_full (bprm->cap_effective);
 	}
 
-	return set_file_caps(bprm);
+	return ret;
 }
 
 void cap_bprm_apply_creds (struct linux_binprm *bprm, int unsafe)
_

Patches currently in -mm which might be from serue@us.ibm.com are

implement-file-posix-capabilities.patch
file-capabilities-dont-do-file-caps-if-mnt_nosuid.patch
file-capabilities-honor-secure_noroot.patch

