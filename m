Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0854031715A
	for <mm-commits@vger.kernel.org>; Fri, 31 Jul 2026 02:41:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785465699; cv=none; b=O6kUPlvVHoe2ncSiE5yh5SGnR5tDhcDRgn9ox1pitfaN+/Nv4ytt+8lnZTJLWdgFyB641j748OUFodkczawLP7rC2O8JRV1Lc6+FxeFAltq7l+tSbtL70MLfqLY4k+oTQ5BdYI9wBL3lytEO76nlUfQma1EDh5UdR83g4BwkaS4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785465699; c=relaxed/simple;
	bh=xaMgrcW7Me8IIO/OBQPef2x7OGzHQZJEW4Z8NQc9F2Y=;
	h=Date:To:From:Subject:Message-Id; b=t3FOYcV1H+outfJOKGbokbBP1zBgumhk89mm8cl+VIbjtheHdZ2BIYCfXaKvaPR65q814gqub0Cp6d0bPUfZwQIRWMTbt5gWB0kImkKyBK7rhCHC0craFz5RmlfjJk7zFBVDhUXfPorXSJHkKyWeO4zHzZHQuC2pHUObIxxQO6I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1hKiev0T; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1hKiev0T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5C771F00A3A;
	Fri, 31 Jul 2026 02:41:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785465697;
	bh=OgWSKbweazGi+UU9mrm2Yo/xdBmYX4EAJCYJaLMaZ3M=;
	h=Date:To:From:Subject;
	b=1hKiev0T8Li7zccxulypvw3vVZ66vq0mQKik62zIrHSY12R1aaguecj9wK9jhBL5h
	 lVH/CzYLKStqCp4NqtF1bRpcULhW4lk9DADGXfdNG+Rr842wtuCKKxcsnJTzd57amN
	 wHzc9ZTlMQqDRl3zB5ByEgAIAGG2V7jyvQ3IyEWI=
Date: Thu, 30 Jul 2026 19:41:37 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,skhan@linuxfoundation.org,sj@kernel.org,saileshnandanavanam@gmail.com,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,gutierrez.asier@huawei-partners.com,doehyunbaek@gmail.com,david@kernel.org,corbet@lwn.net,brendan.higgins@linux.dev,akinobu.mita@gmail.com,plafer@proton.me,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-stat-use-secs_to_jiffies-instead-of-msecs_to_jiffies.patch removed from -mm tree
Message-Id: <20260731024137.A5C771F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/stat: use secs_to_jiffies() instead of msecs_to_jiffies()
has been removed from the -mm tree.  Its filename was
     mm-damon-stat-use-secs_to_jiffies-instead-of-msecs_to_jiffies.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Philippe Laferriere <plafer@proton.me>
Subject: mm/damon/stat: use secs_to_jiffies() instead of msecs_to_jiffies()
Date: Mon, 29 Jun 2026 07:55:33 -0700

The conversion of a duration expressed in seconds reads as
msecs_to_jiffies(5 * MSEC_PER_SEC), which obscures the intent and
needlessly goes through milliseconds.  Use the dedicated secs_to_jiffies()
helper, which expresses the 5-second refresh interval directly.  No
functional change.

Found using Coccinelle (scripts/coccinelle/misc/secs_to_jiffies.cocci).

Link: https://lore.kernel.org/20260629145538.134832-3-sj@kernel.org
Signed-off-by: Philippe Laferriere <plafer@proton.me>
Signed-off-by: SJ Park <sj@kernel.org>
Reviewed-by: SJ Park <sj@kernel.org>
Cc: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Asier Gutierrez <gutierrez.asier@huawei-partners.com>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: David Hildenbrand <david@kernel.org>
Cc: Doehyun Baek <doehyunbaek@gmail.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: "Liam R. Howlett" <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Sailesh Nandanavanam <saileshnandanavanam@gmail.com>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/stat.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/damon/stat.c~mm-damon-stat-use-secs_to_jiffies-instead-of-msecs_to_jiffies
+++ a/mm/damon/stat.c
@@ -138,7 +138,7 @@ static int damon_stat_damon_call_fn(void
 
 	/* avoid unnecessarily frequent stat update */
 	if (time_before_eq(jiffies, damon_stat_last_refresh_jiffies +
-				msecs_to_jiffies(5 * MSEC_PER_SEC)))
+				secs_to_jiffies(5)))
 		return 0;
 	damon_stat_last_refresh_jiffies = jiffies;
 
_

Patches currently in -mm which might be from plafer@proton.me are


