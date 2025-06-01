Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1931D156F28
	for <mm-commits@vger.kernel.org>; Sun,  1 Jun 2025 05:47:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748756858; cv=none; b=YbervG1D6htNNoj+1bvljanMm5kBAxbNtMBrMtnP8pe4osfnrWloZ3+5TdREJkG/vHbJKsTJDqWzqNM41C5KcdF2qT2loP89j34ZRHJmqJVXThclabH0w3eK5h1UjWk2vLLgcj+nQO4eMsuVLzHXbZDXB+Y2IS3RU41HKOnugG4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748756858; c=relaxed/simple;
	bh=cyRbYFgqdvD9pi5dw6d758N/UFNH4qgPxB2TdKA/u00=;
	h=Date:To:From:Subject:Message-Id; b=UXsCItf3Zvi5ygHAMgUDA67RbvjsRCenN94XAMR4cNWijmdDtjZWESJA0owl8TvClpR3L+80THqcSltX0BBwJvoNhmHdRrak+4BtX058rR2x9orAvHusF0si+tokoqyUmThbPqOSDmi7pCcSlYATM1ml6HgfVCQgbBLnCF+Yiww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=cvUQtoeH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="cvUQtoeH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFC81C4CEED;
	Sun,  1 Jun 2025 05:47:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1748756858;
	bh=cyRbYFgqdvD9pi5dw6d758N/UFNH4qgPxB2TdKA/u00=;
	h=Date:To:From:Subject:From;
	b=cvUQtoeH97ZDkLXHmLNGfVw0BLMikq+/zw4URVaplbUqjU3i03ZqQuf9UvTszaHoU
	 +34IDWCh3DByv/8+O1YNb4QCI2hbzuGgLUMZO1iHyQeJnAqo/TrFD9sOvQxS4sBiPo
	 YnHIavV1lsn5ls1cCL9A4qY0162oLHpc2sqlZ7I4=
Date: Sat, 31 May 2025 22:47:37 -0700
To: mm-commits@vger.kernel.org,yeoreum.yun@arm.com,shuah@kernel.org,richard.weiyang@gmail.com,lorenzo.stoakes@oracle.com,dan.carpenter@linaro.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] tools-testing-check-correct-variable-in-open_procmap.patch removed from -mm tree
Message-Id: <20250601054737.DFC81C4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: tools/testing: check correct variable in open_procmap()
has been removed from the -mm tree.  Its filename was
     tools-testing-check-correct-variable-in-open_procmap.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Dan Carpenter <dan.carpenter@linaro.org>
Subject: tools/testing: check correct variable in open_procmap()
Date: Wed, 28 May 2025 11:13:45 +0300

Check if "procmap_out->fd" is negative instead of "procmap_out" (which is
a pointer).

Link: https://lkml.kernel.org/r/aDbFuUTlJTBqziVd@stanley.mountain
Fixes: bd23f293a0d5 ("tools/testing: add PROCMAP_QUERY helper functions in mm self tests")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: levi.yun <yeoreum.yun@arm.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Wei Yang <richard.weiyang@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/vm_util.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/mm/vm_util.c~tools-testing-check-correct-variable-in-open_procmap
+++ a/tools/testing/selftests/mm/vm_util.c
@@ -439,7 +439,7 @@ int open_procmap(pid_t pid, struct procm
 	sprintf(path, "/proc/%d/maps", pid);
 	procmap_out->query.size = sizeof(procmap_out->query);
 	procmap_out->fd = open(path, O_RDONLY);
-	if (procmap_out < 0)
+	if (procmap_out->fd < 0)
 		ret = -errno;
 
 	return ret;
_

Patches currently in -mm which might be from dan.carpenter@linaro.org are


