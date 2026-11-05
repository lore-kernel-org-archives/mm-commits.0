Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793901598;
	b=OYeNPz3LhnGqiT9GmzYpzRPNZEhDLzbHBSWBFWev0PAUrniikc/xKebqQaRlwS8uIX2e
	 QwFryuNK6hprfSudXMynrGJWMXkPt/bqh84mtE+tKjH4z8InDm3soQb6ELIBdracFRQuQ
	 H2SyEQwoiU7UVeCTZ2j/7lCGuS3H7LLGAoNZbXHU0CpEYqpAoC/xx2cjbrSvkakXzKY7k
	 GsAiHRN6PRgz9tV2Ox136VHqm1bGpyoamgpecodpVj6ktkFAKl0Eg2Jn1odTA/ro50A8j
	 geZX3et9xKaGqynL5bQDHwVh3nC6Nf5rNumVv/jlAMZVD6+nSC8eP/75qe6Fu/gtWCg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793901598;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=N6FqJPvE6nSQKnPtEIcbvGfGhWiy3vIdyOSg3p6855w=;
	b=4M+NIEcrGNg/07YU8fO5n3J/mnwdyLRmFw31IpwpLxXgga0myQSlhcD+ZXKOLBCPaxOT
	 0I27TNKYKKj+jvQTCQSMtBagKxqt1n/dvB7FLl+KRaFxEpFTpg+Jn6ac66VE5UEsOT5l3
	 36J4VBRvrwamLbq2kDbiouWDjUys7rj5xcWRTHhy8qr8ThAoxj1WVZmW21MRbRd5q5g/i
	 X7YN4DV3WuIEEeYbxs58yC/1wuvB5FbDNCGzGRWfGDKMTSwF5tNB3k/iYBQ0J88FOlc2A
	 gArY/WNAEJNOV+8I4ic1wc/OG8IYlO1e4SOCDPTItrRmsTe4W7x1fSVNhfWvvT2oGWg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=ZFK2oE3s;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAF8C606D81D
	for <mm-commits@vger.kernel.org>; Thu,  5 Nov 2026 17:59:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=ZFK2oE3s
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60F381F00A26;
	Thu,  5 Nov 2026 17:59:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793901597;
	bh=N6FqJPvE6nSQKnPtEIcbvGfGhWiy3vIdyOSg3p6855w=;
	h=Date:To:From:Subject;
	b=ZFK2oE3sK6uGvmMTcSVM5IIM2/U82+PUb+Hy+aYT4Jim/W8+NAi8EibyaE+6ipetO
	 iNXRhpp050Ju9dUzeRLE3BinkTsCswu2JnmWfU7o68EcB3Oq9eMzSNtBd41HwCFp1W
	 4Py/MWhqo8ZejRxNS4JYTGHKE+f2gm8tduizbNIc=
Date: Thu, 05 Nov 2026 09:59:56 -0800
To: mm-commits@vger.kernel.org,sashal@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] selftests-mm-add-config_debug_fs-to-the-config-fragment.patch removed from -mm tree
Message-Id: <20261105175957.60F381F00A26@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: selftests/mm: add CONFIG_DEBUG_FS to the config fragment
has been removed from the -mm tree.  Its filename was
     selftests-mm-add-config_debug_fs-to-the-config-fragment.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Sasha Levin <sashal@kernel.org>
Subject: selftests/mm: add CONFIG_DEBUG_FS to the config fragment
Date: Thu,  5 Nov 2026 12:18:01 -0500

The split_huge_page and gup tests need debugfs, and CONFIG_GUP_TEST
depends on it. Add CONFIG_DEBUG_FS=y to the fragment.

Link: https://lore.kernel.org/20261105171801.2189772-1-sashal@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Suggested-by: Zi Yan <ziy@nvidia.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Nico Pache <nico.pache@linux.dev>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Usama Arif <usama.arif@linux.dev>
Cc: Kiryl Shutsemau <kas@kernel.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Shuah Khan <shuah@kernel.org>
---

 tools/testing/selftests/mm/config |    1 +
 1 file changed, 1 insertion(+)

--- a/tools/testing/selftests/mm/config~selftests-mm-add-config_debug_fs-to-the-config-fragment
+++ a/tools/testing/selftests/mm/config
@@ -4,6 +4,7 @@ CONFIG_PTE_MARKER_UFFD_WP=y
 CONFIG_TEST_VMALLOC=m
 CONFIG_DEVICE_PRIVATE=y
 CONFIG_TEST_HMM=m
+CONFIG_DEBUG_FS=y
 CONFIG_GUP_TEST=y
 CONFIG_TRANSPARENT_HUGEPAGE=y
 CONFIG_MEM_SOFT_DIRTY=y
_

Patches currently in -mm which might be from sashal@kernel.org are

selftests-proc-cast-the-procmap_query-address-through-uintptr_t.patch
selftests-mm-fix-pointer-width-warnings-on-32-bit-architectures.patch
selftests-mm-uffd-wp-mremap-keep-the-thp-sizes-in-unsigned-long.patch
selftests-mm-skip-split_huge_page_test-without-the-split_huge_pages-file.patch
selftests-proc-search-the-kernel-headers-before-the-tools-copies.patch
selftests-prctl-select-the-tests-by-arch-alone.patch

