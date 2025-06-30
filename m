Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F34A1A073F
	for <mm-commits@vger.kernel.org>; Mon, 30 Jun 2025 23:09:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751324984; cv=none; b=JRbNNx8Di1kyHzd/SiV5FcCxXCt3BdeRU4UOBs/LrGfMD14/mTMbKNyENJ5SCATPrZo/nC/sWTvzvrb013GwNDj6hQimSnabxIiBuFLcd/E1+pjYF2DsB5a9fJM/TUO9No0NB+HE8oSFXJSH0R1dgxYQf4IlE3U27n+T42nbjwI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751324984; c=relaxed/simple;
	bh=kc8V6YwsS0lNxYnHA7xI5LODFsN0071DZBF57AqHsi0=;
	h=Date:To:From:Subject:Message-Id; b=J+w8NK/LzZ8FRJNot40hxiF+TdSFVNbR44GIw69a2mfUIrxF0SHxO/iY3lP8FDj9jX7aLLle94Z85UMBJq/T+KYhUbbYY2H/iNAlSprIGsa3gTC0nivO9dNozcpaZYgkcDG0bXd/Sjy6GdZ2KIkReQzkixXnWoLei3I9pqDSso8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qZJEauI8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qZJEauI8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8720FC4CEE3;
	Mon, 30 Jun 2025 23:09:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1751324981;
	bh=kc8V6YwsS0lNxYnHA7xI5LODFsN0071DZBF57AqHsi0=;
	h=Date:To:From:Subject:From;
	b=qZJEauI8rk6U+2mjPPcQGKgeZohfMokYd5BCS8Hho4ZcEBRI/YB+rEfYs1+9qtFvP
	 LyrjOTKibsrb12CHkRBi6uQOFXrkDoNOxuvsXAzocQrNdUM8tP8fQMIwylGwUWQgzA
	 gFrNr9QAvJjRa9YJuXn0wz6n0T1OieDxfeWxMY/Y=
Date: Mon, 30 Jun 2025 16:09:40 -0700
To: mm-commits@vger.kernel.org,dev.jain@arm.com,thorsten.blum@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-cma-use-str_plural-in-cma_declare_contiguous_multi.patch added to mm-new branch
Message-Id: <20250630230941.8720FC4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/cma: use str_plural() in cma_declare_contiguous_multi()
has been added to the -mm mm-new branch.  Its filename is
     mm-cma-use-str_plural-in-cma_declare_contiguous_multi.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-cma-use-str_plural-in-cma_declare_contiguous_multi.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Thorsten Blum <thorsten.blum@linux.dev>
Subject: mm/cma: use str_plural() in cma_declare_contiguous_multi()
Date: Mon, 30 Jun 2025 15:23:18 +0200

Use the string choice helper function str_plural() to simplify the code
and to fix the following Coccinelle/coccicheck warning reported by
string_choices.cocci:

  opportunity for str_plural(nr)

Link: https://lkml.kernel.org/r/20250630132318.41339-2-thorsten.blum@linux.dev
Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Tested-by: Dev Jain <dev.jain@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/cma.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/cma.c~mm-cma-use-str_plural-in-cma_declare_contiguous_multi
+++ a/mm/cma.c
@@ -22,6 +22,7 @@
 #include <linux/mm.h>
 #include <linux/sizes.h>
 #include <linux/slab.h>
+#include <linux/string_choices.h>
 #include <linux/log2.h>
 #include <linux/cma.h>
 #include <linux/highmem.h>
@@ -548,8 +549,7 @@ out:
 			(unsigned long)total_size / SZ_1M);
 	else
 		pr_info("Reserved %lu MiB in %d range%s\n",
-			(unsigned long)total_size / SZ_1M, nr,
-			nr > 1 ? "s" : "");
+			(unsigned long)total_size / SZ_1M, nr, str_plural(nr));
 	return ret;
 }
 
_

Patches currently in -mm which might be from thorsten.blum@linux.dev are

mm-hugetlb-use-str_plural-in-report_hugepages.patch
mm-cma-use-str_plural-in-cma_declare_contiguous_multi.patch
alpha-replace-sprintf-strcpy-with-scnprintf-strscpy.patch

