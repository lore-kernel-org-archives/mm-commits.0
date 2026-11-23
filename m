Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795420503;
	b=s1G32PtbRSHhaM1X7sh3sgmI0MKF62ZT7a0V24jh9iKbRM2smtNiY6RUMvmKPQzL7UDD
	 AHnCmAxnTYEhyyRROyf9RL3FC2CvEJqpjG1EdHWWgIhDwiZ67nw76Wd+TlvEq6KAykFU4
	 hKBBoM+2fLHrfvhR0xpASxK/XCrbYiPOgypLip4TjGE6UJClPg1YH9Om+hSQ4YMXrG3Hc
	 e4yosUybD6oQbc5SttRP/GaOon3KjMZkff85zEWctInslTiifj5y6vMqqFOGDgKWyQmvH
	 H+3qV+nCaLWZh5C8dc78+HfSJDZB7cHkZxhxTdySF9Muq/YkbizvJBFKs0941W6TpUg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795420503;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=HXQ30hMLDSUOS123c7tKUs09AZWkY4gCAj9bKcwMp1k=;
	b=yH4GssR35AR/tQHFR30I6WMq1ECthL8tmSyXF7WhBtWUXDaavYIr4Soq6uJA7pRh0/wP
	 Lj/qr7FoTX7JRQBYBWWehEc4qfdAKSAHJkoXEp8rcaLqNdXUDim/iXvwhNTAig9bpqYK/
	 5F9BMHh+wZvf2/NLQYJ/98aY2i+MxhK5ZqzEoVtF7N+U3RDolcZx/2ASavnHJXROpRBtS
	 1GFGDTDArdg7jBUS2rrOva2x4UD/yyMz+h4MT+7yhGz9OQN0rlx4MzQtAk/KGsKjI7JUR
	 KwADpiFbrgnxq+eA0xl1hg0WFzu6TNEbTtpO8xnRtnrduTnyrL7uHwv7xIp1Tqt6oww==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=xoLOWqra;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E0D3606A31A
	for <mm-commits@vger.kernel.org>; Mon, 23 Nov 2026 07:55:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=xoLOWqra
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52D871F000C6;
	Mon, 23 Nov 2026 07:55:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795420502;
	bh=HXQ30hMLDSUOS123c7tKUs09AZWkY4gCAj9bKcwMp1k=;
	h=Date:To:From:Subject;
	b=xoLOWqrapm4zqx77cOV+mPp3/ApHz/EdHaAmnHb542DnwVOLAYpr2gDSFxl5hJxWo
	 KLacLuMiUWY8DBPqzuFw+Ytlshd4D6eafZDGthyb1BoVAJ/NCfTj6zYxtR+b37/piw
	 JxdCBFjqwerwgIOZn/nVAJFG0D98G6/Iik0lYlV8=
Date: Sun, 22 Nov 2026 23:55:01 -0800
To: mm-commits@vger.kernel.org,
	syzbot+ci04e7314748e3f6be@syzkaller.appspotmail.com,phillip@squashfs.org.uk,
	phillip.lougher@gmail.com,error27@gmail.com,christian.loehle@arm.com,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + squashfs-dont-compute-start-or-alloc-memory-on-empty-directory-or-index-fix.patch added to mm-nonmm-unstable branch
Message-Id: <20261123075502.52D871F000C6@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: squashfs-dont-compute-start-or-alloc-memory-on-empty-directory-or-index-fix
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     squashfs-dont-compute-start-or-alloc-memory-on-empty-directory-or-index-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/squashfs-dont-compute-start-or-alloc-memory-on-empty-directory-or-index-fix.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: squashfs-dont-compute-start-or-alloc-memory-on-empty-directory-or-index-fix
Date: Sun Nov 22 11:49:59 PM PST 2026

s/inode/dir/ in TRACE statement

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Christian Loehle <christian.loehle@arm.com>
Cc: Dan Carpenter <error27@gmail.com>
Cc: Phillip Lougher <phillip.lougher@gmail.com>
Cc: Phillip Lougher <phillip@squashfs.org.uk>
Cc: syzbot ci <syzbot+ci04e7314748e3f6be@syzkaller.appspotmail.com>

 fs/squashfs/namei.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/squashfs/namei.c~squashfs-dont-compute-start-or-alloc-memory-on-empty-directory-or-index-fix
+++ a/fs/squashfs/namei.c
@@ -134,8 +134,8 @@ static struct dentry *squashfs_lookup(st
 	int offset, err, length;
 	unsigned int dir_count, size;
 
-	TRACE("Entered squashfs_lookup [%llx:%x]\n", squashfs_i(inode)->start,
-			squashfs_i(inode)->offset);
+	TRACE("Entered squashfs_lookup [%llx:%x]\n", squashfs_i(dir)->start,
+			squashfs_i(dir)->offset);
 
 	if (len > SQUASHFS_NAME_LEN)
 		return ERR_PTR(-ENAMETOOLONG);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

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
selftests-mm-check-that-fsync-reports-hard-poisoned-dirty-page-cache.patch
selftests-mm-check-that-fsync-reports-hard-poisoned-dirty-page-cache-fix-2.patch
fuse-let-memory-failure-remove-poisoned-page-cache-folios.patch
nilfs2-report-mapping-errors-from-fsync.patch
ocfs2-unregister-the-jbd2-shrinker-before-journal-shutdown.patch
ipc-msg-clamp-negative-msg_info-usage-counts.patch
squashfs-fix-leaked-page-locks-when-page-actor-allocation-fails-fix.patch
squashfs-dont-compute-start-or-alloc-memory-on-empty-directory-or-index-fix.patch
ocfs2-skip-network-flush-when-no-domain-handlers-are-registered.patch
selftests-ptrace-check-that-ptrace_set_syscall_info-rejects-invalid-error-values-fix.patch
jfs-validate-xattr-entry-bounds-before-replacing-an-attribute.patch
drivers-media-v4l2-core-v4l2-vp9c-reduce-inlining.patch

