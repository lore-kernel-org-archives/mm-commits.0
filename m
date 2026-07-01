Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9A8E3B47F7
	for <mm-commits@vger.kernel.org>; Wed,  1 Jul 2026 23:57:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782950254; cv=none; b=o4+ZTaFS2m/YgImM4KEtxJ2wWLg3FdsQxOwaxdCWrLdyYiB6Co/t5QtEyPSFFuEJDMrBgG9u78MmNBwow5MkUFVW9J0mh7RzEI/eqSpa8077c7h/imaCjM+5HNO2uhykKupWtiDL6f+XSsSk78hYGIYe0cg+XWgedr3S1nKLz1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782950254; c=relaxed/simple;
	bh=2JWjNsQnTDDP/7tv4Y2o4oF3Ef3b+2WJTpCriRR2hf8=;
	h=Date:To:From:Subject:Message-Id; b=bBTmgQvx4wvsGdkrRmX3ICNQC41GdGIJdhlKNNms5e9r+stRAwDYDxTmUreAz2YTyNtOi0ZvLuOhON+xgeuL8KKiGhnhguAz0Fh2lLCnEz6aEWHeFS0WYOa5WAEm5mgnhj2KO4j4Wp5pKVi7NvXeB/LzUNPz+JatPhQZnBL8GSY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fVn7iAb8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fVn7iAb8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D4521F000E9;
	Wed,  1 Jul 2026 23:57:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782950249;
	bh=5Oh8J+7fY4NRVMyCM+g+hI9IiFk16SZSfNb2UCCu86s=;
	h=Date:To:From:Subject;
	b=fVn7iAb8Rek5d7t1tzsN03KVvDUKox5f7Jy0L/7BpmprdZhfYh2B2QI6bGkZbb78v
	 2gu/3Ad2CZGfYE3H1iOpBZh8luou9+xf9/+CaFVt6fa7OExaHexMCpojWIi3sEo5CZ
	 1x6xVoVfilqjwCRwp3bRrLRGTI3TE5jUvKuVmNEw=
Date: Wed, 01 Jul 2026 16:57:28 -0700
To: mm-commits@vger.kernel.org,ye.liu@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-page_owner-add-missing-newline-to-count_threshold-format-string.patch removed from -mm tree
Message-Id: <20260701235729.4D4521F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/page_owner: add missing newline to count_threshold format string
has been removed from the -mm tree.  Its filename was
     mm-page_owner-add-missing-newline-to-count_threshold-format-string.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Ye Liu <ye.liu@linux.dev>
Subject: mm/page_owner: add missing newline to count_threshold format string
Date: Wed, 1 Jul 2026 09:22:31 +0800

The DEFINE_SIMPLE_ATTRIBUTE format string for page_owner_threshold_fops is
missing a trailing \n.  simple_attr_read() uses scnprintf() with the
format string, which does not append a newline, so reading
/sys/kernel/debug/page_owner_stacks/count_threshold produces output
without a terminating newline.  Add the missing \n to match the standard
debugfs attribute convention.

Link: https://lore.kernel.org/20260701012239.315262-6-ye.liu@linux.dev
Signed-off-by: Ye Liu <ye.liu@linux.dev>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_owner.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/page_owner.c~mm-page_owner-add-missing-newline-to-count_threshold-format-string
+++ a/mm/page_owner.c
@@ -974,7 +974,7 @@ static int page_owner_threshold_set(void
 }
 
 DEFINE_SIMPLE_ATTRIBUTE(page_owner_threshold_fops, &page_owner_threshold_get,
-			&page_owner_threshold_set, "%llu");
+			&page_owner_threshold_set, "%llu\n");
 
 
 static int __init pageowner_init(void)
_

Patches currently in -mm which might be from ye.liu@linux.dev are

mm-page_owner-move-free_ts_nsec-output-to-free-section-in-__dump_page_owner.patch
mm-page_owner-drop-redundant-page_owner-prefix-from-static-symbols.patch

