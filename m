Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B079C28EA72
	for <mm-commits@vger.kernel.org>; Sun, 21 Sep 2025 21:23:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758489804; cv=none; b=A13IOOlV5u3JUQcra03BD7Q3jLtyVtZlMpLoOsA3Q4xhYIpihAF3JVZsqJ4dkereyfGEiROOZI+KoRd553wYlNQbSpFfpj+OwB+x5MR/9xqwO1fCmiv4Pqf/3wxD347qvKf2yrYdcJ4bG/whhVfEJf3Ht9i1WO0XHe3mQTsh224=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758489804; c=relaxed/simple;
	bh=XI9KeEFu+nIvqoI/dSBW72rs9VtskeTt5PAVi64knf8=;
	h=Date:To:From:Subject:Message-Id; b=KHxIhcxngQFtq4IIm2A3vSwEitFcUjD2v5BW96OrdS1yhTHft0aYIRp278udvJjUR5TAfFL4DAcMn08UDGRBDp8AhvQZW50BVkKcKAY8kYgUSOG7eb/cyVsOYmqhJQSC3GzfpGc1sWscl4H6MvTT9N8zE0vw8EnCEklWcC9DQ84=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Hu2X+tUT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Hu2X+tUT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 857A6C4CEE7;
	Sun, 21 Sep 2025 21:23:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758489804;
	bh=XI9KeEFu+nIvqoI/dSBW72rs9VtskeTt5PAVi64knf8=;
	h=Date:To:From:Subject:From;
	b=Hu2X+tUT9lFHshpq1lXutYdz3zfSvmoYuImzcHw/1YeXM16Y3qnD0sER8DXjAS5B+
	 A1AImHDvJxiNvjKne8i1qUZJgqx388yoeAG8J1Xb+/uWWmWRZAmAButaeSRy9jVYDZ
	 rs8lJZHVZrjUtxle/HIsJHfYrkke/jZPDOM/3lPE=
Date: Sun, 21 Sep 2025 14:23:23 -0700
To: mm-commits@vger.kernel.org,hughd@google.com,baolin.wang@linux.alibaba.com,joeypabalinas@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memfd-remove-redundant-casts.patch removed from -mm tree
Message-Id: <20250921212324.857A6C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/memfd: remove redundant casts
has been removed from the -mm tree.  Its filename was
     mm-memfd-remove-redundant-casts.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Joey Pabalinas <joeypabalinas@gmail.com>
Subject: mm/memfd: remove redundant casts
Date: Sun, 31 Aug 2025 01:47:48 -1000

MFD_ALL_FLAGS is already an unsigned int.  Remove redundant casts to
unsigned int.

Link: https://lkml.kernel.org/r/efbbe6093b64a5b19f974871d5262d6e75dff2c0.1756639225.git.joeypabalinas@gmail.com
Signed-off-by: Joey Pabalinas <joeypabalinas@gmail.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Joey Pabalinas <joeypabalinas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memfd.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/memfd.c~mm-memfd-remove-redundant-casts
+++ a/mm/memfd.c
@@ -385,11 +385,11 @@ static int sanitize_flags(unsigned int *
 	unsigned int flags = *flags_ptr;
 
 	if (!(flags & MFD_HUGETLB)) {
-		if (flags & ~(unsigned int)MFD_ALL_FLAGS)
+		if (flags & ~MFD_ALL_FLAGS)
 			return -EINVAL;
 	} else {
 		/* Allow huge page size encoding in flags. */
-		if (flags & ~(unsigned int)(MFD_ALL_FLAGS |
+		if (flags & ~(MFD_ALL_FLAGS |
 				(MFD_HUGE_MASK << MFD_HUGE_SHIFT)))
 			return -EINVAL;
 	}
_

Patches currently in -mm which might be from joeypabalinas@gmail.com are


