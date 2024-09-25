Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4340D4C9A
	for <mm-commits@vger.kernel.org>; Wed, 25 Sep 2024 00:24:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727223877; cv=none; b=At4ubtjS7gv7dyRCGqPQ+DWXCMNVcP0ymmsCS7K/uN7K9RiqPbHmUYddSJhCCgL0RiiZZZEj+PEST2q4B+aWP8yVOt2dNb2oY4oeCnaaXKl0d28vHcHIm+bbb/6rDJ9w5y2mxyGd0iiiii9bLySQAblf62yyjCoWssGuR8fKveY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727223877; c=relaxed/simple;
	bh=VlKCZ7hUIoKiccWtgTylxDvlf/6W7rS30hC+GHudKlI=;
	h=Date:To:From:Subject:Message-Id; b=MOfECcc6ue8bjhfa7WK0JlYJ/+5fHHoFG8fZkC25wBZXoSzN4cGpK4bT3td7SNwi3ryYB4cgEKtdgx+TaT0UK/LwT3BBdu08NL+4x8xmNzUqgjOaJBfeIFGxu67SuetzIGhm5kpQiVBMJ4RzKLlInYsLi1g/XWnXZfvuvtzUxyk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=TAZmTAOi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="TAZmTAOi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE007C4CEC4;
	Wed, 25 Sep 2024 00:24:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1727223876;
	bh=VlKCZ7hUIoKiccWtgTylxDvlf/6W7rS30hC+GHudKlI=;
	h=Date:To:From:Subject:From;
	b=TAZmTAOiUuynMEB2aqAyT7Vked91xpSyNpxIPa/uGtLxg+iq7af5C/kGrrWc7zDQC
	 YVgUa/Al6d8Hbd0H0SufmSga+6lygxjpRgYg6V7z60VkQ2bhqHu8/WF1fdnurW5Wlo
	 QXiTe/IKBZOqI5CWKPODWTtraFrcVqQg7KqmxHBg=
Date: Tue, 24 Sep 2024 17:24:36 -0700
To: mm-commits@vger.kernel.org,quic_zijuhu@quicinc.com,gregkh@linuxfoundation.org,zijun_hu@icloud.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-devres-simplify-api-devm_ioport_unmap-implementation.patch added to mm-nonmm-unstable branch
Message-Id: <20240925002436.CE007C4CEC4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib: devres: Simplify API devm_ioport_unmap() implementation
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-devres-simplify-api-devm_ioport_unmap-implementation.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-devres-simplify-api-devm_ioport_unmap-implementation.patch

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
From: Zijun Hu <zijun_hu@icloud.com>
Subject: lib: devres: Simplify API devm_ioport_unmap() implementation
Date: Wed, 18 Sep 2024 22:48:14 +0800


Simplify devm_ioport_unmap() implementation by dedicated API
devres_release(), compared with current solution, namely
ioport_unmap() + devres_destroy(), devres_release() has below advantages:

- it is simpler if devm_ioport_unmap()'s parameter @addr was ever
  returned by devm_ioport_map().

- it can avoid unnecessary ioport_unmap(@addr) if @addr was not
  ever returned by devm_ioport_map().

Link: https://lkml.kernel.org/r/20240918-fix_lib_devres-v1-2-e696ab5486e6@quicinc.com
Signed-off-by: Zijun Hu <quic_zijuhu@quicinc.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/devres.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/lib/devres.c~lib-devres-simplify-api-devm_ioport_unmap-implementation
+++ a/lib/devres.c
@@ -307,8 +307,7 @@ EXPORT_SYMBOL(devm_ioport_map);
  */
 void devm_ioport_unmap(struct device *dev, void __iomem *addr)
 {
-	ioport_unmap(addr);
-	WARN_ON(devres_destroy(dev, devm_ioport_map_release,
+	WARN_ON(devres_release(dev, devm_ioport_map_release,
 			       devm_ioport_map_match, (__force void *)addr));
 }
 EXPORT_SYMBOL(devm_ioport_unmap);
_

Patches currently in -mm which might be from zijun_hu@icloud.com are

lib-devres-simplify-api-devm_ioport_unmap-implementation.patch

