From: akpm@linux-foundation.org
Subject: + md-remove-the-slash-from-the-name-of-a-kmem_cache-used-by-raid5.patch added to -mm tree
Date: Tue, 08 May 2007 16:09:11 -0700
Message-ID: <200705082309.l48N9BkR004350@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:37348 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S969479AbXEHXJQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 19:09:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: neilb@suse.de, clameter@sgi.com


The patch titled
     md: remove the slash from the name of a kmem_cache used by raid5
has been added to the -mm tree.  Its filename is
     md-remove-the-slash-from-the-name-of-a-kmem_cache-used-by-raid5.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: md: remove the slash from the name of a kmem_cache used by raid5
From: NeilBrown <neilb@suse.de>

SLUB doesn't like slashes as it wants to use the cache name as the name of a
directory (or symlink) in sysfs.

Signed-off-by: Neil Brown <neilb@suse.de>
Cc: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/md/raid5.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/md/raid5.c~md-remove-the-slash-from-the-name-of-a-kmem_cache-used-by-raid5 drivers/md/raid5.c
--- a/drivers/md/raid5.c~md-remove-the-slash-from-the-name-of-a-kmem_cache-used-by-raid5
+++ a/drivers/md/raid5.c
@@ -931,8 +931,8 @@ static int grow_stripes(raid5_conf_t *co
 	struct kmem_cache *sc;
 	int devs = conf->raid_disks;
 
-	sprintf(conf->cache_name[0], "raid5/%s", mdname(conf->mddev));
-	sprintf(conf->cache_name[1], "raid5/%s-alt", mdname(conf->mddev));
+	sprintf(conf->cache_name[0], "raid5-%s", mdname(conf->mddev));
+	sprintf(conf->cache_name[1], "raid5-%s-alt", mdname(conf->mddev));
 	conf->active_name = 0;
 	sc = kmem_cache_create(conf->cache_name[conf->active_name],
 			       sizeof(struct stripe_head)+(devs-1)*sizeof(struct r5dev),
_

Patches currently in -mm which might be from neilb@suse.de are

origin.patch
fix-quadratic-behavior-of-shrink_dcache_parent.patch
git-md-accel.patch
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
drivers-mdc-use-array_size-macro-when-appropriate.patch
md-cleanup-use-seq_release_private-where-appropriate.patch
md-move-test-for-whether-level-supports-bitmap-to-correct-place.patch
md-stop-using-csum_partial-for-checksum-calculation-in-md.patch
md-remove-the-slash-from-the-name-of-a-kmem_cache-used-by-raid5.patch
md-allow-reshape_position-for-md-arrays-to-be-set-via-sysfs.patch
md-improve-partition-detection-in-md-array.patch
md-dm-reduce-stack-usage-with-stacked-block-devices.patch
