Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82E7C360
	for <mm-commits@vger.kernel.org>; Sat,  7 Dec 2024 06:37:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733553441; cv=none; b=ClPIjlCMd5ZehYF+UdrxW1pH5bt7cwUAbzFmgRaTW2ND2M3kuhEgt28aRz0PQYNdS5AqX4szr2ig6vXr2z+q3TuLln6srxMAougdSSULWC8jDyE8PI68BBFF0/zV7K4RYF6ENceV6o38/G9WW3g1XX9nhfPjXHv+p289+bpSj4k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733553441; c=relaxed/simple;
	bh=X4/Ow1LpMav+6owdgByg+LTib5ZHUGO6GuOvfWky1vM=;
	h=Date:To:From:Subject:Message-Id; b=nhcpH9o7cd5FIrXuP8AozzYK0bYw2scgZujWHJkM+DStfJVmdwv/pO4LUN0VqWzFqmeeDRhTmTzDq25bBRkK8IaSwCLwjn5wanVXdHB2+5dRHiRUtxWhSXGvKhItQsE1oi3U+KVg1f2cFy98tUfKXQMmKizX8mHRQNlDQzpMRVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FFLsCKb5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FFLsCKb5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6B67C4CECD;
	Sat,  7 Dec 2024 06:37:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1733553441;
	bh=X4/Ow1LpMav+6owdgByg+LTib5ZHUGO6GuOvfWky1vM=;
	h=Date:To:From:Subject:From;
	b=FFLsCKb5zPbgUjKWJRRN8NnxHRIdzuhcrD2HOiXBYsu/il8qUezgnHckAfwRNiWgY
	 5uRFucUI+KJB9MOG8rterBahbNj1V7BTvL82DIiMKdFIOIbUEPQPplO4Qzl1Zwnq+Y
	 spI231CevaeSf0orYNLK1c5l98TSr1zVRpC7pY6g=
Date: Fri, 06 Dec 2024 22:37:20 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,shy828301@gmail.com,ryan.roberts@arm.com,rick.p.edgecombe@intel.com,lorenzo.stoakes@oracle.com,Liam.Howlett@Oracle.com,jannh@google.com,david@redhat.com,christophe.leroy@csgroup.eu,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-dont-try-thp-align-for-fs-without-get_unmapped_area.patch added to mm-hotfixes-unstable branch
Message-Id: <20241207063720.E6B67C4CECD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: don't try THP alignment for FS without get_unmapped_area
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-dont-try-thp-align-for-fs-without-get_unmapped_area.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-dont-try-thp-align-for-fs-without-get_unmapped_area.patch

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
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: don't try THP alignment for FS without get_unmapped_area
Date: Fri, 6 Dec 2024 15:03:45 +0800

Commit ed48e87c7df3 ("thp: add thp_get_unmapped_area_vmflags()") changes
thp_get_unmapped_area() to thp_get_unmapped_area_vmflags() in
__get_unmapped_area(), which doesn't initialize local get_area for
anonymous mappings.  This leads to us always trying THP alignment even for
file_operations which have a NULL ->get_unmapped_area() callback.

Since commit efa7df3e3bb5 ("mm: align larger anonymous mappings on THP
boundaries") we only want to enable THP alignment for anonymous mappings,
so add a !file check to avoid attempting THP alignment for file mappings.

Link: https://lkml.kernel.org/r/20241206070345.2526501-1-wangkefeng.wang@huawei.com
Fixes: ed48e87c7df3 ("thp: add thp_get_unmapped_area_vmflags()")
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Yang Shi <shy828301@gmail.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jann Horn <jannh@google.com>
Cc: Liam R. Howlett <Liam.Howlett@Oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Rick Edgecombe <rick.p.edgecombe@intel.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/mmap.c~mm-dont-try-thp-align-for-fs-without-get_unmapped_area
+++ a/mm/mmap.c
@@ -892,7 +892,7 @@ __get_unmapped_area(struct file *file, u
 
 	if (get_area) {
 		addr = get_area(file, addr, len, pgoff, flags);
-	} else if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE)
+	} else if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) && !file
 		   && !addr /* no hint */
 		   && IS_ALIGNED(len, PMD_SIZE)) {
 		/* Ensures that larger anonymous mappings are THP aligned. */
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

mm-use-aligned-address-in-clear_gigantic_page.patch
mm-use-aligned-address-in-copy_user_gigantic_page.patch
mm-dont-try-thp-align-for-fs-without-get_unmapped_area.patch

