Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 767861448FB
	for <mm-commits@vger.kernel.org>; Tue, 23 Jul 2024 21:30:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721770235; cv=none; b=FxG0nxPARBtOHxffodfukA/XhDSDpmP79rAy6zCSSNdNLqSJVlSKNj5uhw/YT5tQ/lJojtLrQTPOGsGqtCMXjTNwfsOkpLALUOGvggDinJ3EGy4dUvsR7VFGynLw5tmOOqrJ7v+aremcws8K6UcETWigKygtgQKraACG81080Mo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721770235; c=relaxed/simple;
	bh=9JPPO82xGOHg2AL/3pd4S5uk1lGnQ30DHlyJGjzQJes=;
	h=Date:To:From:Subject:Message-Id; b=iS+J65o0FQvAvX8fe1+nmHWH7BrK53EKFMQl6tu/KH0jQiBuTM2eMhDm7J45h4GsxmJpONHOovZzfGY8R9aaNB1pehV6HYXaUUdn5lI7AYEdG4pgaFxKF5vODFAjgSR3HRKaraFXSFZFs7zvvXnOArfwXZ18zo5VCasfdyirfgs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Xu9yjlFp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Xu9yjlFp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1689C4AF09;
	Tue, 23 Jul 2024 21:30:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1721770235;
	bh=9JPPO82xGOHg2AL/3pd4S5uk1lGnQ30DHlyJGjzQJes=;
	h=Date:To:From:Subject:From;
	b=Xu9yjlFpV0PJ1pP/8gH9qVHfh0u9/aIB/frzxdV9s9Cc3QNUZJMGvex3FpLOCFpk3
	 Yo4pF+00/EpX0baREPpHGDRm0HRtqi0dEg0GMxh+GsdYvyw/bo/up8SdNQ5uedfgaa
	 X5LSG1uryGT+/WvTGzxxtyWICAbOW9KEqN4X7x70=
Date: Tue, 23 Jul 2024 14:30:34 -0700
To: mm-commits@vger.kernel.org,zhongjubin@huawei.com,will@kernel.org,tglx@linutronix.de,sjg@chromium.org,sam@gentoo.org,rdunlap@infradead.org,paul.walmsley@sifive.com,palmer@dabbelt.com,mpe@ellerman.id.au,me@lirui.org,krzk@kernel.org,joel@jms.id.au,jmaselbas@zdiv.net,herbert@gondor.apana.org.au,gregkh@linuxfoundation.org,emil.renner.berthing@canonical.com,corbet@lwn.net,catalin.marinas@arm.com,aou@eecs.berkeley.edu,lasse.collin@tukaani.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] docs-add-xz_extern-to-c_id_attributes.patch removed from -mm tree
Message-Id: <20240723213034.F1689C4AF09@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: docs: add XZ_EXTERN to c_id_attributes
has been removed from the -mm tree.  Its filename was
     docs-add-xz_extern-to-c_id_attributes.patch

This patch was dropped because an updated version will be issued

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
xz-cleanup-crc32-edits-from-2018.patch
xz-optimize-for-loop-conditions-in-the-bcj-decoders.patch
xz-add-arm64-bcj-filter.patch
xz-add-risc-v-bcj-filter.patch
xz-use-128-mib-dictionary-and-force-single-threaded-mode.patch
xz-adjust-arch-specific-options-for-better-kernel-compression.patch
arm64-boot-add-imagexz-support.patch
riscv-boot-add-imagexz-support.patch

