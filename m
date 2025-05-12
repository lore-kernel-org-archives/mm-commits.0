Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DC61C2FB
	for <mm-commits@vger.kernel.org>; Mon, 12 May 2025 00:52:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747011131; cv=none; b=aQwVoYqeqC/6C+RK5Kqh3ojCH/2BjRtW5Dd5M9Ii6wfI49xB470Ay3nYdTpauE9Ab0yjhLIF8m6hVeVrCXb87SB0emCE8QUrUVcyixU+/jEiCI2s3ZCt3Qhr8U9v15gGKcPw+rqIiJHSsWyLe9BPyXnSUXZAvgGZrI9Sy7strTk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747011131; c=relaxed/simple;
	bh=E/3pJSB+6n05lZQvt4S/o31rclVK/T2F3BVPvhbwofo=;
	h=Date:To:From:Subject:Message-Id; b=S00cj/N/5CGj6L+ll2tOe46l2HgPKMwG98uGpb1U0h2B2OgPPVeWDFKrnHd9za4cYqfzNMc2rXCoJ6r7a7/sUZ7ZJad1FiG//Hse37yhD5ZMVczPNhcby/OzW2Oeq9lf+WgwVNiywW7lwOtkdwKA2KDU3mTou49XBso9xXHGbu8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=aXqKUsMb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="aXqKUsMb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 511D8C4CEE4;
	Mon, 12 May 2025 00:52:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747011131;
	bh=E/3pJSB+6n05lZQvt4S/o31rclVK/T2F3BVPvhbwofo=;
	h=Date:To:From:Subject:From;
	b=aXqKUsMbXLrbWEFcLuW39O/TW5WZD1TLzP/XgEJTHYCnwIVhHPHqpoUwbvBhdOYuv
	 eVlWX4zxOwH7s8A2Hd4zLFpNHy72M1hBad15N6CSJgJbFFy7hG83AFRN39iIM2f6Gk
	 rZJ8u4QXHuwEUL9Mh0aOA75S0VBWZR996F6ogY6g=
Date: Sun, 11 May 2025 17:52:10 -0700
To: mm-commits@vger.kernel.org,yanjun.zhu@linux.dev,osalvador@suse.de,david@redhat.com,bhe@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-gup-remove-unneeded-checking-in-follow_page_pte.patch removed from -mm tree
Message-Id: <20250512005211.511D8C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/gup: remove unneeded checking in follow_page_pte()
has been removed from the -mm tree.  Its filename was
     mm-gup-remove-unneeded-checking-in-follow_page_pte.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Baoquan He <bhe@redhat.com>
Subject: mm/gup: remove unneeded checking in follow_page_pte()
Date: Thu, 10 Apr 2025 11:57:15 +0800

Patch series "mm/gup: Minor fix, cleanup and improvements", v4.

These were made from code inspection in mm/gup.c.


This patch (of 3):

In __get_user_pages(), it will traverse page table and take a reference to
the page the given user address corresponds to if GUP_GET or GUP_PIN is
set.  However, it's not supported both GUP_GET and GUP_PIN are set.  Even
though this check need be done, it should be done earlier, but not doing
it till entering into follow_page_pte() and failed.

Furthermore, this checking has been done in is_valid_gup_args() and all
external users of __get_user_pages() will call is_valid_gup_args() to
catch the illegal setting.  We don't need to worry about internal users of
__get_user_pages() because the gup_flags are set by MM code correctly.

Here remove the checking in follow_page_pte(), and add VM_WARN_ON_ONCE()
to catch the possible exceptional setting just in case.

And also change the VM_BUG_ON to VM_WARN_ON_ONCE() for checking (!!pages
!= !!(gup_flags & (FOLL_GET | FOLL_PIN))) because the checking has been
done in is_valid_gup_args() for external users of __get_user_pages().

Link: https://lkml.kernel.org/r/20250410035717.473207-1-bhe@redhat.com
Link: https://lkml.kernel.org/r/20250410035717.473207-3-bhe@redhat.com
Signed-off-by: Baoquan He <bhe@redhat.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Yanjun.Zhu <yanjun.zhu@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

--- a/mm/gup.c~mm-gup-remove-unneeded-checking-in-follow_page_pte
+++ a/mm/gup.c
@@ -844,11 +844,6 @@ static struct page *follow_page_pte(stru
 	pte_t *ptep, pte;
 	int ret;
 
-	/* FOLL_GET and FOLL_PIN are mutually exclusive. */
-	if (WARN_ON_ONCE((flags & (FOLL_PIN | FOLL_GET)) ==
-			 (FOLL_PIN | FOLL_GET)))
-		return ERR_PTR(-EINVAL);
-
 	ptep = pte_offset_map_lock(mm, pmd, address, &ptl);
 	if (!ptep)
 		return no_page_table(vma, flags, address);
@@ -1432,7 +1427,11 @@ static long __get_user_pages(struct mm_s
 
 	start = untagged_addr_remote(mm, start);
 
-	VM_BUG_ON(!!pages != !!(gup_flags & (FOLL_GET | FOLL_PIN)));
+	VM_WARN_ON_ONCE(!!pages != !!(gup_flags & (FOLL_GET | FOLL_PIN)));
+
+	/* FOLL_GET and FOLL_PIN are mutually exclusive. */
+	VM_WARN_ON_ONCE((gup_flags & (FOLL_PIN | FOLL_GET)) ==
+			(FOLL_PIN | FOLL_GET));
 
 	do {
 		struct page *page;
_

Patches currently in -mm which might be from bhe@redhat.com are

mm-vmallocc-change-purge_ndoes-as-local-static-variable.patch
mm-vmallocc-find-the-vmap-of-vmap_nodes-in-reverse-order.patch
mm-vmallocc-optimize-code-in-decay_va_pool_node-a-little-bit.patch
mm-vmalloc-optimize-function-vm_unmap_aliases.patch
mm-vmallocc-return-explicit-error-value-in-alloc_vmap_area.patch

