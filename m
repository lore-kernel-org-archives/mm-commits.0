Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793340956;
	b=Om39b6ktrLOjjWQIb8RhmvJ8KadKlDNTuaSfoYfQpi0F7gSPhgscaAj2k6qpafCuL0VG
	 not0Nn8Biz9aTafOLbscPh94F/nUnnLb3XaO/xyXHJKgNWmxPh51IODgRc1OVqMyNEY32
	 F92iiQcWmE/3h0kX+m0GnvhuiiMaVsvQcTwms09wMAFHrOv9reeLmNGCn2KNfyeSRfOYL
	 5NMmxSvhl5voVDAKxto7foeyD7KTDrXjKWPq8pIMHdRKEOx5GVLhtTbyeAbGeGI4mCFpL
	 Q5iw6wMik0F/SNKVLjCPke0qRvXdlddq61Ty7/R9DIEW6L1T7elJm8XReFPCewJTvsA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793340956;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=MzG+iNYRFDVSVrbRUvAmp2rfVQAA7Qobcn//meq11v4=;
	b=P+Am2dHvIGwhUPSaLc8Ky4Yp46LyXaj8vyLzpkME8AXE5YGhKLybLKl3LEYZu3BC0d0e
	 pHpNoHBDf+pfcZpOdPRyQsyfakR8rtFyZELZQ8LWtUFLsgdqRR0spLtz8MqnJMglWGE+g
	 yqG7eEzy3rsCccIUoS5i4jdr5gg8TbszwYze4u5JHmiOf9fL+OGex5747GfIWiLdYRWXk
	 Yenybxu4CvVanWo0wUgLis9d26nX5MFE063RMUry+D+QpexdgMI790ateNc5/GzC9jOCn
	 ESd1o+JzCEFWaO4TSdn7ATXVUvL5F5gRwFd2rrQDXQpiVJTYAgzlIvr9ehfjpyJ21iQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=rtdOhgis;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9368F606A31A
	for <mm-commits@vger.kernel.org>; Fri, 30 Oct 2026 06:15:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=rtdOhgis
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A29E1F0093A;
	Fri, 30 Oct 2026 06:15:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793340956;
	bh=MzG+iNYRFDVSVrbRUvAmp2rfVQAA7Qobcn//meq11v4=;
	h=Date:To:From:Subject;
	b=rtdOhgisf4WuYPsA7nCctW/Hjawon+EMMAMJuDkntkDc5I23528dWZHidzQJKfNjs
	 BSNX8KP/dHgkBQR460ugNOZ17wKkWVuCbvTRUz1Zxk8yVsJoqtIGZI+NZZBrSBDTET
	 AdKV9iBDx7r9BzHW/GR/jxKAS/AT7zaa8xPRwFgw=
Date: Thu, 29 Oct 2026 23:15:55 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,shakeel.butt@linux.dev,
	roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,
	harry@kernel.org,hannes@cmpxchg.org,tz2294@columbia.edu,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memcontrol-remove-mod_memcg_page_state.patch added to mm-new branch
Message-Id: <20261030061556.1A29E1F0093A@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm: memcontrol: remove mod_memcg_page_state()
has been added to the -mm mm-new branch.  Its filename is
     mm-memcontrol-remove-mod_memcg_page_state.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memcontrol-remove-mod_memcg_page_state.patch

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
From: Tal Zussman <tz2294@columbia.edu>
Subject: mm: memcontrol: remove mod_memcg_page_state()
Date: Wed, 14 Oct 2026 13:08:20 -0400

Patch series "mm: memcontrol: remove two unused helpers", v1.

They were happily unused until I decided to disturb their peace.


This patch (of 2):

The last caller was removed in commit c466412c73c3 ("mm: memcontrol:
switch to native NR_VMALLOC vmstat counter"). Remove it.

Link: https://lore.kernel.org/20261014-memcg-unused-page-helpers-v1-0-240b37c53831@columbia.edu
Link: https://lore.kernel.org/20261014-memcg-unused-page-helpers-v1-1-240b37c53831@columbia.edu
Signed-off-by: Tal Zussman <tz2294@columbia.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Harry Yoo (Meta) <harry@kernel.org>
Acked-by: Muchun Song <muchun.song@linux.dev>
Reviewed-by: SJ Park <sj@kernel.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
---

 include/linux/memcontrol.h |   20 --------------------
 1 file changed, 20 deletions(-)

--- a/include/linux/memcontrol.h~mm-memcontrol-remove-mod_memcg_page_state
+++ a/include/linux/memcontrol.h
@@ -964,21 +964,6 @@ void mem_cgroup_print_oom_group(struct m
 void mod_memcg_state(struct mem_cgroup *memcg,
 		     enum memcg_stat_item idx, int val);
 
-static inline void mod_memcg_page_state(const struct page *page,
-					enum memcg_stat_item idx, int val)
-{
-	struct mem_cgroup *memcg;
-
-	if (mem_cgroup_disabled())
-		return;
-
-	rcu_read_lock();
-	memcg = folio_memcg(page_folio(page));
-	if (memcg)
-		mod_memcg_state(memcg, idx, val);
-	rcu_read_unlock();
-}
-
 unsigned long memcg_events(const struct mem_cgroup *memcg, int event);
 unsigned long memcg_page_state(const struct mem_cgroup *memcg, int idx);
 unsigned long memcg_page_state_output(const struct mem_cgroup *memcg, int item);
@@ -1419,11 +1404,6 @@ static inline void mod_memcg_state(struc
 {
 }
 
-static inline void mod_memcg_page_state(const struct page *page,
-					enum memcg_stat_item idx, int val)
-{
-}
-
 static inline unsigned long memcg_page_state(const struct mem_cgroup *memcg, int idx)
 {
 	return 0;
_

Patches currently in -mm which might be from tz2294@columbia.edu are

mm-memcontrol-remove-mod_memcg_page_state.patch
mm-memcontrol-remove-page_memcg_check.patch

