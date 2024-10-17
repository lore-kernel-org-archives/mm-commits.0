Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 169C8168BD;
	Thu, 17 Oct 2024 20:50:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729198244; cv=none; b=SI/ilCfJSTd9OzYp30G9gfq/xEIW6q4oC4myApkuPaf/3dWO03T7xK8PLmFeYv97oTXQua5y2BcnUPikdrhLrTR5fZ/MsE7J1OtZ+5HOwgwIC2oQMijGwNh9PmJxv1UyxcDjMfdZmU7qq8NXK+EKBl/cWfRqRxo7Q9jTHf4zSjo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729198244; c=relaxed/simple;
	bh=b5oJE6B+hBlpogtdFc7EagMz2lcDEyVSsho1i2+3Qk4=;
	h=Date:To:From:Subject:Message-Id; b=iNb0STq+EKU5SoPlDxSOLyspJB30DzbeEfXUsUg6ff8ivFrVxTToJxcFIhEuw1XL8GR3SlZxxkHBVLxY09YHx/jCnwSZegMsAUK/W0lApfZA4VFDnQRKTkm+K8BJQaNZZHd51RZT0R+xwXnmDl+bLyESSUBzu4TvhXbVPaiWAlc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=XiKRK9CU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XiKRK9CU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75422C4CEC3;
	Thu, 17 Oct 2024 20:50:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1729198243;
	bh=b5oJE6B+hBlpogtdFc7EagMz2lcDEyVSsho1i2+3Qk4=;
	h=Date:To:From:Subject:From;
	b=XiKRK9CUivVKmOBaBE2GzTBTJeYRMcttu7isERADtAen/j6LYxMdhNv/R5eZ0DUod
	 W29TcTZYtvuTOxbQI4+4i7RjsyA75/hkgH3xA9P2zPXVixpsZPLOlJtwgEdJBFaJ+T
	 Uv1n/DbBiLarjRs84OrfwmqQclT19AoS+rEsQG6A=
Date: Thu, 17 Oct 2024 13:50:42 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,konishi.ryusuke@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + nilfs2-fix-kernel-bug-due-to-missing-clearing-of-checked-flag.patch added to mm-hotfixes-unstable branch
Message-Id: <20241017205043.75422C4CEC3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: nilfs2: fix kernel bug due to missing clearing of checked flag
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     nilfs2-fix-kernel-bug-due-to-missing-clearing-of-checked-flag.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/nilfs2-fix-kernel-bug-due-to-missing-clearing-of-checked-flag.patch

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
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Subject: nilfs2: fix kernel bug due to missing clearing of checked flag
Date: Fri, 18 Oct 2024 04:33:10 +0900

Syzbot reported that in directory operations after nilfs2 detects
filesystem corruption and degrades to read-only,
__block_write_begin_int(), which is called to prepare block writes, may
fail the BUG_ON check for accesses exceeding the folio/page size,
triggering a kernel bug.

This was found to be because the "checked" flag of a page/folio was not
cleared when it was discarded by nilfs2's own routine, which causes the
sanity check of directory entries to be skipped when the directory
page/folio is reloaded.  So, fix that.

This was necessary when the use of nilfs2's own page discard routine was
applied to more than just metadata files.

Link: https://lkml.kernel.org/r/20241017193359.5051-1-konishi.ryusuke@gmail.com
Fixes: 8c26c4e2694a ("nilfs2: fix issue with flush kernel thread after remount in RO mode because of driver's internal error or metadata corruption")
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Reported-by: syzbot+d6ca2daf692c7a82f959@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=d6ca2daf692c7a82f959
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/page.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/nilfs2/page.c~nilfs2-fix-kernel-bug-due-to-missing-clearing-of-checked-flag
+++ a/fs/nilfs2/page.c
@@ -401,6 +401,7 @@ void nilfs_clear_folio_dirty(struct foli
 
 	folio_clear_uptodate(folio);
 	folio_clear_mappedtodisk(folio);
+	folio_clear_checked(folio);
 
 	head = folio_buffers(folio);
 	if (head) {
_

Patches currently in -mm which might be from konishi.ryusuke@gmail.com are

nilfs2-fix-kernel-bug-due-to-missing-clearing-of-buffer-delay-flag.patch
nilfs2-fix-kernel-bug-due-to-missing-clearing-of-checked-flag.patch

