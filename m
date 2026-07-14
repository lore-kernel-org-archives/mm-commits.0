Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 672332F7F18
	for <mm-commits@vger.kernel.org>; Tue, 14 Jul 2026 00:54:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783990450; cv=none; b=FGimtN2p3bS51/kaee55jHDmPqZXELTdW99wia8iIfCDpztSUqE4RXLlmsm9koZteihPmYJK6q0D/+vKmymYvqcBV8lBiR8U2Qvgs58gD+ZYNBWjlF5JbYxCxnE1LEO3fZH/9lGk7InT1WVd+qtymqmT/s8Fy6UVnFyoSlQiTic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783990450; c=relaxed/simple;
	bh=JzMyrx8mHxhRSXz+kUUyXMuYWQ09iuc4Mkm7JTBepBw=;
	h=Date:To:From:Subject:Message-Id; b=cX20GOuObdYfRQw0IxxqOBY+OiN44acQQmQRVnN2igw6n/HRn1Zlr+BNQN435kuTAsAPcmlaHXZvfzXx7gFsGkgl3LvsuwC/Ih4HmTODyX5flD35Qc2tBI5xd9B6Fj11PBgAR/9xxmF18VjetT0OrnKx36w9NnrgKZxvBgA4jTk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=zb979SPA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zb979SPA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22F821F00A3D;
	Tue, 14 Jul 2026 00:54:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783990441;
	bh=fFTcDm8wiX1UPae5fkTKNvUt8nbY/reQVbnXoarlXb4=;
	h=Date:To:From:Subject;
	b=zb979SPAwff7SI+/qh/xJZAKCrWuzr4+IxnzcRy5NxwHZSuFD424zs0g/UIvOCKOH
	 nsE/QzOSYAc24oVV9W6dgZxtz2BLjkCe+B1+QT1UrMIrCYiB2EOU2OjYYgdrjD+IIn
	 xHkLFzJyXLaSsEfprwFmJ6z0+eOm3yjxofORx6Ic=
Date: Mon, 13 Jul 2026 17:54:00 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,shuah@kernel.org,muchun.song@linux.dev,jack@suse.cz,wangyijia.yeah@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mincore-count-file-mmap-readahead-on-both-sides.patch added to mm-new branch
Message-Id: <20260714005401.22F821F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests: mincore: count file-mmap readahead on both sides
has been added to the -mm mm-new branch.  Its filename is
     selftests-mincore-count-file-mmap-readahead-on-both-sides.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mincore-count-file-mmap-readahead-on-both-sides.patch

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

selftests-mincore-count-file-mmap-readahead-on-both-sides.patch

