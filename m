From: akpm@osdl.org
Subject: + knfsd-fix-up-some-bit-rot-in-exp_export.patch added to -mm tree
Date: Fri, 08 Dec 2006 16:09:54 -0800
Message-ID: <200612090009.kB909s1N010441@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:55624 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1947589AbWLIAJ6 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 19:09:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: neilb@suse.de


The patch titled
     knfsd: Fix up some bit-rot in exp_export
has been added to the -mm tree.  Its filename is
     knfsd-fix-up-some-bit-rot-in-exp_export.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: knfsd: Fix up some bit-rot in exp_export
From: NeilBrown <neilb@suse.de>

The nfsservctl system call isn't used but recent nfs-utils releases for
exporting filesystems, and consequently the code that is uses - exp_export -
has suffered some bitrot.

Particular:
  - some newly added fields in 'struct svc_export' are being initialised
    properly.
  - the return value is now always -ENOMEM ...

This patch fixes both these problems.

Signed-off-by: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/nfsd/export.c |   12 +++++++++---
 1 files changed, 9 insertions(+), 3 deletions(-)

diff -puN fs/nfsd/export.c~knfsd-fix-up-some-bit-rot-in-exp_export fs/nfsd/export.c
--- a/fs/nfsd/export.c~knfsd-fix-up-some-bit-rot-in-exp_export
+++ a/fs/nfsd/export.c
@@ -955,6 +955,8 @@ exp_export(struct nfsctl_export *nxp)
 
 	exp = exp_get_by_name(clp, nd.mnt, nd.dentry, NULL);
 
+	memset(&new, 0, sizeof(new));
+
 	/* must make sure there won't be an ex_fsid clash */
 	if ((nxp->ex_flags & NFSEXP_FSID) &&
 	    (fsid_key = exp_get_fsid_key(clp, nxp->ex_dev)) &&
@@ -985,6 +987,9 @@ exp_export(struct nfsctl_export *nxp)
 
 	new.h.expiry_time = NEVER;
 	new.h.flags = 0;
+	new.ex_path = kstrdup(nxp->ex_path, GFP_KERNEL);
+	if (! new.ex_path)
+		goto finish;
 	new.ex_client = clp;
 	new.ex_mnt = nd.mnt;
 	new.ex_dentry = nd.dentry;
@@ -1005,10 +1010,11 @@ exp_export(struct nfsctl_export *nxp)
 		/* failed to create at least one index */
 		exp_do_unexport(exp);
 		cache_flush();
-		err = -ENOMEM;
-	}
-
+	} else
+		err = 0;
 finish:
+	if (new.ex_path)
+		kfree(new.ex_path);
 	if (exp)
 		exp_put(exp);
 	if (fsid_key && !IS_ERR(fsid_key))
_

Patches currently in -mm which might be from neilb@suse.de are

origin.patch
knfsd-nfsd4-remove-a-dprink-from-nfsd4_lock.patch
knfsd-svcrpc-fix-gss-krb5i-memory-leak.patch
knfsd-nfsd4-clarify-units-of-compound_slack_space.patch
knfsd-nfsd-make-exp_rootfh-handle-exp_parent-errors.patch
knfsd-nfsd-simplify-exp_pseudoroot.patch
knfsd-nfsd4-handling-more-nfsd_cross_mnt-errors-in-nfsd4-readdir.patch
knfsd-nfsd-dont-drop-silently-on-upcall-deferral.patch
knfsd-svcrpc-remove-another-silent-drop-from-deferral-code.patch
knfsd-nfsd4-pass-saved-and-current-fh-together-into-nfsd4-operations.patch
knfsd-nfsd4-remove-spurious-replay_owner-check.patch
knfsd-nfsd4-move-replay_owner-to-cstate.patch
knfsd-nfsd4-dont-inline-nfsd4-compound-op-functions.patch
knfsd-nfsd4-make-verify-and-nverify-wrappers.patch
knfsd-nfsd4-reorganize-compound-ops.patch
knfsd-nfsd4-simplify-migration-op-check.patch
knfsd-nfsd4-simplify-filehandle-check.patch
knfsd-dont-ignore-kstrdup-failure-in-rpc-caches.patch
knfsd-fix-up-some-bit-rot-in-exp_export.patch
readahead-nfsd-case.patch
readahead-nfsd-case-fix.patch
md-tidy-up-device-change-notification-when-an-md-array-is-stopped.patch
md-define-raid5_mergeable_bvec.patch
md-handle-bypassing-the-read-cache-assuming-nothing-fails.patch
md-allow-reads-that-have-bypassed-the-cache-to-be-retried-on-failure.patch
md-allow-reads-that-have-bypassed-the-cache-to-be-retried-on-failure-fix.patch
md-allow-reads-that-have-bypassed-the-cache-to-be-retried-on-failure-misc-fixes-for-aligned-read-handling-including-raid6-read-corruption.patch
md-allow-reads-that-have-bypassed-the-cache-to-be-retried-on-failure-misc-fixes-for-error-handling-of-aligned-reads.patch
md-enable-bypassing-cache-for-reads.patch
md-fix-innocuous-bug-in-raid6-stripe_to_pdidx.patch
md-conditionalize-some-code.patch
md-remove-some-old-ifdefed-out-code-from-raid5c.patch
md-return-a-non-zero-error-to-bi_end_io-as-appropriate-in-raid5.patch
md-assorted-md-and-raid1-one-liners.patch
md-change-lifetime-rules-for-md-devices.patch
md-close-a-race-between-destroying-and-recreating-an-md-device.patch
md-allow-mddevs-to-live-a-bit-longer-to-avoid-a-loop-with-udev.patch
md-dm-reduce-stack-usage-with-stacked-block-devices.patch

