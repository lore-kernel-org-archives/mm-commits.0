Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86A331397;
	Fri, 28 Aug 2026 23:39:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787960374; cv=none; b=PXfsXqd+DjowkDPiriTAqfpjdrp21e5tY48ZyoN2iTPlT9yMsISdarrncgj2b5rzkJh7rkSheccTfgRao4O0MVwFSmP98+fiUAzWQBm1ep2c8bhpyrLhm4lHyAqlwum9i4Y57SB0w1x93y0sbnzDciHBNBtrrS9wFVHlpCP5Pcc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787960374; c=relaxed/simple;
	bh=jW7wHBgg0ykThPgRjT9Dn01f3Yonr88GIOEzNzbJqDA=;
	h=Date:To:From:Subject:Message-Id; b=ALhYSq8VJN36SkD05l773bMrL2YXw5GtAYJlL1hN1X9ZTHvZpS/szyJ4QsU6qAn3h0eGNwdtlG693gfDNDN4MNEUIReIWN5WUurAtSC9ka7Eu7JnxQ/3CUPQY0ymRIe/bx4jIbnP4g/Orbl/XFGBag0v6n6QIJjpi4AX6ceNPqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=KC3mwurV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KC3mwurV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F6021F000E9;
	Fri, 28 Aug 2026 23:39:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787960373;
	bh=68NDZ1+i31lU9wiQD7AAoJk1WCdt3GDf3tL9njpHcF4=;
	h=Date:To:From:Subject;
	b=KC3mwurV8M0XTG63uhJ45N42dZOL23BzeKTt36RYtnN1u8S2mExoEByq2QLmyzxze
	 AP6JSYWuEgfOPiMLXSd9decl7M1YGtETdTxQ7r5nxMcc3qgw659Yq6j8w9roTPGKra
	 /kwppDiq4ZX8wM2f+h6Mho2QcmZ5C4IdP8UJJ76g=
Date: Fri, 28 Aug 2026 16:39:32 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,phillip@squashfs.org.uk,kmehltretter@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + squashfs-fix-fragment-index-table-sizing-overflow-on-32-bit.patch added to mm-nonmm-unstable branch
Message-Id: <20260828233933.1F6021F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: squashfs: fix fragment index table sizing overflow on 32-bit
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     squashfs-fix-fragment-index-table-sizing-overflow-on-32-bit.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/squashfs-fix-fragment-index-table-sizing-overflow-on-32-bit.patch

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
Subject: squashfs: fix fragment index table sizing overflow on 32-bit
Date: Sat, 22 Aug 2026 16:33:27 +0200

Patch series "squashfs: harden fragment index table sizing".

Two integer overflows undermine fragment index table handling.  One is in
the original fragment sizing macros.  The other is in a bounds check added
by commit 1cac63cc9b2f ("Squashfs: add sanity checks to fragment reading
at mount time").

Patch 1: the fragment byte count wraps on 32-bit, so the index table is
allocated too small and squashfs_frag_lookup() reads out of bounds.  A
crafted image triggers a KASAN out-of-bounds read on a 32-bit build.  With
the fix the same image fails cleanly at mount.

Patch 2: the check that the table fits before the next one adds two u64
values controlled by the filesystem image and can wrap.


This patch (of 2):

SQUASHFS_FRAGMENT_BYTES() multiplies the on-disk fragment count (an
unsigned int) by sizeof(struct squashfs_fragment_entry), a size_t.  On a
32-bit kernel that product is 32-bit and can wrap.

squashfs_read_fragment_index_table() sizes the fragment index table from
it, but squashfs_frag_lookup() bounds the fragment number against
msblk->fragments, the unwrapped superblock value.  The two disagree: an
image declaring 0x10000001 fragments wraps the product to 16, so a single
index entry is allocated, yet the lookup still accepts fragment
0x0fffffff:

	if (fragment >= msblk->fragments)
		return -EIO;
	block = SQUASHFS_FRAGMENT_INDEX(fragment);
	...
	start_block = le64_to_cpu(msblk->fragment_index[block]);

block is then 524287 and the read lands ~4MB past an 8-byte allocation. 
On a 32-bit build KASAN catches it when the crafted image is mounted and
the file is stat'd.

Cast to u64 in the macro so the multiplication is 64-bit on all targets. 
After conversion to index-table entries, SQUASHFS_FRAGMENT_INDEX_BYTES()
is at most 64 MiB for any u32 count, so it fits both the unsigned int
local and the int argument it feeds.  64-bit builds are unchanged.

Link: https://lore.kernel.org/20260822143328.68867-1-kmehltretter@gmail.com
Link: https://lore.kernel.org/20260822143328.68867-2-kmehltretter@gmail.com
Fixes: ffae2cd73a9e ("Squashfs: header files")
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Assisted-by: Claude:claude-opus-5
Cc: Phillip Lougher <phillip@squashfs.org.uk>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/squashfs/squashfs_fs.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/squashfs/squashfs_fs.h~squashfs-fix-fragment-index-table-sizing-overflow-on-32-bit
+++ a/fs/squashfs/squashfs_fs.h
@@ -136,7 +136,7 @@ static inline int squashfs_block_size(__
 
 /* fragment and fragment table defines */
 #define SQUASHFS_FRAGMENT_BYTES(A)	\
-				((A) * sizeof(struct squashfs_fragment_entry))
+			((u64)(A) * sizeof(struct squashfs_fragment_entry))
 
 #define SQUASHFS_FRAGMENT_INDEX(A)	(SQUASHFS_FRAGMENT_BYTES(A) / \
 					SQUASHFS_METADATA_SIZE)
_

Patches currently in -mm which might be from kmehltretter@gmail.com are

klist-avoid-accesses-after-waking-klist_remove.patch
squashfs-fix-fragment-index-table-sizing-overflow-on-32-bit.patch
squashfs-make-the-fragment-index-table-bounds-check-overflow-safe.patch

