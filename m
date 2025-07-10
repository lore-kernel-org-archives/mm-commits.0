Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C81452857F2
	for <mm-commits@vger.kernel.org>; Thu, 10 Jul 2025 05:45:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752126325; cv=none; b=SsKo/0rroJc4DnP3t/GnsrvnRduu8LJAPtmr4y81o0zt8uF8sHHqzwAsyJt+ug4mmkIqbVB6PragveOY/StzVHTbMHrGn3DmZjk0V2crVPC4inI9GUfwyPoddN6kwNJQHkrEgplpYfJwJ9sP0XsX+zMoHdSvoMPDDekdYcz77dw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752126325; c=relaxed/simple;
	bh=E+UGhdNlY35fi5498W1GDsLlVn6Hs70LFz2m7iMENZs=;
	h=Date:To:From:Subject:Message-Id; b=H0PB9V6Z2MMWC1bt1vmIzt6tZ3vS73M0k4Yo1qKxFX/xn66IYvuM6sCsjnmXdfzk6n3ifZ+KvwNx8uM1/b8L2q3q19BTJdeBEZZxSnD1uF9nBs7e3X5FAyD6iIfROoMHirGYbdCJDo5HSccFgP9CVnAOn4+cQO+y8mFHisq7ECY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=CJX1UmnQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="CJX1UmnQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DB74C4CEE3;
	Thu, 10 Jul 2025 05:45:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752126325;
	bh=E+UGhdNlY35fi5498W1GDsLlVn6Hs70LFz2m7iMENZs=;
	h=Date:To:From:Subject:From;
	b=CJX1UmnQ7kLdTt5rVWNyk8fHuhikT1K2oZQkR5XBnnVPxb+Zomx19zHu0t8Q3Yw2l
	 X5rKaCGvUmPv8IPaXNEejosCA/YoWz6qD8P5VMVaXTHHE86lwIFAgBuu0vgbI7+3ck
	 55n1LBcJ4QJj2NQQUCVYGLp3DFfxN0LvA5oMeLCQ=
Date: Wed, 09 Jul 2025 22:45:25 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,zcgao@amazon.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-fix-minor-typos-in-damon-header.patch removed from -mm tree
Message-Id: <20250710054525.9DB74C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon: fix minor typos in damon header
has been removed from the -mm tree.  Its filename was
     mm-damon-fix-minor-typos-in-damon-header.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Nathan Gao <zcgao@amazon.com>
Subject: mm/damon: fix minor typos in damon header
Date: Wed, 18 Jun 2025 09:33:31 -0700

Fix typos in include/linux/damon.h.

Link: https://lkml.kernel.org/r/20250618163331.54910-1-sj@kernel.org
Signed-off-by: Nathan Gao <zcgao@amazon.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/damon.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/include/linux/damon.h~mm-damon-fix-minor-typos-in-damon-header
+++ a/include/linux/damon.h
@@ -450,7 +450,7 @@ struct damos_access_pattern {
 /**
  * struct damos - Represents a Data Access Monitoring-based Operation Scheme.
  * @pattern:		Access pattern of target regions.
- * @action:		&damo_action to be applied to the target regions.
+ * @action:		&damos_action to be applied to the target regions.
  * @apply_interval_us:	The time between applying the @action.
  * @quota:		Control the aggressiveness of this scheme.
  * @wmarks:		Watermarks for automated (in)activation of this scheme.
@@ -656,7 +656,7 @@ struct damon_call_control {
  * struct damon_intervals_goal - Monitoring intervals auto-tuning goal.
  *
  * @access_bp:		Access events observation ratio to achieve in bp.
- * @aggrs:		Number of aggregations to acheive @access_bp within.
+ * @aggrs:		Number of aggregations to achieve @access_bp within.
  * @min_sample_us:	Minimum resulting sampling interval in microseconds.
  * @max_sample_us:	Maximum resulting sampling interval in microseconds.
  *
_

Patches currently in -mm which might be from zcgao@amazon.com are


