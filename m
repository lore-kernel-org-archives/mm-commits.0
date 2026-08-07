Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 943C53B05BC
	for <mm-commits@vger.kernel.org>; Fri,  7 Aug 2026 02:00:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786068016; cv=none; b=hraYJuXj3KdrXbsVW1d7OWY40dlXBMU8zYmaARmcKJm7Asi1WJgX3Dq8vNb6gQvkv4nSKbmDog6magONkptUr4GaFzS+CI3SU+KwRT0BvcVsL14w2+j0gEBvADWsJzIHC8g57miLr/HLjRfhqhddA1334YU3QlprbHAYtzqWOr8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786068016; c=relaxed/simple;
	bh=Vb9NbA5HHcQUZPosNObbLfbiFaNzItbYTbIYTRdYSnQ=;
	h=Date:To:From:Subject:Message-Id; b=j3jT65i8HBYWW1iCVvUtIas5jTutyzZqHOU9xg6eDcRoo+FusOD+4IOvtkyopW+5ffLVX9cID2Dk5+Wc61fCAHiMaUaMHza8eXZulzSUanByfjXyXMrihN1tyotmVVNVvuylctYcLsCxG7+PmKlbOd+ZNp6b5oetiR6Wt3JeVEg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=LPCr5y8w; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LPCr5y8w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECAF31F00A3A;
	Fri,  7 Aug 2026 02:00:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786068008;
	bh=Hxztdr7qqrbOATtoZDotJO3HB6vUE3Q2hm37cB/afTk=;
	h=Date:To:From:Subject;
	b=LPCr5y8wf6y1yVMLQbZSO3wWzqLbrcH64oLgBQTYdpJDm3g/26d9NwLPFmYFcC+pq
	 thJfPVsiJcLBupPRS8mkIOQXX11OKcEyxIzMAbW1RzKQkP7RSLpIQd5bPfy5A6lkzh
	 CRWDFH3FhH0vUmyyqNDpOpyrVxV/ynyWZFSbpayw=
Date: Thu, 06 Aug 2026 19:00:07 -0700
To: mm-commits@vger.kernel.org,shakeel.butt@linux.dev,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,hannes@cmpxchg.org,cuitao@kylinos.cn,zhangguopeng@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memcg-v1-account-vmpressure-event-allocations.patch removed from -mm tree
Message-Id: <20260807020007.ECAF31F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: memcg-v1: account vmpressure event allocations
has been removed from the -mm tree.  Its filename was
     mm-memcg-v1-account-vmpressure-event-allocations.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
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

mm-memcg-stop-reclaim-when-a-limit-update-is-superseded.patch

