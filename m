Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A964A7081C
	for <mm-commits@vger.kernel.org>; Sat, 22 Mar 2025 05:10:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742620252; cv=none; b=mUK024BWxbk4UsQCUNy8sG1K7hX9PsUwQTjP0nsdT6/b2FgOOab4kkZP8ivvKj3aAlyWPJ9xOQQIiBbHjWU0MOF81q6FEig5aWGEBXtauEn8dDmkklImK4Yrr+I19cDqaYe5nHK+u+2RGyIKspB8lIx3sSpsV8+Vy8K0QbW2GUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742620252; c=relaxed/simple;
	bh=E079OQrL1F5plBL4GkqdXfrIqJ4vAT9dLi07GZoRF2E=;
	h=Date:To:From:Subject:Message-Id; b=ZQevOFiUD1CuLQ3PYNTWITQpShnMCzJUeai9MJwji7fNoMW6u5aWEW7O+aj+TL2IcMWEM5/xz/keVAbtBTQGdNMjWMusXIthZmzltwQV5OszUSlqTyCERmOHK03P52KtglaFUXkkLQYrkyONHXFbZxm+wID7maKR+XDNV6Zh2+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DT91PK8m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DT91PK8m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25FF2C4CEDD;
	Sat, 22 Mar 2025 05:10:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742620252;
	bh=E079OQrL1F5plBL4GkqdXfrIqJ4vAT9dLi07GZoRF2E=;
	h=Date:To:From:Subject:From;
	b=DT91PK8mx7DG/2ocvEuDzEGobiyrdo9QRdX+W6dN2ppGCGlgHHF0bDZMGQ7OeZ5bA
	 f2amlULVsq0j9Gqe317NDvgfjgV1HdZYgeBisDK7JPHIADvG9VgOpVY9dRtXvGHxbz
	 4/kLyoNDs+rKsiO7z04Mjk5+3ZN+xyCsntv9EO0k=
Date: Fri, 21 Mar 2025 22:10:51 -0700
To: mm-commits@vger.kernel.org,ilpo.jarvinen@linux.intel.com,andriy.shevchenko@linux.intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] resource-replace-open-coded-variant-of-define_res.patch removed from -mm tree
Message-Id: <20250322051052.25FF2C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: resource: replace open coded variant of DEFINE_RES()
has been removed from the -mm tree.  Its filename was
     resource-replace-open-coded-variant-of-define_res.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: resource: replace open coded variant of DEFINE_RES()
Date: Mon, 17 Mar 2025 20:11:13 +0200

Replace open coded variant of DEFINE_RES(). No functional changes intended.

Link: https://lkml.kernel.org/r/20250317181412.1560630-5-andriy.shevchenko@linux.intel.com
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/resource.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/kernel/resource.c~resource-replace-open-coded-variant-of-define_res
+++ a/kernel/resource.c
@@ -561,8 +561,7 @@ static int __region_intersects(struct re
 	struct resource res, o;
 	bool covered;
 
-	res.start = start;
-	res.end = start + size - 1;
+	res = DEFINE_RES(start, size, 0);
 
 	for (p = parent->child; p ; p = p->sibling) {
 		if (!resource_intersection(p, &res, &o))
_

Patches currently in -mm which might be from andriy.shevchenko@linux.intel.com are


