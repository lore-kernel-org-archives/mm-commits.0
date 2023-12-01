Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 801E6C4167B
	for <mm-commits@archiver.kernel.org>; Fri,  1 Dec 2023 00:35:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377423AbjLAAfG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 30 Nov 2023 19:35:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377389AbjLAAfF (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 30 Nov 2023 19:35:05 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47B07D7D
        for <mm-commits@vger.kernel.org>; Thu, 30 Nov 2023 16:35:12 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3AFBC433C9;
        Fri,  1 Dec 2023 00:35:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1701390911;
        bh=uZo/1Nv6mI9KsdDPiEvE8/jro/2EYce2La+SfcAf/88=;
        h=Date:To:From:Subject:From;
        b=bJo4Nwap0Mw5RGuvoO8Pi4TMsoimz+OrPXV+WEdleDZuX8Z53Pymi9DAtXhzKoqjj
         GFR8wAWB8YnLW/vev/vQDBpxyVWtcmRSEEdK513s1hR8jEcg5u4sPVtapdTxdP1T7I
         4zuUgNx4nUobGzKgbxHrN0kWR46q7Ep/e7UwPZN4=
Date:   Thu, 30 Nov 2023 16:35:09 -0800
To:     mm-commits@vger.kernel.org, svens@linux.ibm.com, sth@linux.ibm.com,
        hoeppner@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com,
        borntraeger@linux.ibm.com, arnd@arndb.de, agordeev@linux.ibm.com,
        nathan@kernel.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + s390-dasd-remove-dasd_stats_generic_show.patch added to mm-nonmm-unstable branch
Message-Id: <20231201003511.C3AFBC433C9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: s390/dasd: remove dasd_stats_generic_show()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     s390-dasd-remove-dasd_stats_generic_show.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/s390-dasd-remove-dasd_stats_generic_show.patch

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
From: Nathan Chancellor <nathan@kernel.org>
Subject: s390/dasd: remove dasd_stats_generic_show()
Date: Thu, 30 Nov 2023 17:22:32 -0700

Patch series "s390: A couple of fixes for -Wmissing-prototypes".

This series resolves a couple of -Wmissing-prototypes that I see in my
builds of -next, even though the issues appear to be latent.  This
addresses issues which will be exposed by the later patch
"Makefile.extrawarn: turn on missing-prototypes globally".


This patch (of 2):

With CONFIG_DASD_PROFILE=n, there is a warning that
dasd_stats_generic_show() is missing a prototype:

  drivers/s390/block/dasd.c:1109:5: warning: no previous prototype for 'dasd_stats_generic_show' [-Wmissing-prototypes]
   1109 | int dasd_stats_generic_show(struct seq_file *m, void *v)
        |     ^~~~~~~~~~~~~~~~~~~~~~~

This function has been unused since its introduction in commit
4fa52aa7a82f ("[S390] dasd: add enhanced DASD statistics interface"),
remove it to clear up the warning.

Link: https://lkml.kernel.org/r/20231130-s390-missing-prototypes-v1-0-799d3cf07fb7@kernel.org
Link: https://lkml.kernel.org/r/20231130-s390-missing-prototypes-v1-1-799d3cf07fb7@kernel.org
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Jan Höppner <hoeppner@linux.ibm.com>
Cc: Stefan Haberland <sth@linux.ibm.com>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/s390/block/dasd.c |    6 ------
 1 file changed, 6 deletions(-)

--- a/drivers/s390/block/dasd.c~s390-dasd-remove-dasd_stats_generic_show
+++ a/drivers/s390/block/dasd.c
@@ -1106,12 +1106,6 @@ static void dasd_statistics_removeroot(v
 	return;
 }
 
-int dasd_stats_generic_show(struct seq_file *m, void *v)
-{
-	seq_puts(m, "Statistics are not activated in this kernel\n");
-	return 0;
-}
-
 static void dasd_profile_init(struct dasd_profile *profile,
 			      struct dentry *base_dentry)
 {
_

Patches currently in -mm which might be from nathan@kernel.org are

buffer-fix-grow_buffers-for-block-size-page_size-fix.patch
hexagon-uaccess-remove-clear_user_hexagon.patch
hexagon-mm-mark-paging_init-as-static.patch
hexagon-mm-include-asm-setuph-for-setup_arch_memorys-prototype.patch
hexagon-smp-mark-handle_ipi-and-start_secondary-as-static.patch
hexagon-vm_fault-mark-do_page_fault-as-static.patch
hexagon-vm_fault-include-asm-vm_faulth-for-prototypes.patch
hexagon-vm_tlb-include-asm-tlbflushh-for-prototypes.patch
hexagon-time-include-asm-timeh-for-prototypes.patch
hexagon-time-mark-time_init_deferred-as-static.patch
hexagon-time-include-asm-delayh-for-prototypes.patch
hexagon-signal-switch-to-syscall_define0-for-sys_rt_sigreturn.patch
hexagon-reset-include-linux-rebooth-for-prototypes.patch
hexagon-process-include-linux-cpuh-for-arch_cpu_idle-prototype.patch
hexagon-process-add-internal-prototype-for-do_work_pending.patch
hexagon-vdso-include-asm-elfh-for-arch_setup_additional_pages-prototype.patch
hexagon-vm_events-remove-unused-dummy_handler.patch
hexagon-irq-add-prototype-for-arch_do_irq.patch
hexagon-traps-remove-sys_syscall.patch
hexagon-traps-add-internal-prototypes-for-functions-only-called-from-asm.patch
s390-dasd-remove-dasd_stats_generic_show.patch
s390-traps-only-define-is_valid_bugaddr-under-config_generic_bug.patch

