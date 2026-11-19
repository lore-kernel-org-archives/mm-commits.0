Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795113181;
	b=KUvFF5oNUnL7nAm3P2TG2dDR4+n78dVZ1Nq93Hmc8YWTFTRXRs7N3F/9f2k3P/NGple3
	 9eCKontS45b0x/tbqIq0nxvGwRfQDj8DiyT7tBWbowXbMzWttRuV35KD0aMFVZqMHF7ON
	 edbarEU/qDmzxLCnOjp87gcy0wG8d5xcoYZQAk/FgO/V5GQCPDBa86lrVuuLhy7YWBBbp
	 6Ks5gpR92/GB1UF4Wmn0Iqn9ZwdQqFtNlbKseCeDFiCr6orE81ZBdZXa9bg8tm2rCWii3
	 84GWRrnV0r43Vv4Vrhkfl1MEUkSIQv8WNZ4iQEHAVtSm52ZCtpjuRjsu0W1ATJpaKGQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795113181;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=El2Hi6dP8O9kLBB1BS8NJuPD7E07QFd/QF/7oHmjRog=;
	b=oh1YaR/hQtzAN4cpEA/UTSB8pKJPMPvZoyuzYHa9UPG8aGJHxqKFGbuFIKwzQ/kQwRBy
	 oNoL8ZBfdm1sw8vVPYoc2x4ULmh6yYCSBcQ+ByDONHlUVqjAWrQfQl6sYGDlN86NzGbBs
	 Xv51jcO9ssKGS6oqrF5hna/oNm+f51qgVKcwYOkjX7jm3FdT/0CeafvcbAT81ZDgXWOAM
	 v4I4Kkp6cuCwHDNRmRNvpFEubjF3ATTNTaERge03Fb5O8XDINt25CnY7mUu2rL1RSZv7A
	 u7WXLqFUnFn1FyuugrN2Ke8xLn9gvsZQwKsNo+ZBSvfor188o9Z9se08P2IExBAXyog==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=ZcwtqPno;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D0F5606A320
	for <mm-commits@vger.kernel.org>; Thu, 19 Nov 2026 18:33:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=ZcwtqPno
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C2751F000C5;
	Thu, 19 Nov 2026 18:33:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795113181;
	bh=El2Hi6dP8O9kLBB1BS8NJuPD7E07QFd/QF/7oHmjRog=;
	h=Date:To:From:Subject;
	b=ZcwtqPnoU/uo0PhzRF1EysQOOXYUFewWP8gJpXrii9/JfdCZ94dUFlMa1yj3ANTGu
	 0KWcwMVn1oSazeCQoanDW9n0pCc1so+CTLUyTTkLuoct4yyX/wrYk8n2fBH55PD+BT
	 s6qUT4LtorWQjpOTEx9h4aJdLfkKu4Et7QYCZ81Q=
Date: Thu, 19 Nov 2026 10:33:00 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,yeoreum.yun@arm.com,
	vbabka@kernel.org,usama.arif@linux.dev,surenb@google.com,shuah@kernel.org,
	sarthak.sharma@arm.com,ryan.roberts@arm.com,rppt@kernel.org,
	peterx@redhat.com,nico.pache@linux.dev,mhocko@suse.com,ljs@kernel.org,
	liam@infradead.org,leon@kernel.org,lance.yang@linux.dev,kas@kernel.org,
	jgg@ziepe.ca,dev.jain@arm.com,david@kernel.org,baolin.wang@linux.alibaba.com,
	baohua@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kselftest-mm-rename-read_pmd_pagesize-to-pmd_psize-fix.patch added to mm-unstable branch
Message-Id: <20261119183301.0C2751F000C5@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: kselftest-mm-rename-read_pmd_pagesize-to-pmd_psize-fix
has been added to the -mm mm-unstable branch.  Its filename is
     kselftest-mm-rename-read_pmd_pagesize-to-pmd_psize-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kselftest-mm-rename-read_pmd_pagesize-to-pmd_psize-fix.patch

This patch will later appear in the mm-unstable branch at
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
Subject: kselftest-mm-rename-read_pmd_pagesize-to-pmd_psize-fix
Date: Thu Nov 19 10:09:01 AM PST 2026

add a temporary back-compat define for -next integration reasons

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand (Arm) <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Kiryl Shutsemau <kas@kernel.org>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Leon Romanovsky <leon@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Nico Pache <nico.pache@linux.dev>
Cc: Peter Xu <peterx@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Sarthak Sharma <sarthak.sharma@arm.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Usama Arif <usama.arif@linux.dev>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Yeoreum Yun <yeoreum.yun@arm.com>
Cc: Zi Yan <ziy@nvidia.com>

 tools/testing/selftests/mm/vm_util.h |    2 ++
 1 file changed, 2 insertions(+)

--- a/tools/testing/selftests/mm/vm_util.h~kselftest-mm-rename-read_pmd_pagesize-to-pmd_psize-fix
+++ a/tools/testing/selftests/mm/vm_util.h
@@ -93,6 +93,8 @@ unsigned long pagemap_get_pfn(int fd, ch
 void clear_softdirty(void);
 bool check_for_pattern(FILE *fp, const char *pattern, char *buf, size_t len);
 uint64_t pmd_psize(void);
+/* temporary cross-tree compatibility thing: */
+#define read_pmd_pagesize() pmd_psize()
 unsigned long rss_anon(void);
 bool check_huge_anon(void *addr, size_t len, int nr_hpages, uint64_t hpage_size);
 bool check_huge_file(void *addr, size_t len, int nr_hpages, uint64_t hpage_size);
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
ipc-msg-clamp-negative-msg_info-usage-counts.patch
squashfs-fix-leaked-page-locks-when-page-actor-allocation-fails-fix.patch
squashfs-sanity-check-directory-metadata-block-location-fix.patch
squashfs-fix-variables-in-directory-code-and-add-more-sanity-checks-fix.patch
ocfs2-skip-network-flush-when-no-domain-handlers-are-registered.patch
selftests-ptrace-check-that-ptrace_set_syscall_info-rejects-invalid-error-values-fix.patch
drivers-media-v4l2-core-v4l2-vp9c-reduce-inlining.patch

