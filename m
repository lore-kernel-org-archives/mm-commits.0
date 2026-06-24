Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84B771A9FB0
	for <mm-commits@vger.kernel.org>; Wed, 24 Jun 2026 19:57:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782331076; cv=none; b=Nx9L8XENiVh1N9h0LUn43SyKOzx+cgYfz+geuQM8LXebpu3uwPnDsiy/kMTOqEpDbnmfWvZMfLtaI7f7ZJEIxT9te/TuDK66PtBEKqnYyP2HFXQemq2WJOrlpkoP44iEtus7kKIWX1Sfjn0mQR0k9ERD7RvHarSojaYYd/zzbBo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782331076; c=relaxed/simple;
	bh=HzGJetiAU8NIl5SB2Wwq76dkhCevwwYV2hyMTO45dAo=;
	h=Date:To:From:Subject:Message-Id; b=hbIEH5Au0AtVHX3+SSEg7ldjiD+ZUiBbwa8RCovpsLAGhaiIpbDpvqH0GmF6uUN9Sgq9KolOTjjAH1oNDQudq6wWXgRAU5JangniUHEfGLedOgWhfcghfLvao1qswMVw7f009r0FQ+quUNHCGpbQjfepY3euihP+UDu1rbbbmaI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xPjVsoni; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xPjVsoni"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F12581F000E9;
	Wed, 24 Jun 2026 19:57:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782331075;
	bh=aiQeGFGZBJpb7+fsBRcGqJHb4Zu++WuRlsqm2FTiigg=;
	h=Date:To:From:Subject;
	b=xPjVsoniMSRnXsqaHZnScXGs1OsyjYiXGhiKYqnBHRcYPgiqdyajaHlD+zpv4BvUg
	 6bM0KAokElEBTWxxGl4IOm7jni+b/kSHJ1fBRycAzYDpeAMmFFqGyrfCX/7/uLDh24
	 ltIEWYwyygpIEMIRios3QutzixSnlI76H7lsDJhw=
Date: Wed, 24 Jun 2026 12:57:54 -0700
To: mm-commits@vger.kernel.org,shakeel.butt@linux.dev,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,hannes@cmpxchg.org,joshua.hahnjy@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memcontrol-remove-unused-for_each_mem_cgroup-macro-and-cleanup.patch added to mm-new branch
Message-Id: <20260624195754.F12581F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/memcontrol: remove unused for_each_mem_cgroup macro and cleanup
has been added to the -mm mm-new branch.  Its filename is
     mm-memcontrol-remove-unused-for_each_mem_cgroup-macro-and-cleanup.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memcontrol-remove-unused-for_each_mem_cgroup-macro-and-cleanup.patch

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
From: Joshua Hahn <joshua.hahnjy@gmail.com>
Subject: mm/memcontrol: remove unused for_each_mem_cgroup macro and cleanup
Date: Wed, 24 Jun 2026 11:36:59 -0700

Commit 7e1c0d6f58207 ("memcg: switch lruvec stats to rstat") removed the
last caller of for_each_mem_cgroup back in 2021, and there have not been
any new callers since.  Remove the macro.

A comment in mem_cgroup_css_online has also been out of date since 2021,
when 2bfd36374edd9 ("mm: vmscan: consolidate shrinker_maps handling code")
open-coded the for_each_mem_cgroup iterator.  Update the comment.

Finally, 99430ab8b804c ("mm: introduce BPF kfuncs to access memcg
statistics and events") added a second declaration for memcg_events to
include/linux/memcontrol.h, duplicating the one in mm/memcontrol-v1.h. 
Let's clean that up too.

No functional changes intended.

Link: https://lore.kernel.org/20260624183700.1152742-1-joshua.hahnjy@gmail.com
Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol-v1.h |    6 ------
 mm/memcontrol.c    |    2 +-
 2 files changed, 1 insertion(+), 7 deletions(-)

--- a/mm/memcontrol.c~mm-memcontrol-remove-unused-for_each_mem_cgroup-macro-and-cleanup
+++ a/mm/memcontrol.c
@@ -4217,7 +4217,7 @@ static int mem_cgroup_css_online(struct
 	/*
 	 * A memcg must be visible for expand_shrinker_info()
 	 * by the time the maps are allocated. So, we allocate maps
-	 * here, when for_each_mem_cgroup() can't skip it.
+	 * here, when mem_cgroup_iter() can't skip it.
 	 */
 	if (alloc_shrinker_info(memcg))
 		goto offline_kmem;
--- a/mm/memcontrol-v1.h~mm-memcontrol-remove-unused-for_each_mem_cgroup-macro-and-cleanup
+++ a/mm/memcontrol-v1.h
@@ -17,14 +17,8 @@
 	     iter != NULL;				\
 	     iter = mem_cgroup_iter(root, iter, NULL))
 
-#define for_each_mem_cgroup(iter)			\
-	for (iter = mem_cgroup_iter(NULL, NULL, NULL);	\
-	     iter != NULL;				\
-	     iter = mem_cgroup_iter(NULL, iter, NULL))
-
 void drain_all_stock(struct mem_cgroup *root_memcg);
 
-unsigned long memcg_events(struct mem_cgroup *memcg, int event);
 int memory_stat_show(struct seq_file *m, void *v);
 
 struct mem_cgroup *mem_cgroup_private_id_get_online(struct mem_cgroup *memcg,
_

Patches currently in -mm which might be from joshua.hahnjy@gmail.com are

mm-memcontrol-remove-unused-for_each_mem_cgroup-macro-and-cleanup.patch

