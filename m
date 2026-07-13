Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E411357D1A
	for <mm-commits@vger.kernel.org>; Mon, 13 Jul 2026 19:57:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783972647; cv=none; b=hnUhgdroNmh/xpK0HtqQjpuJp45qMrlNpatB9yT3UGdvIVScI+/zKFPaxoz+S5I8Cl2hiPaBtsxUMrSbk5XukEFdWAc978IqNBJ7YgP9+J3vHrMj8fbYj0j94k/NAEeJ4XiA5IUweWNdc2vw8WSyfWsBEFnvSFMyNYWLo3qyIy8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783972647; c=relaxed/simple;
	bh=ven1osiqDsV0O+UZN6GWBuiyQJ2rNG8ytLqMmy6FB94=;
	h=Date:To:From:Subject:Message-Id; b=nelV+weIFQgAV7hzfYDyCweGBUA/6ud8+5mAIkn8wQrxb3H5+q/gtFHKPaU7ke767gSsHvq8bRoV9wdnDKGaAnv7fE/Ha/FJs/qsiZyPriINJK/LG/Qrq+eBzuqe9LVNskT4ZTwl5Ok8L93xRxxS7j+KF4LNqxhftesQxY2VVlc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NaBVfFas; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NaBVfFas"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C67E31F00A3A;
	Mon, 13 Jul 2026 19:57:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783972645;
	bh=FDcHZEymjKCvHwgfrgSSM5plfFePYyIyYYDPdGM1+N4=;
	h=Date:To:From:Subject;
	b=NaBVfFasYQryKJzMt9oJsIl2Byu9Gmz9fQdv/ZAQ3ijh/c6hewNsNUVMtyIoN/1sM
	 q9zYDceJIabcVaVYToUSbU4hRtwwRMKFyhljLj9QdFBwljY4jb79BkZx43r/dXKa3z
	 37EklBzWN/LM8vWbkAZE9+urBwbk82BpH41qnjsA=
Date: Mon, 13 Jul 2026 12:57:25 -0700
To: mm-commits@vger.kernel.org,shakeel.butt@linux.dev,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,hannes@cmpxchg.org,cuitao@kylinos.cn,zhangguopeng@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memcg-v1-account-vmpressure-event-allocations.patch added to mm-new branch
Message-Id: <20260713195725.C67E31F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: memcg-v1: account vmpressure event allocations
has been added to the -mm mm-new branch.  Its filename is
     mm-memcg-v1-account-vmpressure-event-allocations.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memcg-v1-account-vmpressure-event-allocations.patch

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
From: Guopeng Zhang <zhangguopeng@kylinos.cn>
Subject: mm: memcg-v1: account vmpressure event allocations
Date: Mon, 13 Jul 2026 16:55:20 +0800

Commit 72797d218b43 ("mm/memcg: v1: account event registrations and drop
world-writable cgroup.event_control") accounted cgroup v1 event
registration allocations with GFP_KERNEL_ACCOUNT, but missed struct
vmpressure_event.

Use GFP_KERNEL_ACCOUNT for this allocation as well.

Link: https://lore.kernel.org/20260713085520.2953121-1-guopeng.zhang@linux.dev
Fixes: 72797d218b43 ("mm/memcg: v1: account event registrations and drop world-writable cgroup.event_control")
Signed-off-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
Acked-by: Tao Cui <cuitao@kylinos.cn>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Muchun Song <muchun.song@linux.dev>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol-v1.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memcontrol-v1.c~mm-memcg-v1-account-vmpressure-event-allocations
+++ a/mm/memcontrol-v1.c
@@ -1721,7 +1721,7 @@ int vmpressure_register_event(struct mem
 		mode = ret;
 	}
 
-	ev = kzalloc_obj(*ev);
+	ev = kzalloc_obj(*ev, GFP_KERNEL_ACCOUNT);
 	if (!ev) {
 		ret = -ENOMEM;
 		goto out;
_

Patches currently in -mm which might be from zhangguopeng@kylinos.cn are

mm-memcg-remove-stray-text-from-obj_stock_pcp-comment.patch
mm-memcontrol-update-state_local-when-flushing-nmi-stats.patch
mm-memcg-v1-account-vmpressure-event-allocations.patch

