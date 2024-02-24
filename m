Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF1C879F4
	for <mm-commits@vger.kernel.org>; Sat, 24 Feb 2024 01:50:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708739425; cv=none; b=fRACNA9dbYFlk6kun08NlBnBy0ladnJtLqCvGLp6+2G6JBWzHo1DYVHLTcocOjrXJmTlFOVPT/DLA8WJ72jggZq3SPf3zPZEHN79LVYfJ7qg9BlERYB3yqFC/ehcL3dIQxDTvNqYRgJEJJKq/ixix7Sg/VyB6Dn8UwJ+vECBGjY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708739425; c=relaxed/simple;
	bh=2sSTFv42jp0qU2XFrP8iAga/5poEuPdl6WV0Ncdlwyc=;
	h=Date:To:From:Subject:Message-Id; b=Q1QeBqqpLB2ON6sm6MXJYncB0RubvxV0RRnHm9wdD2D431iLiQ8mhLUDMWdpla82Lnv7w3aj9SA8QRPinyCBhTtl8NV+7kqHSx4jaTPvX2jSi/XlsGFGy56WehX/yUP1WqR52R5gAAlz3/8To2TpM20vAcxDz7idTWtqznFWqcM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=eeQheTg8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="eeQheTg8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B34EBC43390;
	Sat, 24 Feb 2024 01:50:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708739424;
	bh=2sSTFv42jp0qU2XFrP8iAga/5poEuPdl6WV0Ncdlwyc=;
	h=Date:To:From:Subject:From;
	b=eeQheTg8dp4g/PO2c54F+Z6xV5w3MPwZP1JnEDBiHOLW4/8mHhcUySQA/QkSjDEBO
	 Y3+uuPy3tD5g8hwJFqARs+NBLJqy1xphF8OORPwnlhTvu2q787Az27/4TwDMPu6ftj
	 XvRboOZ3rVdjvqL8t4Jg3Ovo03D1K+uIsiOUWW18=
Date: Fri, 23 Feb 2024 17:50:24 -0800
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] docs-mm-damon-design-document-quota-goal-self-tuning.patch removed from -mm tree
Message-Id: <20240224015024.B34EBC43390@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: Docs/mm/damon/design: document quota goal self-tuning
has been removed from the -mm tree.  Its filename was
     docs-mm-damon-design-document-quota-goal-self-tuning.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: Docs/mm/damon/design: document quota goal self-tuning
Date: Mon, 19 Feb 2024 11:44:26 -0800

Update DAMON design doc to explain the quota goal self-tuning, which can
be used by setting the goal's metric to metrics that kernel can
self-retrieve.

Link: https://lkml.kernel.org/r/20240219194431.159606-16-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/mm/damon/design.rst |   20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

--- a/Documentation/mm/damon/design.rst~docs-mm-damon-design-document-quota-goal-self-tuning
+++ a/Documentation/mm/damon/design.rst
@@ -398,12 +398,28 @@ Aim-oriented Feedback-driven Auto-tuning
 ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
 
 Automatic feedback-driven quota tuning.  Instead of setting the absolute quota
-value, users can repeatedly provide numbers representing how much of their goal
-for the scheme is achieved as feedback.  DAMOS then automatically tunes the
+value, users can specify the metric of their interest, and what target value
+they want the metric value to be.  DAMOS then automatically tunes the
 aggressiveness (the quota) of the corresponding scheme.  For example, if DAMOS
 is under achieving the goal, DAMOS automatically increases the quota.  If DAMOS
 is over achieving the goal, it decreases the quota.
 
+The goal can be specified with three parameters, namely ``target_metric``,
+``target_value``, and ``current_value``.  The auto-tuning mechanism tries to
+make ``current_value`` of ``target_metric`` be same to ``target_value``.
+Currently, two ``target_metric`` are provided.
+
+- ``user_input``: User-provided value.  Users could use any metric that they
+  has interest in for the value.  Use space main workload's latency or
+  throughput, system metrics like free memory ratio or memory pressure stall
+  time (PSI) could be examples.  Note that users should explicitly set
+  ``current_value`` on their own in this case.  In other words, users should
+  repeatedly provide the feedback.
+- ``some_mem_psi_us``: System-wide ``some`` memory pressure stall information
+  in microseconds that measured from last quota reset to next quota reset.
+  DAMOS does the measurement on its own, so only ``target_value`` need to be
+  set by users at the initial time.  In other words, DAMOS does self-feedback.
+
 
 .. _damon_design_damos_watermarks:
 
_

Patches currently in -mm which might be from sj@kernel.org are


