Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F07A9388E76
	for <mm-commits@vger.kernel.org>; Thu, 13 Aug 2026 21:17:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786655875; cv=none; b=U8L/tsH30wwYJTM4z6OzCKGw+c1rU5xLXdVV/W9cZhiHQJWv0XNkW08k3Xwcf7gGZ2C+6l6SJ0JWuXLP232lC9L07Cr4sY9gjBS2x2Q+NcFEdDR7ZlG8gwYi0UcZaxTv3Lw0IB0DWbViCLTmIyEAFCyvokxRMtfYfABXBcEqUiA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786655875; c=relaxed/simple;
	bh=tpkMwqLnOGQxrySo0k4SYtnfm8F1qhx7ls56Sg9+GHk=;
	h=Date:To:From:Subject:Message-Id; b=pmnn0WkGTtmjh+D2IMx6sYLGZW4LN89AyxqPNDLOWeljggIm1N3AJ99W2H/t4BCVXjttrUzhAYlg+QoZfWRTiCzeNSzqijvfFVMKQs+pOVpYQ/yhr/nVUlIGxy7BkckbYpxcQjIPgtB3MTN2m/fgV3JPdodVK3RCZqqzbgrLlhU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=BKbyHkP8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="BKbyHkP8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F4021F000E9;
	Thu, 13 Aug 2026 21:17:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786655852;
	bh=I2Zq/ZwH8pc4ZzaHas97R8wUfJ/4bx/xT8z2kBC5ibg=;
	h=Date:To:From:Subject;
	b=BKbyHkP8FbChHSt78Q4VzWkh05Dh8usfAaT85LXb4OhNJvQ95QxfOWKrz/JUicF3m
	 5YLpTXrfU+0zMscai6dhMTC0iwnfK/vq56MJ3w2QGvnQhKq5fCNmJvyY6lp50435vP
	 UqQIMFCHyat9nikciX8BvygqXpRAC9NwP+4vQK/k=
Date: Thu, 13 Aug 2026 14:17:31 -0700
To: mm-commits@vger.kernel.org,liam@infradead.org,andrewjballance@gmail.com,aliceryhl@google.com,akpm@linux-foundation.org,sercombe.joel.mark@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maple_tree-fix-comment-typo.patch added to mm-unstable branch
Message-Id: <20260813211732.5F4021F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: maple_tree: fix comment typo
has been added to the -mm mm-unstable branch.  Its filename is
     maple_tree-fix-comment-typo.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple_tree-fix-comment-typo.patch

This patch will later appear in the mm-unstable branch at
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
From: Mark Sercombe <sercombe.joel.mark@gmail.com>
Subject: maple_tree: fix comment typo
Date: Thu, 13 Aug 2026 20:38:47 +0200

Fix a spelling mistake n a code comment.  This is a comment only change
with no functional impact.

Link: https://lore.kernel.org/20260813183847.474357-1-sercombe.joel.mark@gmail.com
Signed-off-by: Mark Sercombe <sercombe.joel.mark@gmail.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Alice Ryhl <aliceryhl@google.com>
Cc: Andrew Ballance <andrewjballance@gmail.com>
Cc: Liam R. Howlett <liam@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/maple_tree.c~maple_tree-fix-comment-typo
+++ a/lib/maple_tree.c
@@ -3590,7 +3590,7 @@ set_content:
 
 /**
  * mas_prealloc_calc() - Calculate number of nodes needed for a
- * given store oepration
+ * given store operation
  * @wr_mas: The maple write state
  * @entry: The entry to store into the tree
  *
_

Patches currently in -mm which might be from sercombe.joel.mark@gmail.com are

maple_tree-fix-comment-typo.patch

