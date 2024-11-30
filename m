Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8872120330
	for <mm-commits@vger.kernel.org>; Sat, 30 Nov 2024 04:11:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732939869; cv=none; b=U5J8lP9Nt5QpMJD9fq5fR8W0C1H7B1+XmL1T2NBIbom2V3VvfuAQyINsaqFC9yTlCoN+J14Ldys2W+vWNKQ9Pg8a9viM3IjkUKZKXrnEfpTsmCHKffTQ8Zeb0fMvLcXYSshRzpqG6ak/33uPDUPkEKf5abEEuRcI/LamXnhOXh4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732939869; c=relaxed/simple;
	bh=2CvUZo8BvxrPSxH/fycvH+BmsoQkcyFBBFOj1aIWS6Q=;
	h=Date:To:From:Subject:Message-Id; b=gMdpBtlg3krcT3Gaj2IIwxwht8uJ9PXYHDGeZvGe9avcIyqtir8VnXiNjAl5nY4/vUaaWGwb9Gu/PCA71yaCWjxhNBSgVJ11aHieJ5q8WDm61GNsEpa9wi6FmDAB3UMF9KbaT4jA8lIT6DcS+qWoo6LWsHkwLQeG42TDGQ9rvyk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ihKD4Qsl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ihKD4Qsl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21F1AC4CECC;
	Sat, 30 Nov 2024 04:11:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1732939869;
	bh=2CvUZo8BvxrPSxH/fycvH+BmsoQkcyFBBFOj1aIWS6Q=;
	h=Date:To:From:Subject:From;
	b=ihKD4Qsl7rP44xDNqJe7uTVGvrXE0GYwrwAVRI6WcqRHUV1GPNxWi+O0jsANhu13J
	 CcRBlJ/ID/W9sCBtlx78dthB58pYlCLl+g90QNWN4DKQWZZeZnE3h67AYsDPB0OyBI
	 tQqGUjQSVV563OPkAfTPXEdsG87QMh8RicfMeWs4=
Date: Fri, 29 Nov 2024 20:11:08 -0800
To: mm-commits@vger.kernel.org,shakeel.butt@linux.dev,mhocko@kernel.org,hannes@cmpxchg.org,roman.gushchin@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swap_cgroup-get-rid-of-__lookup_swap_cgroup.patch added to mm-unstable branch
Message-Id: <20241130041109.21F1AC4CECC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: swap_cgroup: get rid of __lookup_swap_cgroup()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-swap_cgroup-get-rid-of-__lookup_swap_cgroup.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swap_cgroup-get-rid-of-__lookup_swap_cgroup.patch

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
From: Roman Gushchin <roman.gushchin@linux.dev>
Subject: mm: swap_cgroup: get rid of __lookup_swap_cgroup()
Date: Fri, 15 Nov 2024 19:02:29 +0000

Because swap_cgroup map is now virtually contiguous, swap_cgroup_record()
can be simplified, which eliminates a need to use __lookup_swap_cgroup().

Now as __lookup_swap_cgroup() is really trivial and is used only once, it
can be inlined.

Link: https://lkml.kernel.org/r/20241115190229.676440-2-roman.gushchin@linux.dev
Signed-off-by: Roman Gushchin <roman.gushchin@linux.dev>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap_cgroup.c |   18 ++----------------
 1 file changed, 2 insertions(+), 16 deletions(-)

--- a/mm/swap_cgroup.c~mm-swap_cgroup-get-rid-of-__lookup_swap_cgroup
+++ a/mm/swap_cgroup.c
@@ -33,13 +33,6 @@ static struct swap_cgroup_ctrl swap_cgro
  *
  * TODO: we can push these buffers out to HIGHMEM.
  */
-
-static struct swap_cgroup *__lookup_swap_cgroup(struct swap_cgroup_ctrl *ctrl,
-						pgoff_t offset)
-{
-	return &ctrl->map[offset];
-}
-
 static struct swap_cgroup *lookup_swap_cgroup(swp_entry_t ent,
 					struct swap_cgroup_ctrl **ctrlp)
 {
@@ -49,7 +42,7 @@ static struct swap_cgroup *lookup_swap_c
 	ctrl = &swap_cgroup_ctrl[swp_type(ent)];
 	if (ctrlp)
 		*ctrlp = ctrl;
-	return __lookup_swap_cgroup(ctrl, offset);
+	return &ctrl->map[offset];
 }
 
 /**
@@ -104,16 +97,9 @@ unsigned short swap_cgroup_record(swp_en
 
 	spin_lock_irqsave(&ctrl->lock, flags);
 	old = sc->id;
-	for (;;) {
+	for (; offset < end; offset++, sc++) {
 		VM_BUG_ON(sc->id != old);
 		sc->id = id;
-		offset++;
-		if (offset == end)
-			break;
-		if (offset % SC_PER_PAGE)
-			sc++;
-		else
-			sc = __lookup_swap_cgroup(ctrl, offset);
 	}
 	spin_unlock_irqrestore(&ctrl->lock, flags);
 
_

Patches currently in -mm which might be from roman.gushchin@linux.dev are

mm-swap_cgroup-allocate-swap_cgroup-map-using-vcalloc.patch
mm-swap_cgroup-get-rid-of-__lookup_swap_cgroup.patch

