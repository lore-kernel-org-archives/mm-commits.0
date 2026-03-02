Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7704848123B
	for <mm-commits@vger.kernel.org>; Mon,  2 Mar 2026 20:31:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772483503; cv=none; b=rpsv2AtgNhVEfW51IIEHi1v8+ewJarjHVBUFishHmuH8tO9id26sMAq+/hZ7y9yjnoVkDFnB511+e90J253/Sz77C7a2aDZ9W8118gxxB9i8O1WrGa0l4bcdqKDZseyxzRzE6QN4Ca0gEuMZMOkMqBwOcjL/7fGT0bD1kx2S2j0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772483503; c=relaxed/simple;
	bh=I+x/pViWk67cwjaKZoovOpB4FC1osmH9ihN0ZBQLFk0=;
	h=Date:To:From:Subject:Message-Id; b=tXkQGnIBp+5uTpGyWZcbSoDq+CzwOINNWrwlPWYTyVcrt0cExj989jGH9mufZjE6BeOguuT6tgWUKYoSQU7NUm+2dp24RLUJxRwe7RNBW1oZ24TU62YpwZpsOf9z6DpEGHWGNSpB5+tCYHwlbYEU+mn02RtW6sqZwKaF8qpHMsQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fdA4R2Cg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fdA4R2Cg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E67FBC19423;
	Mon,  2 Mar 2026 20:31:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1772483503;
	bh=I+x/pViWk67cwjaKZoovOpB4FC1osmH9ihN0ZBQLFk0=;
	h=Date:To:From:Subject:From;
	b=fdA4R2Cg7sQhMtj0OjXWDx7Mwk+AwUVt8q8EYU82DZ+MniwYfaHns4RqPEPCamOkX
	 zpv6hj1fsouKNzHNTUa+8xihVdZpmN43xk8kg599bxFP8vJQf+IDzF00mGLJXqEigt
	 E/c/yKUXD67jMHnUIGC1UfLt0RdXQ3rqusSExjG4=
Date: Mon, 02 Mar 2026 12:31:42 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,skhan@linuxfoundation.org,rppt@kernel.org,osalvador@suse.de,muchun.song@linux.dev,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,hillf.zj@alibaba-inc.com,david@kernel.org,corbet@lwn.net,jane.chu@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + documentation-fix-a-hugetlbfs-reservation-statement.patch added to mm-new branch
Message-Id: <20260302203142.E67FBC19423@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: Documentation: fix a hugetlbfs reservation statement
has been added to the -mm mm-new branch.  Its filename is
     documentation-fix-a-hugetlbfs-reservation-statement.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/documentation-fix-a-hugetlbfs-reservation-statement.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Jane Chu <jane.chu@oracle.com>
Subject: Documentation: fix a hugetlbfs reservation statement
Date: Mon, 2 Mar 2026 13:10:15 -0700

Documentation/mm/hugetlbfs_reserv.rst has
	if (resv_needed <= (resv_huge_pages - free_huge_pages))
		resv_huge_pages += resv_needed;
which describes this code in gather_surplus_pages()
	needed = (h->resv_huge_pages + delta) - h->free_huge_pages;
	if (needed <= 0) {
		h->resv_huge_pages += delta;
		return 0;
	}
which means if there are enough free hugepages to account for the new
reservation, simply update the global reservation count without
further action.

But the description is backwards, it should be
	if (resv_needed <= (free_huge_pages - resv_huge_pages))
instead.

Link: https://lkml.kernel.org/r/20260302201015.1824798-1-jane.chu@oracle.com
Fixes: 70bc0dc578b3f ("Documentation: vm, add hugetlbfs reservation overview")
Signed-off-by: Jane Chu <jane.chu@oracle.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Hillf Danton <hillf.zj@alibaba-inc.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/mm/hugetlbfs_reserv.rst |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/Documentation/mm/hugetlbfs_reserv.rst~documentation-fix-a-hugetlbfs-reservation-statement
+++ a/Documentation/mm/hugetlbfs_reserv.rst
@@ -155,7 +155,7 @@ are enough free huge pages to accommodat
 the global reservation count resv_huge_pages is adjusted something like the
 following::
 
-	if (resv_needed <= (resv_huge_pages - free_huge_pages))
+	if (resv_needed <= (free_huge_pages - resv_huge_pages)
 		resv_huge_pages += resv_needed;
 
 Note that the global lock hugetlb_lock is held when checking and adjusting
_

Patches currently in -mm which might be from jane.chu@oracle.com are

documentation-fix-a-hugetlbfs-reservation-statement.patch

