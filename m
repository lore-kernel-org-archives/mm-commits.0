Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 012A01EF38E
	for <mm-commits@vger.kernel.org>; Sun, 13 Jul 2025 23:40:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752450044; cv=none; b=XY2dBvfVayB/o2m2l2IfPNhyb2p1r5l+IBsCLeQDFb3hi+JMiR0yOzYSX2k2WpMlf31zR+XwiLtp0pI2mnGJ2Nufz/b3QwUwnCf0GxLBTD6QPc7qicKoSJMFkcupDOAmXEoZfm3lNX0s5XsaZn38iogrfXiLednEu1wXb6lQtt4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752450044; c=relaxed/simple;
	bh=0+PadYPWd968WwjvrvL14PkyLb/9sC5CE9yk5x7jdB8=;
	h=Date:To:From:Subject:Message-Id; b=LpUgvPhL5IsfbhL5aJ0uw0b33jsMcApLqzzzzTZWTB3elSEoNYOA746/BsmliGosrAHXKtfKv6xkPBvhZIrkp0Jdshz2PrAcXHmY8Px6nO9DrJNqzaNFBCZ8on+1nqSyUPSR0ahkUhBmSzx6OR5mjWbyfLxlRMoLaeOMA6E6kA0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wtcVRo6a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wtcVRo6a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA4B5C4CEE3;
	Sun, 13 Jul 2025 23:40:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752450043;
	bh=0+PadYPWd968WwjvrvL14PkyLb/9sC5CE9yk5x7jdB8=;
	h=Date:To:From:Subject:From;
	b=wtcVRo6aBB4JQzVezb06QkyowqIl3SnLkP4t0ZBZmmWplUqpRRRvPV4ek1kPZO55D
	 Ip54Ni+9/o0i+aOgUHbwnCwT+IPEU1eTaCOCtBpa8j6ClFUQk/7ubZ1SZ39snfaxG1
	 Suj4IiV/VFynUbh7YRl7RP39L2CTGO+sqIv8K4qo=
Date: Sun, 13 Jul 2025 16:40:43 -0700
To: mm-commits@vger.kernel.org,dev.jain@arm.com,david@redhat.com,anshuman.khandual@arm.com,thorsten.blum@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-cma-use-str_plural-in-cma_declare_contiguous_multi.patch removed from -mm tree
Message-Id: <20250713234043.CA4B5C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/cma: use str_plural() in cma_declare_contiguous_multi()
has been removed from the -mm tree.  Its filename was
     mm-cma-use-str_plural-in-cma_declare_contiguous_multi.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Acked-by: David Hildenbrand <david@redhat.com>
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

mm-memfd-replace-deprecated-strcpy-with-memcpy-in-alloc_name.patch

