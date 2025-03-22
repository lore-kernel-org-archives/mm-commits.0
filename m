Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 983F07081C
	for <mm-commits@vger.kernel.org>; Sat, 22 Mar 2025 05:10:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742620250; cv=none; b=Pl9xaGP/XE1iYKf+W9FmNpEY0HDwpWXaBsVKXbOx15O7+TVbbALD+3zbXWpa6z3ieKysPsWpZM/WwNZ9QlL222YAPmTGOH9RcA34zxj3f6un7qVeot69d6+cYxUbZo1bzpbzKPH88cpsSKeo4mM7zUmbpxMIYzjcmrCCNhmBJTs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742620250; c=relaxed/simple;
	bh=rvw5S8xbog78FG3Cl6SXRqO6T4TMVUgjL8Qev39dP2Q=;
	h=Date:To:From:Subject:Message-Id; b=dmd4Q81HqRbB8ZZkPMVhcHX2Hh03UPKCbNg8SyT7joAlgmDnP/OrzgQphJ1IRReQ9I905kISC7+sZmgQVn2oid1T8VxN7B1k9pQQbIDJykYp4FiGxTWkkws+f+dzt33vUyvnz75AWIG6qyOl8iq9iChimp3t5pPdSf9TwdQk0zY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=RdHiLqXT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="RdHiLqXT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07F98C4CEDD;
	Sat, 22 Mar 2025 05:10:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742620250;
	bh=rvw5S8xbog78FG3Cl6SXRqO6T4TMVUgjL8Qev39dP2Q=;
	h=Date:To:From:Subject:From;
	b=RdHiLqXThUsRezFWQJLCyt+H/CF+ooKgzHB+vwJ5gwlxGh+aymg8i5Tixfa1hj/DS
	 jjrGDOGeJ6aXw7AItylmaRCEwVlhKpzr96U8qe0OKH3LukXABW6hE6BSZ1RMaJaNCS
	 HDtFc+EQHyvJdGLLgAPNNGKA4GYoRoIJn+abLIZQ=
Date: Fri, 21 Mar 2025 22:10:49 -0700
To: mm-commits@vger.kernel.org,ilpo.jarvinen@linux.intel.com,andriy.shevchenko@linux.intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] resource-replace-open-coded-variant-of-define_res_named_desc.patch removed from -mm tree
Message-Id: <20250322051050.07F98C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: resource: replace open coded variant of DEFINE_RES_NAMED_DESC()
has been removed from the -mm tree.  Its filename was
     resource-replace-open-coded-variant-of-define_res_named_desc.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


