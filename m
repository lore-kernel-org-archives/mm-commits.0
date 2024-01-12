Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 471DC19451
	for <mm-commits@vger.kernel.org>; Fri, 12 Jan 2024 23:21:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="VI6aumLL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC28CC43390;
	Fri, 12 Jan 2024 23:21:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1705101707;
	bh=xtl3gbzSIcjguxifZ8DeBJVtAffFmN/Bo7klY+IOowI=;
	h=Date:To:From:Subject:From;
	b=VI6aumLLmW7utNpsvomZZ8Tixh9+BuVf6CrgsmX19BXQ9PmuK6L4jG1w7iiGKyocM
	 uog3uQkeA8b9vWJtfYKTJGjubz4jJQ0BkmlfnjeNqerULoBYuxp1o/0XHNjCZTj0Qw
	 cvqlv7UgNgZaNYgtAdUon/zhzI/MwN0FqwjsbFIw=
Date: Fri, 12 Jan 2024 15:21:47 -0800
To: mm-commits@vger.kernel.org,sfr@canb.auug.org.au,peterx@redhat.com,david@redhat.com,aarcange@redhat.com,surenb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] userfaultfd-avoid-huge_zero_page-in-uffdio_move.patch removed from -mm tree
Message-Id: <20240112232147.BC28CC43390@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: userfaultfd: avoid huge_zero_page in UFFDIO_MOVE
has been removed from the -mm tree.  Its filename was
     userfaultfd-avoid-huge_zero_page-in-uffdio_move.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Suren Baghdasaryan <surenb@google.com>
Subject: userfaultfd: avoid huge_zero_page in UFFDIO_MOVE
Date: Thu, 11 Jan 2024 17:39:35 -0800

While testing UFFDIO_MOVE ioctl, syzbot triggered VM_BUG_ON_PAGE caused by
a call to PageAnonExclusive() with a huge_zero_page as a parameter. 
UFFDIO_MOVE does not yet handle zeropages and returns EBUSY when one is
encountered.  Add an early huge_zero_page check in the PMD move path to
avoid this situation.

Link: https://lkml.kernel.org/r/20240112013935.1474648-1-surenb@google.com
Fixes: adef440691ba ("userfaultfd: UFFDIO_MOVE uABI")
Reported-by: syzbot+705209281e36404998f6@syzkaller.appspotmail.com
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/userfaultfd.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/mm/userfaultfd.c~userfaultfd-avoid-huge_zero_page-in-uffdio_move
+++ a/mm/userfaultfd.c
@@ -1393,6 +1393,12 @@ ssize_t move_pages(struct userfaultfd_ct
 				err = -ENOENT;
 				break;
 			}
+			/* Avoid moving zeropages for now */
+			if (is_huge_zero_pmd(*src_pmd)) {
+				spin_unlock(ptl);
+				err = -EBUSY;
+				break;
+			}
 
 			/* Check if we can move the pmd without splitting it. */
 			if (move_splits_huge_pmd(dst_addr, src_addr, src_start + len) ||
_

Patches currently in -mm which might be from surenb@google.com are


