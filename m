Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 672163A6F1C
	for <mm-commits@vger.kernel.org>; Fri,  7 Aug 2026 02:00:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786068026; cv=none; b=ni4z2JZ9xXD232AXt0+Vgg4oqcPQE1EwLjl5d36cd63It4CpoQKVEy2FQZjQM2RHovlLwhROzemf+Az8M+QYtII4ofaMDhNEBwDFCnhQ5VaM6rhqUAxL0+iy/nEJHVJnuaKF4Rkgu76oulbevXM1cCgp+MyxuYvU/Af7B/if9A0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786068026; c=relaxed/simple;
	bh=TAK/L2YQjbLpxGYDUrjqo9tpMxOKuojab0CaaYsVgo0=;
	h=Date:To:From:Subject:Message-Id; b=iAKQzU9TGpU1+ZGZ3phbq1kaLqsfV439yWOLeaMQQeKDfFUDv8qsJ/bYINTyv8yZFFbXGEfD67qdTIMtEDZh5nARhpHu4YSCLPkaIoboQP0U51+M6aVDrDZrvx0Wi/Yjk9r4IzUKTwSKYJuxLCieH2L46g9UUQGU6+H3BJVqsqQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=cmXcHryK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="cmXcHryK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 549151F00ACF;
	Fri,  7 Aug 2026 02:00:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786068015;
	bh=U0p57gXYcIjXvpcHiTQZ8in0oIZpMQSTUaKpwN941zU=;
	h=Date:To:From:Subject;
	b=cmXcHryKU6d10X2u4oSk7/svshlbwimhU2kwtq02nehzAcutirWsQuya/amnrCt3H
	 NZJQidulmBQrHfEKKyAj9qtpf5xVWC1CyfoIQZLCC0ctLplgQSZIs5C6McdK+yRHp0
	 BCo6O0hCa/Ht4XIN2S0mJG6VlelypbEA8NrvG7rs=
Date: Thu, 06 Aug 2026 19:00:14 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,shuah@kernel.org,muchun.song@linux.dev,jack@suse.cz,wangyijia.yeah@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mincore-count-file-mmap-readahead-on-both-sides.patch removed from -mm tree
Message-Id: <20260807020015.549151F00ACF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests: mincore: count file-mmap readahead on both sides
has been removed from the -mm tree.  Its filename was
     selftests-mincore-count-file-mmap-readahead-on-both-sides.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Yijia Wang <wangyijia.yeah@bytedance.com>
Subject: selftests: mincore: count file-mmap readahead on both sides
Date: Mon, 13 Jul 2026 17:43:19 +0800

check_file_mmap() faults a page in the middle of a file mapping and
expects the mmap read-around path to make neighbouring pages resident. 
The test currently counts only pages after the faulted page.

That misses valid read-around on systems with large base page sizes.  On
arm64 with 64K pages and the default 128K readahead setting, the
read-around window is two pages wide and centred on the faulting page. 
Faulting page 32 makes pages 31 and 32 resident, so the forward-only scan
from page 33 reports ra_pages == 0 even though a neighbouring page was
brought in.

Keep the existing readahead assertion, but count resident neighbouring
pages on both sides of the faulted page.  This fixes the 64K-page false
failure without teaching the selftest to compute the expected readahead
window from sysfs or other implementation details.

Link: https://lore.kernel.org/20260713094319.771550-1-wangyijia.yeah@bytedance.com
Signed-off-by: Yijia Wang <wangyijia.yeah@bytedance.com>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mincore/mincore_selftest.c |   12 +++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

--- a/tools/testing/selftests/mincore/mincore_selftest.c~selftests-mincore-count-file-mmap-readahead-on-both-sides
+++ a/tools/testing/selftests/mincore/mincore_selftest.c
@@ -242,8 +242,10 @@ TEST(check_file_mmap)
 	}
 
 	/*
-	 * Touch a page in the middle of the mapping. We expect the next
-	 * few pages (the readahead window) to be populated too.
+	 * Touch a page in the middle of the mapping. We expect some
+	 * surrounding pages (the readahead window) to be populated too.
+	 * Depending on the page size and readahead setting, the pages may
+	 * land before the faulted page rather than after it.
 	 */
 	addr[FILE_SIZE / 2] = 1;
 	retval = mincore(addr, FILE_SIZE, vec);
@@ -252,6 +254,12 @@ TEST(check_file_mmap)
 		TH_LOG("Page not found in memory after use");
 	}
 
+	i = FILE_SIZE / 2 / page_size - 1;
+	while (i >= 0 && vec[i]) {
+		ra_pages++;
+		i--;
+	}
+
 	i = FILE_SIZE / 2 / page_size + 1;
 	while (i < vec_size && vec[i]) {
 		ra_pages++;
_

Patches currently in -mm which might be from wangyijia.yeah@bytedance.com are


