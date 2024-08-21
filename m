Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 443C87405A
	for <mm-commits@vger.kernel.org>; Wed, 21 Aug 2024 21:25:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724275522; cv=none; b=EQucFaWBse4dHvc0dWIcnFksvxm+GaxqC/5lR1zICY3WKsaZHLkumwpy/zR7UW79pvZUq6wTmSoLoyWlF/I3j70bmin72DRIiGy1LdE+FpllwO63geiuRz6qJdPSd9iBX4qF9hy03G78ww++vOyjr/dcuC1vDEIK2FoaLvhszLc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724275522; c=relaxed/simple;
	bh=InfCXytP9oykyzkErBGihS7+I/ZKUjEr7CeJ2eKiXNM=;
	h=Date:To:From:Subject:Message-Id; b=EQ9Fidd7ngi0OSoRdxvVAuCArT2vYjs+fvvlXbzM8nSP6vZnfhyYDZa88zBFt0d96NW9yW9JlUH4RJP/ohzyTsKLELZoMfsN83mgV8EOE6PrCnN+jQvmojpf5I7Cawc15AlXw87r7TbvzenOW2cj7nserJm94SSTqWf1CTmnHI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=z7y9fel4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="z7y9fel4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1103C4AF0E;
	Wed, 21 Aug 2024 21:25:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1724275521;
	bh=InfCXytP9oykyzkErBGihS7+I/ZKUjEr7CeJ2eKiXNM=;
	h=Date:To:From:Subject:From;
	b=z7y9fel4J1o6UY2IGxTGZY6FKO/4EwnAUwUF0rOj56+IYI6PU12yGPVYSYqsVi7R8
	 0vDiqVNvG/zgj2831KyYVKwGsYo4L3iqi4c7Urh8f+yUEyCl8zJPk2lFnlnerFO6WB
	 hXSBxolM53hwhINYkjwzipDQZuFK5cXMA/wtw49M=
Date: Wed, 21 Aug 2024 14:25:20 -0700
To: mm-commits@vger.kernel.org,talgi@nvidia.com,linux@rasmusvillemoes.dk,florian.fainelli@broadcom.com,aleksander.lobakin@intel.com,andriy.shevchenko@linux.intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + dimlib-use-y-instead-of-objs-in-makefile.patch added to mm-nonmm-unstable branch
Message-Id: <20240821212521.C1103C4AF0E@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: dimlib: use *-y instead of *-objs in Makefile
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     dimlib-use-y-instead-of-objs-in-makefile.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/dimlib-use-y-instead-of-objs-in-makefile.patch

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

dimlib-use-y-instead-of-objs-in-makefile.patch

