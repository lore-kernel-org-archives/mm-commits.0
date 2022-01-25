Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A69EC433F5
	for <mm-commits@archiver.kernel.org>; Tue, 25 Jan 2022 06:20:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245037AbiAYGUx (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 25 Jan 2022 01:20:53 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:54604 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244138AbiAYGRx (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 25 Jan 2022 01:17:53 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 552EBB816AF
        for <mm-commits@vger.kernel.org>; Tue, 25 Jan 2022 06:17:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56DCBC340E0;
        Tue, 25 Jan 2022 06:17:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1643091467;
        bh=pZeceg2hz27pBhWe8hsujJjsrTASOBbKQoCvvioC/oo=;
        h=Date:From:To:Subject:From;
        b=oCe3oYgLpFBYN40ZZ1uTlRzgFjHUVBQV62q4+qjhPJp4//wRWduHIuV7WDo0ClZH9
         PSihZLN1Bs9+NuNF1HLVaCl3ulOjIgKKXme2IcxATGEXm1n+ZUjUJZFPsm6GB8SVzX
         Q7CiLq4V7d+tWapLWHfTgKmwWNUbutUg2Ojhpmno=
Date:   Mon, 24 Jan 2022 22:17:45 -0800
From:   akpm@linux-foundation.org
To:     alex@ghiti.fr, aou@eecs.berkeley.edu, bhe@redhat.com, bp@alien8.de,
        catalin.marinas@arm.com, dave.hansen@linux.intel.com,
        ebiederm@xmission.com, hpa@zytor.com, jszhang@kernel.org,
        linux@armlinux.org.uk, mingo@redhat.com,
        mm-commits@vger.kernel.org, palmer@dabbelt.com,
        palmer@rivosinc.com, paul.walmsley@sifive.com,
        rmk+kernel@armlinux.org.uk, tglx@linutronix.de, will@kernel.org
Subject:  +
 =?US-ASCII?Q?kexec-make-crashk=5Fres-crashk=5Flow=5Fres-and-crash=5Fno?=
 =?US-ASCII?Q?tes-symbols-always-visible.patch?= added to -mm tree
Message-ID: <20220125061745.SvM9ASNRA%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kexec: make crashk_res, crashk_low_res and crash_notes symbols always visible
has been added to the -mm tree.  Its filename is
     kexec-make-crashk_res-crashk_low_res-and-crash_notes-symbols-always-visible.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/kexec-make-crashk_res-crashk_low_res-and-crash_notes-symbols-always-visible.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/kexec-make-crashk_res-crashk_low_res-and-crash_notes-symbols-always-visible.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jisheng Zhang <jszhang@kernel.org>
Subject: kexec: make crashk_res, crashk_low_res and crash_notes symbols always visible

Patch series "kexec: use IS_ENABLED(CONFIG_KEXEC_CORE) instead of #ifdef", v2.

Replace the conditional compilation using "#ifdef CONFIG_KEXEC_CORE" by a
check for "IS_ENABLED(CONFIG_KEXEC_CORE)", to simplify the code and
increase compile coverage.

I only modified x86, arm, arm64 and riscv, other architectures such as sh,
powerpc and s390 are better to be kept kexec code as-is so they are not
touched.


This patch (of 5):

Make the forward declarations of crashk_res, crashk_low_res and
crash_notes always visible.  Code referring to these symbols can then just
check for IS_ENABLED(CONFIG_KEXEC_CORE), instead of requiring conditional
compilation using an #ifdef, thus preparing to increase compile coverage
and simplify the code.

Link: https://lkml.kernel.org/r/20211206160514.2000-1-jszhang@kernel.org
Link: https://lkml.kernel.org/r/20211206160514.2000-2-jszhang@kernel.org
Signed-off-by: Jisheng Zhang <jszhang@kernel.org>
Acked-by: Baoquan He <bhe@redhat.com>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Alexandre Ghiti <alex@ghiti.fr>
Cc: Palmer Dabbelt <palmer@rivosinc.com>
Cc: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kexec.h |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/include/linux/kexec.h~kexec-make-crashk_res-crashk_low_res-and-crash_notes-symbols-always-visible
+++ a/include/linux/kexec.h
@@ -20,6 +20,12 @@
 
 #include <uapi/linux/kexec.h>
 
+/* Location of a reserved region to hold the crash kernel.
+ */
+extern struct resource crashk_res;
+extern struct resource crashk_low_res;
+extern note_buf_t __percpu *crash_notes;
+
 #ifdef CONFIG_KEXEC_CORE
 #include <linux/list.h>
 #include <linux/compat.h>
@@ -350,12 +356,6 @@ extern int kexec_load_disabled;
 #define KEXEC_FILE_FLAGS	(KEXEC_FILE_UNLOAD | KEXEC_FILE_ON_CRASH | \
 				 KEXEC_FILE_NO_INITRAMFS)
 
-/* Location of a reserved region to hold the crash kernel.
- */
-extern struct resource crashk_res;
-extern struct resource crashk_low_res;
-extern note_buf_t __percpu *crash_notes;
-
 /* flag to track if kexec reboot is in progress */
 extern bool kexec_in_progress;
 
_

Patches currently in -mm which might be from jszhang@kernel.org are

kexec-make-crashk_res-crashk_low_res-and-crash_notes-symbols-always-visible.patch
riscv-mm-init-use-is_enabledconfig_kexec_core-instead-of-ifdef.patch
x86-setup-use-is_enabledconfig_kexec_core-instead-of-ifdef.patch
arm64-mm-use-is_enabledconfig_kexec_core-instead-of-ifdef.patch
arm-use-is_enabledconfig_kexec_core-instead-of-ifdef.patch

