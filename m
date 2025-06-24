Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFEB42586FE
	for <mm-commits@vger.kernel.org>; Tue, 24 Jun 2025 23:13:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750806834; cv=none; b=L+mDoybq2iBkahKoHHBNUhvwkTM4tONCEgk2Bh9HNkHGjWgrh5oT3LpD4+qJYeCwcxC3RB1ul0ZYrPirOdS2bl0bvvRmAhm/PlEqTg8UNeKMv6+OoPjJbQaDNAxZaCcRLK+l65aE+jqakgA2kpvShh66yQ4rJKQlE8ZzLhCpUG0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750806834; c=relaxed/simple;
	bh=WsmIEmoBzavI6QVbOJMQ8YHeFmGYL79pJpKaQImHe8M=;
	h=Date:To:From:Subject:Message-Id; b=Gok256Ve8ouePl6PQX4ySf2UBoGmPKed/F9w4eQPXuLmnSkHnokPd0xRR0/TL7fQFj0/NWYywdlVWI3ReTZ2qMHPTT4qUv67AyTD59QE3JO/NM4gTC98DKiXluEpKEiPofCVdylgb7hbfGysJdRNm9c240KDk3ny4dxU/4mPOCM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=tWLU/kPH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="tWLU/kPH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C119C4CEF0;
	Tue, 24 Jun 2025 23:13:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1750806833;
	bh=WsmIEmoBzavI6QVbOJMQ8YHeFmGYL79pJpKaQImHe8M=;
	h=Date:To:From:Subject:From;
	b=tWLU/kPHM++jji2lO9KihBoCzPOhnV29dtEbUV+CI1PKhsrt1PQYMCoExjCmFuleF
	 KI7sU5xz7vK7hcy9bmLgv66mzb00UKfbihUWORTLpz7WIdiX2pfTurAnoc0tbi0sy8
	 9Tefm/sHgIjI9mRwliMitwBG88i9htJh7A002Lag=
Date: Tue, 24 Jun 2025 16:13:52 -0700
To: mm-commits@vger.kernel.org,surenb@google.com,sj@kernel.org,rppt@kernel.org,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,jannh@google.com,david@redhat.com,ccross@google.com,vbabka@suse.cz,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-madvise-use-standard-madvise-locking-in-madvise_set_anon_name.patch added to mm-new branch
Message-Id: <20250624231353.5C119C4CEF0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm, madvise: use standard madvise locking in madvise_set_anon_name()
has been added to the -mm mm-new branch.  Its filename is
     mm-madvise-use-standard-madvise-locking-in-madvise_set_anon_name.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-madvise-use-standard-madvise-locking-in-madvise_set_anon_name.patch

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
From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm, madvise: use standard madvise locking in madvise_set_anon_name()
Date: Tue, 24 Jun 2025 15:03:48 +0200

Use madvise_lock()/madvise_unlock() in madvise_set_anon_name() in the same
way as in do_madvise().  This narrows the lock scope a bit and reuses
existing functionality.  get_lock_mode() already picks the correct
MADVISE_MMAP_WRITE_LOCK mode for __MADV_SET_ANON_VMA_NAME so we can just
remove the explicit assignment.

There is a user visible change in that the prctl(PR_SET_VMA,
PR_SET_VMA_ANON_NAME...) might now return -EINTR.

Link: https://lkml.kernel.org/r/20250624-anon_name_cleanup-v2-4-600075462a11@suse.cz
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Tested-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Colin Cross <ccross@google.com>
Cc: Jann Horn <jannh@google.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/madvise.c |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

--- a/mm/madvise.c~mm-madvise-use-standard-madvise-locking-in-madvise_set_anon_name
+++ a/mm/madvise.c
@@ -2082,10 +2082,10 @@ static int madvise_set_anon_name(struct
 {
 	unsigned long end;
 	unsigned long len;
+	int error;
 	struct madvise_behavior madv_behavior = {
 		.mm = mm,
 		.behavior = __MADV_SET_ANON_VMA_NAME,
-		.lock_mode = MADVISE_MMAP_WRITE_LOCK,
 		.anon_name = anon_name,
 	};
 
@@ -2106,7 +2106,14 @@ static int madvise_set_anon_name(struct
 
 	madv_behavior.range.start = start;
 	madv_behavior.range.end = end;
-	return madvise_walk_vmas(&madv_behavior);
+
+	error = madvise_lock(&madv_behavior);
+	if (error)
+		return error;
+	error = madvise_walk_vmas(&madv_behavior);
+	madvise_unlock(&madv_behavior);
+
+	return error;
 }
 
 int set_anon_vma_name(unsigned long addr, unsigned long size,
@@ -2136,9 +2143,7 @@ int set_anon_vma_name(unsigned long addr
 			return -ENOMEM;
 	}
 
-	mmap_write_lock(mm);
 	error = madvise_set_anon_name(mm, addr, size, anon_name);
-	mmap_write_unlock(mm);
 	anon_vma_name_put(anon_name);
 
 	return error;
_

Patches currently in -mm which might be from vbabka@suse.cz are

mm-madvise-simplify-anon_name-handling.patch
mm-madvise-extract-mm-code-from-prctl_set_vma-to-mm-madvisec.patch
mm-madvise-move-madvise_set_anon_name-down-the-file.patch
mm-madvise-use-standard-madvise-locking-in-madvise_set_anon_name.patch

