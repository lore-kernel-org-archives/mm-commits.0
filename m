Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795500736;
	b=TCU2pINRkCNbBsFnqrFs0MsWgfZobnFSLR0Wn+2PCjPAu0NMKdQmCsTaTXbm4l+pRgz3
	 9K/SBmI+GJr3+6xEU8KasTCDe2S5SR1pgB7Z4uOqYmeqzn5xMZDEClsyh2xvcjnFrgA7b
	 xqSZs/uuvcVTXQmYwctXhpvzR6YIiTcZiKTxtBnKOdTP6aj4aOvFEZi2S0HeeLqoMXg6M
	 kARKPl204tysWYOzGjNCphP6OP17EU9Zj/WzX1+mJzuMqrZNoS7sUha1f+T0yaw4chMoj
	 meiYRZLzcxy5wUdcmUBWyZtFfl/sOBNDPAhMObj2WjGXiBJFx/RsyOcOG2a05SfNgDQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795500736;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=XbtZeSAl4KQGuECTA+UxKLTVRsBHJ0WgeuzYH3xa8jw=;
	b=mNUp8NZ883efp/qM/SvNurpnBK1H391f1P2RZ3Htrtb9254jnSHiNfuuoALjyB4P+goL
	 CbDhrmpGIVj9sTM1YPBtUQDdtaqU8O/cOTv5M1I1WrEoga0aQp1biVwOZ3nUmQ8wlCQOY
	 xDyy7HC5SygFTJ1UPEqi+nVSCGemETJF0t9weps7ucOZNGS/xwpJO2tfZdr1VRBlip8FY
	 4iyL0tGFB6IbgWXavt4FYUZdJeqp2RDrbXVIAokrw7fNQtE3fa16bDH6r3rzLFQik5IA3
	 S6UX4Oxpna70Lm0UHm4Ondy5uTrqebiOplT4+d/5CGKG3x2R4ZydeyzHvOsdJaKedyQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=SEzw+HwO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD571606A321
	for <mm-commits@vger.kernel.org>; Tue, 24 Nov 2026 06:12:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=SEzw+HwO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEE921F000C6;
	Tue, 24 Nov 2026 06:12:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795500736;
	bh=XbtZeSAl4KQGuECTA+UxKLTVRsBHJ0WgeuzYH3xa8jw=;
	h=Date:To:From:Subject;
	b=SEzw+HwOYWiF0DMPIMIVMye+5m4lqhrWfEsoJ1vcOUHtyftMe8QjZgFHJGMDYki55
	 8+Czj3wjOXjet/KV4V2Glj5wyUp7hl02Cqcb5n1Vbv3MnVXnB72Wv2jqhRcqH+HpTU
	 HDNhQ09tWXa7sLk0nFthtSIT/XdLa/OV7cXreQeU=
Date: Mon, 23 Nov 2026 22:12:15 -0800
To: mm-commits@vger.kernel.org,vgoyal@redhat.com,vbabka@kernel.org,
	stefanha@redhat.com,shuah@kernel.org,rppt@kernel.org,nao.horiguchi@gmail.com,
	miklos@szeredi.hu,mhocko@suse.com,linmiaohe@huawei.com,liam@infradead.org,
	gmaglione@redhat.com,eperezma@redhat.com,david@kernel.org,amir73il@gmail.com,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [obsolete] selftests-mm-check-that-fsync-reports-hard-poisoned-dirty-page-cache-fix-7.patch removed from -mm tree
Message-Id: <20261124061215.DEE921F000C6@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: selftests/mm: accept EIO from close after poisoning dirty data
has been removed from the -mm tree.  Its filename was
     selftests-mm-check-that-fsync-reports-hard-poisoned-dirty-page-cache-fix-7.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: selftests/mm: accept EIO from close after poisoning dirty data
Date: Mon, 23 Nov 2026 19:38:37 -0800

On overlayfs with a virtiofs upper, poisoning a dirty page makes fsync()
return -EIO as expected. close() can return -EIO again after ftruncate()
removes the poisoned page. The selftest currently fails because it requires
close() to return zero after fsync() has reported the error.

Accept a second -EIO from close() only in the hard-poison dirty-page test,
where fsync() has already been checked for -EIO. Continue to reject other
close() errors. With the virtiofs export owned by the daemon's UID and GID,
all ten overlayfs tests pass with no skips; before this change the dirty
hard-poison case failed at close().

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>
Cc: Amir Goldstein <amir73il@gmail.com>
Cc: German Maglione <gmaglione@redhat.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: Stefan Hajnoczi <stefanha@redhat.com>
Cc: Eugenio Pérez <eperezma@redhat.com>

 tools/testing/selftests/mm/memory-failure.c |   6 ++++++
 1 file changed, 6 insertions(+)

--- a/tools/testing/selftests/mm/memory-failure.c~selftests-mm-check-that-fsync-reports-hard-poisoned-dirty-page-cache-fix-7
+++ b/tools/testing/selftests/mm/memory-failure.c
@@ -474,8 +474,14 @@
 	 * fails. Close while the file is still linked. Remove the name
 	 * before checking the result so a failed close cannot leave a file
 	 * for the next test.
+	 *
+	 * With a virtiofs upper, overlayfs can also report -EIO from close()
+	 * after fsync() has reported the poisoned dirty page. Accept this
+	 * second error only for the hard-poison test and only if it is -EIO.
 	 */
 	ret = close(fd);
+	if (ret < 0 && variant->type == MADV_HARD)
+		ret = errno == EIO ? 0 : ret;
 	unlink(fname);
 	ASSERT_EQ(ret, 0);
 }

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
mm-madvise-notify-userfaultfd-when-installing-guard-regions.patch
afs-do-not-put-error-pointer-after-address-lookup-failure.patch
selftests-mm-check-that-fsync-reports-hard-poisoned-dirty-page-cache.patch
selftests-mm-check-that-fsync-reports-hard-poisoned-dirty-page-cache-fix-2.patch
selftests-mm-check-that-fsync-reports-hard-poisoned-dirty-page-cache-fix-3.patch
selftests-mm-check-that-fsync-reports-hard-poisoned-dirty-page-cache-fix-4.patch
selftests-mm-check-that-fsync-reports-hard-poisoned-dirty-page-cache-fix-5.patch
selftests-mm-check-that-fsync-reports-hard-poisoned-dirty-page-cache-fix-6.patch
fuse-let-memory-failure-remove-poisoned-page-cache-folios.patch
nilfs2-report-mapping-errors-from-fsync.patch
ceph-preserve-data-writeback-errors-in-fsync.patch
ocfs2-unregister-the-jbd2-shrinker-before-journal-shutdown.patch
ipc-msg-clamp-negative-msg_info-usage-counts.patch
squashfs-fix-leaked-page-locks-when-page-actor-allocation-fails-fix.patch
squashfs-dont-compute-start-or-alloc-memory-on-empty-directory-or-index-fix.patch
ocfs2-skip-network-flush-when-no-domain-handlers-are-registered.patch
selftests-ptrace-check-that-ptrace_set_syscall_info-rejects-invalid-error-values-fix.patch
jfs-validate-xattr-entry-bounds-before-replacing-an-attribute.patch
proc-serialize-task-owner-updates.patch
lib-asn1_encoder-fix-encoding-of-zero-oid-components.patch
drivers-media-v4l2-core-v4l2-vp9c-reduce-inlining.patch

