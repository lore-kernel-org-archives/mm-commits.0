Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 201473B841F
	for <mm-commits@vger.kernel.org>; Fri,  7 Aug 2026 02:01:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786068069; cv=none; b=frBnXR4uz4iuZFvBJPzBxwMjBL2RTNgl8iplvctPaW58MKuewqo7AAPXO7n+VgpC93X0WYnEVaQd2a3yyka341W+81RXZ/vszA77m16DzU13EFpiVIIYAttLR/jds0kOYBDqnWipF0+6pg+aVheNLYdJaWivOlj/de8Hv9xz6Uk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786068069; c=relaxed/simple;
	bh=sdI/wnHuV01oXQ2srsMc0eDc+wry+jFiX9yY3vAiQis=;
	h=Date:To:From:Subject:Message-Id; b=eGXQnTqsb5jjZwWPHGzeKmtgR+obj/p3shQQRKbzPyhVUTmf3swFNQFta3XsS9cQtPz8YLS69HKY+dqbVDVhawQ3gpWxd2VAVvZJOvamPMNM1iBDD4iYoxSO2HQOdxUKS/QPo3p7r5y/dYsFvgJEX+cSnkNslD+zT6mWvz/M9yM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=udkWrG5q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="udkWrG5q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA8901F000E9;
	Fri,  7 Aug 2026 02:01:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786068065;
	bh=1n2M6qGG4SYLH9/CMJv1M6kLwn7ZaIpHqBbxOGKfPak=;
	h=Date:To:From:Subject;
	b=udkWrG5q4xeltTWF/WaSqPh8CmHjH8vThNDlrC0WdiD0svOxVWbhhpydteG75cVUq
	 D0gkxLjx6rzSVdLA4LzG0sHo+MinhdEw8DKxr/gTfiEUwYWKhaAUUtSaVigMnFFL3P
	 o2tH/V7hOe5mx+GZruT3JqkSAHibvs0YwkfUkSFY=
Date: Thu, 06 Aug 2026 19:01:05 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-core-hide-private-damos_quota-fields.patch removed from -mm tree
Message-Id: <20260807020105.BA8901F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/core: hide private damos_quota fields
has been removed from the -mm tree.  Its filename was
     mm-damon-core-hide-private-damos_quota-fields.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SJ Park <sj@kernel.org>
Subject: mm/damon/core: hide private damos_quota fields
Date: Tue, 14 Jul 2026 07:35:37 -0700

damos_quota->goals is intended to be used by only the DAMON core layer. 
But it is mistakenly not marked as private.  Mark as private.

Link: https://lore.kernel.org/20260714143544.101305-5-sj@kernel.org
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/damon.h |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/include/linux/damon.h~mm-damon-core-hide-private-damos_quota-fields
+++ a/include/linux/damon.h
@@ -228,7 +228,6 @@ enum damos_quota_goal_tuner {
  * @reset_interval:	Charge reset interval in milliseconds.
  * @ms:			Maximum milliseconds that the scheme can use.
  * @sz:			Maximum bytes of memory that the action can be applied.
- * @goals:		Head of quota tuning goals (&damos_quota_goal) list.
  * @goal_tuner:		Goal-based @esz tuning algorithm to use.
  * @esz:		Effective size quota in bytes.
  * @fail_charge_num:	Failed regions charge rate numerator.
@@ -255,7 +254,7 @@ enum damos_quota_goal_tuner {
  * the scheme's action.  DAMON then compares it against &sz and uses smaller
  * one as the effective quota.
  *
- * If @goals is not empty, DAMON calculates yet another size quota based on the
+ * If goals is not empty, DAMON calculates yet another size quota based on the
  * goals using its internal feedback loop algorithm, for every @reset_interval.
  * Then, if the new size quota is smaller than the effective quota, it uses the
  * new size quota as the effective quota.
@@ -276,7 +275,7 @@ struct damos_quota {
 	unsigned long reset_interval;
 	unsigned long ms;
 	unsigned long sz;
-	struct list_head goals;
+
 	enum damos_quota_goal_tuner goal_tuner;
 	unsigned long esz;
 
@@ -288,6 +287,8 @@ struct damos_quota {
 	unsigned int weight_age;
 
 /* private: */
+	/* Head of quota tuning goals (&damos_quota_goal) list. */
+	struct list_head goals;
 	/* For throughput estimation */
 	unsigned long total_charged_sz;
 	unsigned long total_charged_ns;
_

Patches currently in -mm which might be from sj@kernel.org are


