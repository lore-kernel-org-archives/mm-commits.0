Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8036F263F3C
	for <mm-commits@vger.kernel.org>; Wed, 21 May 2025 16:57:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747846652; cv=none; b=qTXuVWl9FJkKGBLHgDvoyxC6WJePBlxXcWXdBafhFnAPWnbnfEyQziYLZdJTAtUmLOT7bJGgeO0k+y1UQiWOzBUZ8oZfb+oxcPbLyDvTtC7JBH5EyydddC8EQblpwQKtxRa6fFkDYIuN5s/6RBdMMLgQenI1ozrfoboR/GzwgOg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747846652; c=relaxed/simple;
	bh=mk8J8tVyneHMEkNMU72eVyIYfnpUEt7qyuXVTduAbIs=;
	h=Date:To:From:Subject:Message-Id; b=qbaN78/GwX0v1jiTZ3hEwqpTbLA7PNIsgkaORRnqcgwk6p7BlU+Tf6SHnoMHyMFxMACXfGYRXpDuHg0yHIh6iCA1TC7K15kwuN0rLJiBVrjRnxTt45WUktjVsc89yFej9f6G6TZZ0VMaOT6KoVmyunlkWJH4zX8Sv9zuEkpAehs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Mgswjt+T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Mgswjt+T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51AC0C4CEE4;
	Wed, 21 May 2025 16:57:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747846652;
	bh=mk8J8tVyneHMEkNMU72eVyIYfnpUEt7qyuXVTduAbIs=;
	h=Date:To:From:Subject:From;
	b=Mgswjt+TkuIp2miRZ82Hx2xWHpKLq9t+WEqtqoiUt/ZelYK4rg9wlFdnIPfp9iIE8
	 MaRMQQBcESY4QQgu+Wcqxj78oSf+DqLReHLWdZLQ6S/Y2DEQSL2w5KWpdyk5LinM3+
	 LAaBKy5ycU67qy7SetMy4I5fMs26MzIciA5aWDZU=
Date: Wed, 21 May 2025 09:57:31 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,davidgow@google.com,corbet@lwn.net,brendan.higgins@linux.dev,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-paddr-remove-unused-variable-folio_list-in-damon_pa_stat.patch removed from -mm tree
Message-Id: <20250521165732.51AC0C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/paddr: remove unused variable, folio_list, in damon_pa_stat()
has been removed from the -mm tree.  Its filename was
     mm-damon-paddr-remove-unused-variable-folio_list-in-damon_pa_stat.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/paddr: remove unused variable, folio_list, in damon_pa_stat()
Date: Mon, 12 May 2025 17:27:12 -0700

Commit c0cb9d91bf297 ("mm/damon/paddr: report filter-passed bytes back for
DAMOS_STAT action") added unused variable in damon_pa_stat(), due to a
copy-and-paste error.  Remove it.

Link: https://lkml.kernel.org/r/20250513002715.40126-4-sj@kernel.org
Fixes: c0cb9d91bf29 ("mm/damon/paddr: report filter-passed bytes back for DAMOS_STAT action")
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: David Gow <davidgow@google.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/paddr.c |    1 -
 1 file changed, 1 deletion(-)

--- a/mm/damon/paddr.c~mm-damon-paddr-remove-unused-variable-folio_list-in-damon_pa_stat
+++ a/mm/damon/paddr.c
@@ -548,7 +548,6 @@ static unsigned long damon_pa_stat(struc
 		unsigned long *sz_filter_passed)
 {
 	unsigned long addr;
-	LIST_HEAD(folio_list);
 	struct folio *folio;
 
 	if (!damon_pa_scheme_has_filter(s))
_

Patches currently in -mm which might be from sj@kernel.org are


