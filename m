Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B14DF134D4
	for <mm-commits@vger.kernel.org>; Sat, 12 Apr 2025 00:33:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744418006; cv=none; b=Bin9jjLog+h22lLeEmdbc9Fj3D/Xw9TSBSY9Puv1LZ4CDtiYyan4U0hemIyDtsi0H4/ZQLacCT3OD59kmWQNITFikLnT9GFiNt8FZUidW7kaVsKsUaR4ZrCkl2D5yDEwnRkcmBiUUaeUpWc3kzdZgPpHOpWmlZqZ6Qfi2gdRzY4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744418006; c=relaxed/simple;
	bh=JczBlcmoApofeZg18HEVMNbOWC5kYOhxLqtDTPsnbV0=;
	h=Date:To:From:Subject:Message-Id; b=Vu8jkVw/Hc5zCfhfBmr0iqaCQHAcGDO4PxWWrLVnXJ1I0XD/wQ8QoIDPfA4fiygxyRLnsiZxVd5O/AFLGsnYZbUg0VLWd+ArU7Nn9ia4isdC8x0focbS/gSLaDpvThRuAbX+u8fAfS6mEc1dseKlXcenmKiACP9heoGLG2vnyOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jAtASoSo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jAtASoSo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EEC8C4CEE2;
	Sat, 12 Apr 2025 00:33:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1744418006;
	bh=JczBlcmoApofeZg18HEVMNbOWC5kYOhxLqtDTPsnbV0=;
	h=Date:To:From:Subject:From;
	b=jAtASoSokiZxtCFOvQrhsdgzoiIDtxRedzJqR5vVkGPZ/b6ybA0TcyLc1DLOceG3C
	 rUW+1+E8XLcwdcuMisQ/LAQfXbgyAwzi9xx+tYXmJfPqgcBIUAo6+eB7MaUzjzffIg
	 AwECSt653RyU5p0Bu7ruhvkTbspTBKLuGK9bZ0pU=
Date: Fri, 11 Apr 2025 17:33:25 -0700
To: mm-commits@vger.kernel.org,sfr@canb.auug.org.au,masahiroy@kernel.org,jeff.johnson@oss.qualcomm.com,geert@linux-m68k.org,arnd@arndb.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] asn1-add-module-description.patch removed from -mm tree
Message-Id: <20250412003326.1EEC8C4CEE2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ASN.1: add module description
has been removed from the -mm tree.  Its filename was
     asn1-add-module-description.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Arnd Bergmann <arnd@arndb.de>
Subject: ASN.1: add module description
Date: Mon, 24 Mar 2025 18:32:27 +0100

This is needed to avoid a build warning:

WARNING: modpost: missing MODULE_DESCRIPTION() in lib/asn1_decoder.o

Link: https://lkml.kernel.org/r/20250324173242.1501003-2-arnd@kernel.org
Fixes: 6c6c1fc09de3 ("modpost: require a MODULE_DESCRIPTION()")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Tested-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: Stehen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/asn1_decoder.c |    1 +
 1 file changed, 1 insertion(+)

--- a/lib/asn1_decoder.c~asn1-add-module-description
+++ a/lib/asn1_decoder.c
@@ -518,4 +518,5 @@ error:
 }
 EXPORT_SYMBOL_GPL(asn1_ber_decoder);
 
+MODULE_DESCRIPTION("Decoder for ASN.1 BER/DER/CER encoded bytestream");
 MODULE_LICENSE("GPL");
_

Patches currently in -mm which might be from arnd@arndb.de are


