Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CFD0134D4
	for <mm-commits@vger.kernel.org>; Sat, 12 Apr 2025 00:33:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744418011; cv=none; b=Uo7rjLRI45tp8NnHQNTHXIJ40YvWaY5qW+FOkVnXorB5vul1e9tXDPF3sOkjeptDVz0TKdZqfcHPP0dfem+Quph481B5TXoh4+OZwPeYLpDu5dUDc/3AJfMt1WF4obr7dJGYsaDu9UtmmG5xmRFdjILoeN5mlA3ib+KyBf+m3OY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744418011; c=relaxed/simple;
	bh=ytCQnBEXEFyn6kreP8W6V91wu00x4YF4YiTV7NQuyY0=;
	h=Date:To:From:Subject:Message-Id; b=fCxfC4ZJPb/Q2oIXgfXzK6H/z5nPFsGLFkBfWM6EVdtPxM/D9jK5L+gyCabMFUeA0tSEXzjRRGs66tpj00BPrOV6oxFin55vPh59PZvN/yzvY4q9yRapZ6WMooyKoI0SbeGb/ZzI3MblwfH7YiAB2Hr693IUfmYwtugqrKYudzY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wFKgfCp0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wFKgfCp0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 494F7C4CEE2;
	Sat, 12 Apr 2025 00:33:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1744418011;
	bh=ytCQnBEXEFyn6kreP8W6V91wu00x4YF4YiTV7NQuyY0=;
	h=Date:To:From:Subject:From;
	b=wFKgfCp0MDkt1PdLu9+yqFzQEU/re9lTUxeW49bxsBDg4qR23Ih6r33ulNJr+SWjq
	 gAPIGC3+HlHonhHeGlafmfxLpV19gF00FfBFaH9vKuGoP4XSbDndbBhaZr0h9jVsQY
	 r9H1wFo1YEyNzBkalI223IsMPNJNZr3zm+zogDNw=
Date: Fri, 11 Apr 2025 17:33:30 -0700
To: mm-commits@vger.kernel.org,sfr@canb.auug.org.au,masahiroy@kernel.org,jeff.johnson@oss.qualcomm.com,arnd@arndb.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] zlib-add-module-description.patch removed from -mm tree
Message-Id: <20250412003331.494F7C4CEE2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: zlib: add module description
has been removed from the -mm tree.  Its filename was
     zlib-add-module-description.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Arnd Bergmann <arnd@arndb.de>
Subject: zlib: add module description
Date: Mon, 24 Mar 2025 18:32:31 +0100

Modules without a description now cause a warning:

WARNING: modpost: missing MODULE_DESCRIPTION() in lib/zlib_inflate/zlib_inflate.o

Link: https://lkml.kernel.org/r/20250324173242.1501003-6-arnd@kernel.org
Fixes: 6c6c1fc09de3 ("modpost: require a MODULE_DESCRIPTION()")
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


