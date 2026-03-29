Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A7AB19D093
	for <mm-commits@vger.kernel.org>; Sun, 29 Mar 2026 00:41:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774744870; cv=none; b=l6eoIfHdJ/WVaBuP6jx7MY/Phi5cMAUzdoQaXESbhnvBGxOFVytbIhdbbsWevx10fu8ecwp7s94p9gdqxYgsdbLi3TseyKUmNwBkYyrNdmwJV5t3W21MATseciFRv/DZuP2FWbwTVlU28K/nCY5ga7hiazu5Elv8o9I9UPLjfGg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774744870; c=relaxed/simple;
	bh=10QgPuUb41K0tziZ4iirzsduXlB7nwRJ8XcE5V/VDNc=;
	h=Date:To:From:Subject:Message-Id; b=iT1monx1oG8JMNuLJy29fdwofcFd9BVp7dRBmvnwQDAuELwc/87KuxzDijE2B719Ddc3P3BsO9iV7faL6bBD+Rn9tjbFwRyaXBoDc12c4nKLjkB2vnaV14v+M/tYkF8UZQvNrp7oBc5Wny3LCjGrtkEAtws/ztubmPg2tBY6YM4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=YL/b3vVI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YL/b3vVI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73E26C4CEF7;
	Sun, 29 Mar 2026 00:41:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774744870;
	bh=10QgPuUb41K0tziZ4iirzsduXlB7nwRJ8XcE5V/VDNc=;
	h=Date:To:From:Subject:From;
	b=YL/b3vVINql3h06f63ZZfRK5URxPrkH15GJAYv5z3LvvOSUG02RHi34u3nA8scB3G
	 926cS/f4/zTMq4zCWC+LePp/EyYEHYEMWfVP35FsiGWUQPJ6AYudiHT942mgMFRJ+W
	 7gwuCr7uIj5iaTaesT6L1yMXYtcqP/jgsTHmQI5c=
Date: Sat, 28 Mar 2026 17:41:09 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] docs-mm-damon-design-document-the-goal-based-quota-tuner-selections.patch removed from -mm tree
Message-Id: <20260329004110.73E26C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: Docs/mm/damon/design: document the goal-based quota tuner selections
has been removed from the -mm tree.  Its filename was
     docs-mm-damon-design-document-the-goal-based-quota-tuner-selections.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: Docs/mm/damon/design: document the goal-based quota tuner selections
Date: Mon, 9 Mar 2026 18:05:21 -0700

Update the design document for the newly added goal-based quota tuner
selection feature.

Link: https://lkml.kernel.org/r/20260310010529.91162-6-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/mm/damon/design.rst |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/Documentation/mm/damon/design.rst~docs-mm-damon-design-document-the-goal-based-quota-tuner-selections
+++ a/Documentation/mm/damon/design.rst
@@ -566,6 +566,18 @@ aggressiveness (the quota) of the corres
 is under achieving the goal, DAMOS automatically increases the quota.  If DAMOS
 is over achieving the goal, it decreases the quota.
 
+There are two such tuning algorithms that users can select as they need.
+
+- ``consist``: A proportional feedback loop based algorithm.  Tries to find an
+  optimum quota that should be consistently kept, to keep achieving the goal.
+  Useful for kernel-only operation on dynamic and long-running environments.
+  This is the default selection.  If unsure, use this.
+- ``temporal``: More straightforward algorithm.  Tries to achieve the goal as
+  fast as possible, using maximum allowed quota, but only for a temporal short
+  time.  When the quota is under-achieved, this algorithm keeps tuning quota to
+  a maximum allowed one.  Once the quota is [over]-achieved, this sets the
+  quota zero.  Useful for deterministic control required environments.
+
 The goal can be specified with five parameters, namely ``target_metric``,
 ``target_value``, ``current_value``, ``nid`` and ``path``.  The auto-tuning
 mechanism tries to make ``current_value`` of ``target_metric`` be same to
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-sysfs-dealloc-repeat_call_control-if-damon_call-fails.patch

