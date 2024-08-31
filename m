Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D36F134A8
	for <mm-commits@vger.kernel.org>; Sat, 31 Aug 2024 01:08:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725066524; cv=none; b=ZsIOsjeGLuLOj4WwUtR7JQySrO6b6WBnCLLwzNyj633XzTHiqwwXSxD1mFxvNku058jd/0Kp6uN/EOiHDoBNd5t1iD5URBLJThMvsiFTjrO6FGRKDGRVmAyMQ/svGNXROQUEykKmip5atRkXIHgOf0sbXlMzbOLbu9ulWdF7OLY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725066524; c=relaxed/simple;
	bh=1r3RHAwqwchrZFNBtoO6MDxnrebdEUQhZsRfNAihKds=;
	h=Date:To:From:Subject:Message-Id; b=Wu03ND6OtVogyRafcTrX8zNI0Vcdvf6GTaLyTcuzcvFz7bQod8cZ7KpyiQN4+dpbPGCslXgSeSWPFAxzO4K+eAFcHk5yArclP/WXlZYoHVldSag207xybiG+DJ84XeIdQ+hbkNQMWR3Q1+2/B6zjji6qFhUs2vNYgWWEz0Q6Qzc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=k9bwMi/8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="k9bwMi/8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E01FC4CEC2;
	Sat, 31 Aug 2024 01:08:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725066523;
	bh=1r3RHAwqwchrZFNBtoO6MDxnrebdEUQhZsRfNAihKds=;
	h=Date:To:From:Subject:From;
	b=k9bwMi/8ShX9Fq+g+Rfy2UXhD3DogFhPToFDgaX2RMBtmmfb9UHH6lBNQxgrX7CCh
	 LiYetZ6k2WloahJz6YVR27Pl5LpoYVQ/XEORjncx2bMKlDpamntJEtR0irT7MgIqCz
	 2a38xKK3diD3ZsSU3NYPavQiLWNLLe1Z7VNl4mK4=
Date: Fri, 30 Aug 2024 18:08:42 -0700
To: mm-commits@vger.kernel.org,zeming@nfschina.com,rdunlap@infradead.org,kees@kernel.org,brauner@kernel.org,adobriyan@gmail.com,ruanjinjie@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + user_namespace-use-kmemdup_array-instead-of-kmemdup-for-multiple-allocation.patch added to mm-nonmm-unstable branch
Message-Id: <20240831010843.6E01FC4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: user_namespace: use kmemdup_array() instead of kmemdup() for multiple allocation
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     user_namespace-use-kmemdup_array-instead-of-kmemdup-for-multiple-allocation.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/user_namespace-use-kmemdup_array-instead-of-kmemdup-for-multiple-allocation.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: Jinjie Ruan <ruanjinjie@huawei.com>
Subject: user_namespace: use kmemdup_array() instead of kmemdup() for multiple allocation
Date: Wed, 28 Aug 2024 15:23:40 +0800

Let the kmemdup_array() take care about multiplication and possible
overflows.

Link: https://lkml.kernel.org/r/20240828072340.1249310-1-ruanjinjie@huawei.com
Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
Reviewed-by: Kees Cook <kees@kernel.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Li zeming <zeming@nfschina.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/user_namespace.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/kernel/user_namespace.c~user_namespace-use-kmemdup_array-instead-of-kmemdup-for-multiple-allocation
+++ a/kernel/user_namespace.c
@@ -853,9 +853,8 @@ static int sort_idmaps(struct uid_gid_ma
 	     cmp_extents_forward, NULL);
 
 	/* Only copy the memory from forward we actually need. */
-	map->reverse = kmemdup(map->forward,
-			       map->nr_extents * sizeof(struct uid_gid_extent),
-			       GFP_KERNEL);
+	map->reverse = kmemdup_array(map->forward, map->nr_extents,
+				     sizeof(struct uid_gid_extent), GFP_KERNEL);
 	if (!map->reverse)
 		return -ENOMEM;
 
_

Patches currently in -mm which might be from ruanjinjie@huawei.com are

crash-fix-crash-memory-reserve-exceed-system-memory-bug.patch
user_namespace-use-kmemdup_array-instead-of-kmemdup-for-multiple-allocation.patch

