Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 986523211
	for <mm-commits@vger.kernel.org>; Wed,  4 Sep 2024 03:41:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725421274; cv=none; b=pHVlh8ev65ft3qQYfm4doe1YPhqFcf3XXMygX7fI4N+0k1vbQR+QejQmIXpblhjF66KZNKVwX0M2Qma6XM5DMWtQVKAhNJOg9xrM6ctlJYTs3osAOWkK1ryoDHbfCqtcsQveEcypTnkbbGRds3P6pBCV9o/F3lcVX8YYCMK+jzs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725421274; c=relaxed/simple;
	bh=bC3f95aMzFgGO03YmGNi4cGeEhb3pnLeiH8/heXasyg=;
	h=Date:To:From:Subject:Message-Id; b=C4HiOEJV4XjOuDEf5+wTdIAYxYYULqzYmp9rYeH4+OErm2n/OUa576XWn7F2pbgIVGIU3eJv6UBWO8oxi4Y8Cjw88HE5HZMlfAjAkM9P07TGYNhSHtmkMlOJ3SxSDV+DpSj9HpejjdRMLQs9ohDujLneiVRSlqyFvGZa8+bUg5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=nPBcMfyG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="nPBcMfyG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4977FC4CEC2;
	Wed,  4 Sep 2024 03:41:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725421274;
	bh=bC3f95aMzFgGO03YmGNi4cGeEhb3pnLeiH8/heXasyg=;
	h=Date:To:From:Subject:From;
	b=nPBcMfyGlBlF+KGllS/0+b9+eqqIt2YN7ftTmjb6wT4FLGfq+41BCLJFMuBu7Rm+q
	 AlRB7eRPxB4h+b5QbjO4A7YgD3RyELbYezq2NcCJilYXVgyPwF8+2RQUCXjzGHxjBi
	 PwFvo4vtZ0DIlzZFmHTXIfeoDzrxFdpkF4IHk2j8=
Date: Tue, 03 Sep 2024 20:41:13 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,11162571@vivo.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] tools-mm-check-mmap-based-on-return-values.patch removed from -mm tree
Message-Id: <20240904034114.4977FC4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: tools:mm: check mmap based on return values
has been removed from the -mm tree.  Its filename was
     tools-mm-check-mmap-based-on-return-values.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Yang Ruibin <11162571@vivo.com>
Subject: tools:mm: check mmap based on return values
Date: Tue, 20 Aug 2024 23:50:03 -0400

To correctly detect whether mmap is successful, must use if (map_ptr ==
MAP_FAILED)to avoid incorrectly handling a valid mapping.

Link: https://lkml.kernel.org/r/20240821035005.4423-1-11162571@vivo.com
Signed-off-by: Yang Ruibin <11162571@vivo.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/ksm_tests.c     |    2 +-
 tools/testing/selftests/mm/madv_populate.c |    2 +-
 tools/testing/selftests/mm/soft-dirty.c    |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

--- a/tools/testing/selftests/mm/ksm_tests.c~tools-mm-check-mmap-based-on-return-values
+++ a/tools/testing/selftests/mm/ksm_tests.c
@@ -201,7 +201,7 @@ static void  *allocate_memory(void *ptr,
 {
 	void *map_ptr = mmap(ptr, map_size, PROT_WRITE, mapping, -1, 0);
 
-	if (!map_ptr) {
+	if (map_ptr == MAP_FAILED) {
 		perror("mmap");
 		return NULL;
 	}
--- a/tools/testing/selftests/mm/madv_populate.c~tools-mm-check-mmap-based-on-return-values
+++ a/tools/testing/selftests/mm/madv_populate.c
@@ -34,7 +34,7 @@ static void sense_support(void)
 
 	addr = mmap(0, pagesize, PROT_READ | PROT_WRITE,
 		    MAP_ANONYMOUS | MAP_PRIVATE, 0, 0);
-	if (!addr)
+	if (addr == MAP_FAILED)
 		ksft_exit_fail_msg("mmap failed\n");
 
 	ret = madvise(addr, pagesize, MADV_POPULATE_READ);
--- a/tools/testing/selftests/mm/soft-dirty.c~tools-mm-check-mmap-based-on-return-values
+++ a/tools/testing/selftests/mm/soft-dirty.c
@@ -134,7 +134,7 @@ static void test_mprotect(int pagemap_fd
 	if (anon) {
 		map = mmap(NULL, pagesize, PROT_READ|PROT_WRITE,
 			   MAP_ANONYMOUS|MAP_PRIVATE, -1, 0);
-		if (!map)
+		if (map == MAP_FAILED)
 			ksft_exit_fail_msg("anon mmap failed\n");
 	} else {
 		test_fd = open(fname, O_RDWR | O_CREAT, 0664);
_

Patches currently in -mm which might be from 11162571@vivo.com are


