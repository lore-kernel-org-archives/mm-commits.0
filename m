Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3F0D6AFAE
	for <mm-commits@vger.kernel.org>; Wed,  4 Sep 2024 04:19:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725423576; cv=none; b=r/ELWQK7jNjA3AzOGIDhScQwUCOblgLC/gHAwcVHK0qYKZeq13NCYfENcES29LsGGk0+OoS/79h6bl7IjT0+vYv+heYqGfwfeeQaoh467bxWmPmcyOMN1N84FB5FDEMP1puGPJaxhMvsCnnvmfomdNcNE+yjqN7yfas6pGy+yhs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725423576; c=relaxed/simple;
	bh=2KgUavxTy4y8TIkUwQQsP7QCkd5GQ52RoRztJdxJdzU=;
	h=Date:To:From:Subject:Message-Id; b=q/NFT2KxM+CDzBVL7QO/5YHyzsBdjUvOdKC2Vrq/pO4ZBZ/5LI70vqY2NokkK8YaJdTYwzt7VNdDHm5uFkweYzkeLc23B5FUh1L0JlVOF3vvooP7XCsRBHqIsNrgF9SqNDuc61oSnJ2jFUt0SO86ywG7NG8vyBZnSU7EVVSdk+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=YKjEA+wF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YKjEA+wF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAB00C4CEC2;
	Wed,  4 Sep 2024 04:19:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725423576;
	bh=2KgUavxTy4y8TIkUwQQsP7QCkd5GQ52RoRztJdxJdzU=;
	h=Date:To:From:Subject:From;
	b=YKjEA+wFsFnhZCzU82Ng5QHBmJg7iwmKAi+OBJ9LkqgoJfocv/r3Wxf6UNvPsl4RV
	 YTwE5pCk0hpIiKAtuzJv2HrA48Yx4PuFDmO6g3ypitaqlAeFk6hf9Q5/S7ZZtEZQDQ
	 eve8ERhkv+ys0QLcmkNIke9Dckhjjbc8hYocy6uA=
Date: Tue, 03 Sep 2024 21:19:36 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,surenb@google.com,spasswolf@web.de,sidhartha.kumar@oracle.com,paul@paul-moore.com,paulmck@kernel.org,olsajiri@gmail.com,lstoakes@gmail.com,lorenzo.stoakes@oracle.com,kees@kernel.org,jeffxu@chromium.org,broonie@kernel.org,Liam.Howlett@Oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-vma-drop-incorrect-comment-from-vms_gather_munmap_vmas.patch removed from -mm tree
Message-Id: <20240904041936.AAB00C4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/vma: drop incorrect comment from vms_gather_munmap_vmas()
has been removed from the -mm tree.  Its filename was
     mm-vma-drop-incorrect-comment-from-vms_gather_munmap_vmas.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Liam R. Howlett" <Liam.Howlett@Oracle.com>
Subject: mm/vma: drop incorrect comment from vms_gather_munmap_vmas()
Date: Fri, 30 Aug 2024 00:01:00 -0400

The comment has been outdated since 6b73cff239e52 ("mm: change munmap
splitting order and move_vma()").  The move_vma() was altered to fix the
fragile state of the accounting since then.

Link: https://lkml.kernel.org/r/20240830040101.822209-21-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Bert Karwatzki <spasswolf@web.de>
Cc: Jeff Xu <jeffxu@chromium.org>
Cc: Jiri Olsa <olsajiri@gmail.com>
Cc: Kees Cook <kees@kernel.org>
Cc: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: Mark Brown <broonie@kernel.org>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: "Paul E. McKenney" <paulmck@kernel.org>
Cc: Paul Moore <paul@paul-moore.com>
Cc: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vma.c |    7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

--- a/mm/vma.c~mm-vma-drop-incorrect-comment-from-vms_gather_munmap_vmas
+++ a/mm/vma.c
@@ -755,13 +755,8 @@ int vms_gather_munmap_vmas(struct vma_mu
 
 	/*
 	 * If we need to split any vma, do it now to save pain later.
-	 *
-	 * Note: mremap's move_vma VM_ACCOUNT handling assumes a partially
-	 * unmapped vm_area_struct will remain in use: so lower split_vma
-	 * places tmp vma above, and higher split_vma places tmp vma below.
+	 * Does it split the first one?
 	 */
-
-	/* Does it split the first one? */
 	if (vms->start > vms->vma->vm_start) {
 
 		/*
_

Patches currently in -mm which might be from Liam.Howlett@Oracle.com are


