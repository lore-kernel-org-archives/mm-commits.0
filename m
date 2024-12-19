Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AC7F380
	for <mm-commits@vger.kernel.org>; Thu, 19 Dec 2024 00:33:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734568399; cv=none; b=DlGQ2w76eAHTGmXFvM2chOlPg3007pPJue/phTiN6zy2r8UnibjaLXxaKFE92/SdADabWXo3HkRKtlzn63h6iO4/V3jKzVjVlqsVc6abnX0wIvFtk87HXu7WsYHTBK2B6jjPp2RngEDLG9DStRFBdwL6dDb5qxEj71s03oYpUYw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734568399; c=relaxed/simple;
	bh=A4eiKVaO62XvsdkeTzdgHgqJ61dpaAvhl1lwSSpxHQY=;
	h=Date:To:From:Subject:Message-Id; b=dFdFZz8coJJYoAfH4W6e9jFOo0yDSiL1KjVd1WffBaOTQkZr9/JNrC2NwmVgBho5P/OpygloxB/b15VinDmPmd6T5tgn917Fz01jwvuVil9leZHe+P16GU+LIE/qF8LIGRI5TWQ/i+bynRyZdWKJ/SNMtHF46cZvGElkztQwI2s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=hjGk6ylT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hjGk6ylT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB682C4CECD;
	Thu, 19 Dec 2024 00:33:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1734568398;
	bh=A4eiKVaO62XvsdkeTzdgHgqJ61dpaAvhl1lwSSpxHQY=;
	h=Date:To:From:Subject:From;
	b=hjGk6ylTF3iL0c6La9e33eHtDKqU2fQm+uM+2xne2H1aHt6dljJNvmereF8y8RtjO
	 rY9H2a9G3/7zh8KITIjUDZC/QViPV7KSR2BL6qJ5J9dygyVD4oc+0OcdCey+6i96FM
	 Upbl2Xsa+rY5D6q6vz+FsOP6BvO/H1EuA2a+fIEw=
Date: Wed, 18 Dec 2024 16:33:18 -0800
To: mm-commits@vger.kernel.org,yosryahmed@google.com,shakeel.butt@linux.dev,roman.gushchin@linux.dev,mhocko@kernel.org,hughd@google.com,hannes@cmpxchg.org,chrisl@kernel.org,baohua@kernel.org,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swap_cgroup-remove-swap_cgroup_cmpxchg.patch added to mm-unstable branch
Message-Id: <20241219003318.BB682C4CECD@smtp.kernel.org>
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
Date: Wed, 18 Dec 2024 19:46:31 +0800

This function is never used after commit 6b611388b626 ("memcg-v1: remove
charge move code").

Link: https://lkml.kernel.org/r/20241218114633.85196-3-ryncsn@gmail.com
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
mm-swap_cgroup-decouple-swap-cgroup-recording-and-clearing.patch

