Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F30A8130AC8
	for <mm-commits@vger.kernel.org>; Tue, 23 Jul 2024 02:29:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721701761; cv=none; b=uU1YY/1JCtocw6Ng/b7d2Y6SIq/KUykc77/6L+0COJGK1ZVqct4h80cCuDB22ZlLJQyAP4SOQ1nCbUTO2Ylkt16rnCwa5uXXKXnQY+2wnG7DSWH9f1smjiSl8SlSLbPNmHc1WjydtBxp3Mp1gVriCCKJI0mDRIjcEO1BiGgYc3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721701761; c=relaxed/simple;
	bh=6tOYrSBvwr7wPwu79azLCrOVl1Fz4vUf7Qkdvu6jSsE=;
	h=Date:To:From:Subject:Message-Id; b=cazAJzu8JKu34n8GQOex6Y3nXMhJ/H+bC4ea2stk4gaQMPpCnxKSGQ3NivT3hAUKQdS7oPmxYN/ElA7O8oCx5NSGuiW1k3FTsEOeSFNhXrBqxoWha99T0KVlwIIhuOCz+jeI2iY7wPXXSgbrgGYSUSUXMHCP2RLEH9ISPFo3WZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NFqW04Ur; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NFqW04Ur"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF9CAC116B1;
	Tue, 23 Jul 2024 02:29:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1721701760;
	bh=6tOYrSBvwr7wPwu79azLCrOVl1Fz4vUf7Qkdvu6jSsE=;
	h=Date:To:From:Subject:From;
	b=NFqW04UrYNo+RHS3x+Ul9aEk6xTFt+1wTaZwQPmA4MYn6c0uiC3uK2zyAXvuTRGT7
	 V5EiUnULSVPJ9Gi0fYPpSmG/vCOw9EIFMVCALk11OhaFvKEzmRGI9tMWmyR0cmMNtw
	 aj0QdsYhzT992bWl5cfn3BqfczsFAjCGbcUmQJoY=
Date: Mon, 22 Jul 2024 19:29:20 -0700
To: mm-commits@vger.kernel.org,zhongjubin@huawei.com,will@kernel.org,tglx@linutronix.de,sjg@chromium.org,sam@gentoo.org,rdunlap@infradead.org,paul.walmsley@sifive.com,palmer@dabbelt.com,mpe@ellerman.id.au,me@lirui.org,krzk@kernel.org,joel@jms.id.au,jmaselbas@zdiv.net,herbert@gondor.apana.org.au,gregkh@linuxfoundation.org,emil.renner.berthing@canonical.com,corbet@lwn.net,catalin.marinas@arm.com,aou@eecs.berkeley.edu,lasse.collin@tukaani.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + docs-add-xz_extern-to-c_id_attributes.patch added to mm-nonmm-unstable branch
Message-Id: <20240723022920.BF9CAC116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: docs: add XZ_EXTERN to c_id_attributes
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     docs-add-xz_extern-to-c_id_attributes.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-add-xz_extern-to-c_id_attributes.patch

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
From: Lasse Collin <lasse.collin@tukaani.org>
Subject: docs: add XZ_EXTERN to c_id_attributes
Date: Sun, 21 Jul 2024 16:36:23 +0300

include/linux/xz.h uses XZ_EXTERN in function prototypes.  It's needed in
the preboot code.  Adding XZ_EXTERN c_id_attributes silences warnings and
makes the intradocument links to the xz_dec functions work.

Link: https://lkml.kernel.org/r/20240721133633.47721-9-lasse.collin@tukaani.org
Signed-off-by: Lasse Collin <lasse.collin@tukaani.org>
Reviewed-by: Sam James <sam@gentoo.org>
Acked-by: Jonathan Corbet <corbet@lwn.net>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Emil Renner Berthing <emil.renner.berthing@canonical.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Joel Stanley <joel@jms.id.au>
Cc: Jubin Zhong <zhongjubin@huawei.com>
Cc: Jules Maselbas <jmaselbas@zdiv.net>
Cc: Krzysztof Kozlowski <krzk@kernel.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Rui Li <me@lirui.org>
Cc: Simon Glass <sjg@chromium.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/conf.py |    3 +++
 1 file changed, 3 insertions(+)

--- a/Documentation/conf.py~docs-add-xz_extern-to-c_id_attributes
+++ a/Documentation/conf.py
@@ -123,6 +123,9 @@ if major >= 3:
 
             # include/linux/btf.h
             "__bpf_kfunc",
+
+            # include/linux/xz.h
+            "XZ_EXTERN",
         ]
 
 else:
_

Patches currently in -mm which might be from lasse.collin@tukaani.org are

maintainers-add-xz-embedded-maintainer.patch
licenses-add-0bsd-license-text.patch
xz-switch-from-public-domain-to-bsd-zero-clause-license-0bsd.patch
xz-fix-comments-and-coding-style.patch
xz-fix-kernel-doc-formatting-errors-in-xzh.patch
xz-improve-the-microlzma-kernel-doc-in-xzh.patch
xz-documentation-staging-xzrst-revise-thoroughly.patch
docs-add-xz_extern-to-c_id_attributes.patch
xz-cleanup-crc32-edits-from-2018.patch
xz-optimize-for-loop-conditions-in-the-bcj-decoders.patch
xz-add-arm64-bcj-filter.patch
xz-add-risc-v-bcj-filter.patch
xz-use-128-mib-dictionary-and-force-single-threaded-mode.patch
xz-adjust-arch-specific-options-for-better-kernel-compression.patch
arm64-boot-add-imagexz-support.patch
riscv-boot-add-imagexz-support.patch

