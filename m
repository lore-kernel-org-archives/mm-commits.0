Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50B6F3806AF
	for <mm-commits@vger.kernel.org>; Fri,  7 Aug 2026 18:59:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786129200; cv=none; b=a40HkSj6aDQ7jv/3/IodaWcBaU7j3aVBB/lhoS9cTqCZ3quPnsunrHIAH4mOD9hg528/75xsV2eeqDXV33+CsOwYd2CL0eEPYf0kLYPh3fLsoJP1wPGIztncHih6eq48PKOw+/6QvSboNuENkJ//itsoL7/DvYGDaLkSu+HeZ4U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786129200; c=relaxed/simple;
	bh=M0qD7x6ZDJK5oTOioMGsxgsqkD5KtpEhfChQiYkK5mM=;
	h=Date:To:From:Subject:Message-Id; b=TL+UI0amnBH7FlZlwf7fRI3BJnsYrQbACZRAzulohX4RjeizaGIq2rl0hQFzMlk/2ICo28ylYuWXvqqekYs9fksTZR0cvrO86V9cPrK3q3ehmx8I0G+BRvmL5UuWU8iyFO6xFPxhniinYTm0NQmy13eylM81K7meQdHAhbrxquQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=MXSwkZeg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="MXSwkZeg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 471861F000E9;
	Fri,  7 Aug 2026 18:59:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786129197;
	bh=WETTctXA+nKn/CL8fxBZS0ePvZAUAxUUxUcthgra5yo=;
	h=Date:To:From:Subject;
	b=MXSwkZegdSswVTthgAzlZ5eVUNe61iN2VElKvPU45DAGwfIXEW0sxBZvbqKFkQU1D
	 yIJEb+y9PNwM96Ov/WdeWSj3o2giBW/9xQ+2ZTaFZ/CFmIP9pFymdXj7rwrbAC/B6q
	 JsdootrjI1QO1gB519LDkt83veCRAudxffCx5A/k=
Date: Fri, 07 Aug 2026 11:59:56 -0700
To: mm-commits@vger.kernel.org,syjcnss@gmail.com,phillip@squashfs.org.uk,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + squashfs-check-block-offset-is-not-negative.patch added to mm-nonmm-unstable branch
Message-Id: <20260807185957.471861F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: Squashfs: check block offset is not negative
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     squashfs-check-block-offset-is-not-negative.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/squashfs-check-block-offset-is-not-negative.patch

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
From: Phillip Lougher <phillip@squashfs.org.uk>
Subject: Squashfs: check block offset is not negative
Date: Fri, 7 Aug 2026 17:29:51 +0100

If a negative offset is read off disk (for example the offset into the
decompressed fragment block), this will cause squashfs_copy_data() to
perform an out of bounds access.

Fix by checking if offset is negative, and returning 0.  This matches
existing behaviour where an offset beyond the block returns 0 bytes
copied.

To trigger this out of bounds access requires a crafted Squashfs
filesystem and CAP_SYS_ADMIN to mount it.  Unprivileged users will not be
able to mount such a filesystem, but once mounted, an unprivileged user
can trigger the out of bounds access by reading the crafted file with the
negative offset.

Link: https://lore.kernel.org/20260807162951.672510-1-phillip@squashfs.org.uk
Fixes: f400e12656ab ("Squashfs: cache operations")
Signed-off-by: Phillip Lougher <phillip@squashfs.org.uk>
Reported-by: Yuejie Shi <syjcnss@gmail.com>
Closes: https://lore.kernel.org/all/20260803032735.81785-1-syjcnss@gmail.com/
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/squashfs/cache.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/squashfs/cache.c~squashfs-check-block-offset-is-not-negative
+++ a/fs/squashfs/cache.c
@@ -299,7 +299,7 @@ int squashfs_copy_data(void *buffer, str
 {
 	int remaining = length;
 
-	if (length == 0)
+	if (length == 0 || offset < 0)
 		return 0;
 	else if (buffer == NULL)
 		return min(length, entry->length - offset);
_

Patches currently in -mm which might be from phillip@squashfs.org.uk are

maintainers-remove-git-url-for-squashfs.patch
squashfs-check-block-offset-is-not-negative.patch

