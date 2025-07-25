Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78F8B204083
	for <mm-commits@vger.kernel.org>; Fri, 25 Jul 2025 02:14:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753409654; cv=none; b=MOWv4FbtH67aMgTvSSr36Pdiq0K2OnR3tdIAvrE1+likHShleAgXMbWtkvjSU4Bk0+19lxZzxqR09JnNYdrw2uD4Kq7OHRAoLeQzZUT5WVPGcDD2rAdmcqjmUW/uOMcrdnbV33hISVHqz+5Y9ENjdXX2Oon8bKHhfaoBQAe8nNE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753409654; c=relaxed/simple;
	bh=hCBQ2roIzznrueO4zdVqh4tRywmFjVUJyV71q68cHTo=;
	h=Date:To:From:Subject:Message-Id; b=IY59aAfSmYYaRlc54ehKzt2QrhLceY7KjOij4zURjo630dAWQ+s/b4QFAjR2Z4rqKrzI81eiI20QI4/iqAyNB8VvxzD0D/pUGBw3xgN5M2bnBzQ7sXnfyI3KwMnoVg1MLcX/OSfQ9zV8qh+GywlGsKQ2ovBUTIB2W7ZvegwTzEQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=T1+b898i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="T1+b898i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEEBEC4CEED;
	Fri, 25 Jul 2025 02:14:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1753409654;
	bh=hCBQ2roIzznrueO4zdVqh4tRywmFjVUJyV71q68cHTo=;
	h=Date:To:From:Subject:From;
	b=T1+b898ipIYKZbZJYyv1TbCqvhzZWPkNADZsQSXhgd2b4vGOFNjdi8I5/NCE/cglc
	 ixOKFdm46HTWXCK3xR/h9nsybmodvztji6Jnqd44YLnwcvMkXoAvSqIkKkUzyz/WQy
	 5z3NJK5ZYu5oGXs9IsIXumgnI1uhkNjvavtkY94A=
Date: Thu, 24 Jul 2025 19:14:13 -0700
To: mm-commits@vger.kernel.org,zhengqi.arch@bytedance.com,yuzhao@google.com,yuanchu@google.com,shakeel.butt@linux.dev,mhocko@kernel.org,lorenzo.stoakes@oracle.com,kinseyho@google.com,hannes@cmpxchg.org,gthelen@google.com,david@redhat.com,axelrasmussen@google.com,jiahao1@lixiang.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-mglru-stop-try_to_inc_min_seq-if-min_seq-has-not-increased.patch removed from -mm tree
Message-Id: <20250725021413.EEEBEC4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/mglru: stop try_to_inc_min_seq() if min_seq[type] has not increased
has been removed from the -mm tree.  Its filename was
     mm-mglru-stop-try_to_inc_min_seq-if-min_seq-has-not-increased.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -3921,6 +3921,7 @@ static bool try_to_inc_min_seq(struct lr
 {
 	int gen, type, zone;
 	bool success = false;
+	bool seq_inc_flag = false;
 	struct lru_gen_folio *lrugen = &lruvec->lrugen;
 	DEFINE_MIN_SEQ(lruvec);
 
@@ -3937,11 +3938,20 @@ static bool try_to_inc_min_seq(struct lr
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

mm-mglru-update-mg-lru-proactive-reclaim-statistics-only-to-memcg.patch

