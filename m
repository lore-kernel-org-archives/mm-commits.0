Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED20122A4F3
	for <mm-commits@vger.kernel.org>; Mon,  9 Jun 2025 23:21:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749511300; cv=none; b=RnhXuq7bOblmvFjr5odaJJu7Vxma38p0yJxgQVSln0q0OTe/axQ7EEt45lsPEbjd2v5K+ZXwLAZWD/Djdzm2HIse5N4WQgxMu2ILzCyCwVrXJh0ZnRSzRz8KPSGWSxsyAlJ1DQmmOPIJJ64LAj+bg3V07Pk6fW/eIaHxYCECBzI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749511300; c=relaxed/simple;
	bh=/B4LpuTJ7g4MszjsfFNqCah2EDd4FZxp0IvyyAKDf98=;
	h=Date:To:From:Subject:Message-Id; b=Mpbrxc5nvJpG71uBz7x4PKorcDUooZHIPh46qXjoi63NohVGRFzWgr6RT90AQSb3vVsXFKo63snJ1b/I8pUTJXV3lMEEVX7qMeewp4qfpHBXEIIFQ9jZzyg0VC2Yf4Y8b+FhInC+W1wQvBAUNgqx+uK0lE6fu7PC1aBlsFUo+qc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=pKG8rEAc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="pKG8rEAc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E391C4CEEB;
	Mon,  9 Jun 2025 23:21:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1749511298;
	bh=/B4LpuTJ7g4MszjsfFNqCah2EDd4FZxp0IvyyAKDf98=;
	h=Date:To:From:Subject:From;
	b=pKG8rEAckG5PBkaVIRlhh/cA975VBhSy1p7wFwKZUHlI4MOLbomngUxgzhB15YeXk
	 X1yEwOdSKKtF4yQwshnkp7nZG767fKPHVKJt2t5UtuS5kIkFIOdhpjRsbfidnk7E/V
	 p4uCciF3ku6ZWBrIPWSC/V6MOjuIbZgDo4bt7koE=
Date: Mon, 09 Jun 2025 16:21:37 -0700
To: mm-commits@vger.kernel.org,zhengtangquan@oppo.com,vbabka@suse.cz,surenb@google.com,ryan.roberts@arm.com,osalvador@suse.de,lorenzo.stoakes@oracle.com,lokeshgidra@google.com,Liam.Howlett@oracle.com,jannh@google.com,harry.yoo@oracle.com,dev.jain@arm.com,david@redhat.com,anshuman.khandual@arm.com,v-songbaohua@oppo.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-madvise-use-walk_page_range_vma-instead-of-walk_page_range-fix.patch added to mm-unstable branch
Message-Id: <20250609232138.2E391C4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: madvise: revert the walk_page_range_vma change for MADV_GUARD_INSTALL
has been added to the -mm mm-unstable branch.  Its filename is
     mm-madvise-use-walk_page_range_vma-instead-of-walk_page_range-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-madvise-use-walk_page_range_vma-instead-of-walk_page_range-fix.patch

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
From: Barry Song <v-songbaohua@oppo.com>
Subject: mm: madvise: revert the walk_page_range_vma change for MADV_GUARD_INSTALL
Date: Mon, 9 Jun 2025 22:42:13 +1200

Fix the broken MADV_GUARD_INSTALL reported by Ryan.
 # guard-regions.c:719:split_merge:Expected madvise(ptr, 10 * page_size,
 MADV_GUARD_INSTALL) (-1) == 0 (0)

Link: https://lkml.kernel.org/r/20250609105513.10901-1-21cnbao@gmail.com
Closes: https://lore.kernel.org/linux-mm/671f8164-a90b-48d7-9446-359eb9493500@arm.com/
Signed-off-by: Barry Song <v-songbaohua@oppo.com>
Reported-by: Ryan Roberts <ryan.roberts@arm.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Harry Yoo <harry.yoo@oracle.com>
Cc: Jann Horn <jannh@google.com>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: Lokesh Gidra <lokeshgidra@google.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Tangquan Zheng <zhengtangquan@oppo.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/madvise.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/madvise.c~mm-madvise-use-walk_page_range_vma-instead-of-walk_page_range-fix
+++ a/mm/madvise.c
@@ -1162,7 +1162,7 @@ static long madvise_guard_install(struct
 		unsigned long nr_pages = 0;
 
 		/* Returns < 0 on error, == 0 if success, > 0 if zap needed. */
-		err = walk_page_range_vma(vma, start, end,
+		err = walk_page_range_mm(vma->vm_mm, start, end,
 					 &guard_install_walk_ops, &nr_pages);
 		if (err < 0)
 			return err;
_

Patches currently in -mm which might be from v-songbaohua@oppo.com are

mm-madvise-use-walk_page_range_vma-instead-of-walk_page_range.patch
mm-madvise-use-walk_page_range_vma-instead-of-walk_page_range-fix.patch
mm-use-per_vma-lock-for-madv_dontneed.patch

