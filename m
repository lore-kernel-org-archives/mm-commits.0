Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6C8BC001DF
	for <mm-commits@archiver.kernel.org>; Wed,  2 Aug 2023 19:06:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232130AbjHBTGT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 2 Aug 2023 15:06:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231876AbjHBTGR (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 2 Aug 2023 15:06:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8363226BC
        for <mm-commits@vger.kernel.org>; Wed,  2 Aug 2023 12:06:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1820061AB0
        for <mm-commits@vger.kernel.org>; Wed,  2 Aug 2023 19:06:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66AE4C433CA;
        Wed,  2 Aug 2023 19:06:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691003174;
        bh=ZG9Pn9T//G77pFGDnGaxdmQnY/ucz4+w7Fyuw4O0MEk=;
        h=Date:To:From:Subject:From;
        b=DLIXFzBOYJqIkLdFsZQRZEejlY+4lA5CtbJUzG1Tj42uE7Qxmm+Zrf4/FdxQrfii8
         o7CeVizhll+dIgyhnHCMijSvLcVw6ZVm9KZpAm4xYdwJOhMPavCHIh82IxebtAL/kq
         oaX8KaQjh6PkGhIKaMhbDzm+CGfKL6vBDS8nYtlc=
Date:   Wed, 02 Aug 2023 12:06:13 -0700
To:     mm-commits@vger.kernel.org, eric.devolder@oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + remove-arch_default_kexec-from-kconfigkexec.patch added to mm-nonmm-unstable branch
Message-Id: <20230802190614.66AE4C433CA@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: remove ARCH_DEFAULT_KEXEC from Kconfig.kexec
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     remove-arch_default_kexec-from-kconfigkexec.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/remove-arch_default_kexec-from-kconfigkexec.patch

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
From: Eric DeVolder <eric.devolder@oracle.com>
Subject: remove ARCH_DEFAULT_KEXEC from Kconfig.kexec
Date: Wed, 2 Aug 2023 12:17:50 -0400

This patch is a minor cleanup to the series "refactor Kconfig to
consolidate KEXEC and CRASH options".

In that series, a new option ARCH_DEFAULT_KEXEC was introduced in order to
obtain the equivalent behavior of s390 original Kconfig settings for
KEXEC.  As it turns out, this new option did not fully provide the
equivalent behavior, rather a "select KEXEC" did.

As such, the ARCH_DEFAULT_KEXEC is not needed anymore, so remove it.

Link: https://lkml.kernel.org/r/20230802161750.2215-1-eric.devolder@oracle.com
Signed-off-by: Eric DeVolder <eric.devolder@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/s390/Kconfig    |    3 ---
 kernel/Kconfig.kexec |    1 -
 2 files changed, 4 deletions(-)

--- a/arch/s390/Kconfig~remove-arch_default_kexec-from-kconfigkexec
+++ a/arch/s390/Kconfig
@@ -246,9 +246,6 @@ config PGTABLE_LEVELS
 
 source "kernel/livepatch/Kconfig"
 
-config ARCH_DEFAULT_KEXEC
-	def_bool y
-
 config ARCH_SUPPORTS_KEXEC
 	def_bool y
 
--- a/kernel/Kconfig.kexec~remove-arch_default_kexec-from-kconfigkexec
+++ a/kernel/Kconfig.kexec
@@ -17,7 +17,6 @@ config HAVE_IMA_KEXEC
 
 config KEXEC
 	bool "Enable kexec system call"
-	default ARCH_DEFAULT_KEXEC
 	depends on ARCH_SUPPORTS_KEXEC
 	select KEXEC_CORE
 	help
_

Patches currently in -mm which might be from eric.devolder@oracle.com are

kexec-consolidate-kexec-and-crash-options-into-kernel-kconfigkexec.patch
x86-kexec-refactor-for-kernel-kconfigkexec.patch
arm-kexec-refactor-for-kernel-kconfigkexec.patch
ia64-kexec-refactor-for-kernel-kconfigkexec.patch
arm64-kexec-refactor-for-kernel-kconfigkexec.patch
loongarch-kexec-refactor-for-kernel-kconfigkexec.patch
m68k-kexec-refactor-for-kernel-kconfigkexec.patch
mips-kexec-refactor-for-kernel-kconfigkexec.patch
parisc-kexec-refactor-for-kernel-kconfigkexec.patch
powerpc-kexec-refactor-for-kernel-kconfigkexec.patch
riscv-kexec-refactor-for-kernel-kconfigkexec.patch
s390-kexec-refactor-for-kernel-kconfigkexec.patch
sh-kexec-refactor-for-kernel-kconfigkexec.patch
kexec-rename-arch_has_kexec_purgatory.patch
remove-arch_default_kexec-from-kconfigkexec.patch

