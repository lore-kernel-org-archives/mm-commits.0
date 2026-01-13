Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1486330C637;
	Tue, 13 Jan 2026 05:09:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768280970; cv=none; b=Lf0RUDc6NwoQGCRFJoEmZsPcm8EAIENHcvq8Fe9hs2wkkCZH8CMMyNuu4lFfNkqN8ZpFyheL40wnLFcSZvd6hGZL5QpM7LAjY5FQZUueLVGiqRTm14dikvrzooQgxpmANSvGxj9jECRJAsU9FY2fRNmDTP5SwdZ7CBsXmqjCAuQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768280970; c=relaxed/simple;
	bh=20nt1dsO+Cyr2P/ayy/Q1ymNCpH5GgLEDh10dmAvAnk=;
	h=Date:To:From:Subject:Message-Id; b=QumS7yqVJr1jjrZ74vG6SzpQqguMmfGIvMrw/EQhaHHDrl10UohqN5UGSYwHeM6BuA8vEGfOCEMfUQf+YFNy1hOCVFlLCgh70iSljZuObjoYijNhoSYIpyri8jVfbxzzEOGzQn1JTwOldiA3E20/+pzZJPXGruGiwWqvYS8rg7A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=RYJi/88j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="RYJi/88j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E04F1C116C6;
	Tue, 13 Jan 2026 05:09:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768280970;
	bh=20nt1dsO+Cyr2P/ayy/Q1ymNCpH5GgLEDh10dmAvAnk=;
	h=Date:To:From:Subject:From;
	b=RYJi/88jM0qChqOO+0nc/WvtJQw/8f4+rbJW9ww2CO7GRFL/J14T4ydeG7oOScwfS
	 P8cPu1bXY+VImuM029TIGf6Ir0xs6suMyQOyxG9OMR/WflWC3/3isyifNCzGGKjFu9
	 Rc0r88xwZ/4+20/xzuYiG5KVz12QBOBBAhsDz1ZI=
Date: Mon, 12 Jan 2026 21:09:29 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@suse.cz,surenb@google.com,stable@vger.kernel.org,mhocko@suse.com,jackmanb@google.com,hannes@cmpxchg.org,aboorvad@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-page_alloc-make-percpu_pagelist_high_fraction-reads-lock-free.patch removed from -mm tree
Message-Id: <20260113050929.E04F1C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/page_alloc: make percpu_pagelist_high_fraction reads lock-free
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-make-percpu_pagelist_high_fraction-reads-lock-free.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Aboorva Devarajan <aboorvad@linux.ibm.com>
Subject: mm/page_alloc: make percpu_pagelist_high_fraction reads lock-free
Date: Mon, 1 Dec 2025 11:30:09 +0530

When page isolation loops indefinitely during memory offline, reading
/proc/sys/vm/percpu_pagelist_high_fraction blocks on pcp_batch_high_lock,
causing hung task warnings.

Make procfs reads lock-free since percpu_pagelist_high_fraction is a
simple integer with naturally atomic reads, writers still serialize via
the mutex.

This prevents hung task warnings when reading the procfs file during
long-running memory offline operations.

[akpm@linux-foundation.org: add comment, per Michal]
  Link: https://lkml.kernel.org/r/aS_y9AuJQFydLEXo@tiehlicka
Link: https://lkml.kernel.org/r/20251201060009.1420792-1-aboorvad@linux.ibm.com
Signed-off-by: Aboorva Devarajan <aboorvad@linux.ibm.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Zi Yan <ziy@nvidia.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/mm/page_alloc.c~mm-page_alloc-make-percpu_pagelist_high_fraction-reads-lock-free
+++ a/mm/page_alloc.c
@@ -6667,11 +6667,19 @@ static int percpu_pagelist_high_fraction
 	int old_percpu_pagelist_high_fraction;
 	int ret;
 
+	/*
+	 * Avoid using pcp_batch_high_lock for reads as the value is read
+	 * atomically and a race with offlining is harmless.
+	 */
+
+	if (!write)
+		return proc_dointvec_minmax(table, write, buffer, length, ppos);
+
 	mutex_lock(&pcp_batch_high_lock);
 	old_percpu_pagelist_high_fraction = percpu_pagelist_high_fraction;
 
 	ret = proc_dointvec_minmax(table, write, buffer, length, ppos);
-	if (!write || ret < 0)
+	if (ret < 0)
 		goto out;
 
 	/* Sanity checking to avoid pcp imbalance */
_

Patches currently in -mm which might be from aboorvad@linux.ibm.com are


