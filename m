Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794004961;
	b=h9CrYXLfAJ9rlx5a6q3DG9QKg4X5t4p6+Z1AP9+KVVAw86towtzorZQ0Wm5awZmfPUcz
	 WnMkihCZCRGeoQdQ+Dke7PRE+dblBjdZaRPnvfqBtHflwgB5NTQvp3ymKTYIRkPGPysxH
	 2xam040CzSOuH9L7Y8Vgjqs9biawIW96gdJcg+4u+rr9KA/4LoJOEejrzyfXNQhOm7ZVE
	 Reiif6wMi4Gf1a90ShzhkxjZydXUCE7MWKEOThC8ePtHJxqGM5LCc1ESBmZx+1zySRys7
	 TvtaZ5am9UUsDysv0MO9Dik8mxtgJ/DANhiNb8YHAVX+bvaB66Ur+KhJfojhceMzcAg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794004961;
	h=Received:DKIM-Signature:Date:To:Cc:From:Subject:Message-Id;
	bh=KDMCk4/nFam4vXhmb5RBBlIvTMQ+yYfNljLK17kD7P8=;
	b=X+kkB4X1F0zc+6PvMCtG9hMbK1ChRMjsLmVXvXxLEKMdMWqJ2ruKy6SOcbqxfCXHh0g5
	 TCzsKAM3qa2ImtvDMjhxyM54WL2mpqNYAmd/TbvbTFvlMFe/C1ECITN6gRP75NoJ7M0VP
	 MjTNqowRB0YybH0129Lyum5ah4LR9uXAGmu3CnPLGLrVyiFOduOg+ZlVtx4BbVdzGVp+e
	 6vBP3zHTaM3bXyaCpNiZjyC8HOLpTajrGua16frCcWJ4L83CZ4f0nt+n9xX5edMByp2F1
	 w47nGy2/gk+zmQfmB3FAENLwxZ1LP0wH3bLZ/EV2X154N9CZu0OVXC0DYnktEwoRI5A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=y1sTsdyw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AE7E606D802
	for <mm-commits@vger.kernel.org>; Fri,  6 Nov 2026 22:42:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=y1sTsdyw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B32351F00900;
	Fri,  6 Nov 2026 22:42:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794004960;
	bh=KDMCk4/nFam4vXhmb5RBBlIvTMQ+yYfNljLK17kD7P8=;
	h=Date:To:Cc:From:Subject;
	b=y1sTsdywHPqstUcwacHHQYsmid+gqbJw6+62U5vrWJ4BRUSQ2/+f0ByEe0fL/QRl9
	 xuD3r3bM+UYIQ1EsMzw/PQ6rZMzvM8hIhn2gnsATL2HsK4aZXaGTsxPdC03OaQ6YVB
	 1CilnTr0Da8jCniHjemRv1a2dAlrflfVn7aOC5Jc=
Date: Fri, 06 Nov 2026 14:42:40 -0800
To: mm-commits@vger.kernel.org, ziy@nvidia.com, usama.arif@linux.dev,
 shuah@kernel.org, ryan.roberts@arm.com, ritesh.list@gmail.com,
 peterx@redhat.com, nico.pache@linux.dev, maddy@linux.ibm.com,
 loic.molinari@collabora.com, ljs@kernel.org, liam@infradead.org,
 lance.yang@linux.dev, khorenko@virtuozzo.com, kas@kernel.org, jgg@ziepe.ca,
 dev.jain@arm.com, baolin.wang@linux.alibaba.com, baohua@kernel.org,
 azpijr@gmail.com, alex@shazbot.org, akpm@linux-foundation.org
Cc: David Hildenbrand <david@kernel.org>
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] selftests-mm-test-fork-of-pmd-mapped-shmem-thps-fix.patch removed from -mm tree
Message-Id: <20261106224240.B32351F00900@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: selftests-mm-test-fork-of-pmd-mapped-shmem-thps-fix
has been removed from the -mm tree.  Its filename was
     selftests-mm-test-fork-of-pmd-mapped-shmem-thps-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
alloc_tag-introduce-ioctls-to-toggle-allocation-tracepoints-fix-fix.patch
alloc_tag-introduce-ioctls-to-toggle-allocation-tracepoints-fix.patch
mm-filemap-convert-fault-and-readahead-logic-to-use-vma_flags_t-fix.patch
mm-filemap-convert-fault-and-readahead-logic-to-use-vma_flags_t-fix-fix.patch
profile-account-for-partial-proc-profile-reads.patch
profile-simplify-proc-profile-read-layout.patch
ipc-msg-clamp-negative-msg_info-usage-counts.patch
drivers-media-v4l2-core-v4l2-vp9c-reduce-inlining.patch

