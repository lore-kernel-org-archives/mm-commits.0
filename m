Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 590053C1D40
	for <mm-commits@vger.kernel.org>; Fri,  7 Aug 2026 02:01:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786068075; cv=none; b=e7hO9yqQigWaPw4a7QxUFAqjGj2tT1kWZSBeltN1fW1IEfu+90r+vsQ18hCR4yed4XzmKa7/9PwRLlGVfjoNojIyTQF5i0YvF2Q1DTrkjFzT8WCzySH8xOfsgtI/gdZK7dRFifLRAxLmrgRZKg0MAEjQcuLy6H9zdZdf+GvZ2v4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786068075; c=relaxed/simple;
	bh=PHuatEUWE5yYL/E048c+me/Yb8tBUCCiO1pab23SxYY=;
	h=Date:To:From:Subject:Message-Id; b=JxNwjFd2dkuehgba3buwxkcJS1uQqZwWZNTAvgUlJBfMBX6jhD7tNTmeTRh4CELBSzJo8hTwLYHBy6f4IIYT2vRKJZaPNVf9gwkDk4CSmg4Eqzcr1ioro/YdauujxOW+r2ihrl/zUAbMIzMjJAaCZQk8FtfKuuao0ddIeFwY1fo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZojZqWqp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZojZqWqp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 257641F00AC4;
	Fri,  7 Aug 2026 02:01:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786068072;
	bh=/Q9S6uiLbszMKhsV3wKWHoQTvOBzju8Nm/kx0qJvHms=;
	h=Date:To:From:Subject;
	b=ZojZqWqp9lcHgoYNoSIrg0Lnp6sI2JXbHkVtDrVijp8RshgKzSFRuWfN07KlFp6G8
	 tlwS03ZdDUCsFlSg8u9LvVF4Tp4HtG2aPpnAF+E19F2GTTm5sO+QnNUsgqsJUffpHI
	 kHwzgmB4Z+Q+zF3FhqxgA9Y0c8ATRK4vN5VhrCTM=
Date: Thu, 06 Aug 2026 19:01:11 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-core-hide-core-private-damon_ctx-fields.patch removed from -mm tree
Message-Id: <20260807020112.257641F00AC4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/core: hide core-private damon_ctx fields
has been removed from the -mm tree.  Its filename was
     mm-damon-core-hide-core-private-damon_ctx-fields.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SJ Park <sj@kernel.org>
Subject: mm/damon/core: hide core-private damon_ctx fields
Date: Tue, 14 Jul 2026 07:35:43 -0700

'ops', 'probes', 'adaptive_targets', 'schemes', and 'rnd_state' fields of
damon_ctx are intended to be used by only the DAMON core layer.  However,
those are mistakenly not marked as private.  Mark as private.

Link: https://lore.kernel.org/20260714143544.101305-11-sj@kernel.org
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/damon.h |   15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

--- a/include/linux/damon.h~mm-damon-core-hide-core-private-damon_ctx-fields
+++ a/include/linux/damon.h
@@ -848,14 +848,9 @@ struct damon_attrs {
  * thread other than the kdamond should be made using safe DAMON APIs,
  * including damon_call() and damos_walk().
  *
- * @ops:	Set of monitoring operations for given use cases.
- * @probes:	Head of probes (&damon_probe) list.
  * @addr_unit:	Scale factor for core to ops address conversion.
  * @min_region_sz:	Minimum region size.
  * @pause:	Pause kdamond main loop.
- * @adaptive_targets:	Head of monitoring targets (&damon_target) list.
- * @schemes:		Head of schemes (&damos) list.
- * @rnd_state:	Per-ctx PRNG state for damon_rand().
  */
 struct damon_ctx {
 	struct damon_attrs attrs;
@@ -904,15 +899,21 @@ struct damon_ctx {
 	struct mutex kdamond_lock;
 
 /* public: */
-	struct damon_operations ops;
-	struct list_head probes;
 	unsigned long addr_unit;
 	unsigned long min_region_sz;
 	bool pause;
 
+/* private: */
+	/* Set of monitoring operations for given use cases. */
+	struct damon_operations ops;
+	/* Head of monitoring targets (&damon_target) list. */
 	struct list_head adaptive_targets;
+	/* Head of probes (&damon_probe) list. */
+	struct list_head probes;
+	/* Head of schemes (&damos) list. */
 	struct list_head schemes;
 
+	/* @rnd_state:	Per-ctx PRNG state for damon_rand(). */
 	struct rnd_state rnd_state;
 };
 
_

Patches currently in -mm which might be from sj@kernel.org are


