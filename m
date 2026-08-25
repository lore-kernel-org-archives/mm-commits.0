Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 444B725B098
	for <mm-commits@vger.kernel.org>; Tue, 25 Aug 2026 01:54:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787622847; cv=none; b=Kfws/KawoF1emObBBfKX6LX8rqrl3umCogdK54+aA07TR4td7n3UuQNxLUwa6ZFuwavER99V7S+TWYGpGq8LxZagH73ODpFJ+2eXpJu2VfoUSIBFsFT7xZmoUYRIngOljPWYkoAytKyn5CQw+Irze73zFmg18rvUiA+sHpsghhY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787622847; c=relaxed/simple;
	bh=CocjphDXfegypJRudqjFQ6y3zH5eawqCB3DUxY/SFmQ=;
	h=Date:To:From:Subject:Message-Id; b=PyTJnyprmY1V+N/qP3Nr3pqkfuhIdBNMImr7sqRU8Mgfel8m5dzS7OLhi9avEZLvauQyfw80AahAbLwRh+31YAwCV38IJy++1CUErFWF7pDwlSfg2P7K6QWmXAN0f/nC5v25LfmqNL+nrxDOmtB949kTL5GVTDdI+vTciJD4ffU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=14Nlg5mL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="14Nlg5mL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDB521F000E9;
	Tue, 25 Aug 2026 01:54:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787622844;
	bh=nnHq4+OOc+iY9Q7Mysn5XNDBymdm1pH9h4UT1h7/9Y4=;
	h=Date:To:From:Subject;
	b=14Nlg5mL6BujUsoNB5xfSl+pKlowqc/XLn3QyLoGMWnjUCgjNb2WPJ0X79E7iB9Qh
	 BLkT7wAfTMmAbYoNcrbijXCpdgDA/OynwRDwuunj2qdxyGkn6qwVVHrhsuqmW4E1ZD
	 Fp1WleaDUxquaD67CLvH5E/XC5Li1MhC+Ucr1jTU=
Date: Mon, 24 Aug 2026 18:54:03 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,surenb@google.com,mhocko@suse.com,hannes@cmpxchg.org,akpm@linux-foundation.org,liuye@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-debug_page_alloc-fix-type-mismatch-for-debug_guardpage_minorder.patch removed from -mm tree
Message-Id: <20260825015403.DDB521F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: debug_page_alloc: fix type mismatch for debug_guardpage_minorder
has been removed from the -mm tree.  Its filename was
     mm-debug_page_alloc-fix-type-mismatch-for-debug_guardpage_minorder.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ye Liu <liuye@kylinos.cn>
Subject: mm: debug_page_alloc: fix type mismatch for debug_guardpage_minorder
Date: Wed, 5 Aug 2026 17:31:07 +0800

The debug_guardpage_minorder local variable is declared as unsigned int,
but debug_guardpage_minorder_setup() uses unsigned long and kstrtoul() to
parse the value.

Use kstrtouint() with unsigned int local variable to match the actual type
of _debug_guardpage_minorder.  Also fix the format specifier from %lu to
%u accordingly.

Link: https://lore.kernel.org/20260805093108.2352900-1-ye.liu@linux.dev
Signed-off-by: Ye Liu <liuye@kylinos.cn>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/debug_page_alloc.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/debug_page_alloc.c~mm-debug_page_alloc-fix-type-mismatch-for-debug_guardpage_minorder
+++ a/mm/debug_page_alloc.c
@@ -20,14 +20,14 @@ early_param("debug_pagealloc", early_deb
 
 static int __init debug_guardpage_minorder_setup(char *buf)
 {
-	unsigned long res;
+	unsigned int res;
 
-	if (kstrtoul(buf, 10, &res) < 0 ||  res > MAX_PAGE_ORDER / 2) {
+	if (kstrtouint(buf, 10, &res) < 0 ||  res > MAX_PAGE_ORDER / 2) {
 		pr_err("Bad debug_guardpage_minorder value: %s\n", buf);
 		return 0;
 	}
 	_debug_guardpage_minorder = res;
-	pr_info("Setting debug_guardpage_minorder to %lu\n", res);
+	pr_info("Setting debug_guardpage_minorder to %u\n", res);
 	return 0;
 }
 early_param("debug_guardpage_minorder", debug_guardpage_minorder_setup);
_

Patches currently in -mm which might be from liuye@kylinos.cn are


