Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3405AEEAD
	for <mm-commits@vger.kernel.org>; Thu, 22 Feb 2024 00:03:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708560204; cv=none; b=e7qY3kSC6R+MT5+RboygTQNnuc3zXF+KdI4B0+pZ+UT/wddlsi8t6mMFiYtLXYGG2+fpZ8y4EuAki0l6dST0psOMJp+u+HYiYd+MZJJIom3eXnvVInIBuvOz1Gw9RrbZB4NZ7AVcBEzxqgnS+iSG6sgXaEAyXY55aSReTXC4zoY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708560204; c=relaxed/simple;
	bh=lFY1SdQbwaHMfchLJs9OBgThbJ3C+vVnwnVTz8ld4qI=;
	h=Date:To:From:Subject:Message-Id; b=IH4v4pWQJJIM7os6zxJgPOjn5xENhqeoymmKJ5xyc7kuB48BU9maHj2xAHaL5N+uGil+kO/j8EHsyDTTg28ZFTDpY2F0X0oo8O1/pBtHtel8DmePJgzZ+I/h/5IsG21FvReK6BgwA4pF0Zlg/jFAwJO2wRpJwqVbDjD34+6XAGY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qozogS0s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qozogS0s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F13FCC43390;
	Thu, 22 Feb 2024 00:03:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708560204;
	bh=lFY1SdQbwaHMfchLJs9OBgThbJ3C+vVnwnVTz8ld4qI=;
	h=Date:To:From:Subject:From;
	b=qozogS0s+Ht6XdJSw8ISxzhGp+NSCEEEe15h1j2/mEY31IjZ488jU8DVCU1fkszTW
	 g4pZ5mLC3qoy3GzmSKwfx5CVJjoe5p4Hot59PXDR1AHDwrIikvZbXx39WyTOSBjZJp
	 QwcCFFbfdlYtUAqJ6THBL2F8dBdpuAeNtqS2No80=
Date: Wed, 21 Feb 2024 16:03:23 -0800
To: mm-commits@vger.kernel.org,john@groves.net,hch@infradead.org,dan.j.williams@intel.com,John@Groves.net,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] memremaph-correct-an-error-in-a-comment.patch removed from -mm tree
Message-Id: <20240222000323.F13FCC43390@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: memremap.h: correct an error in a comment
has been removed from the -mm tree.  Its filename was
     memremaph-correct-an-error-in-a-comment.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: John Groves <John@Groves.net>
Subject: memremap.h: correct an error in a comment
Date: Mon, 5 Feb 2024 18:57:37 -0600

It tried to send me off to memory_hotplug.h for an enum that is a few
lines above...

Link: https://lkml.kernel.org/r/dba0f5f01162d6fa16e4da2a9fede7f97080e92d.1707179960.git.john@groves.net
Signed-off-by: John Groves <john@groves.net>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Cc: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memremap.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/memremap.h~memremaph-correct-an-error-in-a-comment
+++ a/include/linux/memremap.h
@@ -109,7 +109,7 @@ struct dev_pagemap_ops {
  * @altmap: pre-allocated/reserved memory for vmemmap allocations
  * @ref: reference count that pins the devm_memremap_pages() mapping
  * @done: completion for @ref
- * @type: memory type: see MEMORY_* in memory_hotplug.h
+ * @type: memory type: see MEMORY_* above in memremap.h
  * @flags: PGMAP_* flags to specify defailed behavior
  * @vmemmap_shift: structural definition of how the vmemmap page metadata
  *      is populated, specifically the metadata page order.
_

Patches currently in -mm which might be from John@Groves.net are


