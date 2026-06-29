Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A627F35DA40;
	Mon, 29 Jun 2026 23:22:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782775343; cv=none; b=f0ktdLV+IMCyEiIfO38XYVos199U0YJ6f4/jA0u0OO0woxiTViR4PegoZDJMkvBEKfst1Ff19WuVHtcz9LoMTzfibgCDExSyzAs+XVDsotLUZulqidUSWh6UHCM12JIatDQJSPu1BhvG0JwabzwzrOM/CsvllKw+US9wM45k5kc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782775343; c=relaxed/simple;
	bh=k2+1OLQNa725jefBDgGD+WQyO9O7Dft3sqf3EADo5aE=;
	h=Date:To:From:Subject:Message-Id; b=qaCQdfWtdMrADF1N+kQXnTHuLxxmlVeDhytoGU4ChvZLSSDBxC8O6jKV+otjl9zBuXsL7rHiXx7YW4IPjX5hdD0RgrUoaqUILAFT6y+BiTLZBR/teGmv82otHX0wGq7fkUWavrTxWos60OcyFO5n6SY8QK2b4B5+2WI2zS91WnI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=J1LrFJll; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="J1LrFJll"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 286811F000E9;
	Mon, 29 Jun 2026 23:22:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782775342;
	bh=17iU6tyFBl2WrdWmQwg3c/M9i/m6l8NqvW+GkbVilFU=;
	h=Date:To:From:Subject;
	b=J1LrFJllSSZCZUOFixtEVuvopf1ut68GSPRIvrr04l7Ta6qxZnmdI9YmFNwyocR9v
	 Gxvhh8wbQTUhBQ8H54IUFb4gYG5oX5YEHsLJ/uzEOAoFUDraEY8b0U/IpzAUV82zAJ
	 w3D6gekoiFroGfcP2pAk8Aqhd7PUor2OTzYkbu9k=
Date: Mon, 29 Jun 2026 16:22:21 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,viro@zeniv.linux.org.uk,vbabka@kernel.org,stable@vger.kernel.org,liam@infradead.org,jannh@google.com,jack@suse.cz,david@kernel.org,brauner@kernel.org,pfalcato@suse.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-do-file-ownership-checks-with-the-proper-mount-idmap.patch added to mm-hotfixes-unstable branch
Message-Id: <20260629232222.286811F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: do file ownership checks with the proper mount idmap
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-do-file-ownership-checks-with-the-proper-mount-idmap.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-do-file-ownership-checks-with-the-proper-mount-idmap.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: Pedro Falcato <pfalcato@suse.de>
Subject: mm: do file ownership checks with the proper mount idmap
Date: Thu, 25 Jun 2026 16:38:53 +0100

Ever since idmapped mounts were introduced, inode ownership checks (for
side-channel protection) in mincore() and madvise(MADV_PAGEOUT) were done
against the nop_mnt_idmap, which completely ignores the file's mount's
idmap.  This results in odd edgecases like:

1) mount/bind-mount with an idmap userA:userB:1
2) userB runs an owner_or_capable() check on file that is owned by userA
on-disk/in-memory, but owned by userB after idmap translation
3) owner_or_capable() mysteriously fails as the correct idmap wasn't supplied

In the case of mincore/madvise MADV_PAGEOUT, this is usually benign,
because file_permission(file, MAY_WRITE) will probably succeed, as it uses
the proper idmap internally, but it does not need to be the case on e.g a
0444 file where even the owner itself doesn't have permissions to write to
it.

Since this is clearly not trivial to get right, introduce a
file_owner_or_capable() that can carry the correct semantics, and switch
the various users in mm to it.

The issue was found by manual code inspection & an off-list discussion
with Jan Kara.

Link: https://lore.kernel.org/20260625153853.913949-1-pfalcato@suse.de
Fixes: 9caccd41541a ("fs: introduce MOUNT_ATTR_IDMAP")
Signed-off-by: Pedro Falcato <pfalcato@suse.de>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Christian Brauner (Amutable) <brauner@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Jann Horn <jannh@google.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/fs.h |    5 +++++
 mm/filemap.c       |    2 +-
 mm/madvise.c       |    3 +--
 mm/mincore.c       |    3 +--
 4 files changed, 8 insertions(+), 5 deletions(-)

--- a/include/linux/fs.h~mm-do-file-ownership-checks-with-the-proper-mount-idmap
+++ a/include/linux/fs.h
@@ -2444,6 +2444,11 @@ static inline struct mnt_idmap *file_mnt
 	return mnt_idmap(file->f_path.mnt);
 }
 
+static inline bool file_owner_or_capable(const struct file *file)
+{
+	return inode_owner_or_capable(file_mnt_idmap(file), file_inode(file));
+}
+
 /**
  * is_idmapped_mnt - check whether a mount is mapped
  * @mnt: the mount to check
--- a/mm/filemap.c~mm-do-file-ownership-checks-with-the-proper-mount-idmap
+++ a/mm/filemap.c
@@ -4704,7 +4704,7 @@ static inline bool can_do_cachestat(stru
 {
 	if (f->f_mode & FMODE_WRITE)
 		return true;
-	if (inode_owner_or_capable(file_mnt_idmap(f), file_inode(f)))
+	if (file_owner_or_capable(f))
 		return true;
 	return file_permission(f, MAY_WRITE) == 0;
 }
--- a/mm/madvise.c~mm-do-file-ownership-checks-with-the-proper-mount-idmap
+++ a/mm/madvise.c
@@ -336,8 +336,7 @@ static inline bool can_do_file_pageout(s
 	 * otherwise we'd be including shared non-exclusive mappings, which
 	 * opens a side channel.
 	 */
-	return inode_owner_or_capable(&nop_mnt_idmap,
-				      file_inode(vma->vm_file)) ||
+	return file_owner_or_capable(vma->vm_file) ||
 	       file_permission(vma->vm_file, MAY_WRITE) == 0;
 }
 
--- a/mm/mincore.c~mm-do-file-ownership-checks-with-the-proper-mount-idmap
+++ a/mm/mincore.c
@@ -227,8 +227,7 @@ static inline bool can_do_mincore(struct
 	 * for writing; otherwise we'd be including shared non-exclusive
 	 * mappings, which opens a side channel.
 	 */
-	return inode_owner_or_capable(&nop_mnt_idmap,
-				      file_inode(vma->vm_file)) ||
+	return file_owner_or_capable(vma->vm_file) ||
 	       file_permission(vma->vm_file, MAY_WRITE) == 0;
 }
 
_

Patches currently in -mm which might be from pfalcato@suse.de are

mm-do-file-ownership-checks-with-the-proper-mount-idmap.patch

