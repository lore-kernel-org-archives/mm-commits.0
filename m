Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C034610F2
	for <mm-commits@vger.kernel.org>; Sun, 29 Mar 2026 00:40:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774744837; cv=none; b=Wsnc6oALBXc5mvoxMKhdDna+j74yC36LyPvQcL7xniDFr/Dj3eDpi5OpPoAdGQhVA9MDbAUq1r0nVI4Q3ad6pobc/vguw5KSi0MQqpW/3oomJoV7a6qJ2XGG7NpJtSRUGHeVbJrUOsqM1HJCmK+NLGJ14Cr8DeVSIJotmr83ETA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774744837; c=relaxed/simple;
	bh=J9HguCCHhmuIN8qPF7rdIfCrg+FDO6HFWIIyl2RvMcc=;
	h=Date:To:From:Subject:Message-Id; b=q80o/5W7S3v0Po3/8gjqVEFHP+Bsl6TQSh2JBhpjmTrfadOq+Oa1h4gCaQZrrgJqenlkIjxgbi46YYmaGyVRr4VjgbMH1ktLE26ZV34bGhaoPTDI/4TtBr7C+7hFu6XdviInU5PXreAgp713NRNC4hJ5YZCzcGKeJv0WhqkmD88=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=cGr56Pmw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="cGr56Pmw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FB40C4CEF7;
	Sun, 29 Mar 2026 00:40:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774744837;
	bh=J9HguCCHhmuIN8qPF7rdIfCrg+FDO6HFWIIyl2RvMcc=;
	h=Date:To:From:Subject:From;
	b=cGr56Pmwy4Y7HSOFlK9faSccabI/hdx4ab0cS9gnuwIXZDj1D6FiTmMwMTnzMcmNs
	 jMpEYQhBhJinFvREDD5EbaocTFS/WmXCxpgOJFSSWqoTLTNeGxGPc+QlTGNzM/W1fB
	 Tnns33n05NrRjzHvDEkQHVaeJt9BT1SMATp3QLQE=
Date: Sat, 28 Mar 2026 17:40:37 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,skhan@linuxfoundation.org,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,lianux.mm@gmail.com,liam.howlett@oracle.com,david@kernel.org,davidgow@google.com,corbet@lwn.net,brendan.higgins@linux.dev,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-core-clarify-damon_set_attrs-usages.patch removed from -mm tree
Message-Id: <20260329004037.8FB40C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/core: clarify damon_set_attrs() usages
has been removed from the -mm tree.  Its filename was
     mm-damon-core-clarify-damon_set_attrs-usages.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/core: clarify damon_set_attrs() usages
Date: Sat, 7 Mar 2026 11:53:51 -0800

damon_set_attrs() is called for multiple purposes from multiple places. 
Calling it in an unsafe context can make DAMON internal state polluted and
results in unexpected behaviors.  Clarify when it is safe, and where it is
being called.

Link: https://lkml.kernel.org/r/20260307195356.203753-4-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Acked-by: wang lian <lianux.mm@gmail.com>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: David Gow <davidgow@google.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

--- a/mm/damon/core.c~mm-damon-core-clarify-damon_set_attrs-usages
+++ a/mm/damon/core.c
@@ -751,8 +751,16 @@ static bool damon_valid_intervals_goal(s
  * @ctx:		monitoring context
  * @attrs:		monitoring attributes
  *
- * This function should be called while the kdamond is not running, an access
- * check results aggregation is not ongoing (e.g., from damon_call().
+ * This function updates monitoring results and next monitoring/damos operation
+ * schedules.  Because those are periodically updated by kdamond, this should
+ * be called from a safe contexts.  Such contexts include damon_ctx setup time
+ * while the kdamond is not yet started, and inside of kdamond_fn().
+ *
+ * In detail, all DAMON API callers directly call this function for initial
+ * setup of damon_ctx before calling damon_start().  Some of the API callers
+ * also indirectly call this function via damon_call() -> damon_commit() for
+ * online parameters updates.  Finally, kdamond_fn() itself use this for
+ * applying auto-tuned monitoring intervals.
  *
  * Every time interval is in micro-seconds.
  *
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-sysfs-dealloc-repeat_call_control-if-damon_call-fails.patch

