Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9122C1397;
	Fri, 28 Aug 2026 23:39:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787960376; cv=none; b=DAHDWIZ1kEV9GCXcDTfl8Zn0QbjTGQTeXqK0gA39L2Q6IikospIQED8rH8R1B+2wAwdtcdhhqsom50gVo9uH1fMVNpgY68Q//nmpSh5RrvxrTZYc0tCw05ny6Kvpz80k5Aw0ibN0VF2QULmEb7qxbaOsHC6U315owOXqUJYEDz4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787960376; c=relaxed/simple;
	bh=JZp797P4MVnytlL3l2PNQ3mQaAcmN9dbIcpQsU7EmJg=;
	h=Date:To:From:Subject:Message-Id; b=b5hXnHnR6gXLrd2LZt2yhUTSZobvt+fwP65yzw0kAvMAVY46T4HrWz3s/rbUShJ19PYGbveB0uji56L2wFwAI0nom1nDx/TTcKIyqA0XsUFmKTwSsi/VNYxOkUZ+KlOCO9fzDfH772hdXB0Q1FIhmj9c3BQ0MdPtp9R5hF3ZO9g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jzpZO/MU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jzpZO/MU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 217051F000E9;
	Fri, 28 Aug 2026 23:39:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787960375;
	bh=2gel+Vukvr3JZO2r2EJk3cnupOOWaPlKkwW9AimkWlQ=;
	h=Date:To:From:Subject;
	b=jzpZO/MUTX9lGwqkRbtubgW4yjQaQss6zcqBwc9rop1/dJThVdhLgSo/bhiTRVqp7
	 OexUG+7+KonzpP5spT6oX0+YEoDAZd/ufEoayxWO5M8mIYro822r8IcOpsK1dhaUWL
	 bHYEZZ7nkMCmyujroLVy7ts6aJKE+OMxpReXgkqQ=
Date: Fri, 28 Aug 2026 16:39:34 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,phillip@squashfs.org.uk,kmehltretter@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + squashfs-make-the-fragment-index-table-bounds-check-overflow-safe.patch added to mm-nonmm-unstable branch
Message-Id: <20260828233935.217051F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: squashfs: make the fragment index table bounds check overflow-safe
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     squashfs-make-the-fragment-index-table-bounds-check-overflow-safe.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/squashfs-make-the-fragment-index-table-bounds-check-overflow-safe.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: Karl Mehltretter <kmehltretter@gmail.com>
Subject: squashfs: make the fragment index table bounds check overflow-safe
Date: Sat, 22 Aug 2026 16:33:28 +0200

squashfs_read_fragment_index_table() checks that the table fits before the
next one with:

	if (fragment_table_start + length > next_table)
		return ERR_PTR(-EINVAL);

fragment_table_start comes from the superblock and is not validated before
this point.  A start of 2^64 - length wraps the sum to zero, so the check
passes regardless of next_table and fails to reject the invalid table
ordering.

length then reaches kmalloc() through squashfs_read_table().  A fragment
count of 0xffffffff asks for 64MB, order 14.  GFP_KERNEL does not include
__GFP_NOWARN, so the page allocator warns before the mount fails with
-ENOMEM.  With panic_on_warn, the warning panics the kernel.

Compare the operands instead of adding them.  id.c and export.c avoid the
same wrap with an exact-size check.  Keep the inequality here because a
gap before the next table is still allowed.

Link: https://lore.kernel.org/20260822143328.68867-3-kmehltretter@gmail.com
Fixes: 1cac63cc9b2f ("Squashfs: add sanity checks to fragment reading at mount time")
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Assisted-by: Claude:claude-opus-5
Cc: Phillip Lougher <phillip@squashfs.org.uk>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/squashfs/fragment.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/fs/squashfs/fragment.c~squashfs-make-the-fragment-index-table-bounds-check-overflow-safe
+++ a/fs/squashfs/fragment.c
@@ -69,9 +69,11 @@ __le64 *squashfs_read_fragment_index_tab
 	/*
 	 * Sanity check, length bytes should not extend into the next table -
 	 * this check also traps instances where fragment_table_start is
-	 * incorrectly larger than the next table start
+	 * incorrectly larger than the next table start.  Both values are read
+	 * from the filesystem image, so compare without adding them.
 	 */
-	if (fragment_table_start + length > next_table)
+	if (fragment_table_start > next_table ||
+	    length > next_table - fragment_table_start)
 		return ERR_PTR(-EINVAL);
 
 	table = squashfs_read_table(sb, fragment_table_start, length);
_

Patches currently in -mm which might be from kmehltretter@gmail.com are

klist-avoid-accesses-after-waking-klist_remove.patch
squashfs-fix-fragment-index-table-sizing-overflow-on-32-bit.patch
squashfs-make-the-fragment-index-table-bounds-check-overflow-safe.patch

