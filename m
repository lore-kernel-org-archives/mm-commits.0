Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 413C5156F1
	for <mm-commits@vger.kernel.org>; Tue,  2 Jan 2024 17:58:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="VlWL1zcS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA94EC433C8;
	Tue,  2 Jan 2024 17:58:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1704218327;
	bh=3XWjWFH0GEwacPcNqwopONUUkQoxSjkJdcLCtSdAyf0=;
	h=Date:To:From:Subject:From;
	b=VlWL1zcSKm4iUF3yKjhv80G4FW2EzZLSN/bzXx8IWwlwzl/D8UY1IfHJtcFim2oDE
	 6Zft7icWaZ/B6UAmPkVP7oofecVoVi0/7Q5LcbYfD/RMUQ5O70KA5yj9cuciKeCyp2
	 Q6cQUBHgEBv5A4l+877C9RPdCiHrS/t39fzKJoOw=
Date: Tue, 02 Jan 2024 09:58:46 -0800
To: mm-commits@vger.kernel.org,zhengqi.arch@bytedance.com,syzbot+1e0ed05798af62917464@syzkaller.appspotmail.com,songmuchun@bytedance.com,penguin-kernel@I-love.SAKURA.ne.jp,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-shrinker-use-kvzalloc_node-from-memcg_expand_one_shrinker_map.patch added to mm-hotfixes-unstable branch
Message-Id: <20240102175847.AA94EC433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: shrinker: use kvzalloc_node() from memcg_expand_one_shrinker_map()
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-shrinker-use-kvzalloc_node-from-memcg_expand_one_shrinker_map.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-shrinker-use-kvzalloc_node-from-memcg_expand_one_shrinker_map.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Subject: mm: shrinker: use kvzalloc_node() from memcg_expand_one_shrinker_map()
Date: Wed, 3 Jan 2024 00:46:36 +0900

syzbot is reporting uninit-value at shrinker_alloc(), for commit
307bececcd12 ("mm: shrinker: add a secondary array for
shrinker_info::{map, nr_deferred}") which assumed that the ->unit was
allocated with __GFP_ZERO forgot to replace kvmalloc_node() in
memcg_expand_one_shrinker_map() with kvzalloc_node().

Link: https://lkml.kernel.org/r/b1a78c6a-b3fa-46ed-810a-ce546e726d44@I-love.SAKURA.ne.jp
Fixes: 307bececcd12 ("mm: shrinker: add a secondary array for shrinker_info::{map, nr_deferred}")
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Reported-by: syzbot <syzbot+1e0ed05798af62917464@syzkaller.appspotmail.com>
Closes: https://syzkaller.appspot.com/bug?extid=1e0ed05798af62917464
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shrinker.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/shrinker.c~mm-shrinker-use-kvzalloc_node-from-memcg_expand_one_shrinker_map
+++ a/mm/shrinker.c
@@ -126,7 +126,7 @@ static int expand_one_shrinker_info(stru
 		if (new_nr_max <= old->map_nr_max)
 			continue;
 
-		new = kvmalloc_node(sizeof(*new) + new_size, GFP_KERNEL, nid);
+		new = kvzalloc_node(sizeof(*new) + new_size, GFP_KERNEL, nid);
 		if (!new)
 			return -ENOMEM;
 
_

Patches currently in -mm which might be from penguin-kernel@I-love.SAKURA.ne.jp are

mm-shrinker-use-kvzalloc_node-from-memcg_expand_one_shrinker_map.patch

