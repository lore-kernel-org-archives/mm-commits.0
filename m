Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3EDAEC25B46
	for <mm-commits@archiver.kernel.org>; Mon, 23 Oct 2023 18:09:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232503AbjJWSJI (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 23 Oct 2023 14:09:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232572AbjJWSJH (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 23 Oct 2023 14:09:07 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 061FAC0
        for <mm-commits@vger.kernel.org>; Mon, 23 Oct 2023 11:09:05 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93654C433C8;
        Mon, 23 Oct 2023 18:09:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1698084544;
        bh=Mtr7NdyBHSRSkDnLDZohTj33+BMnR8ZZHdT1Ord1Daw=;
        h=Date:To:From:Subject:From;
        b=OVx6v/OjGL2kcXRlF2UzoS+tmaiW/QrY2QJhVrsVpJGI186EDy35kLsOoxCrpVo1Z
         pP8d4qVMQAAFwxCenFprdKwNX9wrQ7WMlDFxmIbIYzb5TNeiJlzQq7KmUxKAHVayx5
         p2OLpElXaZsh+T+7ToeBRmyBJnyLvuYS7KGJRRA4=
Date:   Mon, 23 Oct 2023 11:09:04 -0700
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
Subject: + kexec-fix-kexec_file-dependencies-fix.patch added to mm-hotfixes-unstable branch
Message-Id: <20231023180904.93654C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kexec-fix-kexec_file-dependencies-fix
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     kexec-fix-kexec_file-dependencies-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kexec-fix-kexec_file-dependencies-fix.patch

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
From: "Arnd Bergmann" <arnd@arndb.de>
Subject: kexec-fix-kexec_file-dependencies-fix
Date: Mon, 23 Oct 2023 18:04:06 +0200

fix riscv build

Link: https://lkml.kernel.org/r/67ddd260-d424-4229-a815-e3fcfb864a77@app.fastmail.com
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Conor Dooley <conor@kernel.org>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Eric DeVolder <eric.devolder@oracle.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
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

 arch/riscv/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/riscv/Kconfig~kexec-fix-kexec_file-dependencies-fix
+++ a/arch/riscv/Kconfig
@@ -687,7 +687,7 @@ config ARCH_SELECTS_KEXEC_FILE
 	select KEXEC_ELF
 
 config ARCH_SUPPORTS_KEXEC_PURGATORY
-	def_bool y
+	def_bool ARCH_SUPPORTS_KEXEC_FILE
 
 config ARCH_SUPPORTS_CRASH_DUMP
 	def_bool y
_

Patches currently in -mm which might be from arnd@arndb.de are

kexec-fix-kexec_file-dependencies.patch
kexec-select-crypto-from-kexec_file-instead-of-depending-on-it.patch
kexec-fix-kexec_file-dependencies-fix.patch

