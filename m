Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AF9C258EF0
	for <mm-commits@vger.kernel.org>; Fri,  3 Oct 2025 23:43:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759534996; cv=none; b=LjBTJOA+BCQcV8IWf3f4s39+YH9u17WcNxuJbnJXh3N90tw1Mgz8iLEdBOIC2n+iXQ0/00ex8/JncDC7wedO8st9vdrYYAq7YN40dWmxxCH3/RNG79QlBTNy086LANlkotZLxbBZCe+JbHxJR4T9PWi8rZsrSG1tngazYcC35vY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759534996; c=relaxed/simple;
	bh=9W+lTMKQefr1uADuNZ2qgzFyK3YCESWxD6crfp9a4F4=;
	h=Date:To:From:Subject:Message-Id; b=PtZZEj2VOgbyDZ6AiJ6E3KTfMjRtNH57mbZ4ppzUzGx4pvUDwQcKY8Tgi5zEXJMLoNAUOR7k6NygvmXcbShPgvUmL5/18FM9ZcI+REmITjnJnKJVoP+lBGe3MLJ+9cEYTV2O7oheraTv24M+AHYI7sp4sMnbKHrqn8dKlf05cM4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=nfcg5WZQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="nfcg5WZQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D0D2C4CEFA;
	Fri,  3 Oct 2025 23:43:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1759534996;
	bh=9W+lTMKQefr1uADuNZ2qgzFyK3YCESWxD6crfp9a4F4=;
	h=Date:To:From:Subject:From;
	b=nfcg5WZQ3tIhg+2nHGpZP9AmRZJc0F/bq9KiYAz2SeXSgMaJGBtveKoT27nD5+z4W
	 6N77F61Z0DFWTCnCI7pJALkCwZGpUModGL202c1ZCwMgqDcaiyLIllFjlHKXBZNMIr
	 cDHPILJtGv9mXl6SkIojE3PgRmmQ6FGYiJ/e6Ewk=
Date: Fri, 03 Oct 2025 16:43:15 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ryan.roberts@arm.com,richard.weiyang@gmail.com,npache@redhat.com,mpenttil@redhat.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,kirill@shutemov.name,kasong@tencent.com,hughd@google.com,dev.jain@arm.com,david@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,lance.yang@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-clean-up-is_guard_pte_marker.patch removed from -mm tree
Message-Id: <20251003234316.2D0D2C4CEFA@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: clean up is_guard_pte_marker()
has been removed from the -mm tree.  Its filename was
     mm-clean-up-is_guard_pte_marker.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lance Yang <lance.yang@linux.dev>
Subject: mm: clean up is_guard_pte_marker()
Date: Wed, 24 Sep 2025 12:58:30 +0800

Let's simplify the implementation. The current code is redundant as it
effectively expands to:

  is_swap_pte(pte) &&
  is_pte_marker_entry(...) && // from is_pte_marker()
  is_pte_marker_entry(...)    // from is_guard_swp_entry()

While a modern compiler could likely optimize this away, let's have clean
code and not rely on it.

Link: https://lkml.kernel.org/r/20250924045830.3817-1-lance.yang@linux.dev
Signed-off-by: Lance Yang <lance.yang@linux.dev>
Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Kairui Song <kasong@tencent.com>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Mariano Pache <npache@redhat.com>
Cc: Mika Penttilä <mpenttil@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/madvise.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/madvise.c~mm-clean-up-is_guard_pte_marker
+++ a/mm/madvise.c
@@ -1071,8 +1071,8 @@ static bool is_valid_guard_vma(struct vm
 
 static bool is_guard_pte_marker(pte_t ptent)
 {
-	return is_pte_marker(ptent) &&
-		is_guard_swp_entry(pte_to_swp_entry(ptent));
+	return is_swap_pte(ptent) &&
+	       is_guard_swp_entry(pte_to_swp_entry(ptent));
 }
 
 static int guard_install_pud_entry(pud_t *pud, unsigned long addr,
_

Patches currently in -mm which might be from lance.yang@linux.dev are

hung_task-fix-warnings-caused-by-unaligned-lock-pointers.patch
mm-thp-fix-mte-tag-mismatch-when-replacing-zero-filled-subpages.patch
mm-rmap-fix-soft-dirty-and-uffd-wp-bit-loss-when-remapping-zero-filled-mthp-subpage-to-shared-zeropage.patch
mm-khugepaged-abort-collapse-scan-on-non-swap-entries.patch

