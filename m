Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7DC236D
	for <mm-commits@vger.kernel.org>; Wed,  9 Oct 2024 20:45:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728506741; cv=none; b=AqJAi77hgkwaukzjYVfzepoKd5ZDP3/IshyxxbDaXUnxYAQ+4VixGcyt5HcUH/CrnEb7ZnuHVGbyH3I+fbkGtVupJspugwReU2R8MDrUEktnMXEP1g/4Se7qw27FzEeMaqRhkf9BEwVXnrnwPOA5WNg7NKZFCQIdzFarDiky6nA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728506741; c=relaxed/simple;
	bh=kiczniQsM1qIQbgLoIDGLhFhz2ivKWghjVKIyVHIkIs=;
	h=Date:To:From:Subject:Message-Id; b=g266KDiCgLOOm+hJm1ClN1Gf16vId5omsnb4NHPVAym8kvYVZFlVzuV5W8kSA2YbeIQ+stsVWvRrTME4Yw4wKM9Mi1PkSRFwlIbdo1/aGZxNuOID7ByAWQpN/FerjdhUkPvtMkaWq41/2nEJgKYgfdJlysuAHyWqkVrGLxbFk0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=CFqj4WY5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="CFqj4WY5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23F78C4CEC3;
	Wed,  9 Oct 2024 20:45:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1728506741;
	bh=kiczniQsM1qIQbgLoIDGLhFhz2ivKWghjVKIyVHIkIs=;
	h=Date:To:From:Subject:From;
	b=CFqj4WY5necAqtdejbATRc3UrRTKfqlH+SQEjiTGJc2qAGAqL5t4N5+Mi8Vo7ERq8
	 1acIoaGQPR49mDKzO4DTaKv4ofqrAX0Y/RtX0jyxckvPWtb29GcCTuYEYyCBh8bQO1
	 jm4cJKHI5hJl9aBYYSQE7pyLN6n63LbUoXrH3Rdg=
Date: Wed, 09 Oct 2024 13:45:40 -0700
To: mm-commits@vger.kernel.org,ilpo.jarvinen@linux.intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + resource-correct-reallocate_resource-documentation.patch added to mm-nonmm-unstable branch
Message-Id: <20241009204541.23F78C4CEC3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: resource: correct reallocate_resource() documentation
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     resource-correct-reallocate_resource-documentation.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/resource-correct-reallocate_resource-documentation.patch

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
From: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Subject: resource: correct reallocate_resource() documentation
Date: Wed, 9 Oct 2024 15:57:51 +0300

reallocate_resource() documentation claims constraint is about "the size
and alignment" but the size is provided in another parameter.  Instead of
size, constraint has the allowed memory range (min, max) so change the
wording to reflect that.

Link: https://lkml.kernel.org/r/20241009125751.8090-1-ilpo.jarvinen@linux.intel.com
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/resource.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/resource.c~resource-correct-reallocate_resource-documentation
+++ a/kernel/resource.c
@@ -740,7 +740,7 @@ EXPORT_SYMBOL_GPL(find_resource_space);
  * @root: root resource descriptor
  * @old:  resource descriptor desired by caller
  * @newsize: new size of the resource descriptor
- * @constraint: the size and alignment constraints to be met.
+ * @constraint: the memory range and alignment constraints to be met.
  */
 static int reallocate_resource(struct resource *root, struct resource *old,
 			       resource_size_t newsize,
_

Patches currently in -mm which might be from ilpo.jarvinen@linux.intel.com are

resource-correct-reallocate_resource-documentation.patch

