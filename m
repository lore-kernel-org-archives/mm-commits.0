Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8D6F44A730;
	Wed,  2 Sep 2026 22:34:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788388459; cv=none; b=eWuNi6mifD79oxvVLTDm5oCascw37gWGShRGle+hv31INVhfPibiG1lsj3KCGoAt/jhHdckCW67EOLaPUoPDdbCU4B0bhJcw4MBNLAfYGa07VnHstc+RqBVphZdnT6vI8Nbdao/UJ1ppbetKOxDLofQyxr7SBsVDW+w880KhBQM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788388459; c=relaxed/simple;
	bh=1d2ipJuzDM5i/0KPieI4b/1eXFRCu7erdjy0GeQmMbs=;
	h=Date:To:From:Subject:Message-Id; b=ga9B3n/GfdhswFUg0G9ejRA4cmvSe5tvWB9GXlsV/wexQDrgPT69mJcnbFiUJDW7emTvdjt/IaLaNtUHVhDtSM56YNmFd7piJ91SBvzQhjRxAzOARJC0P1Q3E1bTFJItSKFVGzJ3BGdWt9VnaKm1eIDA7XsDxH1UJIFtB06UVEk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=lgvxvIO5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="lgvxvIO5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44BF51F000E9;
	Wed,  2 Sep 2026 22:34:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788388448;
	bh=oLUmHCL5tdwzFjJ5uO6i2GscMI0Zl/n9nLA/rO8rFc0=;
	h=Date:To:From:Subject;
	b=lgvxvIO5TcFwn3TBSNh8XmZnMQWINy2aW+cVtv8YispL1pkOkwmBW6nbqNjyb4XSh
	 zXvs3nY32om09ONQSC0cJogkcedKz7bcme0WxN6aAJOJns4gdEt6irXs3XP0VO6y5R
	 bBMczLfodZk/PQZZYGJJHsbbUmZy76W6KYDcBnJw=
Date: Wed, 02 Sep 2026 15:34:07 -0700
To: mm-commits@vger.kernel.org,usama.arif@linux.dev,stable@vger.kernel.org,shakeel.butt@linux.dev,roman.gushchin@linux.dev,muchun.song@linux.dev,kasong@tencent.com,hannes@cmpxchg.org,david@fromorbit.com,jiayuan.chen@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-shrinker-fix-bogus-set_shrinker_bit-with-cgroupmemory=nokmem.patch added to mm-hotfixes-unstable branch
Message-Id: <20260902223408.44BF51F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/shrinker: fix bogus set_shrinker_bit() with cgroup.memory=nokmem
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-shrinker-fix-bogus-set_shrinker_bit-with-cgroupmemory=nokmem.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-shrinker-fix-bogus-set_shrinker_bit-with-cgroupmemory=nokmem.patch

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
From: Jiayuan Chen <jiayuan.chen@linux.dev>
Subject: mm/shrinker: fix bogus set_shrinker_bit() with cgroup.memory=nokmem
Date: Wed, 2 Sep 2026 15:37:59 +0800

With cgroup.memory=nokmem, shrinker_memcg_alloc() bails out early and
never allocates an id, so shrinker->id keeps the 0 it got from the
kzalloc() in shrinker_alloc().  __list_lru_init() then copies that 0 into
lru->shrinker_id, where it looks like a valid bit index.

Nothing calls expand_shrinker_info() on nokmem either, so shrinker_nr_max
stays 0 and every memcg ends up with an empty map (map_nr_max == 0).

deferred_split_folio() hands a real memcg to __list_lru_add() regardless
of whether the lru is memcg aware, so the first THP queued in a cgroup
does set_shrinker_bit(memcg, nid, 0) and trips the bounds check:

WARNING: mm/shrinker.c:212 at set_shrinker_bit+0x7d/0x90, CPU#126
Call Trace:
 <TASK>
 deferred_split_folio+0x18c/0x220
 map_anon_folio_pmd_nopf+0xdd/0x130
 map_anon_folio_pmd_pf+0x14/0xb0
 do_huge_pmd_anonymous_page+0x1a1/0x620
 __handle_mm_fault+0xea9/0x10d0
 handle_mm_fault+0xe5/0x320
 do_user_addr_fault+0x1cc/0x870
 exc_page_fault+0x81/0x1b0
 asm_exc_page_fault+0x27/0x30
 </TASK>

Harmless, the WARN_ON_ONCE() is what keeps the out of bounds unit[] read
from happening, but the id should not look valid in the first place. 
Clear it before returning.

Two other spots could paper over this: drop the id in __list_lru_init()
when nokmem turns memcg_aware off, or make deferred_split_folio() pass
NULL like list_lru_add_obj() does.  Both leave shrinker->id lying around
for the next caller, so fix it where the id is handed out.

Link: https://lore.kernel.org/20260902073800.305481-1-jiayuan.chen@linux.dev
Fixes: fafaeceb89a5 ("mm: switch deferred split shrinker to list_lru")
Signed-off-by: Jiayuan Chen <jiayuan.chen@linux.dev>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Usama Arif <usama.arif@linux.dev>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shrinker.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/shrinker.c~mm-shrinker-fix-bogus-set_shrinker_bit-with-cgroupmemory=nokmem
+++ a/mm/shrinker.c
@@ -227,6 +227,8 @@ static int shrinker_memcg_alloc(struct s
 {
 	int id;
 
+	shrinker->id = -1;
+
 	if (mem_cgroup_disabled())
 		return -ENOSYS;
 	if (mem_cgroup_kmem_disabled() && !(shrinker->flags & SHRINKER_NONSLAB))
_

Patches currently in -mm which might be from jiayuan.chen@linux.dev are

mm-shrinker-fix-bogus-set_shrinker_bit-with-cgroupmemory=nokmem.patch
mm-memcontrol-fix-data-race-on-reading-jiffies_64.patch

