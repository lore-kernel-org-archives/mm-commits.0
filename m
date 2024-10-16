Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C29521CBA16
	for <mm-commits@vger.kernel.org>; Wed, 16 Oct 2024 21:11:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729113104; cv=none; b=JV1QdQirUg900NPRGZuo9uCHspcobvnsCSkHRJQGhw+XPjwSa11zeUW+9l98sRiOpehi7zchrcGr5z/esM/gZaBNiAxIN8uCreU6h3I5Z9nT6MkMb8XGxzSme9AfFgwkFLPskYCUfrGGk8X0QVVtMtOwXEz5fn3JuUd5m5zUbJo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729113104; c=relaxed/simple;
	bh=FiTRlABw48c7Vn98lvww8Kn9WxAKr9SAOa9xEwO6VT4=;
	h=Date:To:From:Subject:Message-Id; b=VKnQrg3p4tRLtBEgqgXDwo+8YM7k4WkhKwnyuMzPtrVL7r0QwCSLr6QFwbQFB1b3LxlkxFt/MjT2ZvuZWyPMnCPnNfTrvIB+09Fp3KgAS4bu3okwopR0wwTosS2Qq1i2jWkZv/3UFODdxi8dbe2YOzjlC7yhy9bbKfLT3zIo9G4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=LC+OQo9p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LC+OQo9p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A42BC4CECD;
	Wed, 16 Oct 2024 21:11:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1729113104;
	bh=FiTRlABw48c7Vn98lvww8Kn9WxAKr9SAOa9xEwO6VT4=;
	h=Date:To:From:Subject:From;
	b=LC+OQo9p904hboPyn5YdqjZvT6ZoG42PpHmgzJoRkwh3O8BZp5dyZtl3GMCKHoZwy
	 cDGOGe1J4ShP+bCDm3NWo7mfJk5jzlCgpsk4VutvwewEI8HqrWm4Kg1ZRAMY2ESkgV
	 KhmPVnCuGsxkpSRwkCYieaZh6yShWERcPu5gqAdU=
Date: Wed, 16 Oct 2024 14:11:43 -0700
To: mm-commits@vger.kernel.org,quic_zijuhu@quicinc.com,gregkh@linuxfoundation.org,zijun_hu@icloud.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] lib-devres-simplify-api-devm_ioport_unmap-implementation.patch removed from -mm tree
Message-Id: <20241016211144.2A42BC4CECD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib: devres: Simplify API devm_ioport_unmap() implementation
has been removed from the -mm tree.  Its filename was
     lib-devres-simplify-api-devm_ioport_unmap-implementation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Zijun Hu <zijun_hu@icloud.com>
Subject: lib: devres: Simplify API devm_ioport_unmap() implementation
Date: Wed, 18 Sep 2024 22:48:14 +0800

From: Zijun Hu <quic_zijuhu@quicinc.com>

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


