Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B863A1C8633
	for <mm-commits@vger.kernel.org>; Thu,  7 Aug 2025 22:13:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754604785; cv=none; b=CA8MYJ9SAPTuPLfPsMYsqL1oc5+cQxX8r5G905a5ipzIsZ6YjO4n12BH0BQCpro93qrYDikNKDd8Aj5Nqvl0wPGEaMOrgWh6GLbr0DDuUHe+EIH0iH1XNwMhYYvKiejLpw3OXb4C/UjeDsLLpE1Q3ui6VOHThkGPgAo6NyI0R8w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754604785; c=relaxed/simple;
	bh=SA8dqMoJr0Ken6KkUwHjmyv0pBwqSh3lH89kEnM4u+0=;
	h=Date:To:From:Subject:Message-Id; b=IiFKlSdUH6QKTBIf92ncmjFwPi6XoZ9mgqqvwrySSbnW1KV2TsvvX5BFLBQubokuJU/72xib98UoABcLbI7+RirGKxUWJ8QhKp0C1WseteYI7XgYSp0OcsAIo5Qq4sngOpqUyLBm1ZHC6UQ7ZAdMv8sMjdfZqbojynau2S3RpLY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=i5qdX1fN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="i5qdX1fN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31C5DC4CEEB;
	Thu,  7 Aug 2025 22:13:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1754604785;
	bh=SA8dqMoJr0Ken6KkUwHjmyv0pBwqSh3lH89kEnM4u+0=;
	h=Date:To:From:Subject:From;
	b=i5qdX1fNuJc11lMsqHsZQhpPvHa8S3GqhUUsbe97N5kZGwhdJS+s/jnVuxzHOntx+
	 jeQYSjfC374q3IPOy4Wwn0HcNSlEz4fwJJpCavhQM5x504JwHbLsZAtN/Q7Pp0JlGP
	 FqbwJjU/3Ronei49buP6QaLGKHL7fC2vC5q61Ivk=
Date: Thu, 07 Aug 2025 15:13:04 -0700
To: mm-commits@vger.kernel.org,peterx@redhat.com,lokeshgidra@google.com,david@redhat.com,aarcange@redhat.com,surenb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + userfaultfd-fix-a-crash-in-uffdio_move-when-pmd-is-a-migration-entry-fix.patch added to mm-hotfixes-unstable branch
Message-Id: <20250807221305.31C5DC4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: userfaultfd-fix-a-crash-in-uffdio_move-when-pmd-is-a-migration-entry-fix
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     userfaultfd-fix-a-crash-in-uffdio_move-when-pmd-is-a-migration-entry-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/userfaultfd-fix-a-crash-in-uffdio_move-when-pmd-is-a-migration-entry-fix.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Suren Baghdasaryan <surenb@google.com>
Subject: userfaultfd-fix-a-crash-in-uffdio_move-when-pmd-is-a-migration-entry-fix
Date: Thu, 7 Aug 2025 13:04:18 -0700

remove extra folio check, per David

Link: https://lkml.kernel.org/r/20250807200418.1963585-1-surenb@google.com
Fixes: adef440691ba ("userfaultfd: UFFDIO_MOVE uABI")
Reported-by: syzbot+b446dbe27035ef6bd6c2@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/68794b5c.a70a0220.693ce.0050.GAE@google.com/
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Reviewed-by: Peter Xu <peterx@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Lokesh Gidra <lokeshgidra@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/userfaultfd.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/userfaultfd.c~userfaultfd-fix-a-crash-in-uffdio_move-when-pmd-is-a-migration-entry-fix
+++ a/mm/userfaultfd.c
@@ -1825,8 +1825,8 @@ ssize_t move_pages(struct userfaultfd_ct
 				if (pmd_present(*src_pmd)) {
 					struct folio *folio = pmd_folio(*src_pmd);
 
-					if (!folio || (!is_huge_zero_folio(folio) &&
-						       !PageAnonExclusive(&folio->page))) {
+					if (!is_huge_zero_folio(folio) &&
+					    !PageAnonExclusive(&folio->page)) {
 						spin_unlock(ptl);
 						err = -EBUSY;
 						break;
_

Patches currently in -mm which might be from surenb@google.com are

userfaultfd-fix-a-crash-in-uffdio_move-when-pmd-is-a-migration-entry.patch
userfaultfd-fix-a-crash-in-uffdio_move-when-pmd-is-a-migration-entry-fix.patch
mm-limit-the-scope-of-vma_start_read.patch
mm-change-vma_start_read-to-drop-rcu-lock-on-failure.patch

