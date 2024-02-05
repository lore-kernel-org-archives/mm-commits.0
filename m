Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7ED1482E1
	for <mm-commits@vger.kernel.org>; Mon,  5 Feb 2024 23:04:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707174285; cv=none; b=VobLxgKha/mQlvBG8PA7T2gnd86xVD66d2X+t55mlwmthKEKH/Zufso6veDpoIN9K6rMkGtx3ONrwAyt4FZ/s/PM482h7HejpZpg492/7FstxMHGl7m+QFD0E1NMBqQp/pCqDGl2ZSyPiTQ5EfcSlrh4GedkDkSkO4pp5JEPUfQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707174285; c=relaxed/simple;
	bh=fgJlZWSQXpHnIgzmoSMp5SNOwo+2taIwiv5MkQeRfbs=;
	h=Date:To:From:Subject:Message-Id; b=uCIgdPxyycHdKVaFEgP/Ns32vpJppcL/tByL4B+xwdakEFlwQhcVAtNTJ6y5zJKFSmsbr/3Pl41Vvy/GicP9ZW80uZX9aiP1xn5pJtCmpplVIbPivrmbF2dqM2LitTnn1mdpkzT/T92e7xUYZ0v0P0gwZePEa8mDTXNua6Md3dg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Z5sPYK5s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Z5sPYK5s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28B1BC433F1;
	Mon,  5 Feb 2024 23:04:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1707174285;
	bh=fgJlZWSQXpHnIgzmoSMp5SNOwo+2taIwiv5MkQeRfbs=;
	h=Date:To:From:Subject:From;
	b=Z5sPYK5sEWI0kq03+tNSjUNEM/3Wp0P0/akZLWWW+EyZpu8eoKi37ALyo5HC81S3+
	 G/lwXm3amQKmNm1mRV9s/ilzkFa1FSf27T1sudBv1Y5vsuAH+af8A11UNggqLF3dnR
	 z5mOATqUvj1opQcpuXTgrLRYRH28CvnaOBOvvfMw=
Date: Mon, 05 Feb 2024 15:04:44 -0800
To: mm-commits@vger.kernel.org,yosryahmed@google.com,tj@kernel.org,shuah@kernel.org,roman.gushchin@linux.dev,riel@surriel.com,lizefan.x@bytedance.com,hannes@cmpxchg.org,nphamcs@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-fix-the-zswap-invasive-shrink-test.patch added to mm-unstable branch
Message-Id: <20240205230445.28B1BC433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests: fix the zswap invasive shrink test
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-fix-the-zswap-invasive-shrink-test.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-fix-the-zswap-invasive-shrink-test.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Nhat Pham <nphamcs@gmail.com>
Subject: selftests: fix the zswap invasive shrink test
Date: Mon, 5 Feb 2024 14:56:07 -0800

The zswap no invasive shrink selftest breaks because we rename the zswap
writeback counter (see [1]).  Fix the test.

[1]: https://patchwork.kernel.org/project/linux-kselftest/patch/20231205193307.2432803-1-nphamcs@gmail.com/

Link: https://lkml.kernel.org/r/20240205225608.3083251-3-nphamcs@gmail.com
Fixes: a697dc2be925 ("selftests: cgroup: update per-memcg zswap writeback selftest")
Signed-off-by: Nhat Pham <nphamcs@gmail.com>
Acked-by: Yosry Ahmed <yosryahmed@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Rik van Riel <riel@surriel.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Zefan Li <lizefan.x@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/cgroup/test_zswap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/cgroup/test_zswap.c~selftests-fix-the-zswap-invasive-shrink-test
+++ a/tools/testing/selftests/cgroup/test_zswap.c
@@ -52,7 +52,7 @@ static int get_zswap_stored_pages(size_t
 
 static int get_cg_wb_count(const char *cg)
 {
-	return cg_read_key_long(cg, "memory.stat", "zswp_wb");
+	return cg_read_key_long(cg, "memory.stat", "zswpwb");
 }
 
 static long get_zswpout(const char *cgroup)
_

Patches currently in -mm which might be from nphamcs@gmail.com are

selftests-zswap-add-zswap-selftest-file-to-zswap-maintainer-entry.patch
selftests-fix-the-zswap-invasive-shrink-test.patch
selftests-add-zswapin-and-no-zswap-tests.patch

