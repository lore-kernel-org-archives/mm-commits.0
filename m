From: akpm@osdl.org
Subject: - knfsd-replace-some-warning-ins-nfsfhh-with-bug_on-or-warn_on.patch removed from -mm tree
Date: Fri, 26 Jan 2007 17:31:50 -0800
Message-ID: <200701270131.l0R1VowQ031864@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:35692 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752258AbXA0BfR (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 26 Jan 2007 20:35:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: neilb@suse.de, bunk@stusta.de, mm-commits@vger.kernel.org


The patch titled
     knfsd: replace some warning ins nfsfh.h with BUG_ON or WARN_ON
has been removed from the -mm tree.  Its filename was
     knfsd-replace-some-warning-ins-nfsfhh-with-bug_on-or-warn_on.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: knfsd: replace some warning ins nfsfh.h with BUG_ON or WARN_ON
From: NeilBrown <neilb@suse.de>

A couple of the warnings will be followed by an Oops if they ever fire, so may
as well be BUG_ON.  Another isn't obviously fatal but has never been known to
fire, so make it a WARN_ON.

Cc: Adrian Bunk <bunk@stusta.de>
Signed-off-by: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 include/linux/nfsd/nfsfh.h |   15 ++++-----------
 1 file changed, 4 insertions(+), 11 deletions(-)

diff -puN include/linux/nfsd/nfsfh.h~knfsd-replace-some-warning-ins-nfsfhh-with-bug_on-or-warn_on include/linux/nfsd/nfsfh.h
--- a/include/linux/nfsd/nfsfh.h~knfsd-replace-some-warning-ins-nfsfhh-with-bug_on-or-warn_on
+++ a/include/linux/nfsd/nfsfh.h
@@ -217,11 +217,7 @@ void	fh_put(struct svc_fh *);
 static __inline__ struct svc_fh *
 fh_copy(struct svc_fh *dst, struct svc_fh *src)
 {
-	if (src->fh_dentry || src->fh_locked) {
-		struct dentry *dentry = src->fh_dentry;
-		printk(KERN_ERR "fh_copy: copying %s/%s, already verified!\n",
-			dentry->d_parent->d_name.name, dentry->d_name.name);
-	}
+	WARN_ON(src->fh_dentry || src->fh_locked);
 			
 	*dst = *src;
 	return dst;
@@ -300,10 +296,8 @@ fh_lock_nested(struct svc_fh *fhp, unsig
 	dfprintk(FILEOP, "nfsd: fh_lock(%s) locked = %d\n",
 			SVCFH_fmt(fhp), fhp->fh_locked);
 
-	if (!fhp->fh_dentry) {
-		printk(KERN_ERR "fh_lock: fh not verified!\n");
-		return;
-	}
+	BUG_ON(!dentry);
+
 	if (fhp->fh_locked) {
 		printk(KERN_WARNING "fh_lock: %s/%s already locked!\n",
 			dentry->d_parent->d_name.name, dentry->d_name.name);
@@ -328,8 +322,7 @@ fh_lock(struct svc_fh *fhp)
 static inline void
 fh_unlock(struct svc_fh *fhp)
 {
-	if (!fhp->fh_dentry)
-		printk(KERN_ERR "fh_unlock: fh not verified!\n");
+	BUG_ON(!fhp->fh_dentry);
 
 	if (fhp->fh_locked) {
 		fill_post_wcc(fhp);
_

Patches currently in -mm which might be from neilb@suse.de are

origin.patch
use-correct-macros-in-raid-code-not-raw-asm.patch
use-correct-macros-in-raid-code-not-raw-asm-include.patch
igrab-should-check-for-i_clear.patch
replace-highest_possible_node_id-with-nr_node_ids.patch
knfsd-sunrpc-update-internal-api-separate-pmap-register-and-temp-sockets.patch
knfsd-sunrpc-allow-creating-an-rpc-service-without-registering-with-portmapper.patch
knfsd-sunrpc-cache-remote-peers-address-in-svc_sock.patch
knfsd-sunrpc-use-sockaddr_storage-to-store-address-in-svc_deferred_req.patch
knfsd-sunrpc-add-a-function-to-format-the-address-in-an-svc_rqst-for-printing.patch
include-linux-nfsd-consth-remove-nfs_super_magic.patch
readahead-nfsd-case.patch
readahead-nfsd-case-fix.patch
md-dm-reduce-stack-usage-with-stacked-block-devices.patch
