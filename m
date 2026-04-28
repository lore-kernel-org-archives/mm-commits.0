Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF8C4332638
	for <mm-commits@vger.kernel.org>; Tue, 28 Apr 2026 21:03:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777410182; cv=none; b=XsAEw8v0EOmqSaj/DNrZVSX8q7sAdeEEYvEhBe7cINc7ZlS/pm7bOcsk89+WOEE9GDR3ITXBV62gNUA4Il/i0oXTrwwY77rLFogyqWO/BockwuzUTci2xJ7V/9f5J1yw5tD2oTO95OX2MDc11WVl9mB5Tovw8CsmSSuJtnMX0W0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777410182; c=relaxed/simple;
	bh=ZQY4ou9POtDax1DnxLLlWQIMqhweuyi8d8vgg3b7ojg=;
	h=Date:To:From:Subject:Message-Id; b=HHZeQQBmN1Fpfr/hMfUsARZK6nvcmAW+0WDUj6TxjrsLu99umuidf8y0fugRT8VOGcl1S2yzRSspmGIaVox4nznyuV5Rou9fz/u0MN7DmNDdinaHlLMKu9y4Vea2YpauKkBEUA+Ho/E/mUGTfoLiQcAG2cYGDfLyZs8Q1I3fMvA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=J59dCpM7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="J59dCpM7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74264C2BCAF;
	Tue, 28 Apr 2026 21:03:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777410182;
	bh=ZQY4ou9POtDax1DnxLLlWQIMqhweuyi8d8vgg3b7ojg=;
	h=Date:To:From:Subject:From;
	b=J59dCpM7dW3n5a1WGYXhMztmvl/XgfRO5FmZXsFtCwh07HMuUUwsss2tkj6MSACki
	 TyO3nOBAanAG2kMYoty48Nnxr20PZ5/KCIy2Z4Td35V2smjyvJfytu3dLVI6pbtJ3M
	 3XguKIcp+E80eh2Fn5LeTp7142evLAwF4cGV3Osw=
Date: Tue, 28 Apr 2026 14:03:01 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,shuah@kernel.org,ryan.roberts@arm.com,rppt@kernel.org,npache@redhat.com,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,dev.jain@arm.com,david@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,agarwal.vineet2006@gmail.com,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-khugepaged-initialize-file-contents-via-mmap-fix.patch added to mm-new branch
Message-Id: <20260428210302.74264C2BCAF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: flush dirty folio so that drop_caches can work
has been added to the -mm mm-new branch.  Its filename is
     selftests-mm-khugepaged-initialize-file-contents-via-mmap-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-khugepaged-initialize-file-contents-via-mmap-fix.patch

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
From: Zi Yan <ziy@nvidia.com>
Subject: flush dirty folio so that drop_caches can work
Date: Tue, 28 Apr 2026 16:12:08 -0400

Link: https://lore.kernel.org/0FA813EA-5EFA-482F-B8BF-FE65D4169C44@nvidia.com
Signed-off-by: Zi Yan <ziy@nvidia.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand (Arm) <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Nico Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vineet Agarwal <agarwal.vineet2006@gmail.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/khugepaged.c |    1 +
 1 file changed, 1 insertion(+)

--- a/tools/testing/selftests/mm/khugepaged.c~selftests-mm-khugepaged-initialize-file-contents-via-mmap-fix
+++ a/tools/testing/selftests/mm/khugepaged.c
@@ -394,6 +394,7 @@ static void *file_setup_area(int nr_hpag
 		exit(EXIT_FAILURE);
 	}
 	fill_memory(p, 0, size);
+	msync(p, size, MS_SYNC);
 	close(fd);
 	munmap(p, size);
 	success("OK");
_

Patches currently in -mm which might be from ziy@nvidia.com are

selftests-mm-khugepaged-initialize-file-contents-via-mmap-fix.patch

