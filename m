Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1444D1C2BE
	for <mm-commits@vger.kernel.org>; Wed,  3 Jan 2024 18:17:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="TQSVDr35"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C1E6C433C7;
	Wed,  3 Jan 2024 18:17:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1704305865;
	bh=Qp/drroUcxBg3ma/TJefQ127Ftex6tIpaz/yJvfT1QE=;
	h=Date:To:From:Subject:From;
	b=TQSVDr35crKZ6vhEuZVvLgpt9zlvyiRU7encGt30TQQa+cdEt1oYssgzKuzGgAXWc
	 tiwC2jc4kqegY2z9812Lyv1BUD1+M+BAAwbfYiZG/lrEtITfoJO4guyYxbGdYnXsYX
	 oAw/Gl9Enng5f8FmhrmXQFBIQCpHFykgWcCqS39E=
Date: Wed, 03 Jan 2024 10:17:44 -0800
To: mm-commits@vger.kernel.org,zhengqi.arch@bytedance.com,syzbot+1e0ed05798af62917464@syzkaller.appspotmail.com,songmuchun@bytedance.com,penguin-kernel@I-love.SAKURA.ne.jp,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-shrinker-use-kvzalloc_node-from-expand_one_shrinker_info.patch added to mm-hotfixes-unstable branch
Message-Id: <20240103181745.7C1E6C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: shrinker: use kvzalloc_node() from expand_one_shrinker_info()
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-shrinker-use-kvzalloc_node-from-expand_one_shrinker_info.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-shrinker-use-kvzalloc_node-from-expand_one_shrinker_info.patch

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
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
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

mm-shrinker-use-kvzalloc_node-from-expand_one_shrinker_info.patch

