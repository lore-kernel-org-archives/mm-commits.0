Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C15A392C2C
	for <mm-commits@vger.kernel.org>; Wed, 16 Sep 2026 01:18:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789521494; cv=none; b=meY1D4pPHlECNXSdw8g3F4VGhRV3BqvDvyXn04j8Kb8O7aiH8xHC1JpB8B0CaeCqs6eccGwVz0+46cuaRxDJw61EcmBmS5BQPlcFElFajKVPI4bd9SQB0Lb2EX/OdJVbS2Dgkgpdva1zYyzLz5eg/xQ+UTMNmJKC4szBvF9AULk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789521494; c=relaxed/simple;
	bh=BQS8cHkkiPuqyOf5qxC8YP1azxJ+YixvtL6P5KO5Qz8=;
	h=Date:To:From:Subject:Message-Id; b=HEzSIYHQ6ONCiGKWPypp/NW1nCGBUho/SBd+MekIWhk17Qp9hI9WfHXOBIEMc6xNfWb5blcHvP97c4lu4colSZUAI3wSlBWEjIffkCXsRjLFVjP4QkTnpPRqn8eeGmNhr8tic7jEqyBYmbMxqDaVPdxyJUQjyFyLDmw+IZfE574=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qf89IOcI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qf89IOcI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E6EF1F00893;
	Wed, 16 Sep 2026 01:18:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789521492;
	bh=7hH78/sIru6fjz53YYK3+BP35jSViT/5/4mWuZQL+mA=;
	h=Date:To:From:Subject;
	b=qf89IOcIONCQA5IHPYsTi4iALXww6f5vsAzsl0aLfnd//NSCDhchEGWMSDZ5SDRo3
	 8xdG33PuhYTkRjcExSH7n1j7NVHJ7xXRqiw6G6VbAcOXYb3CkAJd+T/UhMvhmftZE1
	 +o/oY0i/fPXEjiFa8plFhB5taaAwytcB9ouPwpVI=
Date: Tue, 15 Sep 2026 18:18:12 -0700
To: mm-commits@vger.kernel.org,helgaas@kernel.org,brads@mainlining.org,andriy.shevchenko@linux.intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + resource-replace-open-coded-resource_overlaps.patch added to mm-nonmm-unstable branch
Message-Id: <20260916011812.6E6EF1F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: resource: replace open coded resource_overlaps()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     resource-replace-open-coded-resource_overlaps.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/resource-replace-open-coded-resource_overlaps.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: resource: replace open coded resource_overlaps()
Date: Tue, 15 Sep 2026 10:53:53 +0200

In iomem_map_sanity_check() a piece of code resembles the content of the
resource_overlaps().  Replace open coded piece with the call to the
existing helper.

Link: https://lore.kernel.org/20260915085353.3518153-1-andriy.shevchenko@linux.intel.com
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Bradley Morgan <brads@mainlining.org>
Cc: Bjorn Helgaas <helgaas@kernel.org>
---

 kernel/resource.c |   14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

--- a/kernel/resource.c~resource-replace-open-coded-resource_overlaps
+++ a/kernel/resource.c
@@ -1833,7 +1833,7 @@ __setup("reserve=", reserve_setup);
  */
 int iomem_map_sanity_check(resource_size_t addr, unsigned long size)
 {
-	resource_size_t end = addr + size - 1;
+	struct resource mem = DEFINE_RES_MEM(addr, size);
 	struct resource *p;
 	int err = 0;
 
@@ -1843,12 +1843,10 @@ int iomem_map_sanity_check(resource_size
 		 * We can probably skip the resources without
 		 * IORESOURCE_IO attribute?
 		 */
-		if (p->start > end)
+		if (!resource_overlaps(p, &mem))
 			continue;
-		if (p->end < addr)
-			continue;
-		if (PFN_DOWN(p->start) <= PFN_DOWN(addr) &&
-		    PFN_DOWN(p->end) >= PFN_DOWN(end))
+		if (PFN_DOWN(p->start) <= PFN_DOWN(mem.start) &&
+		    PFN_DOWN(p->end) >= PFN_DOWN(mem.end))
 			continue;
 		/*
 		 * if a resource is "BUSY", it's not a hardware resource
@@ -1859,8 +1857,8 @@ int iomem_map_sanity_check(resource_size
 		if (p->flags & IORESOURCE_BUSY)
 			continue;
 
-		pr_debug("resource sanity check: requesting [mem %pa-%pa], which spans more than %s %pR\n",
-			&addr, &end, p->name, p);
+		pr_debug("resource sanity check: requesting %pR, which spans more than %s %pR\n",
+			 &mem, p->name, p);
 		err = -1;
 		break;
 	}
_

Patches currently in -mm which might be from andriy.shevchenko@linux.intel.com are

resource-replace-open-coded-resource_overlaps.patch

