Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794539084;
	b=jSdB65lKK1u/ilCVrhWvurQHIF/a+o3rYit0DdKqhb3Nw9j4kpKqgd1hdGvqD5F/m4RZ
	 aqUInd/J7yzITXOQQdaXr+DZpFE8+Y6kqVw+x+xqZbOXyKu1TqeuSqa4ku+seqFcTb7Ib
	 uI+Q8Teh/ec2IX/BVmVkh/+Zrmug7qV74gE+2Mt6XC/bPBv+6rrkzZ9M5VlEO7BnqLVeY
	 m3+74N+FWhF8ZwAaJ1vUmV8wwfs7A/a6RYxw6crU3FfLk8T0EXpEaMTn9Ic9fz6qLg4sB
	 iadqV3gLHivpd5WacWpvOYuewUmWwSKVGltkvbdRHxhZUrlV4SUuJSwlq0SsxTcYJqw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794539084;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=OchJebQWWvO5xwStwPSGEYDaM1cAO4y98APdKg/rRkc=;
	b=XlH76K5N7uaC5RZOib+wjtrcRZec3u0jkjOoK4leOdpd4UNMsd//kSV/GTTd8TFvzWE+
	 uAev5Ut7h8kQdrHseaeHVlupPkox2NaKYljeHKz40NSRvA0eC/DkKgxkIM/2q36wrjLd6
	 8BXv7m1vnZPbLU6hJod/afMF55tSalHy92dCeyAg/Y4TU/oJXt2VV8MaFjp2Q/FD+V+kT
	 vQ/wSMgwjXvCBQCDovzHaW5MgSenXIVC40YEz891X/9RSkePuidi18ZPlYlQJgFmeHk+b
	 IC9PA9Ji+jt7kWBeVOGPGI/YvkTBKTH476cmR46Van2Vxmh4HdnXUWuaUrYmlHMg6lg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=KLUYYvBD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6BA7606A321;
	Fri, 13 Nov 2026 03:04:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=KLUYYvBD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D4221F000C4;
	Fri, 13 Nov 2026 03:04:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794539083;
	bh=OchJebQWWvO5xwStwPSGEYDaM1cAO4y98APdKg/rRkc=;
	h=Date:To:From:Subject;
	b=KLUYYvBDqVOLKhy5pAYC5m0xgo+WWqxumi2456YVtpn6BSUp7GtOWdZ2itcE9Whqq
	 e0pl9s1na6BsoJKwc/R4aMl8p0CbIE+fYuMbVp3QIwv9zeiWg41bP9lsMEby3JF6if
	 HxAyHkSBT6EVLXA64oz+c3jraSb9Rs2Dan2oRSn4=
Date: Thu, 12 Nov 2026 19:04:42 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,phillip@squashfs.org.uk,
	kmehltretter@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [obsolete] squashfs-make-the-fragment-index-table-bounds-check-overflow-safe.patch removed from -mm tree
Message-Id: <20261113030443.2D4221F000C4@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: squashfs: make the fragment index table bounds check overflow-safe
has been removed from the -mm tree.  Its filename was
     squashfs-make-the-fragment-index-table-bounds-check-overflow-safe.patch

This patch was dropped because it is obsolete

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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Assisted-by: Claude:claude-opus-5
Cc: Phillip Lougher <phillip@squashfs.org.uk>
Cc: <stable@vger.kernel.org>
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

userfaultfd-docs-fix-an-error-code-two-names-and-the-pollerr-cause.patch
squashfs-fix-fragment-index-table-sizing-overflow-on-32-bit.patch

