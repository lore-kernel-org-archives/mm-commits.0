Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67AC513B288
	for <mm-commits@vger.kernel.org>; Mon,  2 Sep 2024 03:46:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725248768; cv=none; b=UxeQ/sdB0IDpFD5qWHUuKUqYA0t/HkERzzqDeCNhifShP1PiaaMd8+gA7rkRVb59UzikWehYGaowobHYVVUeSX8HzcKz/2OLoqTtOKFyBulBs0v7LxkhEnF00DZTXO2VjdoWD9mMTNZr5/cHnwQvi0OvKwzG8DAc4ggOkXaOS1k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725248768; c=relaxed/simple;
	bh=kTriMKzM0LJn5BLfRnOeHq7D3DdL3tMYJ9ahghCnL60=;
	h=Date:To:From:Subject:Message-Id; b=oFczOTAXZ1qOyruKmBEHXmZ5PT2uuQ8QBSF+yavJqrj7MmPhJkLI3wYsuJbw3+s+P88E8txhcsVcW3z+IPWusNsVfEuwLh5o4obHInwCCYpAr977u/NYRWM2YjAcLIMrbJArlc3jr5mcMpe0ucDO0n29E6TxuKGRlUmB6wjg3X8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=u4DyNzn/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="u4DyNzn/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A9B7C4CEC2;
	Mon,  2 Sep 2024 03:46:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725248768;
	bh=kTriMKzM0LJn5BLfRnOeHq7D3DdL3tMYJ9ahghCnL60=;
	h=Date:To:From:Subject:From;
	b=u4DyNzn/rCJf04HvDWrvBjsNwQWtWnWNHEDsA0kA7+MThd3Vnrm2o5tpsvNe1E23j
	 XO2KfmAvq4WxMv41JO9ztJLnnvq5iFkQvfHbbO1RnipB1OFmeulKPnpADdU6OrJiM6
	 L7oSvc9hdXxpUE6B5cW0JFDlTUuCb4teqRJ5q6QI=
Date: Sun, 01 Sep 2024 20:46:07 -0700
To: mm-commits@vger.kernel.org,zhongjubin@huawei.com,will@kernel.org,tglx@linutronix.de,sjg@chromium.org,sam@gentoo.org,rdunlap@infradead.org,paul.walmsley@sifive.com,palmer@dabbelt.com,mpe@ellerman.id.au,me@lirui.org,krzk@kernel.org,joel@jms.id.au,jmaselbas@zdiv.net,herbert@gondor.apana.org.au,gregkh@linuxfoundation.org,emil.renner.berthing@canonical.com,corbet@lwn.net,catalin.marinas@arm.com,aou@eecs.berkeley.edu,lasse.collin@tukaani.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] xz-cleanup-crc32-edits-from-2018.patch removed from -mm tree
Message-Id: <20240902034608.3A9B7C4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: xz: cleanup CRC32 edits from 2018
has been removed from the -mm tree.  Its filename was
     xz-cleanup-crc32-edits-from-2018.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lasse Collin <lasse.collin@tukaani.org>
Subject: xz: cleanup CRC32 edits from 2018
Date: Sun, 21 Jul 2024 16:36:24 +0300

In 2018, a dependency on <linux/crc32poly.h> was added to avoid
duplicating the same constant in multiple files.  Two months later it was
found to be a bad idea and the definition of CRC32_POLY_LE macro was moved
into xz_private.h to avoid including <linux/crc32poly.h>.

xz_private.h is a wrong place for it too.  Revert back to the upstream
version which has the poly in xz_crc32_init() in xz_crc32.c.

Link: https://lkml.kernel.org/r/20240721133633.47721-10-lasse.collin@tukaani.org
Fixes: faa16bc404d7 ("lib: Use existing define with polynomial")
Fixes: 242cdad873a7 ("lib/xz: Put CRC32_POLY_LE in xz_private.h")
Signed-off-by: Lasse Collin <lasse.collin@tukaani.org>
Reviewed-by: Sam James <sam@gentoo.org>
Tested-by: Michael Ellerman <mpe@ellerman.id.au> (powerpc)
Cc: Krzysztof Kozlowski <krzk@kernel.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Joel Stanley <joel@jms.id.au>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Emil Renner Berthing <emil.renner.berthing@canonical.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Jubin Zhong <zhongjubin@huawei.com>
Cc: Jules Maselbas <jmaselbas@zdiv.net>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Rui Li <me@lirui.org>
Cc: Simon Glass <sjg@chromium.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/xz/xz_crc32.c   |    2 +-
 lib/xz/xz_private.h |    4 ----
 2 files changed, 1 insertion(+), 5 deletions(-)

--- a/lib/xz/xz_crc32.c~xz-cleanup-crc32-edits-from-2018
+++ a/lib/xz/xz_crc32.c
@@ -28,7 +28,7 @@ STATIC_RW_DATA uint32_t xz_crc32_table[2
 
 XZ_EXTERN void xz_crc32_init(void)
 {
-	const uint32_t poly = CRC32_POLY_LE;
+	const uint32_t poly = 0xEDB88320;
 
 	uint32_t i;
 	uint32_t j;
--- a/lib/xz/xz_private.h~xz-cleanup-crc32-edits-from-2018
+++ a/lib/xz/xz_private.h
@@ -104,10 +104,6 @@
 #	endif
 #endif
 
-#ifndef CRC32_POLY_LE
-#define CRC32_POLY_LE 0xedb88320
-#endif
-
 /*
  * Allocate memory for LZMA2 decoder. xz_dec_lzma2_reset() must be used
  * before calling xz_dec_lzma2_run().
_

Patches currently in -mm which might be from lasse.collin@tukaani.org are


