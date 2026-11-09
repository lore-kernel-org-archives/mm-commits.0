Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794267041;
	b=4Wl2wBOvD2oQcpW3rTEyYDBfWWwP1/0Ht0bZTc5aqpyvp8z/cHw/FltK7ZeT3d1ryvzk
	 zla6yB43Fpcwjgmzdf8Z13HR03fnlfGHTthPE0weszchLRAmE/PrUM8/aUobMLTCZIrvp
	 U5AdbORdYMIA9Uxe79vRR+2TXyAfv9tcHLTuGCA4z6SdctFgP8HAUj7jUK3g2ZOqg+Swt
	 cNA1mA+Dq7F4e3ANSZCQCbHId4bOfMHlC+mDIu5mCD98PeC+JEFqmPqYWsj+dh065CnVV
	 6h6YZ8ShNGDBLc2AeeB8Az0l5XvLh0Q5otM8VXXzI44Yh2GQz/fRB0NdN7JJLwWpk6g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794267041;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=4Rk1++tOoZw4yWTUJhl0H8A5DmdQ20mfJOv8gBfyZGE=;
	b=Dnvn4o9jdK0g5/fAKNtvoPLwmSPoSGsQyEwIbJSR/CvDUBHDXeGYY64OvJnZD8mYsXpa
	 amft831UbWYzsVssQYUA5o+qgUjcrFoUFmcQ8Cs/rKkZGyl9YOAgYhjEYC2H3GXXIEkHL
	 IFigQFcIk0AYFl/NATDXp5MFh//oDnLCtcKS+yx2KF0ZlIiCf8Ehas84j7ICB1s2YJXUi
	 OlUnzEXsSDS92+ZmOvqkyt8rArj4FSyt+jj+qgcEEU1fbzyuPAO8LS9Rh+kJzs3pDiTlk
	 Pu2bJTKpL5GFvIO4ljSxg7MWqOgCPj6ck8P9sIuei92qJUJjpQPnGpY7DK9/tsBwWOQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=E+R+Rb1i;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A8CB606A333
	for <mm-commits@vger.kernel.org>; Mon,  9 Nov 2026 23:30:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=E+R+Rb1i
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 174121F008A3;
	Mon,  9 Nov 2026 23:30:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794267040;
	bh=4Rk1++tOoZw4yWTUJhl0H8A5DmdQ20mfJOv8gBfyZGE=;
	h=Date:To:From:Subject;
	b=E+R+Rb1i8PbNXKmFUpuN3NkqD0KmwEXCAvl9xBjcOoUBIKHqi0xY7nX//R9VEC2cN
	 RUSVJYPgREc4vevnnEzlQtlQTl12kl1nViKhoCwukSfPC/n7mZD15AmEc+3UxW0Mbt
	 8H5cWPdtavfGZ3ggM87Lu/dCiWk+DjoWa/iTL+ts=
Date: Mon, 09 Nov 2026 15:30:39 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,usama.arif@linux.dev,
	shuah@kernel.org,ryan.roberts@arm.com,nico.pache@linux.dev,ljs@kernel.org,
	liam@infradead.org,lance.yang@linux.dev,kas@kernel.org,dev.jain@arm.com,
	david@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,
	sashal@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] selftests-mm-skip-split_huge_page_test-without-the-split_huge_pages-file.patch removed from -mm tree
Message-Id: <20261109233040.174121F008A3@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: selftests/mm: skip split_huge_page_test without the split_huge_pages file
has been removed from the -mm tree.  Its filename was
     selftests-mm-skip-split_huge_page_test-without-the-split_huge_pages-file.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Sasha Levin <sashal@kernel.org>
Subject: selftests/mm: skip split_huge_page_test without the split_huge_pages file
Date: Wed,  4 Nov 2026 22:02:42 -0500

Every case in split_huge_page_test goes through
/sys/kernel/debug/split_huge_pages.  When that file does not exist,
because debugfs is not mounted or the kernel has no CONFIG_DEBUG_FS, the
first write bails out of the whole test and it is reported as a failure:

  Bail out! write_file(/sys/kernel/debug/split_huge_pages): No such file or directory

Skip the test in that case.

Link: https://lore.kernel.org/20261105030242.1241448-1-sashal@kernel.org
Fixes: fa6c02315f74 ("mm: huge_memory: a new debugfs interface for splitting THP tests")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Nico Pache <nico.pache@linux.dev>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Usama Arif <usama.arif@linux.dev>
Cc: Shuah Khan <shuah@kernel.org>
---

 tools/testing/selftests/mm/split_huge_page_test.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/tools/testing/selftests/mm/split_huge_page_test.c~selftests-mm-skip-split_huge_page_test-without-the-split_huge_pages-file
+++ a/tools/testing/selftests/mm/split_huge_page_test.c
@@ -610,6 +610,9 @@ int main(int argc, char **argv)
 	if (!thp_is_enabled())
 		ksft_exit_skip("Transparent Hugepages not available\n");
 
+	if (access(SPLIT_DEBUGFS, W_OK))
+		ksft_exit_skip("%s: %s\n", SPLIT_DEBUGFS, strerror(errno));
+
 	if (argc > 1)
 		optional_xfs_path = argv[1];
 
_

Patches currently in -mm which might be from sashal@kernel.org are

selftests-proc-cast-the-procmap_query-address-through-uintptr_t.patch
selftests-mm-fix-pointer-width-warnings-on-32-bit-architectures.patch
selftests-mm-uffd-wp-mremap-keep-the-thp-sizes-in-unsigned-long.patch
selftests-proc-search-the-kernel-headers-before-the-tools-copies.patch
selftests-prctl-select-the-tests-by-arch-alone.patch

