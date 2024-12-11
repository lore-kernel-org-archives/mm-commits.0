Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE7F47080E
	for <mm-commits@vger.kernel.org>; Wed, 11 Dec 2024 01:06:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733879190; cv=none; b=VabEYEvsZFra82n5ZcmqnOGVurUfYAX9sZvpBCB32idPCjyHr8Fc+Xvht7oae/5QB1ou7VNo9iN2Jv5cBG73sZ+UNpYUXFKWmfaT2U3ZGFvMp/JUVswSNZ47yDttyYcM0zrxsnwm+3uDAYQ4ORZiqNEA87d8u7/QXKtN5szlyv4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733879190; c=relaxed/simple;
	bh=/LbNfZU7BRF7MuyVR79avxx6BpaiJSeKRzcWvMLpmmc=;
	h=Date:To:From:Subject:Message-Id; b=CWrBvkK/aBfHQ62rYM5Z+H14NNci7YDzuu5XJQpRHKBv59mr77p6YgjLpdbDbj5nKpDU+6KvRrWXPPozkGMlcJsZ5mXkCDNakVzI7yjpdPhY07+pLDJwdNRT/zE6ulwv9gVGx5J3yVBsJUnEUQXamzrFCiwEgoI8JIbIluBgC5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vyPDZEZU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vyPDZEZU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBD1DC4CED6;
	Wed, 11 Dec 2024 01:06:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1733879189;
	bh=/LbNfZU7BRF7MuyVR79avxx6BpaiJSeKRzcWvMLpmmc=;
	h=Date:To:From:Subject:From;
	b=vyPDZEZUW9vboRskAckwevTk8ubY0fleO1c88BFgpuu2FdgNvKtd7stmIUPxQdo/V
	 91AJQKOilyoGZ5l8WYHratD2zRJ8dqKhr+OfehNm4IrJf6OwGtfYl+2ILHltfEFEoD
	 ctVqLADXakLrJULAMYcuGh6sIYA70b74y+cakU3M=
Date: Tue, 10 Dec 2024 17:06:29 -0800
To: mm-commits@vger.kernel.org,yosryahmed@google.com,shakeel.butt@linux.dev,roman.gushchin@linux.dev,mhocko@kernel.org,hughd@google.com,hannes@cmpxchg.org,chrisl@kernel.org,baohua@kernel.org,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swap_cgroup-remove-swap_cgroup_cmpxchg.patch added to mm-unstable branch
Message-Id: <20241211010629.BBD1DC4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/swap_cgroup: remove swap_cgroup_cmpxchg
has been added to the -mm mm-unstable branch.  Its filename is
     mm-swap_cgroup-remove-swap_cgroup_cmpxchg.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swap_cgroup-remove-swap_cgroup_cmpxchg.patch

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
From: Kairui Song <kasong@tencent.com>
Subject: mm/swap_cgroup: remove swap_cgroup_cmpxchg
Date: Tue, 10 Dec 2024 17:28:04 +0800

This function is never used after commit 6b611388b626 ("memcg-v1: remove
charge move code").

Link: https://lkml.kernel.org/r/20241210092805.87281-3-ryncsn@gmail.com
Signed-off-by: Kairui Song <kasong@tencent.com>
Reviewed-by: Yosry Ahmed <yosryahmed@google.com>
Reviewed-by: Roman Gushchin <roman.gushchin@linux.dev>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: Chris Li <chrisl@kernel.org>
Cc: Barry Song <baohua@kernel.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swap_cgroup.h |    2 --
 mm/swap_cgroup.c            |   29 -----------------------------
 2 files changed, 31 deletions(-)

--- a/include/linux/swap_cgroup.h~mm-swap_cgroup-remove-swap_cgroup_cmpxchg
+++ a/include/linux/swap_cgroup.h
@@ -6,8 +6,6 @@
 
 #if defined(CONFIG_MEMCG) && defined(CONFIG_SWAP)
 
-extern unsigned short swap_cgroup_cmpxchg(swp_entry_t ent,
-					unsigned short old, unsigned short new);
 extern unsigned short swap_cgroup_record(swp_entry_t ent, unsigned short id,
 					 unsigned int nr_ents);
 extern unsigned short lookup_swap_cgroup_id(swp_entry_t ent);
--- a/mm/swap_cgroup.c~mm-swap_cgroup-remove-swap_cgroup_cmpxchg
+++ a/mm/swap_cgroup.c
@@ -46,35 +46,6 @@ static struct swap_cgroup *lookup_swap_c
 }
 
 /**
- * swap_cgroup_cmpxchg - cmpxchg mem_cgroup's id for this swp_entry.
- * @ent: swap entry to be cmpxchged
- * @old: old id
- * @new: new id
- *
- * Returns old id at success, 0 at failure.
- * (There is no mem_cgroup using 0 as its id)
- */
-unsigned short swap_cgroup_cmpxchg(swp_entry_t ent,
-					unsigned short old, unsigned short new)
-{
-	struct swap_cgroup_ctrl *ctrl;
-	struct swap_cgroup *sc;
-	unsigned long flags;
-	unsigned short retval;
-
-	sc = lookup_swap_cgroup(ent, &ctrl);
-
-	spin_lock_irqsave(&ctrl->lock, flags);
-	retval = sc->id;
-	if (retval == old)
-		sc->id = new;
-	else
-		retval = 0;
-	spin_unlock_irqrestore(&ctrl->lock, flags);
-	return retval;
-}
-
-/**
  * swap_cgroup_record - record mem_cgroup for a set of swap entries
  * @ent: the first swap entry to be recorded into
  * @id: mem_cgroup to be recorded
_

Patches currently in -mm which might be from kasong@tencent.com are

zram-refuse-to-use-zero-sized-block-device-as-backing-device.patch
zram-fix-uninitialized-zram-not-releasing-backing-device.patch
mm-memcontrol-avoid-duplicated-memcg-enable-check.patch
mm-swap_cgroup-remove-swap_cgroup_cmpxchg.patch
mm-swap_cgroup-remove-global-swap-cgroup-lock.patch

