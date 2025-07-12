Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A65491EC014
	for <mm-commits@vger.kernel.org>; Sat, 12 Jul 2025 23:53:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752364406; cv=none; b=PVPHF0fN2fkHEAf7OBya8qgBvaFk1O0yLwWNsNv0ZKs4UDy7OomVsqckMh9/k7MIB43Bkd6+gEtrx3aJl9Ea/gXKYCuzziFVBlQLD+G4BI+Gvi96Wg6NHKacvPFohmCBli4rgIDE5KdZqPG+irk7A566gxVXgVbyzAhkh6fabxs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752364406; c=relaxed/simple;
	bh=N3UF6naV+f9pyxYvSc2XRAdsiqCQ3N/5Zdz8HA7lYZY=;
	h=Date:To:From:Subject:Message-Id; b=QnlZ1pt1+Gx2+/7gB+aqnuvhHW/QOLM0oLXLxc7IO5Ho9jM55YZg67YlcRL44TxfqBHVCWdcXTdt1xu0baHm1Iay+nXNTq6l7/oaVVy8QQd0H6qjXFdAj7w4dZrFucsrZWgidOrVrnBuvvZzsZqZudnQkzwfGRZBlPuIynp6BYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=aTuLCTE4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="aTuLCTE4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DA2CC4CEEF;
	Sat, 12 Jul 2025 23:53:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752364406;
	bh=N3UF6naV+f9pyxYvSc2XRAdsiqCQ3N/5Zdz8HA7lYZY=;
	h=Date:To:From:Subject:From;
	b=aTuLCTE4ixfLOD0CSTdsMINfbOg76H0Pu88gmToB829HMavvmzrASEyd+GGjXgQno
	 mm0c/zHotOZp8opn/ABFT6aYhYLi3+goGgXkSkGMPsWbjuVmZfqynOGGOHckLmxy/s
	 1wToyR5wjyhqjlONi3ZS4rSokKInr6wYAapP6xXA=
Date: Sat, 12 Jul 2025 16:53:25 -0700
To: mm-commits@vger.kernel.org,zhengqi.arch@bytedance.com,yuzhao@google.com,yuanchu@google.com,shakeel.butt@linux.dev,mhocko@kernel.org,lorenzo.stoakes@oracle.com,kinseyho@google.com,hannes@cmpxchg.org,gthelen@google.com,david@redhat.com,axelrasmussen@google.com,jiahao1@lixiang.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mglru-stop-try_to_inc_min_seq-if-min_seq-has-not-increased.patch added to mm-new branch
Message-Id: <20250712235326.0DA2CC4CEEF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/mglru: stop try_to_inc_min_seq() if min_seq[type] has not increased
has been added to the -mm mm-new branch.  Its filename is
     mm-mglru-stop-try_to_inc_min_seq-if-min_seq-has-not-increased.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mglru-stop-try_to_inc_min_seq-if-min_seq-has-not-increased.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: Hao Jia <jiahao1@lixiang.com>
Subject: mm/mglru: stop try_to_inc_min_seq() if min_seq[type] has not increased
Date: Thu, 3 Jul 2025 10:39:46 +0800

In try_to_inc_min_seq(), if min_seq[type] has not increased.  In other
words, min_seq[type] == lrugen->min_seq[type].  Then we should return
directly to avoid unnecessary overhead later.

Corollary: If min_seq[type] of both anonymous and file is not increased,
try_to_inc_min_seq() will fail.

Proof:
It is known that min_seq[type] has not increased, that is, min_seq[type]
is equal to lrugen->min_seq[type], then the following:

case 1: min_seq[type] has not been reassigned and changed before
judgment min_seq[type] <= lrugen->min_seq[type].
Then the subsequent min_seq[type] <= lrugen->min_seq[type] judgment
will always be true.

case 2: min_seq[type] is reassigned to seq, before judgment
min_seq[type] <= lrugen->min_seq[type].
Then at least the condition of min_seq[type] > seq must be met
before min_seq[type] will be reassigned to seq.
That is to say, before the reassignment, lrugen->min_seq[type] > seq
is met, and then min_seq[type] = seq.
Then the following min_seq[type](seq) <= lrugen->min_seq[type] judgment
is always true.

Therefore, in try_to_inc_min_seq(), If min_seq[type] of both anonymous
and file is not increased, we can return false directly to avoid
unnecessary overhead.

Link: https://lkml.kernel.org/r/20250703023946.65315-1-jiahao.kernel@gmail.com
Signed-off-by: Hao Jia <jiahao1@lixiang.com>
Suggested-by: Yuanchu Xie <yuanchu@google.com>
Reviewed-by: Axel Rasmussen <axelrasmussen@google.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Greg Thelen <gthelen@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kinsey Ho <kinseyho@google.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/mm/vmscan.c~mm-mglru-stop-try_to_inc_min_seq-if-min_seq-has-not-increased
+++ a/mm/vmscan.c
@@ -3929,6 +3929,7 @@ static bool try_to_inc_min_seq(struct lr
 {
 	int gen, type, zone;
 	bool success = false;
+	bool seq_inc_flag = false;
 	struct lru_gen_folio *lrugen = &lruvec->lrugen;
 	DEFINE_MIN_SEQ(lruvec);
 
@@ -3945,11 +3946,20 @@ static bool try_to_inc_min_seq(struct lr
 			}
 
 			min_seq[type]++;
+			seq_inc_flag = true;
 		}
 next:
 		;
 	}
 
+	/*
+	 * If min_seq[type] of both anonymous and file is not increased,
+	 * we can directly return false to avoid unnecessary checking
+	 * overhead later.
+	 */
+	if (!seq_inc_flag)
+		return success;
+
 	/* see the comment on lru_gen_folio */
 	if (swappiness && swappiness <= MAX_SWAPPINESS) {
 		unsigned long seq = lrugen->max_seq - MIN_NR_GENS;
_

Patches currently in -mm which might be from jiahao1@lixiang.com are

mm-mglru-stop-try_to_inc_min_seq-if-min_seq-has-not-increased.patch

