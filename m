Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8E4D376E0
	for <mm-commits@vger.kernel.org>; Thu, 25 Jul 2024 20:50:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721940638; cv=none; b=NBn6XgKBiDBxgaBxv31iQmS7HdLjEs7+3owZW3aUZB19IdwMDCOtm5Y4JwKkp+1oRyP1KpAyospl68EPrs07/8b5nYcq+hL2YCqr1R5Byp4g8lCQGJwOLOujDadIgdXmCPRM7OtFp2eBtJ0SE4fBLJVdnevoWHaiW6Nsz0dh0Sw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721940638; c=relaxed/simple;
	bh=DmtwmbxPlaUhv1x/TQE0onTkFrNBFsYg+uKC1Hbd3Nk=;
	h=Date:To:From:Subject:Message-Id; b=PTCMiJ3h+XiZ5huxvTXiRdzOihZ8bcn2LZIXn65Q1L020P++yffZbyHZCYAysmT8DNLdNc+pMfwfQsXUfeMi2tNwVOQIjngrrMyXP+LBynrORi4t2FV5a+i0zaVKF4wILvqjeX91qox/l+qQ3NiW1tr7RCr96nVdcGs/MeL4LGI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=CRS6rmKv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="CRS6rmKv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72453C4AF0A;
	Thu, 25 Jul 2024 20:50:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1721940637;
	bh=DmtwmbxPlaUhv1x/TQE0onTkFrNBFsYg+uKC1Hbd3Nk=;
	h=Date:To:From:Subject:From;
	b=CRS6rmKvU7ehTjXzcaAlTLHuDncQfgLNy60S/SQjsOpGvM8X2fQwInYu+URbl1cWy
	 /zMOvFiT910BbgPRohQd7rcDLVqWEHoo26WkOcM/CNN08JMFYs/kdaviXUL6G1x8zY
	 FaADIS4SW+td5alt3j0wsdu9oJ6+wLTy7DazH0dg=
Date: Thu, 25 Jul 2024 13:50:36 -0700
To: mm-commits@vger.kernel.org,urezki@gmail.com,hch@infradead.org,dakr@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmalloc-implement-vrealloc-fix-2.patch added to mm-unstable branch
Message-Id: <20240725205037.72453C4AF0A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: (k)vrealloc: document concurrency restrictions
has been added to the -mm mm-unstable branch.  Its filename is
     mm-vmalloc-implement-vrealloc-fix-2.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmalloc-implement-vrealloc-fix-2.patch

This patch will later appear in the mm-unstable branch at
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
From: Danilo Krummrich <dakr@kernel.org>
Subject: mm: (k)vrealloc: document concurrency restrictions
Date: Thu, 25 Jul 2024 14:54:37 +0200

Document that concurrent calls to vrealloc() with itself or vfree() for
the same memory allocation are not permitted, since it leads to undefined
behavior.

Consequently, the same applies for kvrealloc(), hence also document it
for kvrealloc().

Link: https://lkml.kernel.org/r/20240725125442.4957-1-dakr@kernel.org
Signed-off-by: Danilo Krummrich <dakr@kernel.org>
Suggested-by: Christoph Hellwig <hch@infradead.org>
Suggested-by: Uladzislau Rezki <urezki@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/mm/vmalloc.c~mm-vmalloc-implement-vrealloc-fix-2
+++ a/mm/vmalloc.c
@@ -4049,6 +4049,9 @@ EXPORT_SYMBOL(vzalloc_node_noprof);
  * If @p is %NULL, vrealloc() behaves exactly like vmalloc(). If @size is 0 and
  * @p is not a %NULL pointer, the object pointed to is freed.
  *
+ * This function must not be called concurrently with itself or vfree() for the
+ * same memory allocation.
+ *
  * Return: pointer to the allocated memory; %NULL if @size is zero or in case of
  *         failure
  */
_

Patches currently in -mm which might be from dakr@kernel.org are

mm-vmalloc-implement-vrealloc.patch
mm-vmalloc-implement-vrealloc-fix.patch
mm-vmalloc-implement-vrealloc-fix-2.patch
mm-kvmalloc-align-kvrealloc-with-krealloc.patch
mm-kvmalloc-align-kvrealloc-with-krealloc-fix.patch

