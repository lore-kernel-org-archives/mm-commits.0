Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6456211A3E
	for <mm-commits@vger.kernel.org>; Mon,  7 Apr 2025 01:48:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743990497; cv=none; b=bZ5zAhOVrCLSjrnCmCYrbr6WhKwQKwcd69uGnSVyPffIEimdzmvLkAUxyavupZvSK68zQFWWJmbZoUtJH2rAlc+XGMMV7oO7AvL/Zil5SnuvFIS1a9tqOfpGVC5lDvtlYAbS+Xbeex1LEBfTx/GLjbG0GgovysFd7thqPxztto8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743990497; c=relaxed/simple;
	bh=dV63nqqnTK1DPJKaNVhJyiCx2HBnR+iOHmXNAiKxCCU=;
	h=Date:To:From:Subject:Message-Id; b=GBsn/GFSloQVBmWTH0EyY+HTpovEoCCvendWNacqKpE5I+gkWKtxDMqPhGD4atgZFXNSmyvWmRdfqz8iqyCdPGSJpUzQqqIAd+qz8nM1BXYYVDW26WQXd5PJUp1WM3vivzZSDDinR2ouY0TBW8Tag3rDvDVk4qMvTOAPs14rZuc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fxC5xwq4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fxC5xwq4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2509AC4CEE3;
	Mon,  7 Apr 2025 01:48:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1743990497;
	bh=dV63nqqnTK1DPJKaNVhJyiCx2HBnR+iOHmXNAiKxCCU=;
	h=Date:To:From:Subject:From;
	b=fxC5xwq4QSDfTIoonHSNRbZyer6qv9tf05C28B7vkMkf9apmxzhm8UuJGsinYMXFa
	 1sfxzvpKQNvTn0pASIxJ3/cJ2JHo+eCVmSr0CtP9TdDhafng9DMIeZTYOyLdjAa9IJ
	 F75LDI8GSN9mnRbs42o2Uliv4ky4jRqrSj6q4GOM=
Date: Sun, 06 Apr 2025 18:48:16 -0700
To: mm-commits@vger.kernel.org,sfr@canb.auug.org.au,masahiroy@kernel.org,jeff.johnson@oss.qualcomm.com,arnd@arndb.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ucs2_string-add-module-description.patch added to mm-nonmm-unstable branch
Message-Id: <20250407014817.2509AC4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ucs2_string: add module description
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ucs2_string-add-module-description.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ucs2_string-add-module-description.patch

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
Subject: ucs2_string: add module description
Date: Mon, 24 Mar 2025 18:32:32 +0100

Modules without a description now cause a warning:

WARNING: modpost: missing MODULE_DESCRIPTION() in lib/ucs2_string.o

Link: https://lkml.kernel.org/r/20250324173242.1501003-7-arnd@kernel.org
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: Stehen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/ucs2_string.c |    1 +
 1 file changed, 1 insertion(+)

--- a/lib/ucs2_string.c~ucs2_string-add-module-description
+++ a/lib/ucs2_string.c
@@ -165,4 +165,5 @@ ucs2_as_utf8(u8 *dest, const ucs2_char_t
 }
 EXPORT_SYMBOL(ucs2_as_utf8);
 
+MODULE_DESCRIPTION("UCS2 string handling");
 MODULE_LICENSE("GPL v2");
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

