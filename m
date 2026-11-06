Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793942362;
	b=4BajhrujNhXHwcy6LaDByhqze0r6zainEODrWbJ+eHT4RSvKawZRwpCIyIyVV64mwFmu
	 NCPXC6D/AREsvwAYt05Yr/deUWHn2xGbh3L6eh2zEoB8KGetLC+kwwSIOqF2dAScjGi9v
	 62jNqJndWNDVlsZaOlSNpnM1OzgVo0nBSnf1sBvlyPz5MdGoCV7nbvFhV25TR5KFZu3rb
	 bDu14lwgmkkXWY1Yku7dskwYjtuPG7Ydk0ICXViu0OYPTh1xjD3KJo/IVfnNFivQY+zxP
	 kSb0jGeRM+voxtgMOXMZo3+8N/VLkNVt0Nmm3GDCUUtXg9qNoThgXECDwuADeJAgyMw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793942362;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=J9nECnPQhM6PqDjDFFunjq/0OhT7NZHHsslSfeUZUng=;
	b=K/cT8weQCkRarvCfLVn0zV+3qDZpwbL3fHuf5nOGPsf6TQBu7Fqn9Nbbyrv9Mk7KBA6h
	 uoJNz4h522z6avUuyoojPPLkPtgfE9SpeVb9uOYmwWmqJRc/KhtlrNZD/hKJwuYspjFaS
	 n20JTrA6kVF1CIcdJQmlvAdCWnCPvSgG6MNVZBvHjBG+Fu8TlMWwwyqczEz/ryY+BQTUX
	 e3lRXQtjYUMFJactLxg/Qny+Bhwflo5mR52d5xyhPlUC4ufwzl6TX/bfZbBeJdBk7Ui7d
	 VHeLBO0Jw2lIuOFxExTpQDqAIQ2DdrPGQH5zIKR0dPHTP1kJFbOVNReq2BjhdfBjO+Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=mNRqzrIx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 608AC606A334
	for <mm-commits@vger.kernel.org>; Fri,  6 Nov 2026 05:19:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=mNRqzrIx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E94041F008A1;
	Fri,  6 Nov 2026 05:19:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793942362;
	bh=J9nECnPQhM6PqDjDFFunjq/0OhT7NZHHsslSfeUZUng=;
	h=Date:To:From:Subject;
	b=mNRqzrIx7Fw7evm8VfLprJbiLrxf0YJIZYZnm1VV++s4TKbYJmFVuBloBKFLNkBT2
	 RHsbW0WmhN/YLv/Tux4C+onVRHNn81gZNlixeJJswbuWiknEpmeF+2lxypf9iylHZ5
	 U384Z12M1Px2F0mQwi1qyLP/L1Zlm2Ur2KctIMc4=
Date: Thu, 05 Nov 2026 21:19:21 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,usama.arif@linux.dev,
	shuah@kernel.org,ryan.roberts@arm.com,ritesh.list@gmail.com,
	peterx@redhat.com,nico.pache@linux.dev,maddy@linux.ibm.com,
	loic.molinari@collabora.com,ljs@kernel.org,liam@infradead.org,
	lance.yang@linux.dev,khorenko@virtuozzo.com,kas@kernel.org,jgg@ziepe.ca,
	dev.jain@arm.com,david@kernel.org,baolin.wang@linux.alibaba.com,
	baohua@kernel.org,azpijr@gmail.com,alex@shazbot.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-test-fork-of-pmd-mapped-shmem-thps-fix.patch added to mm-new branch
Message-Id: <20261106051921.E94041F008A1@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: selftests-mm-test-fork-of-pmd-mapped-shmem-thps-fix
has been added to the -mm mm-new branch.  Its filename is
     selftests-mm-test-fork-of-pmd-mapped-shmem-thps-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-test-fork-of-pmd-mapped-shmem-thps-fix.patch

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
Subject: selftests-mm-test-fork-of-pmd-mapped-shmem-thps-fix
Date: Thu Nov  5 07:51:02 PM PST 2026

s/read_pmd_pagesize/pmd_size/

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Alex Williamson <alex@shazbot.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: "Jose A. Perez de Azpillaga" <azpijr@gmail.com>
Cc: Kiryl Shutsemau <kas@kernel.org>
Cc: Konstantin Khorenko <khorenko@virtuozzo.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Loïc Molinari <loic.molinari@collabora.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Nico Pache <nico.pache@linux.dev>
Cc: Peter Xu <peterx@redhat.com>
Cc: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Usama Arif <usama.arif@linux.dev>
Cc: Zi Yan <ziy@nvidia.com>
---

 tools/testing/selftests/mm/fork_file_thp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/mm/fork_file_thp.c~selftests-mm-test-fork-of-pmd-mapped-shmem-thps-fix
+++ a/tools/testing/selftests/mm/fork_file_thp.c
@@ -235,7 +235,7 @@ int main(void)
 {
 	ksft_print_header();
 	pagesize = getpagesize();
-	pmdsize = read_pmd_pagesize();
+	pmdsize = pmd_psize();
 	if (!pmdsize)
 		ksft_exit_skip("THP is not supported\n");
 	if (pmdsize > MAX_PMDSIZE)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-mempolicy-use-one-node-set-for-interleave-weights.patch
maple_tree-fix-reverse-iterator-state-when-the-root-disappears.patch
shmem-consume-the-reserved-xattr-space-despite-remount.patch
selftests-mm-check-madv_cold-and-madv_pageout-on-partly-advised-thps-fix.patch
alloc_tag-introduce-ioctls-to-toggle-allocation-tracepoints-fix.patch
mm-filemap-convert-fault-and-readahead-logic-to-use-vma_flags_t-fix.patch
selftests-mm-test-fork-of-pmd-mapped-shmem-thps-fix.patch
iommufd-enforce-memfd-write-seals-for-file-mappings.patch
fault-inject-initialize-random-state-on-first-use.patch
profile-account-for-partial-proc-profile-reads.patch
profile-simplify-proc-profile-read-layout.patch
ipc-msg-clamp-negative-msg_info-usage-counts.patch
drivers-media-v4l2-core-v4l2-vp9c-reduce-inlining.patch

