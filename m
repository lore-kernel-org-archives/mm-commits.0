Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9D01C25B46
	for <mm-commits@archiver.kernel.org>; Mon, 23 Oct 2023 18:06:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229613AbjJWSGv (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 23 Oct 2023 14:06:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229829AbjJWSGt (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 23 Oct 2023 14:06:49 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38CF4B7
        for <mm-commits@vger.kernel.org>; Mon, 23 Oct 2023 11:06:47 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE7A2C433C7;
        Mon, 23 Oct 2023 18:06:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1698084406;
        bh=ERe0EOujwdWxImLzWu/NhkLiYrCGgxsNwm6f50aXy/g=;
        h=Date:To:From:Subject:From;
        b=NWSIVyzle49YLaUOr1ZGbUzF6Xpr7gK5hXWV4b8Z3W57E9wuS2U0C62XcOfBlLyYF
         iTdkVxYeEeA5Z0DtfBQl0V99Z1igf/3X9mVsElY1cMnE/mZfWLfuLf9Vpq3nreCz4I
         cTHpSk4Xtn8Zvu7kdxauC95ti3xbUD4ICSF7C5Iw=
Date:   Mon, 23 Oct 2023 11:06:46 -0700
To:     mm-commits@vger.kernel.org, tglx@linutronix.de,
        svens@linux.ibm.com, peterz@infradead.org,
        paul.walmsley@sifive.com, palmer@dabbelt.com, npiggin@gmail.com,
        mingo@redhat.com, hpa@zytor.com, herbert@gondor.apana.org.au,
        hca@linux.ibm.com, gor@linux.ibm.com, eric.devolder@oracle.com,
        davem@davemloft.net, dave.hansen@linux.intel.com, conor@kernel.org,
        christophe.leroy@csgroup.eu, bp@alien8.de,
        borntraeger@linux.ibm.com, ardb@kernel.org, aou@eecs.berkeley.edu,
        agordeev@linux.ibm.com, arnd@arndb.de, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + kexec-select-crypto-from-kexec_file-instead-of-depending-on-it.patch added to mm-hotfixes-unstable branch
Message-Id: <20231023180646.BE7A2C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kexec: select CRYPTO from KEXEC_FILE instead of depending on it
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     kexec-select-crypto-from-kexec_file-instead-of-depending-on-it.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kexec-select-crypto-from-kexec_file-instead-of-depending-on-it.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
Subject: kexec: select CRYPTO from KEXEC_FILE instead of depending on it
Date: Mon, 23 Oct 2023 13:01:55 +0200

All other users of crypto code use 'select' instead of 'depends on', so do
the same thing with KEXEC_FILE for consistency.

In practice this makes very little difference as kernels with kexec
support are very likely to also include some other feature that already
selects both crypto and crypto_sha256, but being consistent here helps for
usability as well as to avoid potential circular dependencies.

This reverts the dependency back to what it was originally before commit
74ca317c26a3f ("kexec: create a new config option CONFIG_KEXEC_FILE for
new syscall"), which changed changed it with the comment "This should be
safer as "select" is not recursive", but that appears to have been done in
error, as "select" is indeed recursive, and there are no other
dependencies that prevent CRYPTO_SHA256 from being selected here.

Link: https://lkml.kernel.org/r/20231023110308.1202042-2-arnd@kernel.org
Fixes: 74ca317c26a3f ("kexec: create a new config option CONFIG_KEXEC_FILE for new syscall")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Conor Dooley <conor@kernel.org>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Eric DeVolder <eric.devolder@oracle.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/Kconfig.kexec |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/kernel/Kconfig.kexec~kexec-select-crypto-from-kexec_file-instead-of-depending-on-it
+++ a/kernel/Kconfig.kexec
@@ -36,7 +36,8 @@ config KEXEC
 config KEXEC_FILE
 	bool "Enable kexec file based system call"
 	depends on ARCH_SUPPORTS_KEXEC_FILE
-	depends on CRYPTO_SHA256=y || !ARCH_SUPPORTS_KEXEC_PURGATORY
+	select CRYPTO
+	select CRYPTO_SHA256
 	select KEXEC_CORE
 	help
 	  This is new version of kexec system call. This system call is
_

Patches currently in -mm which might be from arnd@arndb.de are

kexec-fix-kexec_file-dependencies.patch
kexec-select-crypto-from-kexec_file-instead-of-depending-on-it.patch
kexec-fix-kexec_file-dependencies-fix.patch

