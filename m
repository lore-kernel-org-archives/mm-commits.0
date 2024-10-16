Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD9885478E
	for <mm-commits@vger.kernel.org>; Wed, 16 Oct 2024 21:11:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729113104; cv=none; b=NZdqISJXLw2GeI8+jld8ymND47k7DzX+r54Q549AXpgnDo8vhosPCiBO1UnO1r4vVaiqInK5PmMlJnKcgUO69g4uZXXFdBDBeTAxHzBSMGg7fJx5oRocy8Z+qYXDnfPqAVQR2eIOE2TUJW91gpT/Gh6FrC0QEB048jaER7rvU9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729113104; c=relaxed/simple;
	bh=2lXGFvHCm/zd5LVJewEN0aGTc+JTtNbyYtMBxOREH5c=;
	h=Date:To:From:Subject:Message-Id; b=qqGDa5zXdzxn+DD9x46W7fctyVQZ1wP8q0LNOJMQAR++JwYzZzpJ4LDuX62vZTvR2ZvvzICcHv/q4JuB+sbMWVBjKQRy/7Y2EmlTJqmULymp6Rq31NGJQIVrgzaV2BIsEv4rYM+z1v6rdOM01ry0wGi7Y5arUmXmDMTl7Ge1DPM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NV2SHNMa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NV2SHNMa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3009DC4CEC5;
	Wed, 16 Oct 2024 21:11:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1729113103;
	bh=2lXGFvHCm/zd5LVJewEN0aGTc+JTtNbyYtMBxOREH5c=;
	h=Date:To:From:Subject:From;
	b=NV2SHNMaineBBxvrBCnslthwhba4NHouprC0zT9r8L8H8AVfJXZW84u4mvo40Xkh6
	 Fdt3QNl5m4liKs/323aLdzM4DbHEh6isUNK+3aVTczniWp3CNElR/JDhBNyhK67rDy
	 HnXH3hgdRI0F2nSki/P07boRZENLPFtG9BfZBFhQ=
Date: Wed, 16 Oct 2024 14:11:42 -0700
To: mm-commits@vger.kernel.org,zijun_hu@icloud.com,gregkh@linuxfoundation.org,quic_zijuhu@quicinc.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] lib-devres-simplify-api-devm_iounmap-implementation.patch removed from -mm tree
Message-Id: <20241016211143.3009DC4CEC5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib: devres: simplify API devm_iounmap() implementation
has been removed from the -mm tree.  Its filename was
     lib-devres-simplify-api-devm_iounmap-implementation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Zijun Hu <quic_zijuhu@quicinc.com>
Subject: lib: devres: simplify API devm_iounmap() implementation
Date: Wed, 18 Sep 2024 22:48:13 +0800

Patch series "lib: devres: Simplify both API devm_iounmap() and
devm_ioport_unmap() implementation".

This patch series is to simplify implementation for both API
devm_iounmap() and devm_ioport_unmap().


This patch (of 2):

Simplify devm_iounmap() implementation by dedicated API devres_release()
compared with current solution, namely, devres_destroy() + iounmap()
devres_release() has the following advantages:

- it is simpler if devm_iounmap()'s parameter @addr is valid, namely
  @addr was ever returned by one of devm_ioremap() variants.

- it can avoid unnecessary iounmap(@addr) if @addr is not valid.

Link: https://lkml.kernel.org/r/20240918-fix_lib_devres-v1-0-e696ab5486e6@quicinc.com
Link: https://lkml.kernel.org/r/20240918-fix_lib_devres-v1-1-e696ab5486e6@quicinc.com
Signed-off-by: Zijun Hu <quic_zijuhu@quicinc.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Zijun Hu <zijun_hu@icloud.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/devres.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/lib/devres.c~lib-devres-simplify-api-devm_iounmap-implementation
+++ a/lib/devres.c
@@ -115,9 +115,8 @@ EXPORT_SYMBOL(devm_ioremap_wc);
  */
 void devm_iounmap(struct device *dev, void __iomem *addr)
 {
-	WARN_ON(devres_destroy(dev, devm_ioremap_release, devm_ioremap_match,
+	WARN_ON(devres_release(dev, devm_ioremap_release, devm_ioremap_match,
 			       (__force void *)addr));
-	iounmap(addr);
 }
 EXPORT_SYMBOL(devm_iounmap);
 
_

Patches currently in -mm which might be from quic_zijuhu@quicinc.com are

lib-devres-simplify-api-devm_ioport_unmap-implementation.patch

