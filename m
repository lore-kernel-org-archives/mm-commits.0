Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8A2E17BA6
	for <mm-commits@vger.kernel.org>; Mon,  7 Apr 2025 01:48:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743990482; cv=none; b=Stz3cj0yUqJX1D1q60YWuGGaUA8QI4PsYTzCO9ewGmXadtjfMeH6ntxRQUHrGQLL1Wqkbig17WhcnsoFvYFafOO8fr02Y4uHRqjrQ8aWlsAhD7oa/d4CmxZuOyDYiDhX3MyJMpGFZYtp8uxUNtwb4RsoKu5ZPYbKKJo/60KpVLU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743990482; c=relaxed/simple;
	bh=By5WyndZ9cynrfBnrQXh88/PIpo+d2GLCUmc70s3F+U=;
	h=Date:To:From:Subject:Message-Id; b=N6brxcn+DSIyeorYjqYg2gXJmd8jyUBgyycSBDw6Tnd3zwhdnO3rZnxGK0eO97cTWgIqoMleITXHNk8hQK7c93BWZvE2kJ8U83vjoraIwMuCSVL9iQufV1sggFQ1VG0uXiaGk49pE4gMELF1RSYtdMMwuf7QeQJTRtAYl29gdbE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=eUyP2+jc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="eUyP2+jc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 370B8C4CEE3;
	Mon,  7 Apr 2025 01:48:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1743990482;
	bh=By5WyndZ9cynrfBnrQXh88/PIpo+d2GLCUmc70s3F+U=;
	h=Date:To:From:Subject:From;
	b=eUyP2+jccQSnPhCeTubeFaTCet+43VEeipCDwXhZlTEOYrDIp6u39+LhYxlb58reE
	 Yke/uJ3AZrTpseTQ+vf/SgaTnfu7asEhgACW4vV/GIaGDBgXNqW58Ag8vRnsyooeVn
	 QtwQ+eM3MhAPCmzCUIaWlMIt1Kf2+rf0lTZS/iUw=
Date: Sun, 06 Apr 2025 18:48:01 -0700
To: mm-commits@vger.kernel.org,sfr@canb.auug.org.au,masahiroy@kernel.org,jeff.johnson@oss.qualcomm.com,geert@linux-m68k.org,arnd@arndb.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + asn1-add-module-description.patch added to mm-nonmm-unstable branch
Message-Id: <20250407014802.370B8C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ASN.1: add module description
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     asn1-add-module-description.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/asn1-add-module-description.patch

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
From: Arnd Bergmann <arnd@arndb.de>
Subject: ASN.1: add module description
Date: Mon, 24 Mar 2025 18:32:27 +0100

This is needed to avoid a build warning:

WARNING: modpost: missing MODULE_DESCRIPTION() in lib/asn1_decoder.o

Link: https://lkml.kernel.org/r/20250324173242.1501003-2-arnd@kernel.org
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

exportfs-add-module-description.patch
asn1-add-module-description.patch
samples-livepatch-add-module-descriptions.patch
fpga-tests-add-module-descriptions.patch
xenbus-add-module-description.patch
zlib-add-module-description.patch
ucs2_string-add-module-description.patch
mm-kasan-add-module-decription.patch
kunit-slub-add-module-description.patch

