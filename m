Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E7E41D5ABD
	for <mm-commits@vger.kernel.org>; Thu, 17 Oct 2024 21:39:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729201144; cv=none; b=MKwrGeiKDFdLKasDrShtq+bz33WsjTHBiSDhI62MlyYjfjK+TikaoRwQ7t9LaPEbwcnP0o+XgoP8ZlHBIuDaLzl0yEhbcXbYQkiwjQvbOzTTTZgOB9G/xOSjXug8RS4mAbPlzdeic1f1Y4YgWjlRDFDuZ/PzDpSbFNVtbgWNFio=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729201144; c=relaxed/simple;
	bh=lT6PbgrezXh5BNNJPdHQ7Jptqv2LuOB1GCHqrNyeKmQ=;
	h=Date:To:From:Subject:Message-Id; b=UCVd5lZah4tRqNRyBgcGkS4IgAT/Va5iUUxVIKaB++6ifDgBxNemE+cVksNadgX1Cx0a8mlEbcID5Y/m5UgzYY4TNhm2p47gu8BLkACvLZzDiaBXKhEPxQZyS5vWO8Ceqc8Rmth/mlHSIV2g5sz+hxsXo3sBRTkeUd5R5+jGRw4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qd8KFoFs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qd8KFoFs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7467CC4CEC3;
	Thu, 17 Oct 2024 21:39:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1729201143;
	bh=lT6PbgrezXh5BNNJPdHQ7Jptqv2LuOB1GCHqrNyeKmQ=;
	h=Date:To:From:Subject:From;
	b=qd8KFoFsi+VaqhW3vRM24S1Mkpw3H+0WIBDT8OQWsiK+dJnADoVEYVMfi5q0vPHnR
	 CbvypMBCdHdAXsUpXsLSVqgzV5UVArQiMeai6mW52PznyRm+7r5HaOij2vy4/SUyXO
	 dzJv4JUGD9Aunw21bPOuIkx9vfVbNRQDyaAZW5ck=
Date: Thu, 17 Oct 2024 14:38:57 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,viro@zeniv.linux.org.uk,jack@suse.cz,hughd@google.com,david@redhat.com,brauner@kernel.org,baolin.wang@linux.alibaba.com,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + tmpfs-dont-enable-large-folios-if-not-supported.patch added to mm-unstable branch
Message-Id: <20241017213903.7467CC4CEC3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: tmpfs: don't enable large folios if not supported
has been added to the -mm mm-unstable branch.  Its filename is
     tmpfs-dont-enable-large-folios-if-not-supported.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/tmpfs-dont-enable-large-folios-if-not-supported.patch

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
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: tmpfs: don't enable large folios if not supported
Date: Thu, 17 Oct 2024 22:17:42 +0800

tmpfs can support large folios, but there are some configurable options
(mount options and runtime deny/force) to enable/disable large folio
allocation, so there is a performance issue when performing writes without
large folios.  The issue is similar to commit 4e527d5841e2 ("iomap: fault
in smaller chunks for non-large folio mappings").

Since 'deny' is for emergencies and 'force' is for testing, performance
issues should not be a problem in real production environments, so don't
call mapping_set_large_folios() in __shmem_get_inode() when large folio is
disabled with mount huge=never option (default policy).

Link: https://lkml.kernel.org/r/20241017141742.1169404-1-wangkefeng.wang@huawei.com
Fixes: 9aac777aaf94 ("filemap: Convert generic_perform_write() to support large folios")
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/mm/shmem.c~tmpfs-dont-enable-large-folios-if-not-supported
+++ a/mm/shmem.c
@@ -2845,7 +2845,10 @@ static struct inode *__shmem_get_inode(s
 	cache_no_acl(inode);
 	if (sbinfo->noswap)
 		mapping_set_unevictable(inode->i_mapping);
-	mapping_set_large_folios(inode->i_mapping);
+
+	/* Don't consider 'deny' for emergencies and 'force' for testing */
+	if (sbinfo->huge)
+		mapping_set_large_folios(inode->i_mapping);
 
 	switch (mode & S_IFMT) {
 	default:
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

mm-remove-unused-hugepage-for-vma_alloc_folio.patch
tmpfs-dont-enable-large-folios-if-not-supported.patch

