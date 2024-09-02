Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB3214207A
	for <mm-commits@vger.kernel.org>; Mon,  2 Sep 2024 03:45:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725248757; cv=none; b=pnYqK8YjDvV9ev/X1ih3nnjhGW8UC52vTjkXX+saHivnOrZ9ld8faihmVFlUzVArWYeMSx9LYwyzPx5fgR+4H3NirtRfX1l5ohQ6GBTUgxWXLhu+ooEqRWZjh2jfhQbNzOZ2IcpT1xtD2/xMqCLQtm6MTos/YKKIclFpsa9oCLg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725248757; c=relaxed/simple;
	bh=qNHvF0N14PEDTgWXv2Sv8G+Z42GUx5yHzzNgwE3UWrk=;
	h=Date:To:From:Subject:Message-Id; b=WkUgKABek97qX6B2q2CJo1xDGaWt+SQXIuw2wpK0ctbR/6KzthogTrEyAh8gKtM0j/lQSqbiINLhdtc0av31Ej27a+rxYRJc4ItaUqJFVb1GOzvDTTaiSLQs29jHqIYuu4rjBKwpsdUv9Twi9u3fC+t78OBPY8B/LwBqsKTbz1g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qFvZtfLr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qFvZtfLr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5417CC4CEC2;
	Mon,  2 Sep 2024 03:45:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725248757;
	bh=qNHvF0N14PEDTgWXv2Sv8G+Z42GUx5yHzzNgwE3UWrk=;
	h=Date:To:From:Subject:From;
	b=qFvZtfLrK5KFKLDbSLqpoXHBOyZ/+K3VaAHLZxU0H7NQAHAwG/msJ7JIW2xzxTo7D
	 IuMiVMbfQz81igR7EUoNc+AR1BiTGAU2M0/IPYFICTNozyevwvBomhQtYdnSsxc3DL
	 3y+pR5k93jbzZgo35Z4x7SRHtTSVkAxEVSKBgNPk=
Date: Sun, 01 Sep 2024 20:45:56 -0700
To: mm-commits@vger.kernel.org,zhongjubin@huawei.com,will@kernel.org,tglx@linutronix.de,sjg@chromium.org,sam@gentoo.org,rdunlap@infradead.org,paul.walmsley@sifive.com,palmer@dabbelt.com,mpe@ellerman.id.au,me@lirui.org,krzk@kernel.org,joel@jms.id.au,jmaselbas@zdiv.net,herbert@gondor.apana.org.au,gregkh@linuxfoundation.org,emil.renner.berthing@canonical.com,corbet@lwn.net,catalin.marinas@arm.com,aou@eecs.berkeley.edu,lasse.collin@tukaani.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] maintainers-add-xz-embedded-maintainer.patch removed from -mm tree
Message-Id: <20240902034557.5417CC4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: MAINTAINERS: add XZ Embedded maintainer
has been removed from the -mm tree.  Its filename was
     maintainers-add-xz-embedded-maintainer.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -25242,6 +25242,19 @@ S:	Maintained
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


