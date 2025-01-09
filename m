Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90E8520E31A
	for <mm-commits@vger.kernel.org>; Thu,  9 Jan 2025 04:31:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736397091; cv=none; b=sXSGNOh1QuTAfWBuGZ+YW/TnxVaXC2FAxX7AsPfH8U5ODBEKuzGgXyq9qDciOWzDX587WFdmcABpMePjSechJYe0VSRxXhT1myWu1Hvz0gXUaf4rSQTNgbDZxIs21/OwcglaW7mthzkqb4LMPw/Y31imLVlJ7HivJrpONkI5r+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736397091; c=relaxed/simple;
	bh=kUiCjrTDD+F6ey5EkSVrXv8HisllPFKzJAPfzsVp1M0=;
	h=Date:To:From:Subject:Message-Id; b=q2Zb8Fw2wBGo2fKIrnyHIN3zTQ1nU171lON6iLj0Yw7tacK15rk/gOaYEfiDz3v58rzFmUpllyXGcGTu66kdd/QhhLIgYsF3QUrAmUzStmQPfRznIkIzHtmw+4JCMDcxu7Cl1MmdWx1NjYx9LERZSdm5x1EARl5NvR7EX+PbO0Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=zv2/vqLG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zv2/vqLG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F38E0C4CED2;
	Thu,  9 Jan 2025 04:31:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736397091;
	bh=kUiCjrTDD+F6ey5EkSVrXv8HisllPFKzJAPfzsVp1M0=;
	h=Date:To:From:Subject:From;
	b=zv2/vqLGf0dek//qp3NhIc1vaou6fPMd1xFUfBLc4o8gbn59VsdOgavSi6M1MwwJS
	 azk/6Kl7h/Bi3pzbtupXzdlX1jRp8SgT0/oGghPPhA9TeyGK8NJMWKVCD66SGhf61y
	 gZS+yhcuatAnySSvbkVTjV7N74usbnWa3tfDiQYk=
Date: Wed, 08 Jan 2025 20:31:30 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,phillip@squashfs.org.uk,dan.carpenter@linaro.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + squashfs-convert-squashfs_copy_cache-to-take-a-folio-fix.patch added to mm-nonmm-unstable branch
Message-Id: <20250109043130.F38E0C4CED2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: squashfs: fix a NULL vs IS_ERR() bug
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     squashfs-convert-squashfs_copy_cache-to-take-a-folio-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/squashfs-convert-squashfs_copy_cache-to-take-a-folio-fix.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: Dan Carpenter <dan.carpenter@linaro.org>
Subject: squashfs: fix a NULL vs IS_ERR() bug
Date: Wed, 8 Jan 2025 12:16:30 +0300

__filemap_get_folio() never returns NULL, it returns error pointers.  This
incorrect check would lead to an Oops on the following line when we pass
"push_folio" to folio_test_uptodate().

Link: https://lkml.kernel.org/r/7b7f44d6-9153-4d7c-b65b-2d78febe6c7a@stanley.mountain
Fixes: ("squashfs; convert squashfs_copy_cache() to take a folio")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Phillip Lougher <phillip@squashfs.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/squashfs/file.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/squashfs/file.c~squashfs-convert-squashfs_copy_cache-to-take-a-folio-fix
+++ a/fs/squashfs/file.c
@@ -406,7 +406,7 @@ void squashfs_copy_cache(struct folio *f
 					FGP_LOCK|FGP_CREAT|FGP_NOFS|FGP_NOWAIT,
 					mapping_gfp_mask(mapping));
 
-		if (!push_folio)
+		if (IS_ERR(push_folio))
 			continue;
 
 		if (folio_test_uptodate(push_folio))
_

Patches currently in -mm which might be from dan.carpenter@linaro.org are

squashfs-convert-squashfs_copy_cache-to-take-a-folio-fix.patch

