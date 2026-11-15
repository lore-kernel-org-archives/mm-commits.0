Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794783682;
	b=37ulUQYV5sx5NdUoWpEtHqRWswHF2RxN8j/8ziM/Gniv+kopPOJyko984njKmHK4snkk
	 R9jhkp3mpa+ppsgAm0dMQwVvHAwocK1WlMdiL7Z7LcWAeMTU/nCraCmtXraBVgaVj2d/b
	 lwfIIXgzu4c9fHvJflnsS0yb2v7D5kgb6AD0c5zlPNy4yHRE5WsuU3aCqcd7L0yImyBjd
	 57AWvnXujqkF3I802EGnQXhVie8iaru3USDe7Q9U8/39wVpVyoTojlHBd3R0i4T129Who
	 FzUNRJIDqBqcvm00K0Re6/rZlILgJtPt6meWSCJYJHN9E03z3rbdEjANw/m+jEQx3oA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794783682;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=6g8JTVSLBsKLhqOkVttdCkVyuo0+rrMFkhzuEtSx9hI=;
	b=bIA21Olt/XVNEPSAYrf8LhNCznH9/AES6AYwFd489Ukias3QpBHA0P6lZtCtEwFYwK99
	 FJaJ0DiKPY19/eBme0nbfawgTfyPc8GBG8b3Zn61IgBfjsqYmViCVqhHb/EtjqOEcuhY9
	 8mCDrUNGku+jnv1rmEsahCuubnSCLgkt6mEsBqvSSwloKOdEwx8hYCTAl7cAqZA4K2xpq
	 yEATi9kSkWTm/wq1nAw0biNvIYRcB+WJC81Qc+RI5Sg2BVtQo4MLxNdkYE9h+mZ31yHjW
	 jq/qXEroqdCstv+FpSXg2UVdnZ6cQOcNxwc2ql3BQdqG4LjuHYVQS2OZtNwYlMgcbJQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=ghFzYW3f;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F3D1606A323;
	Sun, 15 Nov 2026 23:01:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=ghFzYW3f
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED35B1F000C4;
	Sun, 15 Nov 2026 23:01:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794783682;
	bh=6g8JTVSLBsKLhqOkVttdCkVyuo0+rrMFkhzuEtSx9hI=;
	h=Date:To:From:Subject;
	b=ghFzYW3fi6JJEUyfZ8fpbTX5IN4lFGMqUkYn9A/YFryYDPLUD5F47TrRQxuHutcki
	 9iT3Q3DPMs+IO/ZTKLXKxNETATM6SRr5RmCAFFdcJZCeKfB3GYQ6yjWirVGwEa2KRy
	 RSJCCHFtODe1m8mk12bSC7s+oBHu7e9xnW8gAKz4=
Date: Sun, 15 Nov 2026 15:01:21 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,phillip@squashfs.org.uk,
	guozh23@xiaopeng.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + squashfs-read-symlink-error-before-putting-cache-entry.patch added to mm-nonmm-unstable branch
Message-Id: <20261115230121.ED35B1F000C4@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: squashfs: read symlink error before putting cache entry
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     squashfs-read-symlink-error-before-putting-cache-entry.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/squashfs-read-symlink-error-before-putting-cache-entry.patch

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
From: Guo Zihao <guozh23@xiaopeng.com>
Subject: squashfs: read symlink error before putting cache entry
Date: Thu, 29 Oct 2026 15:25:42 +0800

In the read error path of squashfs_symlink_readpage() the entry is
put back before its error value is read:

squashfs_cache_put(entry);
= entry->error;

Once the reference count drops to zero another thread can take the entry
back from the cache for a different block and overwrite entry->error, so
the value read here may be stale.  Read the error before dropping the
reference.

Link: https://lore.kernel.org/20261029072542.4131873-1-guozh23@xiaopeng.com
Fixes: 675f02e5e656 ("squashfs: convert squashfs_symlink_read_folio to use folio APIs")
Signed-off-by: Guo Zihao <guozh23@xiaopeng.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Phillip Lougher <phillip@squashfs.org.uk>
Cc: <stable@vger.kernel.org>

 fs/squashfs/symlink.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/squashfs/symlink.c~squashfs-read-symlink-error-before-putting-cache-entry
+++ a/fs/squashfs/symlink.c
@@ -74,8 +74,8 @@ static int squashfs_symlink_read_folio(s
 			ERROR("Unable to read symlink [%llx:%x]\n",
 				squashfs_i(inode)->start,
 				squashfs_i(inode)->offset);
-			squashfs_cache_put(entry);
 			error = entry->error;
+			squashfs_cache_put(entry);
 			goto out;
 		}
 
_

Patches currently in -mm which might be from guozh23@xiaopeng.com are

squashfs-read-symlink-error-before-putting-cache-entry.patch

