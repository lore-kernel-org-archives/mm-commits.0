Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE0B9282F18;
	Thu, 27 Aug 2026 05:02:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787806960; cv=none; b=iINA4iiTF3SiPnHapDndWRLjSehX7XmoZfkgzLvxwV8UHwdHfEuuNz6Er/GyazX3bdmMeMu2wOpW3xiOOgSbPPxGkFBJwwPqarl2f/iyq2bN+QcR00sX02ZHurOEQYZyfGJOUo8iAhSiGpKr9oAkk2UnqttZ1hGALQjtnhmpnLI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787806960; c=relaxed/simple;
	bh=Ej4CGjqUqytbGbQfJQxJNK7rkTwNAg0tKv8uNCJqoDo=;
	h=Date:To:From:Subject:Message-Id; b=TiuDtTLD/cH4XhP7zGVf/ThtPJo1pzgYo64xShhUFiZ8W8XamFI2J0KUIRFOcgu+WTl/aOVVq5kGpe6Dg+dGKgC1AFqqGZuy7R/5PmfFQR2DAkKp8/Ar6n7p7lRVNDuEqhSjTGtPgykRsy9k6XYsmholkLR5hGfHsBF0S3k4BiM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=hW4IwCM1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hW4IwCM1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 756161F00A3A;
	Thu, 27 Aug 2026 05:02:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787806958;
	bh=J2/kDQ8ug4iRS9oU35CJWlTITXHBkDIGvZZgnRveZEY=;
	h=Date:To:From:Subject;
	b=hW4IwCM1xAp8g+P7I1EcYM5pjMFew7D8gqs3ESePQ1SJElM0a/maojoFu8Ea4ydjK
	 5QRB0r5dlQouy5NWbhlB5mOalEiaJyY0NWWdraA/VAGA14M/X2P0Fb/DyD11mU/6Ob
	 /uUiDcTubPyo+DkIquoW+KZcnu/s1/7Cbsj2023I=
Date: Wed, 26 Aug 2026 22:02:38 -0700
To: mm-commits@vger.kernel.org,yanquanmin1@huawei.com,stable@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-damon-sysfs-set-next-refresh-jiffies-per-sysfs-context.patch removed from -mm tree
Message-Id: <20260827050238.756161F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/sysfs: set next refresh jiffies per sysfs context
has been removed from the -mm tree.  Its filename was
     mm-damon-sysfs-set-next-refresh-jiffies-per-sysfs-context.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: SJ Park <sj@kernel.org>
Subject: mm/damon/sysfs: set next refresh jiffies per sysfs context
Date: Wed, 26 Aug 2026 21:29:19 -0700

When 'refresh_ms' is set, DAMON sysfs interface periodically updates
auto-tuned parameters and DAMOS stats.  The timestamp for the next refresh
is initialized when a DAMON context starts, and updated in its
damon_call() callback function.  That is, each DAMON context updates it. 
However, the timestamp is a global variable that is shared with all the
contexts.  When there are multiple DAMON contexts having different
refresh_ms, the update frequency will be changed, depending on the order
of the contexts.  When there are multiple kdamonds, it will be even more
chaotic.  Fix the problem by having the timestamp per each context.

The user impact is not very critical.  It does not leak, corrupt or crash.
The update will not be faster or slower than the lowest and largest
refresh_ms values of the contexts, respectively.  The user can also
manually ask the updates on demand using kdamond state commands.  That
said, clearly this is a bug.

Link: https://lore.kernel.org/20260827042920.93580-3-sj@kernel.org
Fixes: 9fd7bb5083d1 ("mm/damon/sysfs: change next_update_jiffies to a global variable")
Signed-off-by: SJ Park <sj@kernel.org>
Cc: Quanmin Yan <yanquanmin1@huawei.com>
Cc: <stable@vger.kernel.org> # 6.18.x
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/sysfs.c |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

--- a/mm/damon/sysfs.c~mm-damon-sysfs-set-next-refresh-jiffies-per-sysfs-context
+++ a/mm/damon/sysfs.c
@@ -1789,6 +1789,7 @@ struct damon_sysfs_kdamond {
 	struct damon_sysfs_contexts *contexts;
 	struct damon_ctx *damon_ctx;
 	unsigned int refresh_ms;
+	unsigned long next_refresh_jiffies;
 };
 
 static struct damon_sysfs_kdamond *damon_sysfs_kdamond_alloc(void)
@@ -2215,17 +2216,15 @@ static struct damon_ctx *damon_sysfs_bui
 	return ctx;
 }
 
-static unsigned long damon_sysfs_next_update_jiffies;
-
 static int damon_sysfs_repeat_call_fn(void *data)
 {
 	struct damon_sysfs_kdamond *sysfs_kdamond = data;
 
 	if (!sysfs_kdamond->refresh_ms)
 		return 0;
-	if (time_before(jiffies, damon_sysfs_next_update_jiffies))
+	if (time_before(jiffies, sysfs_kdamond->next_refresh_jiffies))
 		return 0;
-	damon_sysfs_next_update_jiffies = jiffies +
+	sysfs_kdamond->next_refresh_jiffies = jiffies +
 		msecs_to_jiffies(sysfs_kdamond->refresh_ms);
 
 	if (!mutex_trylock(&damon_sysfs_lock))
@@ -2273,8 +2272,8 @@ static int damon_sysfs_turn_damon_on(str
 	}
 	kdamond->damon_ctx = ctx;
 
-	damon_sysfs_next_update_jiffies =
-		jiffies + msecs_to_jiffies(kdamond->refresh_ms);
+	kdamond->next_refresh_jiffies = jiffies +
+		msecs_to_jiffies(kdamond->refresh_ms);
 
 	repeat_call_control->fn = damon_sysfs_repeat_call_fn;
 	repeat_call_control->data = kdamond;
_

Patches currently in -mm which might be from sj@kernel.org are


