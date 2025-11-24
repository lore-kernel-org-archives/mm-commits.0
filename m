Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8754E27A123
	for <mm-commits@vger.kernel.org>; Mon, 24 Nov 2025 23:11:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764025883; cv=none; b=lvwE1H7MiA+H+mrYsnQvzqNfKRbGgOfVqoKeWyVv/Rgm3rP+XRDxBh8byuxhvqqFRBQkI86GpxF9RhJBztzpSLDCYlfnOADsUE6upPXZkR50tvn3gms88O4eiP4ekQm2jVLtB3r0nDbsgyrpEzKbK1VXBcgsWoF95yrr8UMvFns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764025883; c=relaxed/simple;
	bh=0C1DbHD3FGcxczztbvx6MXneB8yzFEJHho03rjfv9eQ=;
	h=Date:To:From:Subject:Message-Id; b=RSucwYUaIzAdqCY85W+GT4O1vNNo3Kr6bg8cNI2FA7ry0KMYf4ptKVTkVdQVz+A10rteBNg8jYyCLyzIUwMjM7ys5+4rBvRBSY5F8HVg11+dYsT+TkSBDx0bQB4pB9D+lMQydshXIIgoOCplwNfAdeQwNGX6zgOnDBvvfu/LR1A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0BsSe5hm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0BsSe5hm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5ABFAC4CEF1;
	Mon, 24 Nov 2025 23:11:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1764025883;
	bh=0C1DbHD3FGcxczztbvx6MXneB8yzFEJHho03rjfv9eQ=;
	h=Date:To:From:Subject:From;
	b=0BsSe5hmCQcaMm/HB1UzDf1aDWGq4Lk4LegW5DRKLKz//MlgDakyXwPF7m5A53/Mx
	 MoYqOyI5FPLNqT6eXOhsI8hElD7ws2Wf3cpOB/ob+ZP34W2+chP4giYqo50R/PywOX
	 uLHZoNVji+4LrclaBOfTp4N5B/SoKf67Yk0Qa0mA=
Date: Mon, 24 Nov 2025 15:11:22 -0800
To: mm-commits@vger.kernel.org,vdavydov@virtuozzo.com,rppt@kernel.org,n-horiguchi@ah.jp.nec.com,lorenzo.stoakes@oracle.com,koct9i@gmail.com,david@kernel.org,richard@nod.at,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] pagemap-update-buddy-flag-documentation.patch removed from -mm tree
Message-Id: <20251124231123.5ABFAC4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: pagemap: update BUDDY flag documentation
has been removed from the -mm tree.  Its filename was
     pagemap-update-buddy-flag-documentation.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Richard Weinberger <richard@nod.at>
Subject: pagemap: update BUDDY flag documentation
Date: Sat, 22 Nov 2025 22:19:20 +0100

Since v4.6 the BUDDY flag is set for _all_ pages in the block
and no longer just for the first one.
This change was introduced by:
commit 832fc1de01ae ("/proc/kpageflags: return KPF_BUDDY for "tail" buddy pages")

Strictly speaking, this was an ABI change, but as nobody has noticed
since 2016, let's just update the documentation.

Link: https://lkml.kernel.org/r/20251122211920.3410371-1-richard@nod.at
Signed-off-by: Richard Weinberger <richard@nod.at>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Vladimir Davydov <vdavydov@virtuozzo.com>>
Cc: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/pagemap.rst |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/Documentation/admin-guide/mm/pagemap.rst~pagemap-update-buddy-flag-documentation
+++ a/Documentation/admin-guide/mm/pagemap.rst
@@ -115,7 +115,8 @@ Short descriptions to the page flags
     A free memory block managed by the buddy system allocator.
     The buddy system organizes free memory in blocks of various orders.
     An order N block has 2^N physically contiguous pages, with the BUDDY flag
-    set for and _only_ for the first page.
+    set for all pages.
+    Before 4.6 only the first page of the block had the flag set.
 15 - COMPOUND_HEAD
     A compound page with order N consists of 2^N physically contiguous pages.
     A compound page with order 2 takes the form of "HTTT", where H donates its
_

Patches currently in -mm which might be from richard@nod.at are


