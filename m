Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 928661442E8
	for <mm-commits@vger.kernel.org>; Sun, 16 Feb 2025 20:17:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739737055; cv=none; b=s89r77dhqFRZjOETkrWjf/IMqdA99oH/Eb0IWxopDQBXGRZhNBUiXNGjAkrp7GQz+TKE5UNJ9/WGvIPqPbNrsNNidDOLcWLxzdiNQ2S1P7D84jTc8W1i/xltrTPl9YEpjyDGEz1ODOv1+0BxI4dnZCSC4LlQ2/WzTgqJaLpHLnw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739737055; c=relaxed/simple;
	bh=O1H6reBjBL+10q2SBVNHJ2Tk8EX/9bM1qx9gdjfAiW4=;
	h=Date:To:From:Subject:Message-Id; b=LmYHryeuJKvk4EiSiLm8SYNrbuXwmqVwi7X0ob4fGlrjY0RqOAjRXuqoZfYNXy1BBf3VEUci0zPI/iEKsB9aheXpUs44+An+X6Mi/NeMzhsx/bY+yK0E22aIk9zq2fGq5EpXxvCQV8MCSPeLICRVknHZIep5vm70CRB3f76v/bI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rnDa6NzK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rnDa6NzK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB13DC4CEDD;
	Sun, 16 Feb 2025 20:17:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1739737054;
	bh=O1H6reBjBL+10q2SBVNHJ2Tk8EX/9bM1qx9gdjfAiW4=;
	h=Date:To:From:Subject:From;
	b=rnDa6NzKZQ67mrsN+QR2dLSJHeE83dQIRxW4tjFYRBMLgztEt4+bu/5V0urXZyzwS
	 hmXmfdQDEybl2W8+7iOzSmZi+I+4EWjK8Eg5vLqnHxAnomQiBnKpY9zecyyBDpzO+Y
	 YaGovC5Xc/eE6UL2B5rYXuk/uJQNHp8ApHuDQVkE=
Date: Sun, 16 Feb 2025 12:17:34 -0800
To: mm-commits@vger.kernel.org,surenb@google.com,rppt@kernel.org,richard.henderson@linaro.org,mattst88@gmail.com,guoweikang.kernel@gmail.com,geert@linux-m68k.org,agordeev@linux.ibm.com,thorsten.blum@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] alpha-use-str_yes_no-helper-in-pci_dac_dma_supported.patch removed from -mm tree
Message-Id: <20250216201734.CB13DC4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: alpha: use str_yes_no() helper in pci_dac_dma_supported()
has been removed from the -mm tree.  Its filename was
     alpha-use-str_yes_no-helper-in-pci_dac_dma_supported.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Thorsten Blum <thorsten.blum@linux.dev>
Subject: alpha: use str_yes_no() helper in pci_dac_dma_supported()
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


