Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A64F1519B9;
	Thu, 21 Aug 2025 04:40:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755751255; cv=none; b=OMf0FKuRFpj8grcEzDX3UGZBqCEGiCQXdBFSlUAzThisnvW5+x7YpEzausRPM0Qcw18JktiFk7f/iEszuujAqFhQcDOWVwoE4uDNvyOAiLTNZVwPS9dVfKS3ENlxO7xNTBSpt3oVcZzZE5G7IQCIrYRbzxyQPCPOX9BCBX3BknI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755751255; c=relaxed/simple;
	bh=a07q5svi8/ILDF2QZwe4kNMXlAi+jdo0DbrF7I9Sub4=;
	h=Date:To:From:Subject:Message-Id; b=G8jiEBoE1WbPyclqBRlD6j9Y1yXgguPgHd+IiT+HcVmrjJuaJBGQTEYT4An4p+HZ9uJ99m+gOFDGynqXyu9I6HS0RzNVpwAA90nS+xFUf2iB5StowcYMlU0DLhxSfHgrdNSKfQl39LNiiuoybxTQeUIuVcrgQC5Wf1TCX/svfis=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=S6yxXzvU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="S6yxXzvU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E9E0C4CEF4;
	Thu, 21 Aug 2025 04:40:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1755751254;
	bh=a07q5svi8/ILDF2QZwe4kNMXlAi+jdo0DbrF7I9Sub4=;
	h=Date:To:From:Subject:From;
	b=S6yxXzvUaHVl4bAooLrYsKaEUehmmTre0gU0Sy96L0Pt4sMYKCmlZZTR+XnGcnU9g
	 0lsp6ClgI07h7y6M2rJE7XxhOS1d25u2rdfUj+7Qexs76aNMS04zPuVIKHP2gfFiTe
	 bqOajSvyiZC/Vu/tDjjze3BUiHwJ0Nvz9X3ne2s0=
Date: Wed, 20 Aug 2025 21:40:53 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,sj@kernel.org,ekffu200098@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-damon-core-set-quota-charged_from-to-jiffies-at-first-charge-window.patch removed from -mm tree
Message-Id: <20250821044054.7E9E0C4CEF4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/core: set quota->charged_from to jiffies at first charge window
has been removed from the -mm tree.  Its filename was
     mm-damon-core-set-quota-charged_from-to-jiffies-at-first-charge-window.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Sang-Heon Jeon <ekffu200098@gmail.com>
Subject: mm/damon/core: set quota->charged_from to jiffies at first charge window
Date: Wed, 20 Aug 2025 00:01:23 +0900

Kernel initializes "jiffies" timer as 5 minutes below zero, as shown in
include/linux/jiffies.h

/*
 * Have the 32 bit jiffies value wrap 5 minutes after boot
 * so jiffies wrap bugs show up earlier.
 */
 #define INITIAL_JIFFIES ((unsigned long)(unsigned int) (-300*HZ))

And they cast unsigned value to signed to cover wraparound

 #define time_after_eq(a,b) \
  (typecheck(unsigned long, a) && \
  typecheck(unsigned long, b) && \
  ((long)((a) - (b)) >= 0))

In 64bit systems, these might not be a problem because wrapround occurs
300 million years after the boot, assuming HZ value is 1000.

With same assuming, In 32bit system, wraparound occurs 5 minutues after
the initial boot and every 49 days after the first wraparound.  And about
25 days after first wraparound, it continues quota charging window up to
next 25 days.

Example 1: initial boot
jiffies=0xFFFB6C20, charged_from+interval=0x000003E8
time_after_eq(jiffies, charged_from+interval)=(long)0xFFFB6838; In
signed values, it is considered negative so it is false.

Example 2: after about 25 days first wraparound
jiffies=0x800004E8, charged_from+interval=0x000003E8
time_after_eq(jiffies, charged_from+interval)=(long)0x80000100; In
signed values, it is considered negative so it is false

So, change quota->charged_from to jiffies at damos_adjust_quota() when
it is consider first charge window.

In theory; but almost impossible; quota->total_charged_sz and
qutoa->charged_from should be both zero even if it is not in first
charge window. But It will only delay one reset_interval, So it is not
big problem.

Link: https://lkml.kernel.org/r/20250819150123.1532458-1-ekffu200098@gmail.com
Fixes: 2b8a248d5873 ("mm/damon/schemes: implement size quota for schemes application speed control")	[5.16]
Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/mm/damon/core.c~mm-damon-core-set-quota-charged_from-to-jiffies-at-first-charge-window
+++ a/mm/damon/core.c
@@ -2111,6 +2111,10 @@ static void damos_adjust_quota(struct da
 	if (!quota->ms && !quota->sz && list_empty(&quota->goals))
 		return;
 
+	/* First charge window */
+	if (!quota->total_charged_sz && !quota->charged_from)
+		quota->charged_from = jiffies;
+
 	/* New charge window starts */
 	if (time_after_eq(jiffies, quota->charged_from +
 				msecs_to_jiffies(quota->reset_interval))) {
_

Patches currently in -mm which might be from ekffu200098@gmail.com are

mm-damon-update-expired-description-of-damos_action.patch
docs-mm-damon-design-fix-typo-s-sz_trtied-sz_tried.patch
selftests-damon-test-no-op-commit-broke-damon-status.patch
selftests-damon-test-no-op-commit-broke-damon-status-fix.patch
mm-damon-tests-core-kunit-add-damos_commit_filter-test.patch

