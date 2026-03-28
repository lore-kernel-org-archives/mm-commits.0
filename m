Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DB36339714
	for <mm-commits@vger.kernel.org>; Sat, 28 Mar 2026 04:25:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774671927; cv=none; b=c+/ZfPlSGWxkuAN4OgR42igsSIvnNKXH4ZxLolPdwNRIduZKHbGH18DzpcnAgDALNZKj8oDQeHe7qy0QX3y/1KtHQuxIOFeGYA7fj7rDBU4lqrSgaLziLzbmM0VWZLtSEbcBu382R6GbipGiGVmyMJqy6kRFzU5WlEz3UOSzW10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774671927; c=relaxed/simple;
	bh=gXwuwwQSeNzQDMGjLwffSOcfEJ/n3rQtKNKg26DeclY=;
	h=Date:To:From:Subject:Message-Id; b=VhKLcKMI9p1OJMR5+57mHAgkRJ3HtnxQzK4HUDWzqvQljMW9Tw3CQUBruC+wPAd03/RwIQFEs4ijQO5VE7PxOt7YV8SGxyiT5YSrKcaTpjCQv/IwREh3BcJ0rurbR4jdO5tIOyS3D+XqXPXFmKBdpWyDWl4PS+u9JuwmXPh5JbQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Z9gjxQUo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Z9gjxQUo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E47EFC4CEF7;
	Sat, 28 Mar 2026 04:25:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774671927;
	bh=gXwuwwQSeNzQDMGjLwffSOcfEJ/n3rQtKNKg26DeclY=;
	h=Date:To:From:Subject:From;
	b=Z9gjxQUoO4O8hA9lrkopxExf8zKNlvpVeq9F8rElFiD4V4CBkHVnb0bjNX1OON+/9
	 mW0hsfwDyxTT8rSUwLh1LZ/C273w3ZtOWGfco0RidKv5hVDyMmzkoaC9fvhUVeSC8D
	 jriBNNH+EWMf9NUeLuTQGK0VfVtYruJc+Oh/CKYU=
Date: Fri, 27 Mar 2026 21:25:26 -0700
To: mm-commits@vger.kernel.org,akpm@linux-foundation.org,objecting@objecting.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] lib-inflate-fix-grammar-in-comment-variable-to-variables.patch removed from -mm tree
Message-Id: <20260328042526.E47EFC4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib/inflate: fix grammar in comment: "variable" to "variables"
has been removed from the -mm tree.  Its filename was
     lib-inflate-fix-grammar-in-comment-variable-to-variables.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Josh Law <objecting@objecting.org>
Subject: lib/inflate: fix grammar in comment: "variable" to "variables"
Date: Fri, 6 Mar 2026 16:17:07 +0000

Fix "all variable" to "all variables" in the file header comment.

Link: https://lkml.kernel.org/r/20260306161707.2812005-1-objecting@objecting.org
Signed-off-by: Josh Law <objecting@objecting.org>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/inflate.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/inflate.c~lib-inflate-fix-grammar-in-comment-variable-to-variables
+++ a/lib/inflate.c
@@ -9,7 +9,7 @@
  * based on gzip-1.0.3 
  *
  * Nicolas Pitre <nico@fluxnic.net>, 1999/04/14 :
- *   Little mods for all variable to reside either into rodata or bss segments
+ *   Little mods for all variables to reside either into rodata or bss segments
  *   by marking constant variables with 'const' and initializing all the others
  *   at run-time only.  This allows for the kernel uncompressor to run
  *   directly from Flash or ROM memory on embedded systems.
_

Patches currently in -mm which might be from objecting@objecting.org are

mm-damon-core-document-damos_commit_dests-failure-semantics.patch
lib-maple_tree-fix-swapped-arguments-in-mas_safe_pivot-call.patch
lib-idr-fix-ida_find_first_range-missing-ids-across-chunk-boundaries.patch

