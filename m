Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D0E819B;
	Mon,  6 May 2024 00:28:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714955321; cv=none; b=fESsMkkapjTCJUBmu7AKwL8Cn7JYJSjZvG+wuPvk/0Mdzr51v0GHDRR8jnzA9rO5Vgvsxo3n+ADWvAfqP0wlBsjGYgbqCGioliJgT+ds4vSp3KVR376ZHq5QtMWwMQlTYQ2xsMou71FJj+ENQpR8c9HOoSVyUxveCgq4VfTWtDE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714955321; c=relaxed/simple;
	bh=afU8xOwL1zJmMu9/OTZ6occDfuDYiKGcTH/1Nen7wKg=;
	h=Date:To:From:Subject:Message-Id; b=Lq7IODIDdEthn7d+FEPwZAH050Baw3s6yKaD1X/okXuvusJ+VJeWUetVah8vJ+2huVjmY8yo0mcj6NtZs7lMW3h/cqbsXOaw0PyfBS/jmkuoURZqfig69KlPZTlBD00CxP3aesYsMMMgTkk9wLlOc94/srqCVxLUNkjtemSW1y0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=OmuPSv/Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="OmuPSv/Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF8D4C113CC;
	Mon,  6 May 2024 00:28:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714955320;
	bh=afU8xOwL1zJmMu9/OTZ6occDfuDYiKGcTH/1Nen7wKg=;
	h=Date:To:From:Subject:From;
	b=OmuPSv/YY22jJ0SMLpmLglueMpEIMLUAInS5fqiJuGitFuzX6CJh0PYwZIg3qPdlk
	 UUzSubgE1lV+10tX6yBZnU5qi+kUKgjtTWFb9dejKnAOcPDGJyVbTXituTZoOGCObK
	 YnEKnik04QL7VuBHWVBVge3NGYs7ixT33Z6lvJ+0=
Date: Sun, 05 May 2024 17:28:39 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,nadav.amit@gmail.com,david@redhat.com,peterx@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-userfaultfd-reset-ptes-when-close-for-wr-protected-ones.patch removed from -mm tree
Message-Id: <20240506002840.CF8D4C113CC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/userfaultfd: reset ptes when close() for wr-protected ones
has been removed from the -mm tree.  Its filename was
     mm-userfaultfd-reset-ptes-when-close-for-wr-protected-ones.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Peter Xu <peterx@redhat.com>
Subject: mm/userfaultfd: reset ptes when close() for wr-protected ones
Date: Mon, 22 Apr 2024 09:33:11 -0400

Userfaultfd unregister includes a step to remove wr-protect bits from all
the relevant pgtable entries, but that only covered an explicit
UFFDIO_UNREGISTER ioctl, not a close() on the userfaultfd itself.  Cover
that too.  This fixes a WARN trace.

The only user visible side effect is the user can observe leftover
wr-protect bits even if the user close()ed on an userfaultfd when
releasing the last reference of it.  However hopefully that should be
harmless, and nothing bad should happen even if so.

This change is now more important after the recent page-table-check
patch we merged in mm-unstable (446dd9ad37d0 ("mm/page_table_check:
support userfault wr-protect entries")), as we'll do sanity check on
uffd-wp bits without vma context.  So it's better if we can 100%
guarantee no uffd-wp bit leftovers, to make sure each report will be
valid.

Link: https://lore.kernel.org/all/000000000000ca4df20616a0fe16@google.com/
Fixes: f369b07c8614 ("mm/uffd: reset write protection when unregister with wp-mode")
Analyzed-by: David Hildenbrand <david@redhat.com>
Link: https://lkml.kernel.org/r/20240422133311.2987675-1-peterx@redhat.com
Reported-by: syzbot+d8426b591c36b21c750e@syzkaller.appspotmail.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Nadav Amit <nadav.amit@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/userfaultfd.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/fs/userfaultfd.c~mm-userfaultfd-reset-ptes-when-close-for-wr-protected-ones
+++ a/fs/userfaultfd.c
@@ -895,6 +895,10 @@ static int userfaultfd_release(struct in
 			prev = vma;
 			continue;
 		}
+		/* Reset ptes for the whole vma range if wr-protected */
+		if (userfaultfd_wp(vma))
+			uffd_wp_range(vma, vma->vm_start,
+				      vma->vm_end - vma->vm_start, false);
 		new_flags = vma->vm_flags & ~__VM_UFFD_FLAGS;
 		vma = vma_modify_flags_uffd(&vmi, prev, vma, vma->vm_start,
 					    vma->vm_end, new_flags,
_

Patches currently in -mm which might be from peterx@redhat.com are

mm-hugetlb-assert-hugetlb_lock-in-__hugetlb_cgroup_commit_charge.patch
mm-page_table_check-support-userfault-wr-protect-entries.patch
mm-gup-fix-hugepd-handling-in-hugetlb-rework.patch

