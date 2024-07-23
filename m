Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E504B130AC8
	for <mm-commits@vger.kernel.org>; Tue, 23 Jul 2024 02:28:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721701736; cv=none; b=qFQZaXvfRwTBSvoFA/fy1HlMWrcZwwBHe/mPjEaqr9Gz+nYGBBv0hF2XsG1oUBjnLJJah/V/H0LypfamJlLIJZKQWjT9ON8S2WkYjwkLlHhSOcsk1Ug/ynspRTvLnYD1Q4UcnkHvkZIYoMU0w8Dk2/67+1kMOUJzh3NDmoKcP5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721701736; c=relaxed/simple;
	bh=p26KiBpgLYOWS9EbVbBoj395ylgwkTmJZycmb7Gdbhw=;
	h=Date:To:From:Subject:Message-Id; b=JO/IYY/TVtBvvfcuTn035XkB3bplNf20Jqfi0Tgv84gU/vdMlO8eok02gdpIsxTkR7r5GiDPQREFRYPweHNHMosejxDB04QauxhHPhq2YRU0JSAKfIWCs7MUstecuN1481L4oh/kVexcf8vdH8E7exqPhJ1/PqXOpwRP1StKXnM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=iax+cDle; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="iax+cDle"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31591C116B1;
	Tue, 23 Jul 2024 02:28:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1721701735;
	bh=p26KiBpgLYOWS9EbVbBoj395ylgwkTmJZycmb7Gdbhw=;
	h=Date:To:From:Subject:From;
	b=iax+cDle5aWhJO0chseo/5b2Nk/fKjIU2EiSETAeAVqvdDuDYNkWMFPpV9cdQevKO
	 Z9FXZ4agPUOsMz7Dw5LS5YJZ7Wi2+KwEfCqGLh23E8a2biDug+uj603I9kPgsXFyNO
	 6n5NJcgFoJuT/MMmUrYmnxmWFLQv6fri3YHd37zk=
Date: Mon, 22 Jul 2024 19:28:49 -0700
To: mm-commits@vger.kernel.org,zhongjubin@huawei.com,will@kernel.org,tglx@linutronix.de,sjg@chromium.org,sam@gentoo.org,rdunlap@infradead.org,paul.walmsley@sifive.com,palmer@dabbelt.com,mpe@ellerman.id.au,me@lirui.org,krzk@kernel.org,joel@jms.id.au,jmaselbas@zdiv.net,herbert@gondor.apana.org.au,gregkh@linuxfoundation.org,emil.renner.berthing@canonical.com,corbet@lwn.net,catalin.marinas@arm.com,aou@eecs.berkeley.edu,lasse.collin@tukaani.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maintainers-add-xz-embedded-maintainer.patch added to mm-nonmm-unstable branch
Message-Id: <20240723022855.31591C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: MAINTAINERS: add XZ Embedded maintainer
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     maintainers-add-xz-embedded-maintainer.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maintainers-add-xz-embedded-maintainer.patch

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
Subject: MAINTAINERS: add XZ Embedded maintainer
Date: Sun, 21 Jul 2024 16:36:16 +0300

Patch series "xz: Updates to license, filters, and compression options",
v2.

XZ Embedded, the upstream project, switched from public domain to the BSD
Zero Clause License (0BSD).  Now matching SPDX license identifiers can be
added.

Documentation was revised.  Fix syntax errors in kernel-doc comments in
<linux/xz.h>.  The xz_dec API docs from <linux/xz.h> are now included in
Documentation/staging/xz.rst.

The new ARM64 and RISC-V filters can be used for kernel decompression if
CONFIG_EFI_ZBOOT=y.  The filters can be used by Squashfs too.  (Userspace
Squashfs-tools already had the ARM64 filter support committed but it was
reverted due to backdoor fears.  I try to get ARM64 and RISC-V filter
support added to Squashfs-tools somewhat soon.)

Account for the default threading change made in the xz command line tool
version 5.6.0.  Tweak kernel compression options for archs that support XZ
compressed kernel.


This patch (of 16):

I have been the maintainer of the upstream project since I submitted the
code to Linux in 2010 but I forgot to add myself to MAINTAINERS.

Link: https://lkml.kernel.org/r/20240721133633.47721-1-lasse.collin@tukaani.org
Link: https://lkml.kernel.org/r/20240721133633.47721-2-lasse.collin@tukaani.org
Signed-off-by: Lasse Collin <lasse.collin@tukaani.org>
Reviewed-by: Sam James <sam@gentoo.org>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Emil Renner Berthing <emil.renner.berthing@canonical.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Joel Stanley <joel@jms.id.au>
Cc: Jonathan Corbet <corbet@lwn.net>
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

 MAINTAINERS |   13 +++++++++++++
 1 file changed, 13 insertions(+)

--- a/MAINTAINERS~maintainers-add-xz-embedded-maintainer
+++ a/MAINTAINERS
@@ -25170,6 +25170,19 @@ S:	Maintained
 F:	drivers/spi/spi-xtensa-xtfpga.c
 F:	sound/soc/xtensa/xtfpga-i2s.c
 
+XZ EMBEDDED
+M:	Lasse Collin <lasse.collin@tukaani.org>
+S:	Maintained
+W:	https://tukaani.org/xz/embedded.html
+B:	https://github.com/tukaani-project/xz-embedded/issues
+C:	irc://irc.libera.chat/tukaani
+F:	Documentation/staging/xz.rst
+F:	include/linux/decompress/unxz.h
+F:	include/linux/xz.h
+F:	lib/decompress_unxz.c
+F:	lib/xz/
+F:	scripts/xz_wrap.sh
+
 YAM DRIVER FOR AX.25
 M:	Jean-Paul Roubelat <jpr@f6fbb.org>
 L:	linux-hams@vger.kernel.org
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

