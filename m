From: akpm@linux-foundation.org
Subject: + knfsd-avoid-use-of-unitialised-variables-on-error-path-when-nfs-exports.patch added to -mm tree
Date: Mon, 07 May 2007 16:08:24 -0700
Message-ID: <200705072308.l47N8OPZ007822@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:37718 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754904AbXEGXJn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 May 2007 19:09:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: neilb@suse.de, stable@kernel.org


The patch titled
     knfsd: avoid use of unitialised variables on error path when nfs exports
has been added to the -mm tree.  Its filename is
     knfsd-avoid-use-of-unitialised-variables-on-error-path-when-nfs-exports.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: knfsd: avoid use of unitialised variables on error path when nfs exports
From: NeilBrown <neilb@suse.de>

We need to zero various parts of 'exp' before any 'goto out', otherwise when
we go to free the contents...  we die.

Signed-off-by: Neil Brown <neilb@suse.de>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nfsd/export.c |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff -puN fs/nfsd/export.c~knfsd-avoid-use-of-unitialised-variables-on-error-path-when-nfs-exports fs/nfsd/export.c
--- a/fs/nfsd/export.c~knfsd-avoid-use-of-unitialised-variables-on-error-path-when-nfs-exports
+++ a/fs/nfsd/export.c
@@ -469,6 +469,13 @@ static int svc_export_parse(struct cache
 	nd.dentry = NULL;
 	exp.ex_path = NULL;
 
+	/* fs locations */
+	exp.ex_fslocs.locations = NULL;
+	exp.ex_fslocs.locations_count = 0;
+	exp.ex_fslocs.migrated = 0;
+
+	exp.ex_uuid = NULL;
+
 	if (mesg[mlen-1] != '\n')
 		return -EINVAL;
 	mesg[mlen-1] = 0;
@@ -509,13 +516,6 @@ static int svc_export_parse(struct cache
 	if (exp.h.expiry_time == 0)
 		goto out;
 
-	/* fs locations */
-	exp.ex_fslocs.locations = NULL;
-	exp.ex_fslocs.locations_count = 0;
-	exp.ex_fslocs.migrated = 0;
-
-	exp.ex_uuid = NULL;
-
 	/* flags */
 	err = get_int(&mesg, &an_int);
 	if (err == -ENOENT)
_

Patches currently in -mm which might be from neilb@suse.de are

origin.patch
fix-quadratic-behavior-of-shrink_dcache_parent.patch
freezer-add-try_to_freeze-calls-to-all-kernel-threads.patch
nlmclnt_recovery-dont-use-clone_sighand.patch
introduce-freezer-flags-rev-2.patch
the-nfsv2-nfsv3-server-does-not-handle-zero-length-write.patch
knfsd-rename-sk_defer_lock-to-sk_lock.patch
nfsd-nfs4state-remove-unnecessary-daemonize-call.patch
rpc-add-wrapper-for-svc_reserve-to-account-for-checksum.patch
rpc-add-wrapper-for-svc_reserve-to-account-for-checksum-fix.patch
sunrpc-fix-error-path-in-module_init.patch
knfsd-avoid-use-of-unitialised-variables-on-error-path-when-nfs-exports.patch
knfsd-rpc-fix-server-side-wrapping-of-krb5i-replies.patch
knfsd-fix-resource-leak-resulting-in-module-refcount-leak-for-rpcsec_gss_krb5ko.patch
knfsd-rpcgss-rpc_gss_proc_-destroy-request-will-get-a-bad-rpc.patch
knfsd-simplify-a-while-condition-in-svcsockc.patch
knfsd-trivial-makefile-cleanup.patch
knfsd-various-nfsd-xdr-cleanups.patch
knfsd-avoid-oops-if-buggy-userspace-performs-confusing-filehandle-dentry-mapping.patch
readahead-nfsd-case.patch
drivers-mdc-use-array_size-macro-when-appropriate.patch
md-cleanup-use-seq_release_private-where-appropriate.patch
md-dm-reduce-stack-usage-with-stacked-block-devices.patch
