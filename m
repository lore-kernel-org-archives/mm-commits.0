Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795406645;
	b=KuxPObpcIAR9oodk+GcOuhzczhH1qEJzlsBvvT1jdZ6X9Y+hPWcOcoorNVeyRC0TrTBu
	 Ddxl1qWnRwEVDnEj2P2Ee8bu8qoYVVsfxzJfLhj+AIEXu0l5A9ZbBXkVmkvj/+ysRtij0
	 S0WP4/OnxDSM2QneBsEjosiRwbHPC/QBPFtp4v0VXfPVS11qkK56yP7mXxW8JhWkL5iKU
	 HBu4SGvIEuYuCT7qFNsMtlX5Vh8cQsNBo1bkbdmHM22gD6d1gTV36x6OyWx4xMkgrXB10
	 9cNlM5+TSc26AU3asEiqQnkqXXmzC0HWhRAuPFfXmqEII+mRqgrZbvY94GlFEFFQEoA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795406645;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=LBYOY5P3es7KfeabGQpyTsz4IBAaWrksgm/fRM9w1xI=;
	b=K47ifZVXvgc80MHohUvOdVe217FeVhtsl+8i9N8o8bH5Gu6o/JquapcJVJOzqjibpVt1
	 R8h5z7CSxqDuDw+Cds0mBUi3SJTNSoQmniN4V6FifqtpLiapcW0bjJH1tXo8w1xJq/bIC
	 d2kt4+FrDmCn9PNGUGSC6Uk1tBYFPv4fsCLDhjpzvaITOkGGJUPa8atAuGvUbFC1oP9KN
	 TnDAXS63TZ1P3AQoSEbD4mhM3iI4pd5Dn/SxTmXyga5NSmSF3ZGn6Naqi1Ies3cSck7ou
	 nlmGTa7ZmsuvoV3Ry8ssKhEIrLTucupaI4ePwWdK97tEhMRO6xYuLF320+kPgzDLokQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=fbtjZ6Gb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 518CD606A327
	for <mm-commits@vger.kernel.org>; Mon, 23 Nov 2026 04:04:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=fbtjZ6Gb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 682BD1F000E6;
	Mon, 23 Nov 2026 04:04:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795406644;
	bh=LBYOY5P3es7KfeabGQpyTsz4IBAaWrksgm/fRM9w1xI=;
	h=Date:To:From:Subject;
	b=fbtjZ6Gb2xuBnzfIqfJ26nrlQUP+jU5XT5BVSQLA38k53nPSXXcHaMdH3lih6wAoF
	 /+GrdqIuqCh7u1zRYR2gNgNklOvHAgPVNNUMJtfBYCCaLH5uiw+q3Lw9DaIBU+zrsJ
	 S0AuPE8Gtl1qU8MIxkqAMnSzK10CXWp8PRbd2lu4=
Date: Sun, 22 Nov 2026 20:04:03 -0800
To: mm-commits@vger.kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] squashfs-fix-variables-in-directory-code-and-add-more-sanity-checks-fix.patch removed from -mm tree
Message-Id: <20261123040404.682BD1F000E6@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: squashfs-fix-variables-in-directory-code-and-add-more-sanity-checks-fix
has been removed from the -mm tree.  Its filename was
     squashfs-fix-variables-in-directory-code-and-add-more-sanity-checks-fix.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: squashfs-fix-variables-in-directory-code-and-add-more-sanity-checks-fix
Date: Sun Nov 15 09:54:43 PM PST 2026

fix smatch warnings

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <error27@gmail.com>
Closes: https://lore.kernel.org/r/202611131955.0Gd7ipSP-lkp@intel.com/
Cc: Phillip Lougher <phillip.lougher@gmail.com>
Cc: Phillip Lougher <phillip@squashfs.org.uk>

 fs/squashfs/namei.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/fs/squashfs/namei.c~squashfs-fix-variables-in-directory-code-and-add-more-sanity-checks-fix
+++ a/fs/squashfs/namei.c
@@ -221,8 +221,10 @@ static struct dentry *squashfs_lookup(st
 			/*
 			 * Read directory entry.
 			 */
-			if (!squashfs_dir_space(dir, length, sizeof(*dire)))
+			if (!squashfs_dir_space(dir, length, sizeof(*dire))) {
+				err = -ENOSPC;
 				goto read_failure;
+			}
 
 			err = squashfs_read_metadata(dir->i_sb, dire, &block,
 					&offset, sizeof(*dire));
@@ -236,8 +238,10 @@ static struct dentry *squashfs_lookup(st
 			if (size > SQUASHFS_NAME_LEN)
 				goto data_error;
 
-			if (!squashfs_dir_space(dir, length, size))
+			if (!squashfs_dir_space(dir, length, size)) {
+				err = -ENOSPC;
 				goto read_failure;
+			}
 
 			err = squashfs_read_metadata(dir->i_sb, dire->name,
 					&block, &offset, size);
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
ocfs2-skip-network-flush-when-no-domain-handlers-are-registered.patch
selftests-ptrace-check-that-ptrace_set_syscall_info-rejects-invalid-error-values-fix.patch
jfs-validate-xattr-entry-bounds-before-replacing-an-attribute.patch
drivers-media-v4l2-core-v4l2-vp9c-reduce-inlining.patch
a.patch

