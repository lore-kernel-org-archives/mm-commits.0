Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795481708;
	b=MmQ9V5cHmvxO0b2QWuujEJVtXQl+Vfwh/RbxamFdOeSLDy0b/3dkbrLmEiwW6aR23ajY
	 xDoHjW3t4Z02h6FWLSlA01Q46N17dzjxFGf/9aRqvmovrOJkT3sohZQa5atcNDsEWD+c6
	 qnceFb8PyJpavankE2qmsvA8BI2IcPrSUQIAc5HuYsNXg1u6nkyi2oi7MumlVu4FRzyiI
	 907jtMmxSW1Leegrf85y8Vm4Bgj91Wio3icLWSbYqB3DnA3Ba+dqAIiIuuj/D6lRx+wDD
	 qGjT0H7o3yvx515MDl0XimPhx44/nhb1wVDS3ocTOL8MppHxtDVEeDWPCaK8fnLsYtw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795481708;
	h=Received:DKIM-Signature:Date:To:From:In-Reply-To:References:Subject:
	 Message-Id;
	bh=RD08CzD2D1Kj9R+1/GI4+mYhloBcDBB3THxi6rLVnCQ=;
	b=tLbxHL+Dg9teiNxx+daP/KJuuS5FPI44KyVum4y0aqm4fIuEqQ7poA+0PRAQrfZkKrYn
	 jOHBiq1ONnv0RT2PN6RoqC9TbVOgLnOUGEE9cJKs6rmwjvI66rvXdypduJghGlp/1rQae
	 adHt5wPLivhJDh24wtLTz68KU+J8LV0Br75cO27tIz/sYKq8Ul2gnWkcG9opulmf2kURQ
	 7BCkex1Xel82iQyb8EH1Z74NIsVpdvWgEyAy3HeNHP5AgBMkFEiVBhSkI9K+9NqaSeyZI
	 owvmQoIHMXx64oBozd9P+tiJ7J+yhUZycR2Mp/M0HkqE7Ja5khRHwX3RfOn3umlMp9Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b="0iqtgdz/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0A24606A321;
	Tue, 24 Nov 2026 00:55:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=0iqtgdz/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE2611F000C4;
	Tue, 24 Nov 2026 00:55:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795481708;
	bh=RD08CzD2D1Kj9R+1/GI4+mYhloBcDBB3THxi6rLVnCQ=;
	h=Date:To:From:In-Reply-To:References:Subject;
	b=0iqtgdz/9bxcQmJXY5MQ2rB1CJcM/64a4i7CS2xCM57nosoCbJbRwoUK6vjnt5YNg
	 QXDbei/GiAvU55UzeInlBZIKAzr8Bb5QdixZ8DHj9n3XIPPYCzRO5icAF2VVVsQ6JM
	 UfYUy0ByotQwKWG7TxFSogQof9YaIg779aOVaZzI=
Date: Mon, 23 Nov 2026 16:55:07 -0800
To: mm-commits@vger.kernel.org,tj@kernel.org,stable@vger.kernel.org,
	roman.gushchin@linux.dev,muchun.song@linux.dev,mkoutny@suse.com,
	mhocko@kernel.org,hannes@cmpxchg.org,shakeel.butt@linux.dev,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20261124000439.967403-1-shakeel.butt@linux.dev>
References: <20261124000439.967403-1-shakeel.butt@linux.dev>
Subject: + memcg-free-the-private-id-of-a-memcg-that-never-comes-online.patch added to mm-hotfixes-unstable branch
Message-Id: <20261124005507.EE2611F000C4@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: memcg: free the private ID of a memcg that never comes online
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     memcg-free-the-private-id-of-a-memcg-that-never-comes-online.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/memcg-free-the-private-id-of-a-memcg-that-never-comes-online.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Shakeel Butt <shakeel.butt@linux.dev>
Subject: memcg: free the private ID of a memcg that never comes online
Date: Mon, 23 Nov 2026 16:04:39 -0800

mem_cgroup_alloc() reserves the private ID of a memcg when its css is
allocated.  The ID is erased when the last reference to it is put, and
that reference is first taken in mem_cgroup_css_online().  The failure
paths of mem_cgroup_alloc() and mem_cgroup_css_online() erase the ID
themselves.

But css_create() can also fail after css_alloc() and before online_css():
in percpu_ref_init(), cgroup_idr_alloc() or css_rstat_init().  The memcg
is then freed through mem_cgroup_css_free() without ever coming online,
and nothing erases its ID.  The reserved entry stays in
mem_cgroup_private_ids for good, and each such failure takes one of the
65,535 IDs away.  With failslab failing radix tree node allocations during
mkdir, 1,500 mkdirs leaked 6 IDs this way.

Erase the ID in mem_cgroup_css_free() if the memcg never came online,
which is when (memcg->css.flags & CSS_RELEASED) will be false: it is only
set when an fully onlined memcg is released.

Link: https://patch.msgid.link/20261124000439.967403-1-shakeel.butt@linux.dev
Fixes: 73f576c04b94 ("mm: memcontrol: fix cgroup creation failure after many small jobs")
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Koutný <mkoutny@suse.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: <stable@vger.kernel.org>

 include/linux/cgroup.h |    5 +++++
 mm/memcontrol.c        |    7 +++++++
 2 files changed, 12 insertions(+)

--- a/include/linux/cgroup.h~memcg-free-the-private-id-of-a-memcg-that-never-comes-online
+++ a/include/linux/cgroup.h
@@ -449,6 +449,11 @@ static inline bool css_is_online(struct
 	return css->flags & CSS_ONLINE;
 }
 
+static inline bool css_is_released(struct cgroup_subsys_state *css)
+{
+	return css->flags & CSS_RELEASED;
+}
+
 static inline bool css_is_self(struct cgroup_subsys_state *css)
 {
 	if (css == &css->cgroup->self) {
--- a/mm/memcontrol.c~memcg-free-the-private-id-of-a-memcg-that-never-comes-online
+++ a/mm/memcontrol.c
@@ -4525,6 +4525,13 @@ static void mem_cgroup_css_free(struct c
 	irq_work_sync(&memcg->high_irq_work);
 	cancel_work_sync(&memcg->high_work);
 	free_shrinker_info(memcg);
+
+	/*
+	 * The css_create() error path bypasses normal CSS release, leaving
+	 * CSS_RELEASED clear. Drop any private ID that is still reserved.
+	 */
+	if (!css_is_released(css))
+		mem_cgroup_private_id_remove(memcg);
 	mem_cgroup_free(memcg);
 }
 
_

Patches currently in -mm which might be from shakeel.butt@linux.dev are

memcg-free-the-private-id-of-a-memcg-that-never-comes-online.patch
memcg-move-memoryhigh-enforcement-out-of-try_charge_memcg.patch
memcg-force-charges-from-reclaim-before-trying-the-limits.patch
memcg-use-high_work-for-kernel-threads.patch
memcg-use-high_work-for-remote-charges.patch
memcg-simplify-high-limit-handling-after-a-charge.patch

