Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B60817BA6
	for <mm-commits@vger.kernel.org>; Mon,  7 Apr 2025 01:48:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743990495; cv=none; b=CrGsWGvRhs/XpxyhfXe8Si/NVLOwwFC4oKsC6WFdwS45NoB94hm2hy7N2DiYMRqK51YBvlPUoQm0cF0oqF4Ij3BFocsUUCVxl9khm1uY8b0EeYkPn7lh2wJi2acghi9G4dcYF+9uFRsX9/hMN83HX9hyjCaFTWKa2mGPh8Md4Dc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743990495; c=relaxed/simple;
	bh=vUtDhzI0bUlTlK4do3tQsfvy/3bf5zUGi2hKJkYfCRc=;
	h=Date:To:From:Subject:Message-Id; b=QGxqxRv+jNHPgO/QqxzVxZoFkoX/lHshobarw9f25nyBDQM8j7B6xQvFfWR0QwbxSPEIxU1XscPdeHGnKJki1abWV4PZ+ozLB1rFLKIL+kw/U8+EA46Unx4UhYhXSa3HUaZlEiJ80u9k6bA5ed7+Uuhpctobl8FaIMznjtGEOh4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=UHNWOEIX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="UHNWOEIX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28512C4CEE3;
	Mon,  7 Apr 2025 01:48:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1743990495;
	bh=vUtDhzI0bUlTlK4do3tQsfvy/3bf5zUGi2hKJkYfCRc=;
	h=Date:To:From:Subject:From;
	b=UHNWOEIXbB8UjTi75kw3e9GI/3EZZiXQx4UaGBRjJaoIcjMDUTH4ccuN1Y0GidQfH
	 oaq0684ZEeiD4uckv/dtwAWLX7IOS8V+fBlMOqn6GVtL3+S7bl/kxMEVULDAkMvkbI
	 9Bq7EjtHotHziOfClB6gvslsEEfkJ1kJFpuQNPDA=
Date: Sun, 06 Apr 2025 18:48:14 -0700
To: mm-commits@vger.kernel.org,sfr@canb.auug.org.au,masahiroy@kernel.org,jeff.johnson@oss.qualcomm.com,arnd@arndb.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + zlib-add-module-description.patch added to mm-nonmm-unstable branch
Message-Id: <20250407014815.28512C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: zlib: add module description
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     zlib-add-module-description.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zlib-add-module-description.patch

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
Subject: zlib: add module description
Date: Mon, 24 Mar 2025 18:32:31 +0100

Modules without a description now cause a warning:

WARNING: modpost: missing MODULE_DESCRIPTION() in lib/zlib_inflate/zlib_inflate.o

Link: https://lkml.kernel.org/r/20250324173242.1501003-6-arnd@kernel.org
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: Stehen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/zlib_inflate/inflate_syms.c |    1 +
 1 file changed, 1 insertion(+)

--- a/lib/zlib_inflate/inflate_syms.c~zlib-add-module-description
+++ a/lib/zlib_inflate/inflate_syms.c
@@ -18,4 +18,5 @@ EXPORT_SYMBOL(zlib_inflateEnd);
 EXPORT_SYMBOL(zlib_inflateReset);
 EXPORT_SYMBOL(zlib_inflateIncomp); 
 EXPORT_SYMBOL(zlib_inflate_blob);
+MODULE_DESCRIPTION("Data decompression using the deflation algorithm");
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

