Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ACB80C07CA9
	for <mm-commits@archiver.kernel.org>; Thu, 30 Nov 2023 16:47:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232540AbjK3Qqx (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 30 Nov 2023 11:46:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235195AbjK3Qqr (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 30 Nov 2023 11:46:47 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCFB21A4
        for <mm-commits@vger.kernel.org>; Thu, 30 Nov 2023 08:46:53 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 515BFC433C9;
        Thu, 30 Nov 2023 16:46:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1701362813;
        bh=J+99o/v6JI4bitl5Z7N7KLmAdmuqfR6OVv8dj7TeXkY=;
        h=Date:To:From:Subject:From;
        b=2r8QsIU7Cq0dY0zp8btwbCX5s+ovBWjQ9KT54zYWR2eqqqMfwnzLSmMFZDl9mND7w
         vU8Z+pj8jZi0F4g3tl+vv4Fpg1ZGEC61xyXDPuJdM0mzskEdU3JQlfIdSpTy1WfIZj
         FRI8NHjjtglM6wRz6y6rMjfYgTdvzn2kEfaSOQ/4=
Date:   Thu, 30 Nov 2023 08:46:52 -0800
To:     mm-commits@vger.kernel.org, lkp@intel.com, eric_devolder@yahoo.com,
        bhe@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + loongarch-change-dependency-of-object-files.patch added to mm-hotfixes-unstable branch
Message-Id: <20231130164653.515BFC433C9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Date: Thu, 30 Nov 2023 16:22:46 +0800
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     loongarch-change-dependency-of-object-files.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/loongarch-change-dependency-of-object-files.patch

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
From: Baoquan He <bhe@redhat.com>
Date: Thu, 30 Nov 2023 16:22:46 +0800
Subject: LoongArch: change dependency of object files

Currently, in arch/loongarch/kernel/Makefile, building machine_kexec.o
relocate_kernel.o depends on CONFIG_KEXEC.

Whereas, since we will drop the select of KEXEC for CRASH_DUMP in
kernel/Kconfig.kexec, compiling error will be triggered if below config
items are set:

===
CONFIG_CRASH_CORE=y
CONFIG_KEXEC_CORE=y
CONFIG_CRASH_DUMP=y
===

---------------------------------------------------------------
loongarch64-linux-ld: kernel/kexec_core.o: in function `.L209':
>> kexec_core.c:(.text+0x1660): undefined reference to `machine_kexec_cleanup'
   loongarch64-linux-ld: kernel/kexec_core.o: in function `.L287':
>> kexec_core.c:(.text+0x1c5c): undefined reference to `machine_crash_shutdown'
>> loongarch64-linux-ld: kexec_core.c:(.text+0x1c64): undefined reference to `machine_kexec'
   loongarch64-linux-ld: kernel/kexec_core.o: in function `.L2^B5':
>> kexec_core.c:(.text+0x2090): undefined reference to `machine_shutdown'
   loongarch64-linux-ld: kexec_core.c:(.text+0x20a0): undefined reference to `machine_kexec'
---------------------------------------------------------------

Here, changing the dependency of machine_kexec.o relocate_kernel.o to
CONFIG_KEXEC_CORE can fix above building error.

Link: https://lkml.kernel.org/r/ZWhLFDC6vHsxNCpY@MiWiFi-R3L-srv
Closes: https://lore.kernel.org/oe-kbuild-all/202311300946.kHE9Iu71-lkp@intel.com/
Signed-off-by: Baoquan He <bhe@redhat.com>
Reported-by: kernel test robot <lkp@intel.com>
Cc: Eric DeVolder <eric_devolder@yahoo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/loongarch/kernel/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/loongarch/kernel/Makefile~loongarch-change-dependency-of-object-files
+++ a/arch/loongarch/kernel/Makefile
@@ -57,7 +57,7 @@ obj-$(CONFIG_MAGIC_SYSRQ)	+= sysrq.o
 
 obj-$(CONFIG_RELOCATABLE)	+= relocate.o
 
-obj-$(CONFIG_KEXEC)		+= machine_kexec.o relocate_kernel.o
+obj-$(CONFIG_KEXEC_CORE)	+= machine_kexec.o relocate_kernel.o
 obj-$(CONFIG_CRASH_DUMP)	+= crash_dump.o
 
 obj-$(CONFIG_UNWINDER_GUESS)	+= unwind_guess.o
_

Patches currently in -mm which might be from bhe@redhat.com are

drivers-base-cpu-crash-data-showing-should-depends-on-kexec_core.patch
kernel-kconfigkexec-drop-select-of-kexec-for-crash_dump.patch
loongarch-change-dependency-of-object-files.patch
resource-add-walk_system_ram_res_rev.patch
kexec_file-load-kernel-at-top-of-system-ram-if-required.patch

