Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70D637081F
	for <mm-commits@vger.kernel.org>; Thu, 30 Jan 2025 23:59:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738281594; cv=none; b=CnGLXP6fyvG8IGh2FQi8Ezc/6RBjO2n19WEd+eXA35CVXklivj5BpqcUt6CkHBp2PlYKgEH67hVgTr5bhnDejvwRwke/aMpmq+Q4uBzpxwfT5MbshNBwLEfdDnIiyM8X/LAPv1Np+2Td99IAYuu0ZZvZxr74UZlUmjdUllCv5jE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738281594; c=relaxed/simple;
	bh=nyu8KZwUFW2R52o0s3j0+DudGv0/kD+RpiTBO7V98Qs=;
	h=Date:To:From:Subject:Message-Id; b=eo5v8BMERqhmDd/dvBYbXfV9klG9xbtvGVuIE8t5c5r6FPaEdYWjUC1w2DuCyue+N4/C8ATorMF75mzp+T0WbSdiojO2a8Z0OgeSdWbbDmMIB07yzWr5jELhAJ6YV2IAs3erMPvDrMgNjuY2BG5ZPOAFcdNPhvjiJUHbh/GSSZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=T7XhsSYI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="T7XhsSYI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFC84C4CED2;
	Thu, 30 Jan 2025 23:59:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1738281592;
	bh=nyu8KZwUFW2R52o0s3j0+DudGv0/kD+RpiTBO7V98Qs=;
	h=Date:To:From:Subject:From;
	b=T7XhsSYIbxU+PjK+CuLBGvi4kovFlkOlvrS17ogqqg9LE6zMXGTYWOhW7swZN0rLe
	 zYs7LFKvzXHPoeXoGExp3lVJJNAwpIHtO5D1RZjzuDtx/GAQbRoOSinrwbfvXs+jHt
	 szmRu468kV3+mWX95PXbr6o3MiHixHFEY7DuZrio=
Date: Thu, 30 Jan 2025 15:59:52 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,tamird@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maintainers-add-lib-test_xarrayc.patch added to mm-hotfixes-unstable branch
Message-Id: <20250130235952.AFC84C4CED2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: MAINTAINERS: add lib/test_xarray.c
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     maintainers-add-lib-test_xarrayc.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maintainers-add-lib-test_xarrayc.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Tamir Duberstein <tamird@gmail.com>
Subject: MAINTAINERS: add lib/test_xarray.c
Date: Wed, 29 Jan 2025 16:13:49 -0500

Ensure test-only changes are sent to the relevant maintainer.

Link: https://lkml.kernel.org/r/20250129-xarray-test-maintainer-v1-1-482e31f30f47@gmail.com
Signed-off-by: Tamir Duberstein <tamird@gmail.com>
Cc: Mattew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    1 +
 1 file changed, 1 insertion(+)

--- a/MAINTAINERS~maintainers-add-lib-test_xarrayc
+++ a/MAINTAINERS
@@ -25681,6 +25681,7 @@ F:	Documentation/core-api/xarray.rst
 F:	include/linux/idr.h
 F:	include/linux/xarray.h
 F:	lib/idr.c
+F:	lib/test_xarray.c
 F:	lib/xarray.c
 F:	tools/testing/radix-tree
 
_

Patches currently in -mm which might be from tamird@gmail.com are

maintainers-add-lib-test_xarrayc.patch

