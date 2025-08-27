Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E20C2882A8
	for <mm-commits@vger.kernel.org>; Wed, 27 Aug 2025 02:52:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756263138; cv=none; b=pUZHBfw1uxIdRQQ5XVE+j+snNvJQcTi38ADHQVz3nFr/XtR9c5Q2Tk/zpklcXRhCCQ9bTAQPrbqEplnzf/otp20+xk7k4YOfwJ1oMsfj3eMqMEiDLuG5nsxsKUOIMvKCovhzbNWowc7HieUWAQ5a1Nnsir0/HzICY8tcBQilIiU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756263138; c=relaxed/simple;
	bh=jX7zgLO+EXlRhihy24HiyM8n02rWTGak9WyJYB7TivQ=;
	h=Date:To:From:Subject:Message-Id; b=a3Eg4LQXGjrDP0TmVjZclndRx5k/DzQKi/2rEkBm51Py7K8q655Z3ALf6VTBPwlvWP0CbauOlF6OoJ2NH5e1+O1eqNALK/HNPVAYM8sNI9BYeCvwgt6bZARAut1dttANcrlTyyrL27p14IVzApkUWZpF5lt+XFusXTB+8xp2ih0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xBG5K9kk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xBG5K9kk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08A38C4CEF1;
	Wed, 27 Aug 2025 02:52:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1756263138;
	bh=jX7zgLO+EXlRhihy24HiyM8n02rWTGak9WyJYB7TivQ=;
	h=Date:To:From:Subject:From;
	b=xBG5K9kkW6djoShjDGSaJaW/0/apIS6oVPc25mwyNZjjl2J++SwSxmzV+b3l/S5KA
	 QWXVjxYC0R1fRmuzdRRbGFjWGWroHWut4psxAbzz9tM5lUWSPG9sFp0cZN5m+UMgzh
	 +RHcPsjOkGZDqgKkew708/t6ncHzJVUl2RqKmYnU=
Date: Tue, 26 Aug 2025 19:52:17 -0700
To: mm-commits@vger.kernel.org,hughd@google.com,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-shmem-use-folio-for-shmem_partial_swap_usage.patch added to mm-new branch
Message-Id: <20250827025218.08A38C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: shmem: use 'folio' for shmem_partial_swap_usage()
has been added to the -mm mm-new branch.  Its filename is
     mm-shmem-use-folio-for-shmem_partial_swap_usage.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-shmem-use-folio-for-shmem_partial_swap_usage.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: mm: shmem: use 'folio' for shmem_partial_swap_usage()
Date: Tue, 26 Aug 2025 17:35:54 +0800

It is more straightforward to use the term `folio'. No functional changes.

Link: https://lkml.kernel.org/r/a2d39608d99cba1130cacd9cffbafc6949193c08.1756200587.git.baolin.wang@linux.alibaba.com
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/mm/shmem.c~mm-shmem-use-folio-for-shmem_partial_swap_usage
+++ a/mm/shmem.c
@@ -1006,15 +1006,15 @@ unsigned long shmem_partial_swap_usage(s
 						pgoff_t start, pgoff_t end)
 {
 	XA_STATE(xas, &mapping->i_pages, start);
-	struct page *page;
+	struct folio *folio;
 	unsigned long swapped = 0;
 	unsigned long max = end - 1;
 
 	rcu_read_lock();
-	xas_for_each(&xas, page, max) {
-		if (xas_retry(&xas, page))
+	xas_for_each(&xas, folio, max) {
+		if (xas_retry(&xas, folio))
 			continue;
-		if (xa_is_value(page))
+		if (xa_is_value(folio))
 			swapped += 1 << xas_get_order(&xas);
 		if (xas.xa_index == max)
 			break;
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are

mm-shmem-use-folio-for-shmem_partial_swap_usage.patch
mm-shmem-drop-the-unnecessary-folio_nr_pages.patch

