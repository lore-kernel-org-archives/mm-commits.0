Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC22722094
	for <mm-commits@vger.kernel.org>; Tue,  1 Jul 2025 00:37:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751330239; cv=none; b=FTUxEzKQxgIsxvvp+0ulWz/pjMHprWFXomBQ8z67HOzu7xD85jw34jGDyooY6EaYYkHQ2Gf/OCQMRKWyWSiNicwPEja6hepthZdQyAmS+mLhzpW94dTCXoV9W/+aWHBBuJOiQRLaBZbw45qsqHbtwbLwTJddAWM3CruRtcCFUsE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751330239; c=relaxed/simple;
	bh=hUP3TDCAeObc11Ipe3O7SoqxcO9edDZPeFLLs+XksLc=;
	h=Date:To:From:Subject:Message-Id; b=XuxaN0k+Rf5w62hywrVvGAkFLIbWCFiqjr8tkxA4G1DI2uaOButJ65BqaDe/+ogHNTowk2XHoWtofKehNGu0mL8DVES/+lxpnv6+ZbOHO0KZdCQlpnmhMzSuLb+s7J7zV5fK+AQ+TrRUIFZYNbxZA1j7dWLFI568cvlAo0QRMVM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Ty2yPNMt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Ty2yPNMt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C5B6C4CEE3;
	Tue,  1 Jul 2025 00:37:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1751330238;
	bh=hUP3TDCAeObc11Ipe3O7SoqxcO9edDZPeFLLs+XksLc=;
	h=Date:To:From:Subject:From;
	b=Ty2yPNMtErwJ2bNGGzAQ1V61XWyuVprbkhynMyzbAVV6UHuduqtLa0fBVpxo8lWgh
	 8MByKeFpj/LrZuEieDW3nUCgMnZ5c1M6dTUXLIIDbMJE1wDVFYQMNK5ii6wKrO9tY/
	 3cmHosCyPFXTyM0kAu2U10Eud5qxoBKWsgDB+KjQ=
Date: Mon, 30 Jun 2025 17:37:17 -0700
To: mm-commits@vger.kernel.org,zhengqi.arch@bytedance.com,yuzhao@google.com,yuanchu@google.com,shakeel.butt@linux.dev,mhocko@kernel.org,lorenzo.stoakes@oracle.com,kinseyho@google.com,hannes@cmpxchg.org,gthelen@google.com,david@redhat.com,axelrasmussen@google.com,jiahao1@lixiang.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mglru-stop-try_to_inc_min_seq-if-the-oldest-generation-lru-lists-are-not-empty.patch added to mm-new branch
Message-Id: <20250701003718.3C5B6C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/mglru: stop try_to_inc_min_seq() if the oldest generation LRU lists are not empty
has been added to the -mm mm-new branch.  Its filename is
     mm-mglru-stop-try_to_inc_min_seq-if-the-oldest-generation-lru-lists-are-not-empty.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mglru-stop-try_to_inc_min_seq-if-the-oldest-generation-lru-lists-are-not-empty.patch

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
Subject: mm/mglru: stop try_to_inc_min_seq() if the oldest generation LRU lists are not empty
Date: Mon, 30 Jun 2025 16:06:03 +0800

In try_to_inc_min_seq(), if the oldest generation of LRU lists (anonymous
and file) are not empty.  Then we should return directly to avoid
unnecessary subsequent overhead.

Corollary: If the lrugen->folios[gen][type][zone] lists of both anonymous
and file are not empty, try_to_inc_min_seq() will fail.

Proof: Taking LRU_GEN_ANON as an example, consider the following two cases:

Case 1: min_seq[LRU_GEN_ANON] <= seq (seq is lrugen->max_seq - MIN_NR_GENS)

Since min_seq[LRU_GEN_ANON] has not increased, so min_seq[LRU_GEN_ANON] is
still equal to lrugen->min_seq[LRU_GEN_ANON].  Therefore, in the following
judgment: min_seq[LRU_GEN_ANON] <= lrugen->min_seq[LRU_GEN_ANON] is always
true.  So we will not increase the seq of the oldest generation of
anonymous, and try_to_inc_min_seq() will return false.

case 2: min_seq[LRU_GEN_ANON] > seq (seq is lrugen->max_seq - MIN_NR_GENS)

If min_seq[LRU_GEN_ANON] > seq, that is, lrugen->min_seq[LRU_GEN_ANON] >
seq Then min_seq[LRU_GEN_ANON] is assigned seq.  Therefore, in the
following judgment:
min_seq[LRU_GEN_ANON] (seq) <= lrugen->min_seq[LRU_GEN_ANON] is always true.
So, we will not update the oldest generation seq of anonymous, and
try_to_inc_min_seq() will return false.

It is similar for LRU_GEN_FILE.  Therefore, in try_to_inc_min_seq(), if
the oldest generation LRU lists (anonymous and file) are not empty, in
other words, min_seq[type] has not increased.  we can directly return
false to avoid unnecessary checking overhead later.

Link: https://lkml.kernel.org/r/20250630080603.36171-1-jiahao.kernel@gmail.com
Signed-off-by: Hao Jia <jiahao1@lixiang.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Greg Thelen <gthelen@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: David Hildenbrand <david@redhat.com>
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

--- a/mm/vmscan.c~mm-mglru-stop-try_to_inc_min_seq-if-the-oldest-generation-lru-lists-are-not-empty
+++ a/mm/vmscan.c
@@ -3928,6 +3928,7 @@ static bool try_to_inc_min_seq(struct lr
 	int gen, type, zone;
 	bool success = false;
 	struct lru_gen_folio *lrugen = &lruvec->lrugen;
+	int seq_inc_flags[ANON_AND_FILE] = {0};
 	DEFINE_MIN_SEQ(lruvec);
 
 	VM_WARN_ON_ONCE(!seq_is_valid(lruvec));
@@ -3943,11 +3944,20 @@ static bool try_to_inc_min_seq(struct lr
 			}
 
 			min_seq[type]++;
+			seq_inc_flags[type] = 1;
 		}
 next:
 		;
 	}
 
+	/*
+	 * If the oldest generation of LRU lists (anonymous and file)
+	 * are not empty, we can directly return false to avoid unnecessary
+	 * checking overhead later.
+	 */
+	if (!seq_inc_flags[LRU_GEN_ANON] && !seq_inc_flags[LRU_GEN_FILE])
+		return success;
+
 	/* see the comment on lru_gen_folio */
 	if (swappiness && swappiness <= MAX_SWAPPINESS) {
 		unsigned long seq = lrugen->max_seq - MIN_NR_GENS;
_

Patches currently in -mm which might be from jiahao1@lixiang.com are

mm-mglru-stop-try_to_inc_min_seq-if-the-oldest-generation-lru-lists-are-not-empty.patch

