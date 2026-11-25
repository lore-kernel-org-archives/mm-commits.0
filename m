Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795585293;
	b=JAoj/IqSgiBjcHdz5scerFrimqL7HV9T45PP9x+sJtAxpP64QZhMNIYVhsAu/tqb7Ta7
	 cKeCTkt7e87J1wIID/1wANXIya8cB17Uw7zDxl7mZYsCsHxKZo0Nd3JXlXivC77OoRuCD
	 VE/eXjG88OOmcq3WrecZtqLQ/gbAvmwCVQamZp2tNjh8nMOZ5HF7SPi2rb1oCurQH+FvS
	 7NKL0TQ7gJahdLiexaD6G24M6D6Ckxp0VneH27v+UeX2TXzSMfID4QhCypnEorzNzF9TN
	 ZKJ20+liPL4w4tgqx/j5M46CuAP95K+vTDbuHvjNPENlLN4QR/qqKBuVxQKziOs5SZw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795585293;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=EVZmPFbWw5QOR6pMGlxFDh3pktPdk5x+UPUwGlITswQ=;
	b=OqyK3oQ5EXNf9kekGSy98yNVDF+/kZOijeUkhnlcYeFVX7SqWO8WIbQn0uTJMmfh6XNk
	 jHVr/ESZu1hD2UnlAEF6ieGD5wvi0HJnflAp5PjQR0FTM9KwQU2AO2qKhXJ9bFzuFMYlN
	 R08eNkbFZpGWA9sgUaN+afycnB2dpDdUlVtMCh+hlDqCAbZVmoHTouC0Rkma9Z6HvIiec
	 qZxOgW3Selq2BxZgnHGepyvQKEe+Q+QJK9Wkb6pSwB7l/9WJ1JaBMAffbAvq1M0YeyjMO
	 zxEDdLAancqnHmJnuBSZzO2dkSOliXB0PnK68qa7WZIbUp0wwoDNGyuZGmttdokWvcQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=gSje84Hr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8186A606A32A
	for <mm-commits@vger.kernel.org>; Wed, 25 Nov 2026 05:41:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=gSje84Hr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 574D01F000C4;
	Wed, 25 Nov 2026 05:41:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795585292;
	bh=EVZmPFbWw5QOR6pMGlxFDh3pktPdk5x+UPUwGlITswQ=;
	h=Date:To:From:Subject;
	b=gSje84HrYvFeD2xTVXJ3kEns5UJV8szmD3wRJ8u7A+F/HMHQ//Ze4RlKaiBd9xCRv
	 Rue4qiAk9uvNxXetZwI1KXZdvmVjT52JG0EMplrb/CXttvD3yf0jz3+QgwcYgC7ENa
	 yVTgwE7k9S1iGwfPoDDIIAqVvhfsit1SGYiOnNLs=
Date: Tue, 24 Nov 2026 21:41:31 -0800
To: mm-commits@vger.kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] squashfs-dont-compute-start-or-alloc-memory-on-empty-directory-or-index-fix.patch removed from -mm tree
Message-Id: <20261125054132.574D01F000C4@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: squashfs-dont-compute-start-or-alloc-memory-on-empty-directory-or-index-fix
has been removed from the -mm tree.  Its filename was
     squashfs-dont-compute-start-or-alloc-memory-on-empty-directory-or-index-fix.patch

This patch was dropped because an updated version will be issued

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

mm-vma-drop-mm-asynchronously-in-vma_start_read-fix.patch
mm-vma-drop-mm-asynchronously-in-vma_start_read-fix-2.patch
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
afs-do-not-put-error-pointer-after-address-lookup-failure.patch
selftests-mm-check-that-fsync-reports-hard-poisoned-dirty-page-cache.patch
selftests-mm-check-that-fsync-reports-hard-poisoned-dirty-page-cache-fix-0.patch
selftests-mm-check-that-fsync-reports-hard-poisoned-dirty-page-cache-fix-1.patch
selftests-mm-check-that-fsync-reports-hard-poisoned-dirty-page-cache-fix-2.patch
selftests-mm-check-that-fsync-reports-hard-poisoned-dirty-page-cache-fix-3.patch
selftests-mm-check-that-fsync-reports-hard-poisoned-dirty-page-cache-fix-4.patch
selftests-mm-check-that-fsync-reports-hard-poisoned-dirty-page-cache-fix-5.patch
selftests-mm-check-that-fsync-reports-hard-poisoned-dirty-page-cache-fix-6.patch
selftests-mm-check-that-fsync-reports-hard-poisoned-dirty-page-cache-fix-7.patch
ocfs2-unregister-the-jbd2-shrinker-before-journal-shutdown.patch
ipc-msg-clamp-negative-msg_info-usage-counts.patch
squashfs-fix-leaked-page-locks-when-page-actor-allocation-fails-fix.patch
ocfs2-skip-network-flush-when-no-domain-handlers-are-registered.patch
selftests-ptrace-check-that-ptrace_set_syscall_info-rejects-invalid-error-values-fix.patch
lib-asn1_encoder-fix-encoding-of-zero-oid-components.patch
proc-serialize-task-owner-updates.patch
proc-dont-lock-task-inodes-whose-owner-has-not-changed.patch
drivers-media-v4l2-core-v4l2-vp9c-reduce-inlining.patch

