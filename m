Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A554C130AC8
	for <mm-commits@vger.kernel.org>; Tue, 23 Jul 2024 02:28:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721701737; cv=none; b=G34mPtk5ZT6m+Ss50d+U/XILPXKREfDMcAejgXL3GyZtQxDZRGkxSO6BCq495xIvxRHGfBx/XJgwl8RoafosldQ9nkWSyKeEMrkuP/9wNmqcj3TmNg8QaDjM1vBDg4I9I6qc3yJcUvSe3jAMV/EN6n9bJ3ju+gQYZVWRXV7kcKk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721701737; c=relaxed/simple;
	bh=PkuBNOG/E2IGwVm5bSNWuSWQZzVbgBiiobl8rkzXf/M=;
	h=Date:To:From:Subject:Message-Id; b=CQbUiV5T66JQaAT17MfIGgdPNzTayob6mY5nIDrcum4qQzkhEJjjPP2FW9twlFJVi4SGcoj3HrdJAeeOK9YRddfZf9EmrG9YzK2+q3mcU5L4HfbzjDq1IZLNSZUGDmqVRxBQyvKjHuasR3//4EZtX9N4ruBxD8mYKS5BaVMOR5w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FJsZpWq/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FJsZpWq/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24AF4C116B1;
	Tue, 23 Jul 2024 02:28:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1721701737;
	bh=PkuBNOG/E2IGwVm5bSNWuSWQZzVbgBiiobl8rkzXf/M=;
	h=Date:To:From:Subject:From;
	b=FJsZpWq/BPN2YweZxRW7dk3uc+RvCTPBGneKENglk5GTn/ceu0GaUlbs5Sl/pkme2
	 4BTX3Aq3b4Bp5h89R3dRhjwq01QUTkfJXdXBRzkoopRWxEQIhlJ0bA7pmrNo1/yjFD
	 VxVL3VjmHvXnG2A3iIiB/s3goj+85hiFqwj1tS+o=
Date: Mon, 22 Jul 2024 19:28:56 -0700
To: mm-commits@vger.kernel.org,zhongjubin@huawei.com,will@kernel.org,tglx@linutronix.de,sjg@chromium.org,sam@gentoo.org,rdunlap@infradead.org,paul.walmsley@sifive.com,palmer@dabbelt.com,mpe@ellerman.id.au,me@lirui.org,krzk@kernel.org,joel@jms.id.au,jmaselbas@zdiv.net,herbert@gondor.apana.org.au,gregkh@linuxfoundation.org,emil.renner.berthing@canonical.com,corbet@lwn.net,catalin.marinas@arm.com,aou@eecs.berkeley.edu,lasse.collin@tukaani.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + licenses-add-0bsd-license-text.patch added to mm-nonmm-unstable branch
Message-Id: <20240723022857.24AF4C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: LICENSES: add 0BSD license text
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     licenses-add-0bsd-license-text.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/licenses-add-0bsd-license-text.patch

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
Subject: LICENSES: add 0BSD license text
Date: Sun, 21 Jul 2024 16:36:17 +0300

The license text was copied from:

    https://spdx.org/licenses/0BSD.html

Link: https://lkml.kernel.org/r/20240721133633.47721-3-lasse.collin@tukaani.org
Signed-off-by: Lasse Collin <lasse.collin@tukaani.org>
Reviewed-by: Sam James <sam@gentoo.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Emil Renner Berthing <emil.renner.berthing@canonical.com>
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
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 LICENSES/deprecated/0BSD |   23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

--- /dev/null
+++ a/LICENSES/deprecated/0BSD
@@ -0,0 +1,23 @@
+Valid-License-Identifier: 0BSD
+SPDX-URL: https://spdx.org/licenses/0BSD.html
+Usage-Guide:
+  To use the BSD Zero Clause License put the following SPDX tag/value
+  pair into a comment according to the placement guidelines in the
+  licensing rules documentation:
+    SPDX-License-Identifier: 0BSD
+License-Text:
+
+BSD Zero Clause License
+
+Copyright (c) <year> <copyright holders>
+
+Permission to use, copy, modify, and/or distribute this software for any
+purpose with or without fee is hereby granted.
+
+THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY
+SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION
+OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN
+CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
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

