Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37583186A;
	Wed, 27 Aug 2025 01:03:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756256627; cv=none; b=L+wMliMo4yRgXC08QbF0bPN93StjPKZEKfsb+Y5KC3Wo5ZPmG4Nk8tyav2HJUOo6JVCVI4DQ648sN/b9/XrrWCuxgqdJkIissvQu1IJwqjq2kFqwkUzsNjoaFU3RUcVdxB4AECrew9MlLjwfIBJW2ZErJpIegBp5ARHlIDNV9Yg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756256627; c=relaxed/simple;
	bh=e8Sz3nQRGFP1ivd+uPtYZfxaLImhYXmcP1SPjGhWlvI=;
	h=Date:To:From:Subject:Message-Id; b=cFOk6Zcr6TGjRsjTbFKPIDXjPAtN4T62DJjS662MGvSamOPNWurzei45tuRLQDSpmjdJrgtvVVaUA3AHC+56KV5NKGzYDVQ46h8gwEuCvQ+rnwBxg5hxB8FTa8Rl3/sPXRhMXYdQQIBvAcpo/g5gWv6GMV/ph/IWl2WoQ5xTmxA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HfNGlcAi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HfNGlcAi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB861C4CEF1;
	Wed, 27 Aug 2025 01:03:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1756256626;
	bh=e8Sz3nQRGFP1ivd+uPtYZfxaLImhYXmcP1SPjGhWlvI=;
	h=Date:To:From:Subject:From;
	b=HfNGlcAioejw44e4VPJGWHpquzWQRAJ9Yz/kQr0qOGR3Lri956r0fyHpFpb7PFiZ7
	 skecEC0O5bTcRfaO0TUxGNE0zRoGCVHCU8ut2bv/+kUhsCKGLmmWUHH2NCfkPsDl7h
	 r8uXeWgUdpXai5HcS5po2opGXqX1PA3lbOw4z48M=
Date: Tue, 26 Aug 2025 18:03:46 -0700
To: mm-commits@vger.kernel.org,vkuznets@redhat.com,stable@vger.kernel.org,ryncsn@gmail.com,okozina@redhat.com,mark.rutland@arm.com,kernelfans@gmail.com,gmazyland@gmail.com,dyoung@redhat.com,dave.hansen@intel.com,coxu@redhat.com,bhe@redhat.com,berrange@redhat.com,leitao@debian.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] kexec-arm64-initialize-the-random-field-of-kbuf-to-zero-in-the-image-loader.patch removed from -mm tree
Message-Id: <20250827010346.AB861C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kexec/arm64: initialize the random field of kbuf to zero in the image loader
has been removed from the -mm tree.  Its filename was
     kexec-arm64-initialize-the-random-field-of-kbuf-to-zero-in-the-image-loader.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Breno Leitao <leitao@debian.org>
Subject: kexec/arm64: initialize the random field of kbuf to zero in the image loader
Date: Thu Aug 21 04:11:21 2025 -0700

Add an explicit initialization for the random member of the kbuf structure
within the image_load function in arch/arm64/kernel/kexec_image.c. 
Setting kbuf.random to zero ensures a deterministic and clean starting
state for the buffer used during kernel image loading, avoiding this UBSAN
issue later, when kbuf.random is read.

  [   32.362488] UBSAN: invalid-load in ./include/linux/kexec.h:210:10
  [   32.362649] load of value 252 is not a valid value for type '_Bool'

Link: https://lkml.kernel.org/r/oninomspajhxp4omtdapxnckxydbk2nzmrix7rggmpukpnzadw@c67o7njgdgm3
Fixes: bf454ec31add ("kexec_file: allow to place kexec_buf randomly")
Signed-off-by: Breno Leitao <leitao@debian.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Coiby Xu <coxu@redhat.com>
Cc: "Daniel P. Berrange" <berrange@redhat.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Dave Young <dyoung@redhat.com>
Cc: Kairui Song <ryncsn@gmail.com>
Cc: Liu Pingfan <kernelfans@gmail.com>
Cc: Milan Broz <gmazyland@gmail.com>
Cc: Ondrej Kozina <okozina@redhat.com>
Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/kernel/kexec_image.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/arm64/kernel/kexec_image.c~kexec-arm64-initialize-the-random-field-of-kbuf-to-zero-in-the-image-loader
+++ a/arch/arm64/kernel/kexec_image.c
@@ -76,6 +76,7 @@ static void *image_load(struct kimage *i
 	kbuf.buf_min = 0;
 	kbuf.buf_max = ULONG_MAX;
 	kbuf.top_down = false;
+	kbuf.random = 0;
 
 	kbuf.buffer = kernel;
 	kbuf.bufsz = kernel_len;
_

Patches currently in -mm which might be from leitao@debian.org are


