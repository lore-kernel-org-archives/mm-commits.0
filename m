Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795406626;
	b=YUUIxX08lARs+5KbH167CE9uMxR3p4Jv6tQZwR+ogFDE7K3pLCpwvK0p8N1o1qE/P63w
	 YZ7udqusQ3bQ3JCroQvY7qZip3XzQwfH8t8xxBxd/YTbx9A9zCy+mOd/7JR9d8jPLvAXK
	 o9BHRtEhJ5cyFu91wzEezcBajUguP1wANdGIHcWGTGS2RhOpQ+UV5O8v1MCjEENYVYBiC
	 CTmfXkWcaY60FxLvyFojDBHfqzihEVbvMBhphb9Sb6zkOi6bP9ujmHieX1Rl7ZnPMLtyp
	 Xyn56jpx9rnpmvUW0q6ixAd3+B2cLN9SpOZzTTm7kqLvNBysvDmhrNyv8n/a/G/+64w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795406626;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=DenRURlaUgMDUh8cEMmduc5MyRGmo0y5lNaneBZiJwk=;
	b=uk3jYwUjtMs9OxZLUjTDfxSFT5Fk5lokXhEnug8JgIQQ+prMeoMKq1meFIYmXKV4njLa
	 oCpV9qoHhNzAOciahfzplIOXF4qcb+L1cszex7rpoOqL5oQXx6EnNLlV8Clvp5za9wagC
	 0sjrLe9g3QsWHji6kp05cJfx5IK3zW73yyHGNl5G7TmZtJNLXsMdILcld+Ju3je/lE7eT
	 RonNY/P+N7SBoX5+jwpSAlKrJguOGkrywQoEuPtFpTWbd/fXGmrTPfWbAaYm5/TwL/IDu
	 Rw/LFIoW5rSHeTfLOxXncarrnYu/GwMF4JlITqQHfD3p/YUFLvu2IIRbJTtbR8sXJ6w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=S3NgXKgm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03101606A320
	for <mm-commits@vger.kernel.org>; Mon, 23 Nov 2026 04:03:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=S3NgXKgm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A289F1F000D3;
	Mon, 23 Nov 2026 04:03:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795406625;
	bh=DenRURlaUgMDUh8cEMmduc5MyRGmo0y5lNaneBZiJwk=;
	h=Date:To:From:Subject;
	b=S3NgXKgmgTajPRV/Svlg8A7J5iXLM0Oyvagmtzs+hJ1L/l8OqrpLLqowX9/t6sPpN
	 OQ05BRxCKxAX/MEJDS0MzUxrq1S4di3DC4zKnstLFCkr+8xvZtIUwdKJWLwQel0n6S
	 HwundC9IrjsJn3DBNVvhbTFP/ahNWV8wI5hQ9LpA=
Date: Sun, 22 Nov 2026 20:03:45 -0800
To: mm-commits@vger.kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] squashfs-sanity-check-directory-metadata-block-location-fix.patch removed from -mm tree
Message-Id: <20261123040345.A289F1F000D3@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: squashfs-sanity-check-directory-metadata-block-location-fix
has been removed from the -mm tree.  Its filename was
     squashfs-sanity-check-directory-metadata-block-location-fix.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: squashfs-sanity-check-directory-metadata-block-location-fix
Date: Sun Nov 15 11:23:18 PM PST 2026

squashfs_lookup() stores squashfs_dir_start() in a u64 then checks block <
0.  That check cannot detect its negative error returns; block needs a
signed type.

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Phillip Lougher <phillip.lougher@gmail.com>
Cc: Phillip Lougher <phillip@squashfs.org.uk>

 fs/squashfs/namei.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/squashfs/namei.c~squashfs-sanity-check-directory-metadata-block-location-fix
+++ a/fs/squashfs/namei.c
@@ -138,7 +138,7 @@ static struct dentry *squashfs_lookup(st
 
 	TRACE("Entered squashfs_lookup [%llx:%x]\n", squashfs_i(dir)->start, offset);
 
-	if (block < 0)
+	if ((s64)block < 0)
 		goto data_error;
 
 	dire = kmalloc(sizeof(*dire) + SQUASHFS_NAME_LEN + 1, GFP_KERNEL);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

maintainers-add-page_exth-to-memory-management-page-allocator.patch
kselftest-mm-rename-read_pmd_pagesize-to-pmd_psize-fix.patch
selftests-mm-check-madv_cold-and-madv_pageout-on-partly-advised-thps-fix.patch
alloc_tag-introduce-ioctls-to-toggle-allocation-tracepoints-fix-fix.patch
alloc_tag-introduce-ioctls-to-toggle-allocation-tracepoints-fix.patch
selftests-mm-add-uffdio_move-huge-zeropage-pmd-regression-test-fix.patch
selftests-mm-allocate-nr_pages-based-on-pmd-size-for-uffd-pmd_move-tests-fix.patch
selftests-mm-retain-move-pmd-coverage-and-verify-huge-pmds.patch
lib-test_xarray-check-unused-spare-node-after-range-creation.patch
mm-memory-failure-dont-unpoison-a-leaked-raw_hwp_unreliable-folio-fix.patch
mm-vmstat_kunit-add-synthetic-benchmark-for-mm-stats-fix.patch
lib-test_hmm-invalidate-all-mirrors-on-device-private-migration.patch
lib-test_hmm-invalidate-all-mirrors-on-device-private-migration-fix.patch
mm-prevent-pre-content-bypass-through-mremap-and-remap_file_pages.patch
selinux-recheck-backing-file-permissions-on-remap_file_pages.patch
mm-madvise-notify-userfaultfd-when-installing-guard-regions.patch
mm-highmem-reject-previously-poisoned-pages-in-machine-check-copies.patch
selftests-mm-check-that-fsync-reports-hard-poisoned-dirty-page-cache.patch
fuse-let-memory-failure-remove-poisoned-page-cache-folios.patch
nilfs2-report-mapping-errors-from-fsync.patch
ocfs2-unregister-the-jbd2-shrinker-before-journal-shutdown.patch
ipc-msg-clamp-negative-msg_info-usage-counts.patch
squashfs-fix-leaked-page-locks-when-page-actor-allocation-fails-fix.patch
squashfs-fix-variables-in-directory-code-and-add-more-sanity-checks-fix.patch
ocfs2-skip-network-flush-when-no-domain-handlers-are-registered.patch
selftests-ptrace-check-that-ptrace_set_syscall_info-rejects-invalid-error-values-fix.patch
jfs-validate-xattr-entry-bounds-before-replacing-an-attribute.patch
drivers-media-v4l2-core-v4l2-vp9c-reduce-inlining.patch
a.patch

