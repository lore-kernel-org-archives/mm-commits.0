Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795500200;
	b=dHdgXaJ1WM5hjkLAV5KxS67/THj9BO4Za1P2u9g4VDloLq3sWl1Dr2BOPiwvwZI09FWv
	 O/n2KW/jXjF7JvycVCfGTgNQiCW4b1iuOcW5yMlecLmD5pRFpydn2QEpojvZvujE1qg03
	 Exs1JiFCak7kTpfLS2KCQJPq7BzvzvLZ4U+kxun4zMlglfHflrlq9VKw8daV1aEZUe4Ni
	 OuhMInbJnyluZh7dGg0sOl1E0tu0swr+FHpTWbjWQoEqkg6Qwymr6+LTbDWJbhJGNxMxc
	 QvGvI1oFLJp8JDCDckd2d/RT4WuTa5OcZKCkiINx9xiOWTPG5m2FYu7sj69t7+a9mLw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795500200;
	h=Received:DKIM-Signature:Date:To:From:In-Reply-To:References:Subject:
	 Message-Id;
	bh=M9jL5IiALvmK/ea8xnsBuKnxJ95RqHSo/nmekJvDzoA=;
	b=jTTffIWFRLL4DwfTLks5Xw47l05LQYTO/uhLfrXySGL/ajIANlQFMy+wgamJAfwOjsU/
	 7AcNyFSSXYTivgfhEC6jVl3aBi2HoGke6Uzf2rE2Lgnnhjj9Y1lpXvBzfnbBXw8GtHQEQ
	 oCMHglE41mqbQuhLWTbF+ffQhaFQNLzyDC+Efm5FoTdyfGaG62A/sVwWiX98k6mCZWgSP
	 D9Cm2hxU1jWlYuutzYESWjhqNSHCCbKJqhCj6jzP+BVsjlvzXAPkv1k8XisZ2JxQByHJw
	 r/TjUFoAlhIYCT0NnehokOJEHUItt8wNmsZOVF5o6YEw/OAPMeMhjEfpu3f+Zv7d3uA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=lhjG5B+m;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DE6D606A326
	for <mm-commits@vger.kernel.org>; Tue, 24 Nov 2026 06:03:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=lhjG5B+m
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 791E51F000CA;
	Tue, 24 Nov 2026 06:03:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795500199;
	bh=M9jL5IiALvmK/ea8xnsBuKnxJ95RqHSo/nmekJvDzoA=;
	h=Date:To:From:In-Reply-To:References:Subject;
	b=lhjG5B+mrecEgauDy64nQicoYl7xk9UJsVkar546NkAJ8k+NAOg6jjPwiA8WBwbiD
	 siz75LFa888Gh1Afnc895Byhjk0xTuuN6WggpVfrWo1ZJHb8b3SHIkBR7kNhutaYxf
	 mvxOuAOd7HGceGvH751dRxQGxBKb718Y53BA6Xs8=
Date: Mon, 23 Nov 2026 22:03:18 -0800
To: mm-commits@vger.kernel.org,jarkko@kernel.org,
	james.bottomley@hansenpartnership.com,dhowells@redhat.com,abc0eichs@qq.com,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <tencent_AFE15D698FFD4F18E16A6EF7CDA002D69806@qq.com>
References: <tencent_AFE15D698FFD4F18E16A6EF7CDA002D69806@qq.com>
Subject: + lib-asn1_encoder-fix-encoding-of-zero-oid-components.patch added to mm-nonmm-unstable branch
Message-Id: <20261124060319.791E51F000CA@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: lib/asn1_encoder: fix encoding of zero OID components
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-asn1_encoder-fix-encoding-of-zero-oid-components.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-asn1_encoder-fix-encoding-of-zero-oid-components.patch

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
Subject: lib/asn1_encoder: fix encoding of zero OID components
Date: Fri, 20 Nov 2026 21:00:55 +0800

asn1_encode_oid_digit() encodes a zero component as 0x80, which says
another octet belongs to the same subidentifier.  If zero is the last
component, the encoding ends with an unterminated subidentifier.  If
another component follows, a decoder may consume its octets as part of the
zero component instead.  For example, 1.2.0.1 becomes 06 03 2a 80 01: DER
rejects it, while a permissive decoder may read it as 1.2.1.

Encode zero as 0x00, the complete one-octet representation of a zero
subidentifier.

Link: https://patch.msgid.link/tencent_AFE15D698FFD4F18E16A6EF7CDA002D69806@qq.com
Fixes: b07067627cd5 ("lib: Add ASN.1 encoder")
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: zzz <abc0eichs@qq.com>
Cc: James Bottomley <james.bottomley@hansenpartnership.com>
Cc: Jarkko Sakkinen <jarkko@kernel.org>
Cc: David Howells <dhowells@redhat.com>

 lib/asn1_encoder.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/asn1_encoder.c~lib-asn1_encoder-fix-encoding-of-zero-oid-components
+++ a/lib/asn1_encoder.c
@@ -97,7 +97,7 @@ static int asn1_encode_oid_digit(unsigne
 
 	/* quick case */
 	if (oid == 0) {
-		*data++ = 0x80;
+		*data++ = 0;
 		(*data_len)--;
 		goto out;
 	}
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
mm-madvise-notify-userfaultfd-when-installing-guard-regions.patch
afs-do-not-put-error-pointer-after-address-lookup-failure.patch
selftests-mm-check-that-fsync-reports-hard-poisoned-dirty-page-cache.patch
selftests-mm-check-that-fsync-reports-hard-poisoned-dirty-page-cache-fix-2.patch
selftests-mm-check-that-fsync-reports-hard-poisoned-dirty-page-cache-fix-3.patch
selftests-mm-check-that-fsync-reports-hard-poisoned-dirty-page-cache-fix-4.patch
selftests-mm-check-that-fsync-reports-hard-poisoned-dirty-page-cache-fix-5.patch
selftests-mm-check-that-fsync-reports-hard-poisoned-dirty-page-cache-fix-6.patch
selftests-mm-check-that-fsync-reports-hard-poisoned-dirty-page-cache-fix-7.patch
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

