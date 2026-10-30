Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793340958;
	b=f3KpNMZm9M+GTH+jHaDlBX6N48vM7lgffzJdlj7ypMUJXjB/dRyLQ/u4Hq8uajCPRVPk
	 wGZOUTAMfVQoDt0tXFtBR2TWJimkRQ0ZbGWCof8kATvd1eGLHVAL0S8p4S485T5Ov2Aqn
	 4K1lIJkzp4cGsaNKgSHV2ESi/d8PB4dXZmAtz6jkbwB9WCdALR6IpU11hI8Dkmp4NCIZJ
	 2nNfJOnJmdJdmmfMejjOqwdXRR7Srd2Nv37J8E7swzDCTc+PVekYHp3ljhzmEXXC6L3Bu
	 Pf0GkIbwn7H+ILHbqvnK/akckC3boQs87BMWPcoDdkPcwYaW+xnxvp+R+AczWRdLEeQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793340958;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=e06W+5no4L3/44mBD3RIxCs8/WQlIMc/TnHurte0obM=;
	b=oa/cAaOFFYCQGnPJWBfreHZ2NAEB/YowcnZzXpHRZWvJE1OLvhpEcmFHcMOHR/Zat6QG
	 378VPHOv8cgivY+ca0QNGb1f8hipu26hrhKC65HjTFhveZPRFPQTwfXWuT1kZIN4PSUv2
	 izfod8czQrLBjhJU5rCuiY3OrTpkVbsT+nF25NMupOkg18m2OS1IqhMk0cIb69TuRJi/x
	 tEOPl4dsPe7hiLtiPhdoFf+iVNkhIlRSKOQgN91U6Mw+uppD/MgoW7mRf74DYw6DvONlA
	 tlw3+2mdMrbA3dQBWtL51snyaHk1btpc+xnqnpVgqR0VqvP3fdhB7IBRJj/u2dtEgDg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b="ylRUJlO/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47CF8606A31A
	for <mm-commits@vger.kernel.org>; Fri, 30 Oct 2026 06:15:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=ylRUJlO/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E02611F000C1;
	Fri, 30 Oct 2026 06:15:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793340958;
	bh=e06W+5no4L3/44mBD3RIxCs8/WQlIMc/TnHurte0obM=;
	h=Date:To:From:Subject;
	b=ylRUJlO/bRyt1nhswXMAmHKsJjkqFpFErqlvqUPwiI9ngwPYRvqmOCnFFjktVjq/+
	 NH0KGoz8QrHYuDox9B3E4/NBxlY+Uuqo0I6oa+WLbo435mHEahNIE7MgvyHjk3DFEA
	 1VSJkghyA9/CiJUa406xEDwxIEwu9On7DnhoqMuE=
Date: Thu, 29 Oct 2026 23:15:57 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,shakeel.butt@linux.dev,
	roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,
	harry@kernel.org,hannes@cmpxchg.org,tz2294@columbia.edu,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memcontrol-remove-page_memcg_check.patch added to mm-new branch
Message-Id: <20261030061557.E02611F000C1@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm: memcontrol: remove page_memcg_check()
has been added to the -mm mm-new branch.  Its filename is
     mm-memcontrol-remove-page_memcg_check.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memcontrol-remove-page_memcg_check.patch

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
Subject: mm: memcontrol: remove page_memcg_check()
Date: Wed, 14 Oct 2026 13:08:21 -0400

The last caller was removed in commit 90f095b816e2 ("mm/page_owner: use
memcg_data snapshot to avoid TOCTOU in print_page_owner_memcg()").
Remove it.

Link: https://lore.kernel.org/20261014-memcg-unused-page-helpers-v1-2-240b37c53831@columbia.edu
Signed-off-by: Tal Zussman <tz2294@columbia.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Harry Yoo (Meta) <harry@kernel.org>
Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Muchun Song <muchun.song@linux.dev>
Reviewed-by: SJ Park <sj@kernel.org>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
---

 include/linux/memcontrol.h |   12 ------------
 1 file changed, 12 deletions(-)

--- a/include/linux/memcontrol.h~mm-memcontrol-remove-page_memcg_check
+++ a/include/linux/memcontrol.h
@@ -506,13 +506,6 @@ static inline struct mem_cgroup *folio_m
 	return obj_cgroup_memcg(objcg);
 }
 
-static inline struct mem_cgroup *page_memcg_check(const struct page *page)
-{
-	if (PageTail(page))
-		return NULL;
-	return folio_memcg_check((const struct folio *)page);
-}
-
 static inline struct mem_cgroup *get_mem_cgroup_from_objcg(const struct obj_cgroup *objcg)
 {
 	struct mem_cgroup *memcg;
@@ -1095,11 +1088,6 @@ static inline struct mem_cgroup *folio_m
 {
 	return NULL;
 }
-
-static inline struct mem_cgroup *page_memcg_check(const struct page *page)
-{
-	return NULL;
-}
 
 static inline struct mem_cgroup *get_mem_cgroup_from_objcg(const struct obj_cgroup *objcg)
 {
_

Patches currently in -mm which might be from tz2294@columbia.edu are

mm-memcontrol-remove-mod_memcg_page_state.patch
mm-memcontrol-remove-page_memcg_check.patch

