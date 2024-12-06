Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EB2A1925AD;
	Fri,  6 Dec 2024 03:55:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733457331; cv=none; b=KVEUKGqChbFYnWkq5n4428bOqu2LSOINKcB0oKDo0dxbfhYW3gVmbO7eTE3p9yGO3Ug36whPaQfBqaAyqvA0YxbfU1FhVGSqgOyqV+IJM28RgMCZCfdJ/gVxiR25G9bN40uTsj70jMq7Ro9lqEn11hH9y+f4Byz2ee+FUMejjVg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733457331; c=relaxed/simple;
	bh=undpJr0uf9zK2ZhFWj8IX1JsuZfiL69D2nr2WCzb1w0=;
	h=Date:To:From:Subject:Message-Id; b=BjunppbDbBlxgbNhuzXQxJTsUcOfw2CtXEdEn2U4UtbI0AozhwmKIFMQ+kfv/o9b8XyXr3oPengJiv8qQL75ZHvQRjJ3ympdv+ITIpbcMzshYLhY1F3q1rN7+cYmRUZ+JdWaQcidVtncP5PqZ2yg+CKQ617YRyUmA2HEvT84x2o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=p8/QgNYQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="p8/QgNYQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34583C4CED1;
	Fri,  6 Dec 2024 03:55:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1733457331;
	bh=undpJr0uf9zK2ZhFWj8IX1JsuZfiL69D2nr2WCzb1w0=;
	h=Date:To:From:Subject:From;
	b=p8/QgNYQXzVSdc9ojJq3nAD6Qt6M9qX5Z/3ODdUNww241YfbYiaO391B5OvxpGS8e
	 ESHrc8xnhvpaNh9V1L6X24g/sTNctlsDNeixxLoqLmGbUjtFQtEYu6S/HalReK/WFP
	 BOsIEYCIadx80Qk2CqPgB58Gy7M7RWonIXKPDfEU=
Date: Thu, 05 Dec 2024 19:55:30 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,shakeel.butt@linux.dev,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,hannes@cmpxchg.org,jsperbeck@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-memcg-declare-do_memsw_account-inline.patch removed from -mm tree
Message-Id: <20241206035531.34583C4CED1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: memcg: declare do_memsw_account inline
has been removed from the -mm tree.  Its filename was
     mm-memcg-declare-do_memsw_account-inline.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: John Sperbeck <jsperbeck@google.com>
Subject: mm: memcg: declare do_memsw_account inline
Date: Thu, 28 Nov 2024 12:39:59 -0800

In commit 66d60c428b23 ("mm: memcg: move legacy memcg event code into
memcontrol-v1.c"), the static do_memsw_account() function was moved from a
.c file to a .h file.  Unfortunately, the traditional inline keyword
wasn't added.  If a file (e.g., a unit test) includes the .h file, but
doesn't refer to do_memsw_account(), it will get a warning like:

mm/memcontrol-v1.h:41:13: warning: unused function 'do_memsw_account' [-Wunused-function]
   41 | static bool do_memsw_account(void)
      |             ^~~~~~~~~~~~~~~~

Link: https://lkml.kernel.org/r/20241128203959.726527-1-jsperbeck@google.com
Fixes: 66d60c428b23 ("mm: memcg: move legacy memcg event code into memcontrol-v1.c")
Signed-off-by: John Sperbeck <jsperbeck@google.com>
Acked-by: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol-v1.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memcontrol-v1.h~mm-memcg-declare-do_memsw_account-inline
+++ a/mm/memcontrol-v1.h
@@ -38,7 +38,7 @@ void mem_cgroup_id_put_many(struct mem_c
 	     iter = mem_cgroup_iter(NULL, iter, NULL))
 
 /* Whether legacy memory+swap accounting is active */
-static bool do_memsw_account(void)
+static inline bool do_memsw_account(void)
 {
 	return !cgroup_subsys_on_dfl(memory_cgrp_subsys);
 }
_

Patches currently in -mm which might be from jsperbeck@google.com are


