Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B82BD2905
	for <mm-commits@vger.kernel.org>; Thu, 10 Jul 2025 05:43:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752126203; cv=none; b=l8wNWTbbjXLu195eAPsSg8Oz10S6MhZC8ppsnOtLuREH+ueDrvmyKtCKl6B8g9xtiVjbBKOlFMIdLQ0HMVUtWe/CLiPrXquCn/6haFv5aQWOcUdgt/0lK334DZvgxqhVnfKPInEG9C/PzKB5+UveEpCm6rsAe7wgPklZuw3ZCnY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752126203; c=relaxed/simple;
	bh=v44PsUq+x4dvQNxVjy0bRuHJIMDAN7eLzpX3NkH6zFA=;
	h=Date:To:From:Subject:Message-Id; b=eDt4r854vYmZ3g0W8klq6Ei8WwrICLMTemykdnZc4ELDgRxmuMyaPWwhITk19uhZn15OIXZg1A8u0HcJ28XxIOm+6oj1p/lqCOEC6TKFGpwoqOsZx7k8vW9MV/8eJtjNH/+M+8zR6gf6tdRDExZNwO9eg7tzG21UuabeHH+vVrE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=eWtKZats; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="eWtKZats"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 837A5C4CEE3;
	Thu, 10 Jul 2025 05:43:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752126203;
	bh=v44PsUq+x4dvQNxVjy0bRuHJIMDAN7eLzpX3NkH6zFA=;
	h=Date:To:From:Subject:From;
	b=eWtKZatsp4+vTEUUqivWEh25qxaBt+6m+dKCYc9aM24ckLhIbmpCPrp0DZJhaF93Z
	 coCkdgpyRdAk6zTflfFaPk8H6pmFptRM0Eh9peyK1fH3G72ugaFy6UIQ4RFZyy3mFp
	 K83ObrX1LwbQx0Zqj+o50e9sx/rfCBcWkD7HSEbY=
Date: Wed, 09 Jul 2025 22:43:23 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,rppt@kernel.org,lorenzo.stoakes@oracle.com,pmenzel@molgen.mpg.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-kconfig-use-verb-use-in-plural-form-in-description.patch removed from -mm tree
Message-Id: <20250710054323.837A5C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: Kconfig: use verb *use* in plural form in description
has been removed from the -mm tree.  Its filename was
     mm-kconfig-use-verb-use-in-plural-form-in-description.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Paul Menzel <pmenzel@molgen.mpg.de>
Subject: mm: Kconfig: use verb *use* in plural form in description
Date: Tue, 3 Jun 2025 08:13:03 +0200

*workloads* is plural requiring the verb *use* in plural form.

Link: https://lkml.kernel.org/r/20250603061303.479551-2-pmenzel@molgen.mpg.de
Fixes: e13e7922d034 ("mm: add CONFIG_PAGE_BLOCK_ORDER to select page block order")
Signed-off-by: Paul Menzel <pmenzel@molgen.mpg.de>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/Kconfig~mm-kconfig-use-verb-use-in-plural-form-in-description
+++ a/mm/Kconfig
@@ -1022,7 +1022,7 @@ config PAGE_BLOCK_ORDER
 	  or MAX_PAGE_ORDER.
 
 	  Reducing pageblock order can negatively impact THP generation
-	  success rate. If your workloads uses THP heavily, please use this
+	  success rate. If your workloads use THP heavily, please use this
 	  option with caution.
 
 	  Don't change if unsure.
_

Patches currently in -mm which might be from pmenzel@molgen.mpg.de are


