Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73D7F14534C
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 05:26:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719293208; cv=none; b=Lg4tExQqklrJG0fkh6W4Ab9kxsBloiokKUJzxnfebBNZ0xwztp3nUC0X9kV4o8eY1Kftx4gu4FpBD3RNEXopSL/RzyoI9avJOTqpaJboKRlp5t6R9HhmYe18mu30XllWSr0c0is6uGAEQyrgXAbkSRmU2MHUBjOCezXElhDeFR0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719293208; c=relaxed/simple;
	bh=9VEbkKch0YOeMHxNZWEAT7hXDzB2UiNXJfF9GLj6Yvc=;
	h=Date:To:From:Subject:Message-Id; b=DFylLocfoF3EsLC2i616Hofu/6EsIiSZX+S3Q6C5ZDHUdHfjNhOqgP92VwCHNvMPwrvcqSQhqG0Qt3dWoZG2YEbJL4UWepoTHBSlrT/XiGA7+4OD50DWP6IGkAJ2vau35+nA6drU6d70ixhpSzv/eSxAW6E6Cs/wRcxObPVDGS8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=GRRdzaZE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="GRRdzaZE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 480D2C32782;
	Tue, 25 Jun 2024 05:26:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719293208;
	bh=9VEbkKch0YOeMHxNZWEAT7hXDzB2UiNXJfF9GLj6Yvc=;
	h=Date:To:From:Subject:From;
	b=GRRdzaZESDKAW2ikF58S6iZteCDUXFmJ5/U0ljsnH5rsdCj6jUz4r0+XaOw2w14Zr
	 /e2Y+DC+ZHkSzufFj71XCzjSeTb5m2C1wz/WapmkhyQsK+p4gXXqqfXwGJG/nHzRML
	 PpuES844nFdWhoZGHD5zkjN9RFl1MWhNabTUlBvI=
Date: Mon, 24 Jun 2024 22:26:47 -0700
To: mm-commits@vger.kernel.org,mcgrof@kernel.org,lucas.demarchi@intel.com,quic_jjohnson@quicinc.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] lib-test_kmod-add-missing-module_description-macro.patch removed from -mm tree
Message-Id: <20240625052648.480D2C32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib/test_kmod: add missing MODULE_DESCRIPTION() macro
has been removed from the -mm tree.  Its filename was
     lib-test_kmod-add-missing-module_description-macro.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Jeff Johnson <quic_jjohnson@quicinc.com>
Subject: lib/test_kmod: add missing MODULE_DESCRIPTION() macro
Date: Fri, 31 May 2024 17:23:09 -0700

make allmodconfig && make W=1 C=1 reports:
WARNING: modpost: missing MODULE_DESCRIPTION() in lib/test_kmod.o

Add the missing invocation of the MODULE_DESCRIPTION() macro.

Link: https://lkml.kernel.org/r/20240531-md-lib-test_kmod-v1-1-fdf11bc6095e@quicinc.com
Signed-off-by: Jeff Johnson <quic_jjohnson@quicinc.com>
Reviewed-by: Lucas De Marchi <lucas.demarchi@intel.com>
Cc: Luis Chamberlain <mcgrof@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_kmod.c |    1 +
 1 file changed, 1 insertion(+)

--- a/lib/test_kmod.c~lib-test_kmod-add-missing-module_description-macro
+++ a/lib/test_kmod.c
@@ -1223,4 +1223,5 @@ static void __exit test_kmod_exit(void)
 module_exit(test_kmod_exit);
 
 MODULE_AUTHOR("Luis R. Rodriguez <mcgrof@kernel.org>");
+MODULE_DESCRIPTION("kmod stress test driver");
 MODULE_LICENSE("GPL");
_

Patches currently in -mm which might be from quic_jjohnson@quicinc.com are

kfifo-add-missing-module_description-macros.patch
resource-add-missing-module_description.patch
selftests-fpu-add-missing-module_description-macro.patch

