Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4323359A81
	for <mm-commits@vger.kernel.org>; Wed,  7 Oct 2026 02:05:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791338714; cv=none; b=Gz3QRlLUZI4hKk2xf5wIHGj8QawzCBwUpymahkxZvNmjXk21+DIyaxpDh9Yydm6r3GQP2H7X7oLcIIw7bhrGvrKWYiOlIcMagqXjF/R2wt5geQJdAsysY6Q9JUYCaMN0IkmJwfSSOY4LURd1lCdGRAlS28DyzUgu7hgG6emCDis=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791338714; c=relaxed/simple;
	bh=XnOXaYen86vX6wTRcQoahLzsaSCC4wcoz71RMB24Ccc=;
	h=Date:To:From:Subject:Message-Id; b=N8bh5V7x+ezYddXrCGJ7vfWrClLJpm92J94NYFVvsxnKXZcbG+V0k46jwCDl0FQ+mxXoU52guNYSjf5EyTB1ViTlJZQ/OvPJQDBFD+RRtwraIxEd9hTYdBS6Fmsym+AHP2bxTvD+2qtollpzb+feq7MO+Nf6Z0D36m0nOgor1ww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xrKiMWja; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xrKiMWja"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98AB61F0089C;
	Wed,  7 Oct 2026 02:05:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791338713;
	bh=c7NT8MJKIQCaaWK7/Ak1Mwx3lfVtdnHcQD3bYH/qcno=;
	h=Date:To:From:Subject;
	b=xrKiMWja5alUQqUAyzXbrn7GoOZ6eklKCDgv8zwjF3xPsXKrxLVzI2otyNg5nZTq1
	 weoQx8R9qn8D1n5HLMKWbF50pmoKTqfUvvOHxaKRWyLGEuZ7EDI6CczId8E/m6vHy9
	 bG4LYaOD4LYPq188MVWqFoYFne8cDTRpPZFv5igg=
Date: Tue, 06 Oct 2026 19:05:13 -0700
To: mm-commits@vger.kernel.org,helgaas@kernel.org,brads@mainlining.org,andriy.shevchenko@linux.intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] resource-replace-open-coded-resource_overlaps.patch removed from -mm tree
Message-Id: <20261007020513.98AB61F0089C@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: resource: replace open coded resource_overlaps()
has been removed from the -mm tree.  Its filename was
     resource-replace-open-coded-resource_overlaps.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


