Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7B49186E40
	for <mm-commits@vger.kernel.org>; Thu, 16 Jan 2025 05:44:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737006291; cv=none; b=TzJ8b8uDl/56v2Rbe/JTbH0b1R3m/CWuTEegOuTbmYvgmDejQPynG3IFIZtzCPgJ2A5LatEsGuPLaAhBgKs8oGRB7o6yXpVyyXRf/7mO//AGyexh6goY9MsXAldH/g7taHGq5bo2HQG/w7AdYEG1A28WmFi7tKGB2DEfLZBtTWY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737006291; c=relaxed/simple;
	bh=RqzMZHXLR45z/VujWzlATLb3iSRtTLkx4Pa1O4Q6cCg=;
	h=Date:To:From:Subject:Message-Id; b=DjfImEI+zS3K9o4fl7dPFEZxn9Q1DSnTe/K2pBm7n3C0kJ/vwhYgHhLZjHDyKpVvvcZwb3zMr2ctELQqRpS0bq3jwlv4oz+d2g7d9S5gJAIqtBjIfYmTdIABzagAS3l7kSQyc8pNzj+/2IkfPVW0A2Dj3NyV4N/aYVzsCAzsreo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=B4KbpQnJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="B4KbpQnJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DC2FC4CED6;
	Thu, 16 Jan 2025 05:44:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1737006291;
	bh=RqzMZHXLR45z/VujWzlATLb3iSRtTLkx4Pa1O4Q6cCg=;
	h=Date:To:From:Subject:From;
	b=B4KbpQnJBjJfc2dA095anSdbBqZMWMaLG3jwOH+8ZdB3AMgM+5l9+FwGkrz8fHyYQ
	 DKCqycsQMQAEa8QPp4oYv0uJg51ijjlwOyCzLhgfcNM70AehcEW4NwXnmzykqEXxvy
	 1+WWeu8/Im1HMtWBMWp1BosEfwTlmGF/kCnCzzNk=
Date: Wed, 15 Jan 2025 21:44:51 -0800
To: mm-commits@vger.kernel.org,yunjeong.mun@sk.com,honggyu.kim@sk.com,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-explain-effective-quota-on-kernel-doc-comment.patch removed from -mm tree
Message-Id: <20250116054451.8DC2FC4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon: explain "effective quota" on kernel-doc comment
has been removed from the -mm tree.  Its filename was
     mm-damon-explain-effective-quota-on-kernel-doc-comment.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon: explain "effective quota" on kernel-doc comment
Date: Fri, 10 Jan 2025 10:52:32 -0800

The kernel-doc comment for 'struct damos_quota' describes how "effective
quota" is calculated, but does not explain what it is.  Actually there was
an input[1] about it.  Add the explanation on the comment.

Also, fix a trivial typo on the comment block: s/empt/empty/

[1] https://github.com/damonitor/damo/issues/17#issuecomment-2497525043

Link: https://lkml.kernel.org/r/20250110185232.54907-6-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Suggested-by: Honggyu Kim <honggyu.kim@sk.com>
Cc: Yunjeong Mun <yunjeong.mun@sk.com>
Cc: Honggyu Kim <honggyu.kim@sk.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/damon.h |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

--- a/include/linux/damon.h~mm-damon-explain-effective-quota-on-kernel-doc-comment
+++ a/include/linux/damon.h
@@ -193,11 +193,16 @@ struct damos_quota_goal {
  * size quota is set, DAMON tries to apply the action only up to &sz bytes
  * within &reset_interval.
  *
- * Internally, the time quota is transformed to a size quota using estimated
- * throughput of the scheme's action.  DAMON then compares it against &sz and
- * uses smaller one as the effective quota.
+ * To convince the different types of quotas and goals, DAMON internally
+ * converts those into one single size quota called "effective quota".  DAMON
+ * internally uses it as the only one real quota.  The conversion is made as
+ * follows.
  *
- * If @goals is not empt, DAMON calculates yet another size quota based on the
+ * The time quota is transformed to a size quota using estimated throughput of
+ * the scheme's action.  DAMON then compares it against &sz and uses smaller
+ * one as the effective quota.
+ *
+ * If @goals is not empty, DAMON calculates yet another size quota based on the
  * goals using its internal feedback loop algorithm, for every @reset_interval.
  * Then, if the new size quota is smaller than the effective quota, it uses the
  * new size quota as the effective quota.
_

Patches currently in -mm which might be from sj@kernel.org are


