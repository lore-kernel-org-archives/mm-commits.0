Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33D963B8D4A
	for <mm-commits@vger.kernel.org>; Tue,  2 Jun 2026 22:23:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780439025; cv=none; b=KU27wMd3VvCfccv/5v9ZAtMhnh3EXa8cMjfjNWLC01ZeoVWR/xjnKdcEeG5Q5Pr4/nvS2LAaKByzXRnCcrmDiP9em2ynydWUy2KIebcxyqBXHvmxqIOw7VdF8EmeLNu5zeXHhln8m91SqS4XNNErKT2xc/KouFYgN1bVfg9CGI4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780439025; c=relaxed/simple;
	bh=BMjVvnroSST0m4S5Lvizief3J0I/gcKlMGHYoIbsvE0=;
	h=Date:To:From:Subject:Message-Id; b=gqsn6BB7Quk691xHr49f7S5gqR4SQHjtrkMtq0mAkkNKLxnxeoKph4b8p0tP4Y+Asi86vkGOIyIcY6/L5NH3vLb4srsuXGMPpyMybYp6q2i/8vGd9Lvnm/F9aky/5o0GvAUwBMlr9UIc00POS50WLDRSRVXpKdRogzHhG8e+iOk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gRxQ4A5T; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gRxQ4A5T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3B4B1F00899;
	Tue,  2 Jun 2026 22:23:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780439024;
	bh=DsAs+B4Khv66odYkHStdjTQQY0UozX1DQJ+9nW1g4Do=;
	h=Date:To:From:Subject;
	b=gRxQ4A5TnNAGAIy9wdeTXltqWHSwm45/aGBaLKBFinE3Zdl9HtSi99zoTNV9Y+KEv
	 XpJC7W0JLnYilFoAef3zv5+BSDdBmR+eOzEWBp68UU057YMUXeU4o0hP3aLaqPNrSZ
	 lpC2TQKzvydvt+4OH7H3gOsokedTWrswViJAI5Lw=
Date: Tue, 02 Jun 2026 15:23:43 -0700
To: mm-commits@vger.kernel.org,richard.weiyang@gmail.com,ljs@kernel.org,david@kernel.org,agarwal.vineet2006@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-check-file-initialization-writes-in-split_huge_page_test.patch removed from -mm tree
Message-Id: <20260602222343.F3B4B1F00899@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: check file initialization writes in split_huge_page_test
has been removed from the -mm tree.  Its filename was
     selftests-mm-check-file-initialization-writes-in-split_huge_page_test.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Vineet Agarwal <agarwal.vineet2006@gmail.com>
Subject: selftests/mm: check file initialization writes in split_huge_page_test
Date: Tue, 12 May 2026 13:19:24 +0530

create_pagecache_thp_and_fd() fills the backing file for the pagecache THP
tests using repeated write() calls, but the return value is never checked.

If a write fails or completes only partially, the test may continue with
an incompletely initialized file and produce misleading results.

Check the result of write() and fail the test if the expected number of
bytes was not written.

[akpm@linux-foundation.org: remove unneeded local, per David]
  Link: https://lore.kernel.org/da82de92-29d8-457c-9f65-40fc4900b922@kernel.org
Link: https://lore.kernel.org/20260512074924.27721-1-agarwal.vineet2006@gmail.com
Signed-off-by: Vineet Agarwal <agarwal.vineet2006@gmail.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Wei Yang <richard.weiyang@gmail.com>
Cc: Vineet Agarwal <agarwal.vineet2006@gmail.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/split_huge_page_test.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--- a/tools/testing/selftests/mm/split_huge_page_test.c~selftests-mm-check-file-initialization-writes-in-split_huge_page_test
+++ a/tools/testing/selftests/mm/split_huge_page_test.c
@@ -609,9 +609,13 @@ static int create_pagecache_thp_and_fd(c
 	assert(fd_size % sizeof(buf) == 0);
 	for (i = 0; i < sizeof(buf); i++)
 		buf[i] = (unsigned char)i;
-	for (i = 0; i < fd_size; i += sizeof(buf))
-		write(*fd, buf, sizeof(buf));
-
+	for (i = 0; i < fd_size; i += sizeof(buf)) {
+		if (write(*fd, buf, sizeof(buf)) != sizeof(buf)) {
+			ksft_perror("write testfile");
+			close(*fd);
+			goto err_out_unlink;
+		}
+	}
 	close(*fd);
 	sync();
 	*fd = open("/proc/sys/vm/drop_caches", O_WRONLY);
_

Patches currently in -mm which might be from agarwal.vineet2006@gmail.com are


