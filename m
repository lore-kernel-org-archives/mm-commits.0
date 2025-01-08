Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B28320B20
	for <mm-commits@vger.kernel.org>; Wed,  8 Jan 2025 04:13:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736309622; cv=none; b=ZRgx3baGTgfhmvahD82jdRWXIhNN4dRp+fZRf5xJ8/ipDp2XygRJ7omHB8cjiwAfyR+KvopshkspCbcs6eQDAirSEHX/euFOwWkR0JNgjjNAHkYmvf0CAhkTrx3QY1GzIurQkj6M+HuXONfr32VeJOufpfoIxxD6ZSrJCFcH+2k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736309622; c=relaxed/simple;
	bh=DuICj2/eVL1IPVSExTZ1Mn1UHXQJTnV3B1qqrDRO0Lw=;
	h=Date:To:From:Subject:Message-Id; b=mwFB90Sxeq8hUa9oUXhcrvhPGfBS/dgYVmDEdlM1bc57SsaEOpiMNDEP2Mb5/v4RityP2I6eAsoJvKruzeaPalnGbGp90uQTz9raqbqMdIaWLGF2dS0beDCHBiGGIMAbUKhyItyzTNTG5tY8yhkseAEqjLP3glEte6ZF7wQuhIk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=x6ELf17V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="x6ELf17V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 028CEC4CED0;
	Wed,  8 Jan 2025 04:13:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736309621;
	bh=DuICj2/eVL1IPVSExTZ1Mn1UHXQJTnV3B1qqrDRO0Lw=;
	h=Date:To:From:Subject:From;
	b=x6ELf17Vwlet3WqAdmvI0s6YD2kJI3ktD4kyNGRDne+2egw9rszdD2eFu9aXjwYv9
	 mEfttoNCJEXXvRzsnRrrN4bJ4FdxsBMU3tgsHXy/080+gdMdxVpd0rqDewlQYTuRPI
	 QkXRnKTIBKWAchpK/hvN/ET9dewfvRhdpwEV/QDM=
Date: Tue, 07 Jan 2025 20:13:40 -0800
To: mm-commits@vger.kernel.org,konishi.ryusuke@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + nilfs2-protect-access-to-buffers-with-no-active-references.patch added to mm-nonmm-unstable branch
Message-Id: <20250108041341.028CEC4CED0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: nilfs2: protect access to buffers with no active references
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     nilfs2-protect-access-to-buffers-with-no-active-references.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/nilfs2-protect-access-to-buffers-with-no-active-references.patch

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
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Subject: nilfs2: protect access to buffers with no active references
Date: Wed, 8 Jan 2025 05:00:47 +0900

nilfs_lookup_dirty_data_buffers(), which iterates through the buffers
attached to dirty data folios/pages, accesses the attached buffers without
locking the folios/pages.

For data cache, nilfs_clear_folio_dirty() may be called asynchronously
when the file system degenerates to read only, so
nilfs_lookup_dirty_data_buffers() still has the potential to cause use
after free issues when buffers lose the protection of their dirty state
midway due to this asynchronous clearing and are unintentionally freed by
try_to_free_buffers().

Eliminate this race issue by adjusting the lock section in this function.

Link: https://lkml.kernel.org/r/20250107200202.6432-3-konishi.ryusuke@gmail.com
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Fixes: 8c26c4e2694a ("nilfs2: fix issue with flush kernel thread after remount in RO mode because of driver's internal error or metadata corruption")
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/segment.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/fs/nilfs2/segment.c~nilfs2-protect-access-to-buffers-with-no-active-references
+++ a/fs/nilfs2/segment.c
@@ -734,7 +734,6 @@ static size_t nilfs_lookup_dirty_data_bu
 		if (!head)
 			head = create_empty_buffers(folio,
 					i_blocksize(inode), 0);
-		folio_unlock(folio);
 
 		bh = head;
 		do {
@@ -744,11 +743,14 @@ static size_t nilfs_lookup_dirty_data_bu
 			list_add_tail(&bh->b_assoc_buffers, listp);
 			ndirties++;
 			if (unlikely(ndirties >= nlimit)) {
+				folio_unlock(folio);
 				folio_batch_release(&fbatch);
 				cond_resched();
 				return ndirties;
 			}
 		} while (bh = bh->b_this_page, bh != head);
+
+		folio_unlock(folio);
 	}
 	folio_batch_release(&fbatch);
 	cond_resched();
_

Patches currently in -mm which might be from konishi.ryusuke@gmail.com are

nilfs2-do-not-force-clear-folio-if-buffer-is-referenced.patch
nilfs2-protect-access-to-buffers-with-no-active-references.patch

