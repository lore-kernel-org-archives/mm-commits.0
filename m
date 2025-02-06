Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A02192248BB
	for <mm-commits@vger.kernel.org>; Thu,  6 Feb 2025 07:57:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738828666; cv=none; b=Wuw+LEu+eYwyJCe3KM3p07W/3a9cEirJ91AkuFr7+xAuYIJDNrhXSSUpTO1JuCeAF6RjN3RYibytuZ+L1GdmANhw1rykcCQjjMOgPsoaUcX7Ua02mDp0+O/59zAGjNSTno6VXPHoIGL0ITWw/M4wG5oAirewGJu4kBzaz30/VNc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738828666; c=relaxed/simple;
	bh=db43QfQG3CeWhYNqTxtlbH7q3+eqm5KfsF4J5E31pUw=;
	h=Date:To:From:Subject:Message-Id; b=eY8mVB5YSGnjQx5fmro/yW3fNj1zKbt/cyHvmew0m739wsxEYUnKSL+epuqvUQYCIgn6u88EpzIWP0SrwB53NhdYToODbxp4rYfLGpM6Z4wyu5zAA1v1JDn0qsUpH5Nx6zkDIuqKGF5tH9JtAwN/p2pL0QndvdSzA88UyxkzJpk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jM34PQzo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jM34PQzo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C425C4CEDD;
	Thu,  6 Feb 2025 07:57:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1738828666;
	bh=db43QfQG3CeWhYNqTxtlbH7q3+eqm5KfsF4J5E31pUw=;
	h=Date:To:From:Subject:From;
	b=jM34PQzollZ23d1vcAqp7A5UCGh03TD+aIZU984kO52lIaNB/z2nIGcE+6HfeOqmU
	 vQxsc+Zkdce+7y3Y4KlJc/A6IKEYQ7Vku+lPwLkHmGJ3ld/lFJ64LVq0snVda6FRmQ
	 ev6F4oRP2mb0oVtOKAxVX+5Hv397UdHLS57e6N/4=
Date: Wed, 05 Feb 2025 23:57:45 -0800
To: mm-commits@vger.kernel.org,ryncsn@gmail.com,chrisl@kernel.org,bhe@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swapfilec-remove-the-incorrect-code-comment.patch added to mm-unstable branch
Message-Id: <20250206075746.6C425C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/swapfile.c: remove the incorrect code comment
has been added to the -mm mm-unstable branch.  Its filename is
     mm-swapfilec-remove-the-incorrect-code-comment.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swapfilec-remove-the-incorrect-code-comment.patch

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
From: Baoquan He <bhe@redhat.com>
Subject: mm/swapfile.c: remove the incorrect code comment
Date: Wed, 5 Feb 2025 17:27:20 +0800

Since commit eb085574a752 ("mm, swap: fix race between swapoff and some
swap operations"), the non_swap_entry() checking has been taken off from
function __swap_duplicate().  Hence, in the kernel-doc comment, the line
'swp_entry is migration entry -> EINVAL' is obsolete.  Remove that line to
avoid misleading people.

Link: https://lkml.kernel.org/r/20250205092721.9395-12-bhe@redhat.com
Signed-off-by: Baoquan He <bhe@redhat.com>
Cc: Chis Li <chrisl@kernel.org>
Cc: Kairui Song <ryncsn@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |    1 -
 1 file changed, 1 deletion(-)

--- a/mm/swapfile.c~mm-swapfilec-remove-the-incorrect-code-comment
+++ a/mm/swapfile.c
@@ -3525,7 +3525,6 @@ void si_swapinfo(struct sysinfo *val)
  * Returns error code in following case.
  * - success -> 0
  * - swp_entry is invalid -> EINVAL
- * - swp_entry is migration entry -> EINVAL
  * - swap-cache reference is requested but there is already one. -> EEXIST
  * - swap-cache reference is requested but the entry is not used. -> ENOENT
  * - swap-mapped reference requested but needs continued swap count. -> ENOMEM
_

Patches currently in -mm which might be from bhe@redhat.com are

mm-swap_statec-fix-the-obsolete-code-comment.patch
mm-swap_statec-optimize-the-code-in-clear_shadow_from_swap_cache.patch
mm-swap-remove-swap_flag_prio_shift.patch
mm-swap-skip-scanning-cluster-range-if-its-empty-cluster.patch
mm-swap-rename-swap_is_has_cache-to-swap_only_has_cache.patch
mm-swapfilec-update-the-code-comment-above-swap_count_continued.patch
mm-swapfilec-optimize-code-in-setup_clusters.patch
mm-swap_statec-remove-the-meaningless-code-comment.patch
mm-swapfilec-remove-the-unneeded-checking.patch
mm-swap-rename-swap_swapcount-to-swap_entry_swapped.patch
mm-swapfilec-remove-the-incorrect-code-comment.patch
mm-swapfilec-open-code-cluster_alloc_swap.patch

