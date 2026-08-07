Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E6E93C10AE
	for <mm-commits@vger.kernel.org>; Fri,  7 Aug 2026 02:01:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786068068; cv=none; b=PLg7efTaX1y30DCkXjZ81idN8DYM/MVg9ChnjZtD/GO4a2dBkBKhRsu6t1ZTzE4QV2kOfuhkSy8MgEg2HTJIE+VhqoJNxbyshwFtmNhWpH2rT/sSG9fgdymlBAw+/KSBZMdH1Y/diNrcxZnBQtp4Wc8Z9h7lRXu8Xdslz6zL7Nc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786068068; c=relaxed/simple;
	bh=va3/x3fpNC+rXSQXxWNk886sAfXhha798lOKVQrgtjk=;
	h=Date:To:From:Subject:Message-Id; b=cbEEop5mCajxdBSK4KaKWQ8aTL7mRQAwnP8IahuHknZiS2HdThTKyVAlNFghvFUMz9wRl7NVFzsNCnHjtwzIIseiB1nWWpIA7IZLBRa7oKlLIuLmYIAEkLvOL0EMSq1/RpaOO/RLmPmjha9rn1mAgOYyuWmezryV/Yq2eCojUIQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=UjNNRtYK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="UjNNRtYK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8BBE1F00A3F;
	Fri,  7 Aug 2026 02:01:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786068064;
	bh=rM7HrGakWQDA9nMzKjVd3EXYnyH0mwgxEMavQnR6cUE=;
	h=Date:To:From:Subject;
	b=UjNNRtYKA9qMXneDx0qEsZAFtwS4jVYz1pF4//Kd63gPPANEq6V4n72HYG4e/2x1y
	 PSz50DqsSVUgPakqejLJdSfPOQ2eE66PFl/q1ukf8FmYnJyOt8L0SZ7P0vTF3m1g3X
	 4PmtBfbywqoP33nEF2Rs6A68/PG6MZQAU8TsoNTo=
Date: Thu, 06 Aug 2026 19:01:04 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-core-hide-private-damos_quota_goal-fields.patch removed from -mm tree
Message-Id: <20260807020104.A8BBE1F00A3F@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/core: hide private damos_quota_goal fields
has been removed from the -mm tree.  Its filename was
     mm-damon-core-hide-private-damos_quota_goal-fields.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SJ Park <sj@kernel.org>
Subject: mm/damon/core: hide private damos_quota_goal fields
Date: Tue, 14 Jul 2026 07:35:36 -0700

'last_psi_total' and 'list' of damos_quota_goal are intended to be used by
only the DAMON core layer.  Those are mistakenly not marked as private,
though.  Mark as private.

Link: https://lore.kernel.org/20260714143544.101305-4-sj@kernel.org
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/damon.h |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/include/linux/damon.h~mm-damon-core-hide-private-damos_quota_goal-fields
+++ a/include/linux/damon.h
@@ -175,10 +175,8 @@ enum damos_quota_goal_metric {
  * @metric:		Metric to be used for representing the goal.
  * @target_value:	Target value of @metric to achieve with the tuning.
  * @current_value:	Current value of @metric.
- * @last_psi_total:	Last measured total PSI
  * @nid:		Node id.
  * @memcg_id:		Memcg id.
- * @list:		List head for siblings.
  *
  * Data structure for getting the current score of the quota tuning goal.  The
  * score is calculated by how close @current_value and @target_value are.  Then
@@ -201,12 +199,17 @@ struct damos_quota_goal {
 	unsigned long current_value;
 	/* metric-dependent fields */
 	union {
-		u64 last_psi_total;
 		struct {
 			int nid;
 			u64 memcg_id;
 		};
+/* private: */
+		/* Last measured total PSI */
+		u64 last_psi_total;
+
 	};
+/* private: */
+	/* List head for siblings. */
 	struct list_head list;
 };
 
_

Patches currently in -mm which might be from sj@kernel.org are


