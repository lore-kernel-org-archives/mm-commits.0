Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 299BA23ED5B
	for <mm-commits@vger.kernel.org>; Thu, 12 Mar 2026 23:04:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773356646; cv=none; b=CPZp0+6ymjP1L7RQPfHYsaSviqIxznhJDFl5gAVnoVUi4cOHP3Xb5F7kd2t/RN37TEciZ6z8p/aWz7V7wJiNMwT5yZcUONQNtVHcg6Lo5NSzNqII3YtqpSik6JD42WF1ajbPt6tMbfzsho4U/rKv2HG5aC/QBuLdIRTvJXOIuQ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773356646; c=relaxed/simple;
	bh=IwUSpbTTXEZ7ciTLOlHSJJ9THHmWD16VgCbdWdbi7b8=;
	h=Date:To:From:Subject:Message-Id; b=o8ZRFSc+qD5dWiVobiI7RBLQaDzoWakG8tsTNyhjwRiinUmbRKPVONcnoh+1cBPSsQvnh0PLT27bHbCRR3aK8ynJuhrxRVI9kkd8jpC7ejTrDPZYI8jrDmWEjUX690Dvfkb92ExmcntYkV5i1EZU2K9xiGtP0Ki9qngfQGO681Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Ga1akc+a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Ga1akc+a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0E78C4CEF7;
	Thu, 12 Mar 2026 23:04:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1773356645;
	bh=IwUSpbTTXEZ7ciTLOlHSJJ9THHmWD16VgCbdWdbi7b8=;
	h=Date:To:From:Subject:From;
	b=Ga1akc+a1jZS8XkUK+flxIso8lDidJKADQCGlI6cFVMhiXQvmmrvzTA6dsf2voThr
	 9k+GEYqN8c6wri339U6+D1VQlSOxutMtsb+yVfdmTMZW4zdorjHiaalTNS8sBsTpdq
	 g+e6p8Y+1M0cG4q5P6gY6zyb0vPzxF7yADohlYQc=
Date: Thu, 12 Mar 2026 16:04:05 -0700
To: mm-commits@vger.kernel.org,youngjun.park@lge.com,geliang@kernel.org,chrisl@kernel.org,baohua@kernel.org,zhuhui@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swap-strengthen-locking-assertions-and-invariants-in-cluster-allocation-v5.patch added to mm-unstable branch
Message-Id: <20260312230405.B0E78C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-swap-strengthen-locking-assertions-and-invariants-in-cluster-allocation-v5
has been added to the -mm mm-unstable branch.  Its filename is
     mm-swap-strengthen-locking-assertions-and-invariants-in-cluster-allocation-v5.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swap-strengthen-locking-assertions-and-invariants-in-cluster-allocation-v5.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: Hui Zhu <zhuhui@kylinos.cn>
Subject: mm-swap-strengthen-locking-assertions-and-invariants-in-cluster-allocation-v5
Date: Thu, 12 Mar 2026 10:30:24 +0800


initialize `flags', per Chris

Link: https://lkml.kernel.org/r/20260312023024.903143-1-hui.zhu@linux.dev
Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
Reviewed-by: Youngjun Park <youngjun.park@lge.com>
Reviewed-by: Barry Song <baohua@kernel.org>
Acked-by: Chris Li <chrisl@kernel.org>
Acked-by: Geliang Tang <geliang@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/swapfile.c~mm-swap-strengthen-locking-assertions-and-invariants-in-cluster-allocation-v5
+++ a/mm/swapfile.c
@@ -602,7 +602,7 @@ static struct swap_cluster_info *isolate
 		struct swap_info_struct *si, struct list_head *list)
 {
 	struct swap_cluster_info *ci, *found = NULL;
-	u8 flags;
+	u8 flags = CLUSTER_FLAG_NONE;
 
 	spin_lock(&si->lock);
 	list_for_each_entry(ci, list, list) {
_

Patches currently in -mm which might be from zhuhui@kylinos.cn are

mm-swap-strengthen-locking-assertions-and-invariants-in-cluster-allocation.patch
mm-swap-strengthen-locking-assertions-and-invariants-in-cluster-allocation-v4.patch
mm-swap-strengthen-locking-assertions-and-invariants-in-cluster-allocation-v5.patch

