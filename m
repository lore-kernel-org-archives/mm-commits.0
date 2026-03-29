Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14D4125393E
	for <mm-commits@vger.kernel.org>; Sun, 29 Mar 2026 00:40:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774744844; cv=none; b=NpdcgHXNo7nzvW7kzjmCWCMYVeddUcdclHNjQqwMikDRwu7GNDzFhU8W7kL39Zvgo7S2hssJah77wh84rLxMazfFcEvPUzuXTsYDqnuEtWoZOFKCOP4SkyzUU6f8aHsiwhYnsNx5GbfhpopZr4JZ62Xv8gQ0K7ZXS+xOWI+PXxI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774744844; c=relaxed/simple;
	bh=Y9HOyYDzotctPkpWpM02zxyrm6UgtK8A4mU+KQD4fIk=;
	h=Date:To:From:Subject:Message-Id; b=MKWzXt+IYuYW2/DazR9nLZ2vooFRjI85UcTOSfwkPz+1f6Yhh+nhuv6JEv6/SJQMrD3ABvqOKSiEwb0pBJfilAztq/+ylyXzzsmSyOvWhY03ZUEt3uV9XhahJJaIO7JsIJvIlpnZi9i4yiEoroqngdUa616mXG/I9D/kI7zzqB4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=N+kON7FY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="N+kON7FY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF314C4CEF7;
	Sun, 29 Mar 2026 00:40:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774744844;
	bh=Y9HOyYDzotctPkpWpM02zxyrm6UgtK8A4mU+KQD4fIk=;
	h=Date:To:From:Subject:From;
	b=N+kON7FYeyJQHtO1mgukW4Md7ZpGtOpWhRWnr0Uw0bHQLRv8CY4e0ote+1ZUD+nsf
	 Hak0dDA2UZ0TLb5PusEWIVLYRjP5QDTu2xdTRrCot4RGRQ5dZS8V/tkgOYhRZEP7KX
	 AlR/QeYkjlf2o9ZtgfhOuSRt0F9da98a+mR82zC4=
Date: Sat, 28 Mar 2026 17:40:43 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org,akinobu.mita@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] docs-mm-fix-typo-in-numa_memory_policyrst.patch removed from -mm tree
Message-Id: <20260329004043.DF314C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: docs: mm: fix typo in numa_memory_policy.rst
has been removed from the -mm tree.  Its filename was
     docs-mm-fix-typo-in-numa_memory_policyrst.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: docs: mm: fix typo in numa_memory_policy.rst
Date: Wed, 11 Mar 2026 00:18:37 +0900

Fix a typo: MPOL_INTERLEAVED -> MPOL_INTERLEAVE.

Link: https://lkml.kernel.org/r/20260310151837.5888-1-akinobu.mita@gmail.com
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/numa_memory_policy.rst |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/Documentation/admin-guide/mm/numa_memory_policy.rst~docs-mm-fix-typo-in-numa_memory_policyrst
+++ a/Documentation/admin-guide/mm/numa_memory_policy.rst
@@ -217,7 +217,7 @@ MPOL_PREFERRED
 	the MPOL_F_STATIC_NODES or MPOL_F_RELATIVE_NODES flags
 	described below.
 
-MPOL_INTERLEAVED
+MPOL_INTERLEAVE
 	This mode specifies that page allocations be interleaved, on a
 	page granularity, across the nodes specified in the policy.
 	This mode also behaves slightly differently, based on the
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are


