Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795072329;
	b=qJSWuYyq7lAULFussI59Rwfmb7D5n6WJnlWZs/QDjTrKrjVUYasNI7lvZIeO5HGktrcV
	 kV2B86cCfNWcbeXTBkmn2GaoWLiTZPnSjcSI20IyLrR8lEW2Hh20+/ZJ5VfZXQZM8tUvn
	 SyU4v3KaWyuqk774OcU5AoTnowcXCtNv0m7aYIHpHMqD3gz6X65N1P09f9j++/UnE7XUc
	 STZVV2rev9uCp/9BLQ6+uOGg77oPUq44eCSXDq11NBOx8xLbUvnWaSwck/RTnC32t6uLd
	 XbUYwRAqBlgH4cdru9RZLUnnDFl49swOv7fWA//XpkYxPU/avqoOjyynwN+fvYFJvvg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795072329;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=Lyb2O/m7Zh5rZhsSvK3WuQm9m/Ubxy7vviXQamNl+8w=;
	b=1cqTj4/nZHUZH2egP3UXUczYB6wvIbEEuL/rX2Qo53U6T7T+VMU1J86YPBDAukegIViv
	 46r8nje8Ihio84Ggun/OeWznAlJqVEDOO+KtFyrDM7zIFUv2581KSMQUQfuJnZ6F14h7Y
	 0PNkHXW/LipnfM4KFUnaHOF9qDEn+WihUSlIHRh/6eQP0EI2ejDnnOKJm+LrhFR6CsTXT
	 x7C161OXMTSk4aPvjowsacQTqoQXXnkjEO/QwUztjwSp9s+mKcrfGZ4ptd5NkHqLjn5GI
	 Vk2bg8RGiOHBtn/5xs8T5njwmiZKvMBkJuG8W32dI8S3RbUgOlh5AXeYXoBR9EnyN5A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=rF7zv0nf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AA2A606A320
	for <mm-commits@vger.kernel.org>; Thu, 19 Nov 2026 07:12:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=rF7zv0nf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D1401F000C6;
	Thu, 19 Nov 2026 07:12:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795072328;
	bh=Lyb2O/m7Zh5rZhsSvK3WuQm9m/Ubxy7vviXQamNl+8w=;
	h=Date:To:From:Subject;
	b=rF7zv0nfWylI1dJ05cYKAPWATM2LRwop36iQTS2RW6irglYrgXzF+nPOg1OlIPTF/
	 wgiPWrLqry++bxO85vUeSnZ/d7f5navc+GC4K1TMQwR8mwMQYiqugCkuUfixfFSYno
	 PRRxK3urRYpkv1R0w8RxotIOUErjFG+pltc9dRDQ=
Date: Wed, 18 Nov 2026 23:12:07 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,yuzhao@google.com,
	willy@infradead.org,tz2294@columbia.edu,rppt@kernel.org,osalvador@suse.de,
	nao.horiguchi@gmail.com,muchun.song@linux.dev,mt4022@columbia.edu,
	mike.kravetz@oracle.com,linmiaohe@huawei.com,kaitao.cheng@linux.dev,
	jane.chu@oracle.com,david@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory-failure-dont-unpoison-a-leaked-raw_hwp_unreliable-folio-fix.patch added to mm-new branch
Message-Id: <20261119071208.4D1401F000C6@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm-memory-failure-dont-unpoison-a-leaked-raw_hwp_unreliable-folio-fix
has been added to the -mm mm-new branch.  Its filename is
     mm-memory-failure-dont-unpoison-a-leaked-raw_hwp_unreliable-folio-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memory-failure-dont-unpoison-a-leaked-raw_hwp_unreliable-folio-fix.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
Subject: mm-memory-failure-dont-unpoison-a-leaked-raw_hwp_unreliable-folio-fix
Date: Wed Nov 18 11:07:50 PM PST 2026

add a unpoison_pr_info message. per Miaohe

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Jane Chu <jane.chu@oracle.com>
Cc: Kaitao Cheng <kaitao.cheng@linux.dev>
Cc: Mani Tofigh <mt4022@columbia.edu>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Tal Zussman <tz2294@columbia.edu>
Cc: Yu Zhao <yuzhao@google.com>
Cc: Zi Yan <ziy@nvidia.com>

 mm/memory-failure.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/mm/memory-failure.c~mm-memory-failure-dont-unpoison-a-leaked-raw_hwp_unreliable-folio-fix
+++ a/mm/memory-failure.c
@@ -2818,8 +2818,12 @@ int unpoison_memory(unsigned long pfn)
 	 * flag in folio->private, which stays set on the leaked folio.
 	 */
 	if (folio_test_large(folio) &&
-	    folio_test_hugetlb_raw_hwp_unreliable(folio))
+	    folio_test_hugetlb_raw_hwp_unreliable(folio)) {
+		unpoison_pr_info("%#lx: cannot unpoison, poisoned subpages are unknown\n",
+				 pfn, &unpoison_rs);
+
 		goto unlock_mutex;
+	}
 
 	ghp = get_hwpoison_page(p, MF_UNPOISON);
 	if (!ghp) {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

maintainers-add-page_exth-to-memory-management-page-allocator.patch
shmem-consume-the-reserved-xattr-space-despite-remount.patch
selftests-mm-check-madv_cold-and-madv_pageout-on-partly-advised-thps-fix.patch
alloc_tag-introduce-ioctls-to-toggle-allocation-tracepoints-fix-fix.patch
alloc_tag-introduce-ioctls-to-toggle-allocation-tracepoints-fix.patch
selftests-mm-add-uffdio_move-huge-zeropage-pmd-regression-test-fix.patch
selftests-mm-allocate-nr_pages-based-on-pmd-size-for-uffd-pmd_move-tests-fix.patch
selftests-mm-retain-move-pmd-coverage-and-verify-huge-pmds.patch
lib-test_xarray-check-unused-spare-node-after-range-creation.patch
mm-memory-failure-dont-unpoison-a-leaked-raw_hwp_unreliable-folio-fix.patch
ipc-msg-clamp-negative-msg_info-usage-counts.patch
squashfs-fix-leaked-page-locks-when-page-actor-allocation-fails-fix.patch
squashfs-sanity-check-directory-metadata-block-location-fix.patch
squashfs-fix-variables-in-directory-code-and-add-more-sanity-checks-fix.patch
ocfs2-skip-network-flush-when-no-domain-handlers-are-registered.patch
selftests-ptrace-check-that-ptrace_set_syscall_info-rejects-invalid-error-values-fix.patch
drivers-media-v4l2-core-v4l2-vp9c-reduce-inlining.patch

