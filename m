Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AE741799F
	for <mm-commits@vger.kernel.org>; Fri,  7 Feb 2025 00:36:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738888620; cv=none; b=CrG3aaMRireGl+00ieyHhzd+oGjmtf1nZqJKjrxXc8kQYGgk8+Q7hQ6igOySS25S6FzjSj8SYaPsa/dy70CMxm+uD1UWkPvV8Z+8vHY9+3cxlO8VBhqmEeVQ7ajTtjaYjeC0Zkt8qlaLD5KnUXyfDFYq263Kj2ufx3jYnXQFNCU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738888620; c=relaxed/simple;
	bh=UHLi+Lz4qcwsZRQlkJ1BpTZGbYzA+4C6GVy+bx+sV2Y=;
	h=Date:To:From:Subject:Message-Id; b=Kp2F13fXWkKvSXzqKkricobQAZd/HGXMWugyxOE9YmvYCKko3miyQY8Wu57Hu21F9IZZIgVGGhvhwttU9zwiHBbI65dSVctWLayIR22E/NcC98d6Rewhw00a29tJHGzZrfpzCe5C+QN9QAMu1nmcUaUA/J6pugHiX6I71btPLiM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=RK47Skz2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="RK47Skz2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60242C4CEDF;
	Fri,  7 Feb 2025 00:36:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1738888619;
	bh=UHLi+Lz4qcwsZRQlkJ1BpTZGbYzA+4C6GVy+bx+sV2Y=;
	h=Date:To:From:Subject:From;
	b=RK47Skz22Sf7q6SPX/zoNt+3y3EGzg1PGp+tzjyjeZyNwtbRHxNmJmcvTqw3KL7Ir
	 bq88gwxrBUGo1TS0ou72uNRdwEKhOngdyBNDGN3uUTAZ8RIHwMam9U5ei/8eVd4P6Y
	 b5bsAeJeRovloCCWZil3KJzkpm+l9qAzH0uRYTnY=
Date: Thu, 06 Feb 2025 16:36:58 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,sj@kernel.org,shakeel.butt@linux.dev,lorenzo.stoakes@oracle.com,howlett@gmail.com,david@redhat.com,dave@stgolabs.net,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-madvise-remove-redundant-mmap_lock-operations-from-process_madvise-fix.patch added to mm-unstable branch
Message-Id: <20250207003659.60242C4CEDF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-madvise-remove-redundant-mmap_lock-operations-from-process_madvise-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-madvise-remove-redundant-mmap_lock-operations-from-process_madvise-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-madvise-remove-redundant-mmap_lock-operations-from-process_madvise-fix.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-madvise-remove-redundant-mmap_lock-operations-from-process_madvise-fix
Date: Thu Feb  6 04:34:29 PM PST 2025

update comment, per Lorenzo

Cc: David Hildenbrand <david@redhat.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Liam R. Howlett <howlett@gmail.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: SeongJae Park <sj@kernel.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/madvise.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/madvise.c~mm-madvise-remove-redundant-mmap_lock-operations-from-process_madvise-fix
+++ a/mm/madvise.c
@@ -1787,7 +1787,7 @@ static ssize_t vector_madvise(struct mm_
 		 * the operation in aggregate, and would be surprising to the
 		 * user.
 		 *
-		 * As we have already dropped locks, it is safe to just loop and
+		 * We drop and reacquire locks so it is safe to just loop and
 		 * try again. We check for fatal signals in case we need exit
 		 * early anyway.
 		 */
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-vmscan-extract-calculated-pressure-balance-as-a-function-fix.patch
mm-madvise-remove-redundant-mmap_lock-operations-from-process_madvise-fix.patch
lib-plistc-add-shortcut-for-plist_requeue-fix.patch

