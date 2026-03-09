Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C30E41F181F
	for <mm-commits@vger.kernel.org>; Mon,  9 Mar 2026 17:44:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773078298; cv=none; b=CWj57YBfGBb1XwLw0L6sJOKJDgQV7xKGwqnMmfBCP1Lb3BeLvNUrTF7MzMeYULfAwHQLrt8ZwXJuBFRSDj8wKlpOAoIiTrCdK7eCJmlaBEa7RIQzjhNnCX9+HONqhFejV+LM3j3UGNDhe15CxvUFYCGbdBltZKboDhSZXemgGKY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773078298; c=relaxed/simple;
	bh=iW4i4G6FBnQuLZbAh1gw6lTAabseywYi1ioZrZNc+jo=;
	h=Date:To:From:Subject:Message-Id; b=jXHn7TJnzJhbfNbUPMLBZlOWjvMmh+WUcqV45r5CcYyNJILdWg92QPD7m3dDl/nPAkoyx5G3JjeN73LXiGF31l35C9WIQBATXzQEmjWCxYNe8pYnaup7nk3oSwd4kH/tuDD8YT16fDV/Nul9zS0EMsftx4jpKOm061s3545kziY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qTgqjYFk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qTgqjYFk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47CD1C4CEF7;
	Mon,  9 Mar 2026 17:44:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1773078298;
	bh=iW4i4G6FBnQuLZbAh1gw6lTAabseywYi1ioZrZNc+jo=;
	h=Date:To:From:Subject:From;
	b=qTgqjYFk/ci/1YQpceReU5/mZtWKGL8w+8FBgMMKTLKEiwdnH7k0Vqk9FgtIjQTZo
	 1q/Juzl/75Bq5euyWaGR01IuhxUV/kjM6b5vEVyRjcFOTsjWzq7aV5PfWeV4cB2G69
	 diyJxu+xzAS0ojQilfsYouXdRW2Kdypu422UOTxA=
Date: Mon, 09 Mar 2026 10:44:57 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@kernel.org,surenb@google.com,rppt@kernel.org,nathan@kernel.org,morbo@google.com,ljs@kernel.org,liam.howlett@oracle.com,justinstitt@google.com,david@kernel.org,qq570070308@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-optimize-the-implementation-of-warn_on_once_gfp.patch added to mm-new branch
Message-Id: <20260309174458.47CD1C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: optimize the implementation of WARN_ON_ONCE_GFP()
has been added to the -mm mm-new branch.  Its filename is
     mm-optimize-the-implementation-of-warn_on_once_gfp.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-optimize-the-implementation-of-warn_on_once_gfp.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
From: Xie Yuanbin <qq570070308@gmail.com>
Subject: mm: optimize the implementation of WARN_ON_ONCE_GFP()
Date: Mon, 9 Mar 2026 23:38:11 +0800

As shown in the commit message of commit 242b872239f6a7deacbc
("include/linux/once_lite.h: fix judgment in WARN_ONCE with clang"), the
code "unlikely(a && b)" may generate poor assembly code if it is actually
"unlikely(a) && unlikely(b)" or "unlikely(a) && b".

WARN_ON_ONCE_GFP() may be used in the hot path code:
1. The argument cond shoud be unlikely.
2. When "1." is true, !(gfp & __GFP_NOWARN) is unlikely, otherwise, a
   WARN may be triggered, which is a very unlikely case.
3. When "1. && 2." is true, just like the implementation of WARN_ONCE(),
   !__warned can be unlikely.

Reorder __ret_warn_once judgement to first and split out the unlikely() in
WARN_ON_ONCE_GFP() to optimize performance.

Link: https://lkml.kernel.org/r/20260309153811.40958-1-qq570070308@gmail.com
Signed-off-by: Xie Yuanbin <qq570070308@gmail.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Bill Wendling <morbo@google.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Justin Stitt <justinstitt@google.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/internal.h~mm-optimize-the-implementation-of-warn_on_once_gfp
+++ a/mm/internal.h
@@ -94,7 +94,8 @@ struct pagetable_move_control {
 	static bool __section(".data..once") __warned;			\
 	int __ret_warn_once = !!(cond);					\
 									\
-	if (unlikely(!(gfp & __GFP_NOWARN) && __ret_warn_once && !__warned)) { \
+	if (unlikely(__ret_warn_once) &&				\
+	    unlikely(!(gfp & __GFP_NOWARN)) && unlikely(!__warned)) {	\
 		__warned = true;					\
 		WARN_ON(1);						\
 	}								\
_

Patches currently in -mm which might be from qq570070308@gmail.com are

mm-optimize-the-implementation-of-warn_on_once_gfp.patch

