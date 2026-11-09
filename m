Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794261940;
	b=u0FsbHnGqK3IPZEchANv5lZ0yQbgsflJls8M/iPTSwBZd1JrzWLOdwHvwtFSe+kYJVKG
	 aUIpvXu3xEzwcNgxz0WeRCCCPTE5V7Ogd27hvcjg8m3AqHJzFxt1HjJWUELo8UhhF+ERj
	 HEMYz4Pa9gkOm4jOPM+SFVLtTHo+sn/iTAnKjcrqGMaAo+WHB23Av3q0g/5id2K8XE/oh
	 3So2kwT8yMSSjGOyG2cpdETroLc1V9oauPDYRhoyhZmWZHHq6IyR2reSKi0reypfeyOyB
	 bY1555Wrhbeii0K6Kx9SSMtU8c57T5+ewXhzI3YijT/CTdpuP/mYSs+1vu0LrhMiqMQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794261940;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=RQlb7QwUZ4/sQeRTFoyxh+yA9GdtCGC1ii8UuQaZ7YA=;
	b=XPHvfMCAcFUVpnABrSX5VgQh9xS+jEgecsQlQExMHsMobA9wgTRCp3Qddsg10ha6MzNU
	 spZTN/E+W9eSe2XnebIrA4T49QlVt4sMbRDE00tBC4Ccwqdu+VemxKmc8rRsHsPW9vY7f
	 ZJGCnDvWbyfqYya62JefEMx8Q++X/Sjk12BYIkBh23RCuDk2dlPmcFUejq9ntiwpaByeT
	 1UvZ2bmUbLdIGdfqV0wkawbJJZKl8pSRXG6PLRZ3xuvsUmxPiPSn6iVIlc6q7RML35U7W
	 O/0R9woH6wEWT01HVVPisuZIoB1gSnlyODLVN7mbzD0NzvbF5IKYB87r7BTpF72AkEg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=fv4NGruR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E365606A31C
	for <mm-commits@vger.kernel.org>; Mon,  9 Nov 2026 22:05:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=fv4NGruR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87C1A1F0089F;
	Mon,  9 Nov 2026 22:05:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794261939;
	bh=RQlb7QwUZ4/sQeRTFoyxh+yA9GdtCGC1ii8UuQaZ7YA=;
	h=Date:To:From:Subject;
	b=fv4NGruRkXEcdc7z3eua6ykiTy9DzEb3QNIzY7ArFhX/gDavYdbnaYxWY9IKTCUUp
	 D6VM7cPhDEbby80QhPSzInCD2YhZwLiekqJIsQ2jParfT9FjSFm5lgvSZ3q3oDw0wG
	 RFT6SO2zEAGMpyeeudf8BCZZEfmUzPQwbugKS6no=
Date: Mon, 09 Nov 2026 14:05:39 -0800
To: mm-commits@vger.kernel.org,zhen.ni@easystack.cn,sarthak.sharma@arm.com,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + tools-mm-add-page_owner_filter-to-gitignore.patch added to mm-new branch
Message-Id: <20261109220539.87C1A1F0089F@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: tools/mm: add page_owner_filter to .gitignore
has been added to the -mm mm-new branch.  Its filename is
     tools-mm-add-page_owner_filter-to-gitignore.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/tools-mm-add-page_owner_filter-to-gitignore.patch

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
From: Sarthak Sharma <sarthak.sharma@arm.com>
Subject: tools/mm: add page_owner_filter to .gitignore
Date: Mon,  9 Nov 2026 16:31:39 +0530

Add the missing page_owner_filter to .gitignore in tools/mm.

Link: https://lore.kernel.org/20261109110139.216653-1-sarthak.sharma@arm.com
Signed-off-by: Sarthak Sharma <sarthak.sharma@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Zhen Ni <zhen.ni@easystack.cn>
---

 tools/mm/.gitignore |    1 +
 1 file changed, 1 insertion(+)

--- a/tools/mm/.gitignore~tools-mm-add-page_owner_filter-to-gitignore
+++ a/tools/mm/.gitignore
@@ -2,6 +2,7 @@
 slabinfo
 page-types
 page_owner_sort
+page_owner_filter
 thp_swap_allocator_test
 gup_bench
 memory-failure/hwpoison-panic
_

Patches currently in -mm which might be from sarthak.sharma@arm.com are

tools-mm-add-page_owner_filter-to-gitignore.patch

