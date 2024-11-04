Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37AD04C6C
	for <mm-commits@vger.kernel.org>; Mon,  4 Nov 2024 04:06:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730693200; cv=none; b=I84oqwOz0cgxCA3ASYPkXiWrhMVxybRhp5QcSqcLl7/3El6yt2aNANl42ipzoSNtaclgeeLWVtnVZDnpTMfgcwrUlWCNKpqDHl9rIbFoxlioQCY6yHBdfcuRM83/ncnP4NnztUHp15C3JZbV9nHP92gthm90wIqQJLgEuoyJPq4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730693200; c=relaxed/simple;
	bh=8NcfSDtMrT5VmV7J0nd77bXfFvuuFJ0NuvE/lt76xeQ=;
	h=Date:To:From:Subject:Message-Id; b=fpEwIswXNS05alj+MIFGYvJQrr+aQ8z0NswwGvbkyL5A5AQTwXewly8ndO4ZusI8GfPXLjcbRHHu2x8luVzyp/xPdqPFWZHIjTm380K/151uvEQoiu6a+9X70PehLxojeF4L69642Yoe+Nr4bIn/SgRbBqQXIRTURpTRNNqed7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=KTPTghzi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KTPTghzi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A548BC4CECE;
	Mon,  4 Nov 2024 04:06:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730693199;
	bh=8NcfSDtMrT5VmV7J0nd77bXfFvuuFJ0NuvE/lt76xeQ=;
	h=Date:To:From:Subject:From;
	b=KTPTghzi2m+grQ9/t+sFYQt4rHJwxV0r31rzC6iTqHQviioShtouLa7fiMbXc345A
	 Sfwlvy8DUkzt1AImUFSwivqOLlER0vnCd3dSCiLAqahZ7gKuQT6lkJH70Sl7IOZTyA
	 ZrtYbpEO+4a7Rb31XlJlI64JfRcc3KgXTHefYmd8=
Date: Sun, 03 Nov 2024 20:06:39 -0800
To: mm-commits@vger.kernel.org,zhouchengming@bytedance.com,zhengqi.arch@bytedance.com,willy@infradead.org,usamaarif642@gmail.com,shakeel.butt@linux.dev,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@suse.com,longman@redhat.com,kasong@tencent.com,hannes@cmpxchg.org,ryncsn@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-list_lru-split-the-lock-to-per-cgroup-scope-fix.patch added to mm-unstable branch
Message-Id: <20241104040639.A548BC4CECE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-list_lru-split-the-lock-to-per-cgroup-scope-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-list_lru-split-the-lock-to-per-cgroup-scope-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-list_lru-split-the-lock-to-per-cgroup-scope-fix.patch

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
From: Kairui Song <ryncsn@gmail.com>
Subject: mm-list_lru-split-the-lock-to-per-cgroup-scope-fix
Date: Mon, 28 Oct 2024 01:26:30 +0800

Thanks for the report. I converted list_lru_walk callback to keep the
list unlocked when LRU_RETRY and LRU_REMOVED_RETRY is returned, but
didn't notice shrink_memcg_cg in zswap.c could return LRU_STOP after
it unlocked the list.

Link: https://lkml.kernel.org/r/CAMgjq7D_OA=vYf5SnNnKXjppPFhDqsbYF--6=cOayKiadxuwrQ@mail.gmail.com
Signed-off-by: Kairui Song <ryncsn@gmail.com>
Reported-by: Usama Arif <usamaarif642@gmail.com>
Closes: https://lkml.kernel.org/r/7334b158-8567-4c66-8176-57b879ff8882@gmail.com
Cc: Chengming Zhou <zhouchengming@bytedance.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Waiman Long <longman@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/list_lru.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

--- a/mm/list_lru.c~mm-list_lru-split-the-lock-to-per-cgroup-scope-fix
+++ a/mm/list_lru.c
@@ -298,9 +298,9 @@ restart:
 		ret = isolate(item, l, &l->lock, cb_arg);
 		switch (ret) {
 		/*
-		 * LRU_RETRY and LRU_REMOVED_RETRY will drop the lru lock,
-		 * the list traversal will be invalid and have to restart from
-		 * scratch.
+		 * LRU_RETRY, LRU_REMOVED_RETRY and LRU_STOP will drop the lru
+		 * lock, the list traversal will be invalid and have to restart
+		 * from scratch.
 		 */
 		case LRU_RETRY:
 			goto restart;
@@ -318,14 +318,13 @@ restart:
 		case LRU_SKIP:
 			break;
 		case LRU_STOP:
-			assert_spin_locked(&l->lock);
 			goto out;
 		default:
 			BUG();
 		}
 	}
-out:
 	unlock_list_lru(l, irq_off);
+out:
 	return isolated;
 }
 
_

Patches currently in -mm which might be from ryncsn@gmail.com are

mm-list_lru-split-the-lock-to-per-cgroup-scope-fix.patch

