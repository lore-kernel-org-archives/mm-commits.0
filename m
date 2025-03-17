Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 193351E52D
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 18:58:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742237920; cv=none; b=dRPcDnHwhw177wz+K6qZjaVYvSGXfrPZMjvLvVFw+jRElx3QJo540tzp2gkdaMBM7u6MRwPHhDg0igoxKbXbF1BNKwr91gKkDSoQ9YKTQGCAvfsY0y1moKD0kSxv/gz04x5NBvwQtfFJUSYerpGhoqywdHP+9VhLxqe1FytPbXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742237920; c=relaxed/simple;
	bh=8pGy+gkTrMZtUXPrOWreXm0GQ9m1ccotDZbzkQ7Uzwk=;
	h=Date:To:From:Subject:Message-Id; b=ipMuGZcnra4VGwOXmlyA6D9T6ue1NR4MNXFnsbv5qubUElxfMFgzrR+uJBxj/eggo9m0VluKpEgAQyEDHN/FXlEgHNq6JBLhpBimLypYWWHGW6hHdCcub8UthdH1oGt4yLYkH4VbA/gQgBMho5W+ptQbrfZb9JqBiaHGQoeXkxg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=GfA7PkIu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="GfA7PkIu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA923C4CEE3;
	Mon, 17 Mar 2025 18:58:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742237919;
	bh=8pGy+gkTrMZtUXPrOWreXm0GQ9m1ccotDZbzkQ7Uzwk=;
	h=Date:To:From:Subject:From;
	b=GfA7PkIuCA+obUoAJEyNGkGK4OdhMukSFufey4wbVkJWsV29C7VZcBORHaBZM/pYk
	 8Fr3V9HGfatOU9qqx+aEz6tcsXDnb+aviKjvV2HwNHh3DSDrM94CNfd4s1zLKmNukr
	 vfQbpEDOmhCUdSVtnX9PBDA1dtCTYezJXO4UvOG0=
Date: Mon, 17 Mar 2025 11:58:39 -0700
To: mm-commits@vger.kernel.org,ilpo.jarvinen@linux.intel.com,andriy.shevchenko@linux.intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + resource-replace-open-coded-variant-of-define_res_named_desc.patch added to mm-nonmm-unstable branch
Message-Id: <20250317185839.BA923C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: resource: replace open coded variant of DEFINE_RES_NAMED_DESC()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     resource-replace-open-coded-variant-of-define_res_named_desc.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/resource-replace-open-coded-variant-of-define_res_named_desc.patch

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
Subject: resource: replace open coded variant of DEFINE_RES_NAMED_DESC()
Date: Mon, 17 Mar 2025 20:11:11 +0200

Replace open coded variant of DEFINE_RES_NAMED_DESC().

Link: https://lkml.kernel.org/r/20250317181412.1560630-3-andriy.shevchenko@linux.intel.com
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/resource.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

--- a/kernel/resource.c~resource-replace-open-coded-variant-of-define_res_named_desc
+++ a/kernel/resource.c
@@ -1975,11 +1975,7 @@ get_free_mem_region(struct device *dev,
 			 */
 			revoke_iomem(res);
 		} else {
-			res->start = addr;
-			res->end = addr + size - 1;
-			res->name = name;
-			res->desc = desc;
-			res->flags = IORESOURCE_MEM;
+			*res = DEFINE_RES_NAMED_DESC(addr, size, name, IORESOURCE_MEM, desc);
 
 			/*
 			 * Only succeed if the resource hosts an exclusive
_

Patches currently in -mm which might be from andriy.shevchenko@linux.intel.com are

resource-split-define_res_named_desc-out-of-define_res_named.patch
resource-replace-open-coded-variant-of-define_res_named_desc.patch
resource-replace-open-coded-variants-of-define_res__named.patch
resource-replace-open-coded-variant-of-define_res.patch

