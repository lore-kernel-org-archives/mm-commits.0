Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8AFA1A6814
	for <mm-commits@vger.kernel.org>; Sat, 21 Mar 2026 17:57:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774115821; cv=none; b=En4aQDpUrDobRqGPGYzbuECh9M1ojiTA/32y4HvlM1FTCV/1lMAEV99XMyQjgBf7tk26ueUce9cYonT4AmUMDWhnrbk9yb294e7NrPP152GA9BhksDNWWtiJ7EJfIDdE0KXi0m6NBH2Oq93PSDMHoe7m7jnyQZ3fZuQcHftcA9s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774115821; c=relaxed/simple;
	bh=xwjLHNQ3S6jWzHvEy3OXb+E8PyZZsq4CRT6PQwOKrIM=;
	h=Date:To:From:Subject:Message-Id; b=Y+hTxkPTx83vA7FbR0G4HyGob/kEod+hY2WD64M/TencFC6nckEOGiho5LWK8wipQGilD7vysj0vGLvX8WGrhQuX0E2xEsozkUJ0loRS3SOfbZUfCdnPjeZw71pjiFXz3cJdo6Py2Oob0dlJxeizxutpjRifGfx5cGy9SV+xC9A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=BlwL2lBD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="BlwL2lBD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65F16C2BCAF;
	Sat, 21 Mar 2026 17:57:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774115821;
	bh=xwjLHNQ3S6jWzHvEy3OXb+E8PyZZsq4CRT6PQwOKrIM=;
	h=Date:To:From:Subject:From;
	b=BlwL2lBDu4QKKlCPsIg9yZVrS+Ct/qkoRiRJ4WzHc91Lhr2JtAf9g0YDS1zaBxQE+
	 d7qU6KgFXfEylnYhgTpwiU5Ms+dZSZBewLe09FTTp8RY9k/tVZmUmVh9Oda4+/0xCX
	 hxoH+YkUd9E2lHXWCJ1ZZS+slr88LMZvXmazIrLg=
Date: Sat, 21 Mar 2026 10:57:00 -0700
To: mm-commits@vger.kernel.org,zhengqi.arch@bytedance.com,yuanchu@google.com,weixugc@google.com,shikemeng@huaweicloud.com,shakeel.butt@linux.dev,nphamcs@gmail.com,mhocko@kernel.org,lorenzo.stoakes@oracle.com,ljs@kernel.org,kasong@tencent.com,julia.lawall@inria.fr,hannes@cmpxchg.org,david@kernel.org,chrisl@kernel.org,bhe@redhat.com,baohua@kernel.org,axelrasmussen@google.com,kexinsun@smail.nju.edu.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-update-outdated-comments-for-removed-scan_swap_map_slots.patch added to mm-new branch
Message-Id: <20260321175701.65F16C2BCAF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: update outdated comments for removed scan_swap_map_slots()
has been added to the -mm mm-new branch.  Its filename is
     mm-update-outdated-comments-for-removed-scan_swap_map_slots.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-update-outdated-comments-for-removed-scan_swap_map_slots.patch

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
From: Kexin Sun <kexinsun@smail.nju.edu.cn>
Subject: mm: update outdated comments for removed scan_swap_map_slots()
Date: Sat, 21 Mar 2026 18:58:14 +0800

The function scan_swap_map_slots() was removed in commit 0ff67f990bd4
("mm, swap: remove swap slot cache").

The three comments referencing it simply noted that ->flags can be updated
non-atomically by scan_swap_map_slots() to justify a data_race()
annotation.  Since the function no longer exists, drop the parenthetical
reference while keeping the data_race() justification intact: ->flags can
still be updated non-atomically by other paths (e.g., swapoff clearing
SWP_WRITEOK).

Assisted-by: unnamed:deepseek-v3.2 coccinelle
Link: https://lkml.kernel.org/r/20260321105814.7053-1-kexinsun@smail.nju.edu.cn
Signed-off-by: Kexin Sun <kexinsun@smail.nju.edu.cn>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Chris Li <chrisl@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Julia Lawall <julia.lawall@inria.fr>
Cc: Kairui Song <kasong@tencent.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Wei Xu <weixugc@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_io.c |    4 ++--
 mm/vmscan.c  |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

--- a/mm/page_io.c~mm-update-outdated-comments-for-removed-scan_swap_map_slots
+++ a/mm/page_io.c
@@ -454,14 +454,14 @@ void __swap_writepage(struct folio *foli
 
 	VM_BUG_ON_FOLIO(!folio_test_swapcache(folio), folio);
 	/*
-	 * ->flags can be updated non-atomically (scan_swap_map_slots),
+	 * ->flags can be updated non-atomically,
 	 * but that will never affect SWP_FS_OPS, so the data_race
 	 * is safe.
 	 */
 	if (data_race(sis->flags & SWP_FS_OPS))
 		swap_writepage_fs(folio, swap_plug);
 	/*
-	 * ->flags can be updated non-atomically (scan_swap_map_slots),
+	 * ->flags can be updated non-atomically,
 	 * but that will never affect SWP_SYNCHRONOUS_IO, so the data_race
 	 * is safe.
 	 */
--- a/mm/vmscan.c~mm-update-outdated-comments-for-removed-scan_swap_map_slots
+++ a/mm/vmscan.c
@@ -1046,7 +1046,7 @@ static bool may_enter_fs(struct folio *f
 	/*
 	 * We can "enter_fs" for swap-cache with only __GFP_IO
 	 * providing this isn't SWP_FS_OPS.
-	 * ->flags can be updated non-atomically (scan_swap_map_slots),
+	 * ->flags can be updated non-atomically,
 	 * but that will never affect SWP_FS_OPS, so the data_race
 	 * is safe.
 	 */
_

Patches currently in -mm which might be from kexinsun@smail.nju.edu.cn are

kasan-update-outdated-comment.patch
mm-vmalloc-update-outdated-comment-for-renamed-vread.patch
mm-update-outdated-comments-for-removed-scan_swap_map_slots.patch

