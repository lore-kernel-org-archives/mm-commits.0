Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1C0A189B8F
	for <mm-commits@vger.kernel.org>; Sat,  1 Feb 2025 11:54:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738410861; cv=none; b=PJn/43llDs1bHbnr5Z2RjwDBOWgRsIpYi74ZdIksnZ4bQybexdvoKdz0r0GwjjIfV9pJ4woEhQQ2jfHnViETWgcO+I3ZO+PcetmRJG2Hl3pQIBhOrbE8htbLePGd2IfrsN9wj2U1M0Ob6QAiGRbSvy7AkLU7xX6Ub/o5dDcLF2A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738410861; c=relaxed/simple;
	bh=aYvIjB4iaK4B18RYyY2mXKC2TLY8Fv+LF8Unfx1oUJ8=;
	h=Date:To:From:Subject:Message-Id; b=JoIYpOQZ2GbXUu9TnHfDbh0UgfpdQ5T/fehCIh9vdlxP/35NqvCyEpc8l9baVLxQqmD8OFCkgTjb+6vD+rZY2mQFXGWWJ3EHA6WxU0GOmg3nd8Brxh4WaQgynAxKttZUsKnzu74PLHs/6yZz79xZyK2ElDM3ndvktMb6pEd8zCQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=EZq3y1EK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="EZq3y1EK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C67A9C4CED3;
	Sat,  1 Feb 2025 11:54:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1738410860;
	bh=aYvIjB4iaK4B18RYyY2mXKC2TLY8Fv+LF8Unfx1oUJ8=;
	h=Date:To:From:Subject:From;
	b=EZq3y1EKQEwLOdB3o8mlYT0woTRuPsetDs4mDKaSQyNj6jWRVRt91Ck65JfilVKDt
	 NkX9h/WumPMz8y5b8SMBnrA7ohLp/z+F5rHQXhy/WgV0vpFxbU5MHUeJp31hHyPl4n
	 qdyV3QParzH8qoBEfYiptO8Me+BE5SqhknmIAWUs=
Date: Sat, 01 Feb 2025 03:54:20 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,tamird@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] maintainers-add-lib-test_xarrayc.patch removed from -mm tree
Message-Id: <20250201115420.C67A9C4CED3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: MAINTAINERS: add lib/test_xarray.c
has been removed from the -mm tree.  Its filename was
     maintainers-add-lib-test_xarrayc.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -25734,6 +25734,7 @@ F:	Documentation/core-api/xarray.rst
 F:	include/linux/idr.h
 F:	include/linux/xarray.h
 F:	lib/idr.c
+F:	lib/test_xarray.c
 F:	lib/xarray.c
 F:	tools/testing/radix-tree
 
_

Patches currently in -mm which might be from tamird@gmail.com are


