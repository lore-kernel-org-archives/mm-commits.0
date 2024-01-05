Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C70CD328CA
	for <mm-commits@vger.kernel.org>; Fri,  5 Jan 2024 17:59:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="AgzJru3V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A62BC433C7;
	Fri,  5 Jan 2024 17:59:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1704477543;
	bh=vq+9nUAQtbT4lXRDXN1QgT4WPlzOW2hY2Sb3ILM3HxM=;
	h=Date:To:From:Subject:From;
	b=AgzJru3VV9/T5bAjHzjqCdkI2IpLD0hppV3gixWaP6r54jLLUnnIk8hVbASl91Oo0
	 SsJjeg5AOC7bnSpv4tN3QYGMgUbzQb7lTAhAPLNH98/PQ5L+UR2SY5mV1dP5/YJE2N
	 VeSs3BH0+iJ7WTjvwgW1jU4bRX2m9TzwHRL4v2+c=
Date: Fri, 05 Jan 2024 09:59:02 -0800
To: mm-commits@vger.kernel.org,zhengqi.arch@bytedance.com,syzbot+1e0ed05798af62917464@syzkaller.appspotmail.com,songmuchun@bytedance.com,penguin-kernel@I-love.SAKURA.ne.jp,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-shrinker-use-kvzalloc_node-from-expand_one_shrinker_info.patch removed from -mm tree
Message-Id: <20240105175903.2A62BC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: shrinker: use kvzalloc_node() from expand_one_shrinker_info()
has been removed from the -mm tree.  Its filename was
     mm-shrinker-use-kvzalloc_node-from-expand_one_shrinker_info.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Subject: mm: shrinker: use kvzalloc_node() from expand_one_shrinker_info()
Date: Wed, 3 Jan 2024 10:52:22 +0900

syzbot is reporting uninit-value at shrinker_alloc(), for commit
307bececcd12 ("mm: shrinker: add a secondary array for
shrinker_info::{map, nr_deferred}") which assumed that the ->unit was
allocated with __GFP_ZERO forgot to replace kvmalloc_node() in
expand_one_shrinker_info() with kvzalloc_node().

Link: https://lkml.kernel.org/r/9226cc0a-10e0-4489-80c5-58c3b5b4359c@I-love.SAKURA.ne.jp
Reported-by: syzbot <syzbot+1e0ed05798af62917464@syzkaller.appspotmail.com>
Closes: https://syzkaller.appspot.com/bug?extid=1e0ed05798af62917464
Fixes: 307bececcd12 ("mm: shrinker: add a secondary array for shrinker_info::{map, nr_deferred}")
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Acked-by: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shrinker.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/shrinker.c~mm-shrinker-use-kvzalloc_node-from-expand_one_shrinker_info
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


