Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B53533122D
	for <mm-commits@vger.kernel.org>; Wed,  7 Oct 2026 02:04:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791338675; cv=none; b=deHbkhEBWNet+IVc0iMofTQHPVAtaO6PVLJV+rGRHS30CL6xQc+HIIoaYMh4yShtgagD7xRBatnIifYtazq0N2WG4gLMccFqYQK8S/xSrzbrYa33NYNHZ3oivOYSeh30RUwHptgv5MH3wv0apyR1+USm76awHFMSkjd8PM9c0NE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791338675; c=relaxed/simple;
	bh=0PPjAMnhlqpTtHWZJrRLWgqlNPVkx3v8a7BMtkqbWfc=;
	h=Date:To:From:Subject:Message-Id; b=IJDbsPqfDeCwQV60mEqoXlyvdAOlpdWdDOQG4MeLfl6F/T6oochETbWiAgTOtpHtppVg4Q4Ejt/j/7heNSqb6aofQpYCKpcL1Ba4McR9T1+N0Ux+vwDE+Gw4tDfV/deJhhUg3vrkJGPeJsbP+8uMy2ZYzqtELuXwzUXgFkIvwpk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1IG36p6D; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1IG36p6D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A5B91F0089C;
	Wed,  7 Oct 2026 02:04:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791338674;
	bh=9Mcs5XeHGI8F9sWm1++g7/pJ/IR68PhoPToCXq5tX7I=;
	h=Date:To:From:Subject;
	b=1IG36p6D2zE+f2cn5S6qCvnCPiNhS9eukDyJOCpbw5/5d4LG6j/clt25ktwp2dVz4
	 hibDEc+Jnbd//2rOTKz15F9OgKNnfWrQ/16+jr+UYnOqtnPjYaHTtrv3Kqj7pHM/LV
	 Qex0ic97ZIP/CuMR14orRv4xKY/BrS9cXbb5umTo=
Date: Tue, 06 Oct 2026 19:04:33 -0700
To: mm-commits@vger.kernel.org,lasse.collin@tukaani.org,skunkolee@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] lib-decompress_unxz-make-it-obvious-that-there-is-no-memory-leak.patch removed from -mm tree
Message-Id: <20261007020434.2A5B91F0089C@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib: decompress_unxz: make it obvious that there is no memory leak
has been removed from the -mm tree.  Its filename was
     lib-decompress_unxz-make-it-obvious-that-there-is-no-memory-leak.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ivy Lopez <skunkolee@gmail.com>
Subject: lib: decompress_unxz: make it obvious that there is no memory leak
Date: Mon, 31 Aug 2026 19:41:38 -0600

Calling __decompress() or unxz() with fill == NULL && flush == NULL && in
== NULL is invalid, thus there were no memory leaks even though it might
have looked like that.  Move the conditional free() calls so that it's
obvious that there are no leaks.

Link: https://lore.kernel.org/20260901014138.22699-1-skunkolee@gmail.com
Link: https://lore.kernel.org/lkml/20241006072542.66442-2-t.v.s10123@gmail.com/T/
Link: https://lore.kernel.org/lkml/20260825191333.34276-1-skunkolee@gmail.com/T/
Signed-off-by: Ivy Lopez <skunkolee@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=207113
Reviewed-by: Lasse Collin <lasse.collin@tukaani.org>
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


