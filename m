Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26EBD427F8B
	for <mm-commits@vger.kernel.org>; Tue,  1 Sep 2026 02:12:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788228768; cv=none; b=LjzgFV3lwOa4MOBmOR4cmHewqPY9j8hjq766gf2ofHTSMO2mq9wz6YdBRo+4VESxVnY8KRXbZ0uPiu4kRwCJKP7CfBbqh4wrtIGvWJJBkOpQdoeThJkbcKRWxwXLKAHBAJMy/02RaYFYBc8jKfCTaKQk7AsK6ZLsFacxbwQmgr4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788228768; c=relaxed/simple;
	bh=cx6N/gT+H7m9sJjrmI6oThh1kf6Gyx3Aj8R6lo7heGY=;
	h=Date:To:From:Subject:Message-Id; b=ULKuI7GEdz1fbRSV2ehpYO9Mmdf1l5e5LhNO+AB0yfxtrZZlaRf6vsUB/bxwUBmnFFR/etaqHHDbZFjJ4lrnCJT6/bEDSuxsXlVIjjpjnvOMZnPZWle4RZAjRFIB99EPdXTpdOuP4M1zTUvhhcXyAv2PLXDklmOuHc/dLI7MtEg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=orzDSKzV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="orzDSKzV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 059EF1F00A3D;
	Tue,  1 Sep 2026 02:12:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788228762;
	bh=0jaeWoLcF9OWWnqUeKuzInqlZTftdbHANBi0XKjib4U=;
	h=Date:To:From:Subject;
	b=orzDSKzVaBzrQdMSG2biV5Gaa9e6XkHe+RxQ4sJXrzpd+PEVc7SpfR3J/Tyeq7C9T
	 skpNmvRw7te9z3luPH+joWMu6jozmW3qvRaqFvqvwIK2kcVasBeESxP8H1usy4k2bQ
	 qJ3GSc7xe12EnJeuEycL95FEIXltN0qlaa15rTBo=
Date: Mon, 31 Aug 2026 19:12:41 -0700
To: mm-commits@vger.kernel.org,lasse.collin@tukaani.org,skunkolee@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-decompress_unxz-make-it-obvious-that-there-is-no-memory-leak.patch added to mm-nonmm-unstable branch
Message-Id: <20260901021242.059EF1F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib: decompress_unxz: make it obvious that there is no memory leak
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-decompress_unxz-make-it-obvious-that-there-is-no-memory-leak.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-decompress_unxz-make-it-obvious-that-there-is-no-memory-leak.patch

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
From: Ivy Lopez <skunkolee@gmail.com>
Subject: lib: decompress_unxz: make it obvious that there is no memory leak
Date: Mon, 31 Aug 2026 19:41:38 -0600

Calling __decompress() or unxz() with fill == NULL && flush == NULL && in
== NULL is invalid, thus there were no memory leaks even though it might
have looked like that.  Move the conditional free() calls so that it's
obvious that there are no leaks.

Link: https://lore.kernel.org/20260901014138.22699-1-skunkolee@gmail.com
Signed-off-by: Ivy Lopez <skunkolee@gmail.com>
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=207113
Link: https://lore.kernel.org/lkml/20241006072542.66442-2-t.v.s10123@gmail.com/T/
Link: https://lore.kernel.org/lkml/20260825191333.34276-1-skunkolee@gmail.com/T/
Reviewed-by: Lasse Collin <lasse.collin@tukaani.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/decompress_unxz.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/lib/decompress_unxz.c~lib-decompress_unxz-make-it-obvious-that-there-is-no-memory-leak
+++ a/lib/decompress_unxz.c
@@ -342,13 +342,13 @@ STATIC int INIT unxz(unsigned char *in,
 				b.out_pos = 0;
 			}
 		} while (ret == XZ_OK);
+	}
 
-		if (must_free_in)
-			free(in);
+	if (must_free_in)
+		free(in);
 
-		if (flush != NULL)
-			free(b.out);
-	}
+	if (flush != NULL)
+		free(b.out);
 
 	if (in_used != NULL)
 		*in_used += b.in_pos;
_

Patches currently in -mm which might be from skunkolee@gmail.com are

lib-decompress_unxz-make-it-obvious-that-there-is-no-memory-leak.patch

