Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69E354C9A
	for <mm-commits@vger.kernel.org>; Wed, 25 Sep 2024 00:24:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727223875; cv=none; b=FyX32rIR1yyc+BSvm4S5lX7C++f9WifYHC3mA6o4jGfcsWoIODn3c19gJUMjFy/BWsvSFXpY7z2N2DHrhCubL3rugRwRty5ZIYnarIy0IkBy8HTmFXgkFV3XsM0KEQoApPEG5P4Dl7ekYiocnj+nZup+VFLjt3fm23i43zL0OyM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727223875; c=relaxed/simple;
	bh=XN3/hP3XZwwIIIAyhziO8tZy8q7WVgahJlKpU/TgHzo=;
	h=Date:To:From:Subject:Message-Id; b=l34S2FPtDn5J4OrJ51qso52gvZfU8a8hO6+9MjGg16ZyQDtalGrdhAEDnohO9rRiK1J4YY9jDMxPb7MdHe6iQSlS+eJt/xW2yZruHopPEUhCK19tkI3At3tV40mK47UKdauzYXI5uFPKLSn+Y1iQNrOikZcwlT3QCFp9iy1tpbQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=zrMgkeMk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zrMgkeMk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D82B7C4CEC4;
	Wed, 25 Sep 2024 00:24:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1727223874;
	bh=XN3/hP3XZwwIIIAyhziO8tZy8q7WVgahJlKpU/TgHzo=;
	h=Date:To:From:Subject:From;
	b=zrMgkeMk3gdfgB9Cllk91Yiph2oicps9DjhmP9nzigGJf2+S3l3c/F8Jo8sYyb7dL
	 LYcOYXS1NeFG1VKAVu34yoxAgcyO6hNuJ97hKwJ2rShDBQ9WcLJLDHnDzw3GQY7BX/
	 pTCBRD1JStoJ/c/TKTF5/yfqo1yA2vTN4sjawhno=
Date: Tue, 24 Sep 2024 17:24:34 -0700
To: mm-commits@vger.kernel.org,zijun_hu@icloud.com,gregkh@linuxfoundation.org,quic_zijuhu@quicinc.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-devres-simplify-api-devm_iounmap-implementation.patch added to mm-nonmm-unstable branch
Message-Id: <20240925002434.D82B7C4CEC4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib: devres: simplify API devm_iounmap() implementation
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-devres-simplify-api-devm_iounmap-implementation.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-devres-simplify-api-devm_iounmap-implementation.patch

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

lib-devres-simplify-api-devm_iounmap-implementation.patch
lib-devres-simplify-api-devm_ioport_unmap-implementation.patch

