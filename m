Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DF08144D0A
	for <mm-commits@vger.kernel.org>; Mon,  2 Sep 2024 03:47:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725248841; cv=none; b=LpBzWQjqZTd24FXRBXlfvJRLCyjjBsRUX2RZp/HvVYQgUb8ukODJn/vXTiRrK/dXJy3ax8Q20ypmgOXAAv+sFKAhhC3ErZH/Xx0J9z8l8vz1yol6d2b6xC7v0FaH5hjkPJT2U1a/CMoPtYe6MereDWm45UCN1/yhVHKo5ilA89c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725248841; c=relaxed/simple;
	bh=WDDriJbGhG3VdLlSXV/j7bFI/BfDCQxMgUPTbaNLTk4=;
	h=Date:To:From:Subject:Message-Id; b=vFHtgh9QwUa2Km5OEGt5u6nIbKm0VyryyR8U5AO49hQFtdmCsl2dGDGyxJ5C9XGD4MqQGN9G1n0AsgLyZVlgwjOJW4AgiiyB4Fc31DiJ3MUHp1P5n5PueTOCGirTX588b/ohLliIOK4kwNykyUNgzZCR3m8ArRlqDb21QpuKJfQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qb02gwSG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qb02gwSG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76F85C4CEC2;
	Mon,  2 Sep 2024 03:47:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725248841;
	bh=WDDriJbGhG3VdLlSXV/j7bFI/BfDCQxMgUPTbaNLTk4=;
	h=Date:To:From:Subject:From;
	b=qb02gwSGhUIR7akdo6EyMcJ7sbVGiR+skzhZTMUBTWiAc6PZUf9gBqlQknWmW1Rox
	 Vzfe9FDRzJH8z0ixof8Ew4LLzkf1dIgibzt7iYrG5Rq5ec6HxniOUrC0iHy2c2lnyW
	 G9IXx0/nb96J1JUyMGL1K8RaHeThzwNo3UKMq5MI=
Date: Sun, 01 Sep 2024 20:47:20 -0700
To: mm-commits@vger.kernel.org,talgi@nvidia.com,linux@rasmusvillemoes.dk,florian.fainelli@broadcom.com,aleksander.lobakin@intel.com,andriy.shevchenko@linux.intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] dimlib-use-y-instead-of-objs-in-makefile.patch removed from -mm tree
Message-Id: <20240902034721.76F85C4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: dimlib: use *-y instead of *-objs in Makefile
has been removed from the -mm tree.  Its filename was
     dimlib-use-y-instead-of-objs-in-makefile.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: dimlib: use *-y instead of *-objs in Makefile
Date: Wed, 21 Aug 2024 18:51:04 +0300

*-objs suffix is reserved rather for (user-space) host programs while
usually *-y suffix is used for kernel drivers (although *-objs works for
that purpose for now).

Let's correct the old usages of *-objs in Makefiles.

Link: https://lkml.kernel.org/r/20240821155140.611514-1-andriy.shevchenko@linux.intel.com
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Acked-by: Florian Fainelli <florian.fainelli@broadcom.com>
Reviewed-by: Alexander Lobakin <aleksander.lobakin@intel.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Tal Gilboa <talgi@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/dim/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/dim/Makefile~dimlib-use-y-instead-of-objs-in-makefile
+++ a/lib/dim/Makefile
@@ -4,4 +4,4 @@
 
 obj-$(CONFIG_DIMLIB) += dimlib.o
 
-dimlib-objs := dim.o net_dim.o rdma_dim.o
+dimlib-y := dim.o net_dim.o rdma_dim.o
_

Patches currently in -mm which might be from andriy.shevchenko@linux.intel.com are


