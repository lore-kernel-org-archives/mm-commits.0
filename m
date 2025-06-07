Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E2F21F4E4F
	for <mm-commits@vger.kernel.org>; Sat,  7 Jun 2025 23:08:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749337727; cv=none; b=sDI8N2/y6i5GwGyJQXgMEFlLdy1IFNIYrMfPs86iRQ9HkzttxmaYAWQzmNMqjS/5C8gr1+1UqPvNVA95hadbhGt5WpK2YnxQKlxYHa6RRfuxvF/vDmzn3Hwqaw/FrZY48Vw9RqYvDwxEKNQ82KF8fLMlr46mtW9Um1Xj6o5B2H0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749337727; c=relaxed/simple;
	bh=ghfK8x9tRozoSgSXhuOGitXEuTc6gcnHpUEC+bwe16g=;
	h=Date:To:From:Subject:Message-Id; b=Q3o9pwTvUxOWAyet+WtlYY5KrVrWU5huTD3kDjC6zQ8AXjm41vRrMnLfcduJKuXBjxdY3hdpkbzAZ3J5icB7NkHSzZybvDb8avHD2FTum0IkyeDMZcxt+EBQZ7gikQ0TCO9EWnJ9AYcuMb4qMEOYR9jiE/j1lX8t9PHo6+HWvD4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=H0Og6YID; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="H0Og6YID"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9727DC4CEE4;
	Sat,  7 Jun 2025 23:08:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1749337726;
	bh=ghfK8x9tRozoSgSXhuOGitXEuTc6gcnHpUEC+bwe16g=;
	h=Date:To:From:Subject:From;
	b=H0Og6YID87tNnf9YbTomSwU6J0vZ7aCvAwUUXuKJhe0AuV6UbQZlowZ+xYh++7Tr6
	 Qp+VUTkL5h9JeOwKILeEDxEjFOc4EmjWT0NO47bAS8lXWU1cQ8+5C4Y38D+Vgbepwd
	 IW7VkvGtEzXVm0SF1LpQAx7YxwVjB7O7HMWD7b/E=
Date: Sat, 07 Jun 2025 16:08:46 -0700
To: mm-commits@vger.kernel.org,david@redhat.com,lizhe.67@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + gup-optimize-longterm-pin_user_pages-for-large-folio-fix.patch added to mm-new branch
Message-Id: <20250607230846.9727DC4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: gup-optimize-longterm-pin_user_pages-for-large-folio-fix
has been added to the -mm mm-new branch.  Its filename is
     gup-optimize-longterm-pin_user_pages-for-large-folio-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/gup-optimize-longterm-pin_user_pages-for-large-folio-fix.patch

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
From: Li Zhe <lizhe.67@bytedance.com>
Subject: gup-optimize-longterm-pin_user_pages-for-large-folio-fix
Date: Fri, 6 Jun 2025 17:19:17 +0800

whitespace fix, per David

Link: https://lkml.kernel.org/r/20250606091917.91384-1-lizhe.67@bytedance.com
Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
Cc: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/gup.c~gup-optimize-longterm-pin_user_pages-for-large-folio-fix
+++ a/mm/gup.c
@@ -2333,7 +2333,7 @@ static void collect_longterm_unpinnable_
 	long i = 0;
 
 	for (folio = pofs_get_folio(pofs, i); folio;
-		 folio = pofs_next_folio(folio, pofs, &i)) {
+	     folio = pofs_next_folio(folio, pofs, &i)) {
 
 		if (folio_is_longterm_pinnable(folio))
 			continue;
_

Patches currently in -mm which might be from lizhe.67@bytedance.com are

gup-optimize-longterm-pin_user_pages-for-large-folio.patch
gup-optimize-longterm-pin_user_pages-for-large-folio-fix.patch

