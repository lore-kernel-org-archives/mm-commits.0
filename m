From: akpm@linux-foundation.org
Subject: + sysctl-remove-the-proc_dir_entry-member-for-the-sysctl-tables-fix-3-fix.patch added to -mm tree
Date: Wed, 07 Feb 2007 16:27:17 -0800
Message-ID: <200702080028.l180SMBW032617@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:47597 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422828AbXBHA21 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 7 Feb 2007 19:28:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, ebiederm@xmission.com, jmorris@namei.org, sds@tycho.nsa.gov


The patch titled
     sysctl-remove-the-proc_dir_entry-member-for-the-sysctl-tables-fix-3-fix
has been added to the -mm tree.  Its filename is
     sysctl-remove-the-proc_dir_entry-member-for-the-sysctl-tables-fix-3-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: sysctl-remove-the-proc_dir_entry-member-for-the-sysctl-tables-fix-3-fix
From: Andrew Morton <akpm@linux-foundation.org>

security/selinux/hooks.c: In function 'selinux_proc_get_sid':
security/selinux/hooks.c:826: error: label 'out_free' used but not defined

Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Stephen Smalley <sds@tycho.nsa.gov>
Cc: James Morris <jmorris@namei.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 security/selinux/hooks.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN security/selinux/hooks.c~sysctl-remove-the-proc_dir_entry-member-for-the-sysctl-tables-fix-3-fix security/selinux/hooks.c
--- a/security/selinux/hooks.c~sysctl-remove-the-proc_dir_entry-member-for-the-sysctl-tables-fix-3-fix
+++ a/security/selinux/hooks.c
@@ -798,7 +798,8 @@ static int selinux_proc_get_sid(struct p
 				u16 tclass,
 				u32 *sid)
 {
-	int buflen, rc;
+	int buflen;
+	int rc = -ENOMEM;
 	char *buffer, *path, *end;
 
 	buffer = (char*)__get_free_page(GFP_KERNEL);
@@ -828,6 +829,7 @@ static int selinux_proc_get_sid(struct p
 	memcpy(end, "/sys", 4);
 	path = end;
 	rc = security_genfs_sid("proc", path, tclass, sid);
+out_free:
 	free_page((unsigned long)buffer);
 	return rc;
 }
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
fix-warning-in-device_add_attrs.patch
git-dvb.patch
kthread-api-conversion-for-dvb_frontend-and-av7110-fix.patch
git-libata-all.patch
sis-warning-fixes.patch
git-md-accel-fixes.patch
git-md-accel-warning-fixes.patch
git-netdev-all.patch
revert-drivers-net-tulip-dmfe-support-basic-carrier-detection.patch
git-sh.patch
git-block.patch
git-cryptodev-fixup.patch
mm-vm_insert_pfn-tidy.patch
swiotlb-uninlinings.patch
spi-filesystem-api-tweaks.patch
knfsd-sunrpc-teach-svc_sendto-to-deal-with-ipv6-addresses-tidy.patch
knfsd-sunrpc-support-ipv6-addresses-in-rpc-servers-udp-receive-path-tidy.patch
fix-utrace-utrace-ptrace-compat.patch
sysctl-remove-the-proc_dir_entry-member-for-the-sysctl-tables-fix-3-fix.patch
