Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794539216;
	b=XIbMnP1lt3gonRdSQe58SugmQXMcCM5hZPBTvtmzOUHsKATrNKgDD1plR0ZTkV9beSbe
	 bGkcGoqalx62isDxWrRRrgPEdOT8DPbbPi2vT3hh/d5vyMiizDZZtQlRebwiFA6zGHwgt
	 X27MX/O9kRaTLTHw5wVmGmHIIUotnovVyyTst9s4K5ai3A6n8EOzJNpzOWnJ8xQLaQscs
	 uKeu4vtYJ1F7XF6rJwhF77+jBdpzEh5MsAd4P2hTLRqG5AGW4ms6e5OMXPt2S5fCM/DSc
	 zjAuzCOFpfgjAMySVYCRXqfz7ly/x0D8qbUirlE50JpCUlXdOK6rBMuvcq2FQEPcDWw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794539216;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=aCNUZLhrcivd0AJt+vf1pLWb5VPgRNTU+lwhHQXhqoY=;
	b=quahpqZBYX7x0iJL9800uD2DDq3eL0MVrnBRgV3UhwBCRt+rblqMJ4fxjHnlHAHrTC7L
	 Vv2T7a3QrKV/NtJIcuD/TU7ili0UpHS0YYSgFuX8vyn5JpukDr1izKaYODeFFJHYJrHHh
	 j5/5tou3iWuU4t9/A9JkoFfuJuxEbJZ+PxifjkRikpr0I+goRRwQyCntgZoABVxPj0kJY
	 dB4yhaSLIh6g9QdcaQq2kDQSFZMSNiJb5Gxdd+BxPFZK7I63Wp8rKS/xejw7AIpaqsYXW
	 VpTGaXbmP22OebKL+n/ghbvdJpJ17b4JSsSwIuyV0jG9jTKlEx35YUfPzNrmCou9Quw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=ntibkS5C;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 221F4606A323;
	Fri, 13 Nov 2026 03:06:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=ntibkS5C
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 909501F000C4;
	Fri, 13 Nov 2026 03:06:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794539215;
	bh=aCNUZLhrcivd0AJt+vf1pLWb5VPgRNTU+lwhHQXhqoY=;
	h=Date:To:From:Subject;
	b=ntibkS5CRMJkJtRFbhqMtJOrSjB56VGyhinutsb9unK+XIAKw9ViHxKrZVIZuUtG2
	 OieyRekMMJpd9tffIr4P95eMM6AHupU4sBNuC5e4TUGW3JuofuhM0bBgxYoxIBOZLg
	 70L90Q+/0oyLn1e6ENCEYz96jXUAIUzhXkIP9aM4=
Date: Thu, 12 Nov 2026 19:06:55 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,phillip@squashfs.org.uk,
	kmehltretter@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [obsolete] squashfs-fix-fragment-index-table-sizing-overflow-on-32-bit.patch removed from -mm tree
Message-Id: <20261113030655.909501F000C4@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: squashfs: fix fragment index table sizing overflow on 32-bit
has been removed from the -mm tree.  Its filename was
     squashfs-fix-fragment-index-table-sizing-overflow-on-32-bit.patch

This patch was dropped because it is obsolete

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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Assisted-by: Claude:claude-opus-5
Cc: Phillip Lougher <phillip@squashfs.org.uk>
Cc: <stable@vger.kernel.org>
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

userfaultfd-docs-fix-an-error-code-two-names-and-the-pollerr-cause.patch
squashfs-make-the-fragment-index-table-bounds-check-overflow-safe.patch

