Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7A35645
	for <mm-commits@vger.kernel.org>; Thu, 13 Feb 2025 00:01:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739404919; cv=none; b=t6KLe4kDOx+orDsfcoAEDhBhmcZQAo1B6ct5k9vYEXV3tULV6r4BDUg15s3KuNW7DULuTjgs3uLmtomjjcEfvJLJpGLp2KFJAtTkO6JN89i59XHnl5ss6i/H1Ch6mt187LAFG6xApvGnRwRR6SeQdT2HMXRUkhxSlbtwZKds928=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739404919; c=relaxed/simple;
	bh=/E0nFeDjeLbiZUsnqs6gCxYV/1b8PUwMyXL3NIAmpbU=;
	h=Date:To:From:Subject:Message-Id; b=Xj587BkRJas2LeyOBu7gbRIhKS8+aO4jN1SKypYxQVsarRodSgFc0q+kcEaV7V7qYlJ+v0zkyTHaasGOttCqvSEMGG5o+dcucuwbnWryRQi0jDye6T2EvqAmeEKBBZi1joKjLPS/qsEEVRWXz6e4/nOvTHp+RG7FWtHTbgB5YGo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=EkaO3PjF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="EkaO3PjF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05DB8C4CEDF;
	Thu, 13 Feb 2025 00:01:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1739404919;
	bh=/E0nFeDjeLbiZUsnqs6gCxYV/1b8PUwMyXL3NIAmpbU=;
	h=Date:To:From:Subject:From;
	b=EkaO3PjF/tqZmALzAl9b88fROlGvECii91jdWbnBLLNPjJk3edexMMFuhBnJU0NgU
	 pBVe4flOBL9ySHGQshKT+mUQaKHkUlVMYqXWm0Uadqg+fTxkvLqOe0RPvqArcl1/tV
	 FAkHYfBVVjANwOS/A0t6ZjVh4yoO3vhB7NHoJKXY=
Date: Wed, 12 Feb 2025 16:01:58 -0800
To: mm-commits@vger.kernel.org,surenb@google.com,rppt@kernel.org,richard.henderson@linaro.org,mattst88@gmail.com,guoweikang.kernel@gmail.com,geert@linux-m68k.org,agordeev@linux.ibm.com,thorsten.blum@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + alpha-use-str_yes_no-helper-in-pci_dac_dma_supported.patch added to mm-nonmm-unstable branch
Message-Id: <20250213000159.05DB8C4CEDF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: alpha: Use str_yes_no() helper in pci_dac_dma_supported()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     alpha-use-str_yes_no-helper-in-pci_dac_dma_supported.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/alpha-use-str_yes_no-helper-in-pci_dac_dma_supported.patch

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
From: Thorsten Blum <thorsten.blum@linux.dev>
Subject: alpha: Use str_yes_no() helper in pci_dac_dma_supported()
Date: Wed, 12 Feb 2025 12:14:47 +0100

Remove hard-coded strings by using the str_yes_no() helper function.

Link: https://lkml.kernel.org/r/20250212111449.3675-2-thorsten.blum@linux.dev
Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
Reviewed-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: guoweikang <guoweikang.kernel@gmail.com>
Cc: Matt Turner <mattst88@gmail.com>
Cc: "Mike Rapoport (IBM)" <rppt@kernel.org>
Cc: Richard Henderson <richard.henderson@linaro.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/kernel/pci_iommu.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/arch/alpha/kernel/pci_iommu.c~alpha-use-str_yes_no-helper-in-pci_dac_dma_supported
+++ a/arch/alpha/kernel/pci_iommu.c
@@ -13,6 +13,7 @@
 #include <linux/log2.h>
 #include <linux/dma-map-ops.h>
 #include <linux/iommu-helper.h>
+#include <linux/string_choices.h>
 
 #include <asm/io.h>
 #include <asm/hwrpb.h>
@@ -212,7 +213,7 @@ static int pci_dac_dma_supported(struct
 
 	/* If both conditions above are met, we are fine. */
 	DBGA("pci_dac_dma_supported %s from %ps\n",
-	     ok ? "yes" : "no", __builtin_return_address(0));
+	     str_yes_no(ok), __builtin_return_address(0));
 
 	return ok;
 }
_

Patches currently in -mm which might be from thorsten.blum@linux.dev are

alpha-use-str_yes_no-helper-in-pci_dac_dma_supported.patch

