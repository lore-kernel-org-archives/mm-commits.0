Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 891C0224AE4
	for <mm-commits@vger.kernel.org>; Wed, 16 Apr 2025 22:05:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744841154; cv=none; b=kGkmxj92yChIB8iRrU/9Pi8G8veASdhXuZ4RNeP2tSebwRx5YGuvXStngSZ13RGlWylolIAsbVWjXbayz8UXenoWWJBJ2YWW5AAz9/j6tC1ERs91RubAOczuv1BS28oxV5fH3ps+HVoxaluMnazjLGB9GIO0kSW2F5cyHIO++Mo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744841154; c=relaxed/simple;
	bh=6H5kN+3dIistMZwNxdhbS1CCVCVjEAxTuXam8N++VXg=;
	h=Date:To:From:Subject:Message-Id; b=YM+kCTsaWPf3S2MviMYCICf/0YVr51/hnGUlGdvI6FkuH79wFpYxHDKwnf0AGTrJkyl7Vj2zKGbTzBRFODdGo6pxsbyvunCT/VmR9d2HLmwbUHLfemY/ONU9CMFZMcORsTYP8WsjZf8ie7Xmx51DgkxqAvJUlP0nyFTrHuRp59k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=pAINqaum; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="pAINqaum"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D65C6C4CEE4;
	Wed, 16 Apr 2025 22:05:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1744841153;
	bh=6H5kN+3dIistMZwNxdhbS1CCVCVjEAxTuXam8N++VXg=;
	h=Date:To:From:Subject:From;
	b=pAINqaum8L+WHSAvCn2Ru8swUfObpR/RjQQlXeMYq5d3xIKL2K/205zqw+0n7EG5P
	 swZtIVd+D7+LR5Dnv2EBKebwXsCILmGXE67sRk0PSmvzj0npeIHxiXU4+6exNDEJxC
	 /OPxyOaEVzoWt0/6XEv79raBwjw4dI3S5dTuqJwE=
Date: Wed, 16 Apr 2025 15:05:53 -0700
To: mm-commits@vger.kernel.org,ebiggers@kernel.org,csander@purestorage.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + scatterlist-inline-sg_next.patch added to mm-nonmm-unstable branch
Message-Id: <20250416220553.D65C6C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: scatterlist: inline sg_next()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     scatterlist-inline-sg_next.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/scatterlist-inline-sg_next.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: Caleb Sander Mateos <csander@purestorage.com>
Subject: scatterlist: inline sg_next()
Date: Wed, 16 Apr 2025 10:06:13 -0600

sg_next() is a short function called frequently in I/O paths. Define it
in the header file so it can be inlined into its callers.

Link: https://lkml.kernel.org/r/20250416160615.3571958-1-csander@purestorage.com
Signed-off-by: Caleb Sander Mateos <csander@purestorage.com>
Cc: Eric Biggers <ebiggers@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/scatterlist.h |   23 ++++++++++++++++++++++-
 lib/scatterlist.c           |   23 -----------------------
 2 files changed, 22 insertions(+), 24 deletions(-)

--- a/include/linux/scatterlist.h~scatterlist-inline-sg_next
+++ a/include/linux/scatterlist.h
@@ -95,6 +95,28 @@ static inline bool sg_is_last(struct sca
 }
 
 /**
+ * sg_next - return the next scatterlist entry in a list
+ * @sg:		The current sg entry
+ *
+ * Description:
+ *   Usually the next entry will be @sg@ + 1, but if this sg element is part
+ *   of a chained scatterlist, it could jump to the start of a new
+ *   scatterlist array.
+ *
+ **/
+static inline struct scatterlist *sg_next(struct scatterlist *sg)
+{
+	if (sg_is_last(sg))
+		return NULL;
+
+	sg++;
+	if (unlikely(sg_is_chain(sg)))
+		sg = sg_chain_ptr(sg);
+
+	return sg;
+}
+
+/**
  * sg_assign_page - Assign a given page to an SG entry
  * @sg:		    SG entry
  * @page:	    The page
@@ -418,7 +440,6 @@ static inline void sg_init_marker(struct
 
 int sg_nents(struct scatterlist *sg);
 int sg_nents_for_len(struct scatterlist *sg, u64 len);
-struct scatterlist *sg_next(struct scatterlist *);
 struct scatterlist *sg_last(struct scatterlist *s, unsigned int);
 void sg_init_table(struct scatterlist *, unsigned int);
 void sg_init_one(struct scatterlist *, const void *, unsigned int);
--- a/lib/scatterlist.c~scatterlist-inline-sg_next
+++ a/lib/scatterlist.c
@@ -14,29 +14,6 @@
 #include <linux/folio_queue.h>
 
 /**
- * sg_next - return the next scatterlist entry in a list
- * @sg:		The current sg entry
- *
- * Description:
- *   Usually the next entry will be @sg@ + 1, but if this sg element is part
- *   of a chained scatterlist, it could jump to the start of a new
- *   scatterlist array.
- *
- **/
-struct scatterlist *sg_next(struct scatterlist *sg)
-{
-	if (sg_is_last(sg))
-		return NULL;
-
-	sg++;
-	if (unlikely(sg_is_chain(sg)))
-		sg = sg_chain_ptr(sg);
-
-	return sg;
-}
-EXPORT_SYMBOL(sg_next);
-
-/**
  * sg_nents - return total count of entries in scatterlist
  * @sg:		The scatterlist
  *
_

Patches currently in -mm which might be from csander@purestorage.com are

scatterlist-inline-sg_next.patch

