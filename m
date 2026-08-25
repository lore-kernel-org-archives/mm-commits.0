Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6086834BA24
	for <mm-commits@vger.kernel.org>; Tue, 25 Aug 2026 01:54:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787622858; cv=none; b=OASeqGSmuyQywflmDkAdZz1TFmwj9B8AD1P1neGu/HLn7TZEqqU+Oztd+Gurw0ld51/XXabgMgZPkZUC6N4a+aCxUDRjGPnG7ueRW8Mk7+mj2NKTIb36DZyXjoMTD5cil6+Wjor9iRiG9AJRT+jcbE62p2LLspa28G+89PU7BpQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787622858; c=relaxed/simple;
	bh=852bx8TAHrokrpMtqURuBgWcqqURZFF9sEUA1QE/BLM=;
	h=Date:To:From:Subject:Message-Id; b=eRFk7WIfS/bL2EUTgDNctVA0v5v3xwijrrlCApyPyZr5D+ay3GxqyerXmwshNhlAbd8lEtmBBmDCjQ73eCUPlaquEP5QtV4JQHAH/phH6h812T9Hdo3uaxV+hwqoxSfrG968DpMyO3Kg8eLaU0rVertf0fPvi86O+snLSkAaTCY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=JJcFT4rE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="JJcFT4rE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 372961F00A3A;
	Tue, 25 Aug 2026 01:54:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787622857;
	bh=RWpPVjWEoQPuBXgkE7GS5SZzwTjLj4iqJxby0YP9xF8=;
	h=Date:To:From:Subject;
	b=JJcFT4rEehb6y/6+eMq/CiPe05HGuHj7oh0A3O3tvwUFJ5vSYmEpAgWxXeLWHD+ny
	 ZpkOT1yl/P817OzqMtw9LjSDbwCEBvvm07ukBgfZFb0ndIlnXSNlvwJJBwe4nsKw3e
	 u575Q0p48SaBeRJk0fT+fFZD4ZeI1ZxERSpbEcR4=
Date: Mon, 24 Aug 2026 18:54:16 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,surenb@google.com,mhocko@suse.com,jhubbard@nvidia.com,hannes@cmpxchg.org,akpm@linux-foundation.org,liuye@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-debug_page_alloc-fix-null-buf-in-debug_guardpage_minorder_setup.patch removed from -mm tree
Message-Id: <20260825015417.372961F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: debug_page_alloc: fix NULL buf in debug_guardpage_minorder_setup
has been removed from the -mm tree.  Its filename was
     mm-debug_page_alloc-fix-null-buf-in-debug_guardpage_minorder_setup.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ye Liu <liuye@kylinos.cn>
Subject: mm: debug_page_alloc: fix NULL buf in debug_guardpage_minorder_setup
Date: Thu, 6 Aug 2026 08:45:55 +0800

If the kernel command line includes "debug_guardpage_minorder" without an
equals sign (i.e., no value is provided), the early parameter parser
passes a NULL buf pointer to the setup function.

kstrtouint() does not perform a NULL check on its input and calls directly
into kstrtoull() which dereferences s[0] unconditionally, leading to a
NULL pointer dereference and early boot crash.

Additionally, the error path's pr_err("%s", buf) would also crash with a
NULL format argument.

Link: https://lore.kernel.org/20260806004556.2633049-1-ye.liu@linux.dev
Fixes: c0a32fc5a2e4 ("mm: more intensive memory corruption debugging")
Signed-off-by: Ye Liu <liuye@kylinos.cn>
Acked-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: John Hubbard <jhubbard@nvidia.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/debug_page_alloc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/debug_page_alloc.c~mm-debug_page_alloc-fix-null-buf-in-debug_guardpage_minorder_setup
+++ a/mm/debug_page_alloc.c
@@ -22,8 +22,8 @@ static int __init debug_guardpage_minord
 {
 	unsigned int res;
 
-	if (kstrtouint(buf, 10, &res) < 0 ||  res > MAX_PAGE_ORDER / 2) {
-		pr_err("Bad debug_guardpage_minorder value: %s\n", buf);
+	if (!buf || kstrtouint(buf, 10, &res) < 0 || res > MAX_PAGE_ORDER / 2) {
+		pr_err("Bad debug_guardpage_minorder value: %s\n", buf ?: "(missing)");
 		return 0;
 	}
 	_debug_guardpage_minorder = res;
_

Patches currently in -mm which might be from liuye@kylinos.cn are


