Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A68E829A0
	for <mm-commits@vger.kernel.org>; Sat, 30 Nov 2024 05:29:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732944569; cv=none; b=fTGPabeXQ36Xj7YVCxmjEze258XE+ywMCRKjgCh9eiv7k4kACKBkEKBGIC7v5Ci0IyUBtghOAl+t73c3nnud3j3ioqNoRU9453Klm0AG/nPRvwfEj+X8RT8TSiT5IhvUHdbySPFxR4fp3dgET2/4xZuSgDGfd7Qi9U4XEkJoTLo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732944569; c=relaxed/simple;
	bh=C329fyAtyQIm2FaVQ0i/y+fn6ejboQTcZdYjnfv0qnI=;
	h=Date:To:From:Subject:Message-Id; b=AKIeTgaNbGR4DC+Qa+1CeyLyP2BmDMzH/9isrmeeKk4/lmeKZBwCNWu3/Ma3OWOoXCCHyz05pVkuUgDuEtGB3GcQNUwCuqxywlCggWO/huIJ+SfU6r8B3w2VAyptMgeqbhVTKvPU31k0opAtMFuEuQwmUlEDOJj9ZtfHxUk4iDo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=foRBoN9T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="foRBoN9T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68211C4CECC;
	Sat, 30 Nov 2024 05:29:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1732944569;
	bh=C329fyAtyQIm2FaVQ0i/y+fn6ejboQTcZdYjnfv0qnI=;
	h=Date:To:From:Subject:From;
	b=foRBoN9T/jsUNFrBtboTwKJHzKxkOWFPZSEYBqect8TUo895I+HJNBvmuwpJlY9Fu
	 BRfb5FVIqrn67EENFlI1925g6Q7uYYNuyj+PYKv1/lxfUsLQcQb28atqZeY8jQBOh4
	 53kv5rDK9G51knLM7YomTsQyYS08YSn8FBFoGJBA=
Date: Fri, 29 Nov 2024 21:29:28 -0800
To: mm-commits@vger.kernel.org,mika.westerberg@linux.intel.com,ilpo.jarvinen@linux.intel.com,bhelgaas@google.com,andriy.shevchenko@linux.intel.com,quic_zijuhu@quicinc.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kernel-resource-simplify-api-__devm_release_region-implementation.patch added to mm-nonmm-unstable branch
Message-Id: <20241130052929.68211C4CECC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kernel/resource: simplify API __devm_release_region() implementation
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kernel-resource-simplify-api-__devm_release_region-implementation.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kernel-resource-simplify-api-__devm_release_region-implementation.patch

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
Subject: kernel/resource: simplify API __devm_release_region() implementation
Date: Thu, 17 Oct 2024 23:34:49 +0800

Simplify __devm_release_region() implementation by dedicated API
devres_release() which have below advantages than current
__release_region() + devres_destroy():

It is simpler if __devm_release_region() is undoing what
__devm_request_region() did, otherwise, it can avoid wrong and undesired
__release_region().

Link: https://lkml.kernel.org/r/20241017-release_region_fix-v1-1-84a3e8441284@quicinc.com
Signed-off-by: Zijun Hu <quic_zijuhu@quicinc.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/resource.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/kernel/resource.c~kernel-resource-simplify-api-__devm_release_region-implementation
+++ a/kernel/resource.c
@@ -1683,8 +1683,7 @@ void __devm_release_region(struct device
 {
 	struct region_devres match_data = { parent, start, n };
 
-	__release_region(parent, start, n);
-	WARN_ON(devres_destroy(dev, devm_region_release, devm_region_match,
+	WARN_ON(devres_release(dev, devm_region_release, devm_region_match,
 			       &match_data));
 }
 EXPORT_SYMBOL(__devm_release_region);
_

Patches currently in -mm which might be from quic_zijuhu@quicinc.com are

kernel-resource-simplify-api-__devm_release_region-implementation.patch

