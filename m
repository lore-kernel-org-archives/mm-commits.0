Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96CDFC4332F
	for <mm-commits@archiver.kernel.org>; Mon,  6 Nov 2023 16:24:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229642AbjKFQYf (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 6 Nov 2023 11:24:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229974AbjKFQYa (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 6 Nov 2023 11:24:30 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F306FF4
        for <mm-commits@vger.kernel.org>; Mon,  6 Nov 2023 08:24:27 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DBA2C433C7;
        Mon,  6 Nov 2023 16:24:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1699287867;
        bh=Owq6GAyefMEIdecO/NkWCoUyyxxCaUb9pP8ww918rMw=;
        h=Date:To:From:Subject:From;
        b=Jj5Vsunt+hJvuIhfhIGnHxVLY/rVmmODYswLbuRzLlaKJ0/o6FmoWYYKIp9nQIQeZ
         39PLhrSIVfQQjApHsVHSJNFdoWoqC37TRZdASHs5pO4m1ZATcF+9E7moD0d6dQA2+x
         qL7eKGjW0P7OVI4ND8tjHLX9l+Zh8NTsV9M+6ZPA=
Date:   Mon, 06 Nov 2023 08:24:26 -0800
To:     mm-commits@vger.kernel.org, ldmldm05@gmail.com,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + kernel-reboot-explicitly-notify-if-halt-occurred-instead-of-power-off-fix.patch added to mm-nonmm-unstable branch
Message-Id: <20231106162427.5DBA2C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kernel-reboot-explicitly-notify-if-halt-occurred-instead-of-power-off-fix
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kernel-reboot-explicitly-notify-if-halt-occurred-instead-of-power-off-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kernel-reboot-explicitly-notify-if-halt-occurred-instead-of-power-off-fix.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: kernel-reboot-explicitly-notify-if-halt-occurred-instead-of-power-off-fix
Date: Mon Nov  6 08:22:24 AM PST 2023

tweak comment text

Cc: Dongmin Lee <ldmldm05@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/reboot.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/kernel/reboot.c~kernel-reboot-explicitly-notify-if-halt-occurred-instead-of-power-off-fix
+++ a/kernel/reboot.c
@@ -59,9 +59,10 @@ struct sys_off_handler {
 };
 
 /*
- * This variable is used to indicate if a halt initiated instead when
- * reboot call is invoked with LINUX_REBOOT_CMD_POWER_OFF, but system
- * cannot be powered off. This allowes kernel_halt() to notify that.
+ * This variable is used to indicate if a halt was initiated instead of a
+ * reboot when the reboot call was invoked with LINUX_REBOOT_CMD_POWER_OFF, but
+ * the system cannot be powered off. This allowes kernel_halt() to notify users
+ * of that.
  */
 static bool poweroff_fallback_to_halt;
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-shmem-fix-race-in-shmem_undo_range-w-thp-fix.patch
kernel-reboot-explicitly-notify-if-halt-occurred-instead-of-power-off-fix.patch

