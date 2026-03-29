Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D2632580E1
	for <mm-commits@vger.kernel.org>; Sun, 29 Mar 2026 00:41:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774744876; cv=none; b=G2NprW+CQzObhNS0JMlKihe73xQPdtO/0q0P9FwMjK2YjlAH0zVLFamt7IVfVlz0TUzgWpJqnwzHW7hq4gYz9ibE6n1+UQYMb7uqfRWqttka6HA5+FLVvEyyx7nTAHcIhbREIRNAOyw6fqC0eizfYTGhCHUnyfQoGzTLMmssMuE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774744876; c=relaxed/simple;
	bh=SWx9rXHX/UC6qbRxz5dF6jZsvKOIB7LRwv1A04/kD1E=;
	h=Date:To:From:Subject:Message-Id; b=XqJWntFZP6zzUEMkq5/DkbMbNmuSELoxdXPHkjAW6rfiA/qTKnBW9XEZJNWwN+jJSU90oDpShzszUSaIHVbQP7e5T/9G1R00E607X9QPCiPDLDSlQj0RtBB/gSR/Pkjfq4Fj9bcSk3VGFtC5lQ+quGl/o6+OrlK2xyW2vRAiPbU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=srCQn7Gu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="srCQn7Gu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06AAEC4CEF7;
	Sun, 29 Mar 2026 00:41:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774744876;
	bh=SWx9rXHX/UC6qbRxz5dF6jZsvKOIB7LRwv1A04/kD1E=;
	h=Date:To:From:Subject:From;
	b=srCQn7Gu+0cY2dTQXU5djLf5WgbfgFVQpKP3yM3f+f4+ddAN56v/JSGNqLNnv1Ete
	 aD4l16gWKMUl1eTqlEgiSbje0ENcdSeERuY3pA2MW9ZhVupQNMsjenEBB6elFXmOJE
	 P4T/pVhBMy/gyGH+Gk4MNxJbQQwmPlIKJymre2mQ=
Date: Sat, 28 Mar 2026 17:41:15 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-damon-drgn_dump_damon_status-support-quota-goal_tuner-dumping.patch removed from -mm tree
Message-Id: <20260329004116.06AAEC4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/damon/drgn_dump_damon_status: support quota goal_tuner dumping
has been removed from the -mm tree.  Its filename was
     selftests-damon-drgn_dump_damon_status-support-quota-goal_tuner-dumping.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: selftests/damon/drgn_dump_damon_status: support quota goal_tuner dumping
Date: Mon, 9 Mar 2026 18:05:26 -0700

Update drgn_dump_damon_status.py, which is being used to dump the
in-kernel DAMON status for tests, to dump goal_tuner setup status.

Link: https://lkml.kernel.org/r/20260310010529.91162-11-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/damon/drgn_dump_damon_status.py |    1 +
 1 file changed, 1 insertion(+)

--- a/tools/testing/selftests/damon/drgn_dump_damon_status.py~selftests-damon-drgn_dump_damon_status-support-quota-goal_tuner-dumping
+++ a/tools/testing/selftests/damon/drgn_dump_damon_status.py
@@ -110,6 +110,7 @@ def damos_quota_to_dict(quota):
         ['reset_interval', int],
         ['ms', int], ['sz', int],
         ['goals', damos_quota_goals_to_list],
+        ['goal_tuner', int],
         ['esz', int],
         ['weight_sz', int],
         ['weight_nr_accesses', int],
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-sysfs-dealloc-repeat_call_control-if-damon_call-fails.patch

