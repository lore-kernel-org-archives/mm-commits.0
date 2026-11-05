Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793899296;
	b=POFTa7TUdtuZYVnGcwCa8Rdw8CnUBTNXlAjPI7mqAsT0xK7FxcSkZeorqHu+8v/bpK2R
	 xagFpH2hIFP/ilVAea2G3lP46EY8XZrWLwrt/RTeBUcIS/Srgj+Z0vAgPlW0i2U1zausu
	 cCbwvqlbiFuwACqZZrFErzModlt5A7S7jvGG0ca3kqwZzwILTmJL7Kdk/CwT6MqJp34Ex
	 xIAeQ1dhPRE0PF0pYojy+mln6glfxaD8zfetGm9daMa5nWF3pqw6QdCQDw1Gx5BaxGnB7
	 5a7P2MC0PbPW9iicGKweIQMjBSHBr2rhlklCE8Zp2Rd/ln2vp3lWgIch07fXQ69xXZg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793899296;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=0sALZF7VsKCy9ZVmB/AwQasdXrzHkU89nDNmepM8XAw=;
	b=R1TB61T2zY/cPckVj3Ok0tNp6YDaTwqFOFKg5HKKcieHsADis2y5554P/ChUtA9/V/wU
	 FnNuq/1O/XIIxm06kf1uxs/ByE84WBPu8TKj2oWzlMTMQri8m1oTqkDgUMAZivl9R5bcJ
	 i82Pxf7KaLIM0zUEgQvX56J3d4tTKv5RH7orG6ovRUnktvu884dEAkwmuD0yYCYX/eirv
	 GeKhqBO4iM67srKbTUBgVQZ8Z4IZdW88JyE2WPhgQpEgXBYtanDW0Xr6i7ozdDsSv7cLV
	 qrqX5Td6kxlHSku02KarxG7Zjv1CazLc0146jy+YtabIDwPedEabkJVmR5th5ptP3lg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=Ed0eD3F3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3591D60703CC
	for <mm-commits@vger.kernel.org>; Thu,  5 Nov 2026 17:21:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=Ed0eD3F3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A29221F000C1;
	Thu,  5 Nov 2026 17:21:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793899295;
	bh=0sALZF7VsKCy9ZVmB/AwQasdXrzHkU89nDNmepM8XAw=;
	h=Date:To:From:Subject;
	b=Ed0eD3F3q2EE1Tclqgw7DU8XJVjiiqhTSvcSQbnppiu/3Tf7XehQRl4N01e1l7/Po
	 9RyFgB/f7LNdYNiMxrGt+JfOVnouIEAi1RJrbkJ7i1ewGOK9/hjLnO1Rt975efoc38
	 a7Li3jnKRx+YshaNDQy9AqC2s1iWtwRlbxn4wIQU=
Date: Thu, 05 Nov 2026 09:21:35 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,
	usama.arif@linux.dev,surenb@google.com,shuah@kernel.org,ryan.roberts@arm.com,
	rppt@kernel.org,nico.pache@linux.dev,mhocko@suse.com,ljs@kernel.org,
	liam@infradead.org,lance.yang@linux.dev,kas@kernel.org,dev.jain@arm.com,
	david@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,
	sashal@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-add-config_debug_fs-to-the-config-fragment.patch added to mm-new branch
Message-Id: <20261105172135.A29221F000C1@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: selftests/mm: add CONFIG_DEBUG_FS to the config fragment
has been added to the -mm mm-new branch.  Its filename is
     selftests-mm-add-config_debug_fs-to-the-config-fragment.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-add-config_debug_fs-to-the-config-fragment.patch

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
selftests-mm-add-config_debug_fs-to-the-config-fragment.patch
selftests-proc-search-the-kernel-headers-before-the-tools-copies.patch
selftests-prctl-select-the-tests-by-arch-alone.patch

