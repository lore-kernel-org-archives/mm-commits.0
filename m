Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C26F714884C
	for <mm-commits@vger.kernel.org>; Sun, 20 Jul 2025 02:01:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752976901; cv=none; b=dJ0JRl2c50GD1ePUNH37QnE38VGEbqf8WhUCkz2gXtkskm0ewhoQ2AZOWeWK8vDz+m05kjDHTLFJBQouVsLGyCVd1gu+W2E87ioxiEI4qXTcu7T9rg8K082GS6prXAhWWLMtnn+Dar6x9B/HrNkJOxsx7/IKygpDs9+o8br0CE8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752976901; c=relaxed/simple;
	bh=WZhhySJZEfjRKjG61G6kGxgaVMO11A3uBc5nsN4ShhQ=;
	h=Date:To:From:Subject:Message-Id; b=OX3Jvq7DwOAMXrqjew/x04EOzejmAS58FR8J2tUrjRMtdyow3mSLvMBDnzJbGTIgAIzTQp2VKBooMlT91jQxPmCvXWF+qWj26yD9Oh/oU/g9eqIR/2Ae8NEINpoNswMJlSh7H/V0uObPfi2AD9cf5/Jwd1dWrNUH489Ste7f+Hk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=EQyp7Etu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="EQyp7Etu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94D8AC4CEE3;
	Sun, 20 Jul 2025 02:01:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752976901;
	bh=WZhhySJZEfjRKjG61G6kGxgaVMO11A3uBc5nsN4ShhQ=;
	h=Date:To:From:Subject:From;
	b=EQyp7Etu8Tg8xt4tT+n9BI+Vzl+OE9S7K2cCOVjPUC4VDYgE+pUnCxIocV9HApram
	 4v1NlWk5PQ9hUoHtEXb+D6N0hik9ySealtoJtNJVrQvBTh+GE0W/ydu0+sd6Ul3Vcw
	 yGDjKH/utugFEVw5KokcxK5ec3UTeYb/ADVii2Zg=
Date: Sat, 19 Jul 2025 19:01:41 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,ravis.opensrc@micron.com,corbet@lwn.net,bijantabatab@micron.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-core-commit-damos-migrate_dests.patch removed from -mm tree
Message-Id: <20250720020141.94D8AC4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/core: commit damos->migrate_dests
has been removed from the -mm tree.  Its filename was
     mm-damon-core-commit-damos-migrate_dests.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Bijan Tabatabai <bijantabatab@micron.com>
Subject: mm/damon/core: commit damos->migrate_dests
Date: Tue, 8 Jul 2025 19:59:37 -0500

When committing new scheme parameters from the sysfs, copy the
migrate_dests struct of the source schemes into the destination schemes.

Link: https://lkml.kernel.org/r/20250709005952.17776-8-bijan311@gmail.com
Signed-off-by: Bijan Tabatabai <bijantabatab@micron.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Ravi Shankar Jonnalagadda <ravis.opensrc@micron.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core.c |   39 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 39 insertions(+)

--- a/mm/damon/core.c~mm-damon-core-commit-damos-migrate_dests
+++ a/mm/damon/core.c
@@ -943,6 +943,41 @@ static void damos_set_filters_default_re
 		damos_filters_default_reject(&s->ops_filters);
 }
 
+static int damos_commit_dests(struct damos *dst, struct damos *src)
+{
+	struct damos_migrate_dests *dst_dests, *src_dests;
+
+	dst_dests = &dst->migrate_dests;
+	src_dests = &src->migrate_dests;
+
+	if (dst_dests->nr_dests != src_dests->nr_dests) {
+		kfree(dst_dests->node_id_arr);
+		kfree(dst_dests->weight_arr);
+
+		dst_dests->node_id_arr = kmalloc_array(src_dests->nr_dests,
+			sizeof(*dst_dests->node_id_arr), GFP_KERNEL);
+		if (!dst_dests->node_id_arr) {
+			dst_dests->weight_arr = NULL;
+			return -ENOMEM;
+		}
+
+		dst_dests->weight_arr = kmalloc_array(src_dests->nr_dests,
+			sizeof(*dst_dests->weight_arr), GFP_KERNEL);
+		if (!dst_dests->weight_arr) {
+			/* ->node_id_arr will be freed by scheme destruction */
+			return -ENOMEM;
+		}
+	}
+
+	dst_dests->nr_dests = src_dests->nr_dests;
+	for (int i = 0; i < src_dests->nr_dests; i++) {
+		dst_dests->node_id_arr[i] = src_dests->node_id_arr[i];
+		dst_dests->weight_arr[i] = src_dests->weight_arr[i];
+	}
+
+	return 0;
+}
+
 static int damos_commit_filters(struct damos *dst, struct damos *src)
 {
 	int err;
@@ -984,6 +1019,10 @@ static int damos_commit(struct damos *ds
 	dst->wmarks = src->wmarks;
 	dst->target_nid = src->target_nid;
 
+	err = damos_commit_dests(dst, src);
+	if (err)
+		return err;
+
 	err = damos_commit_filters(dst, src);
 	return err;
 }
_

Patches currently in -mm which might be from bijantabatab@micron.com are


