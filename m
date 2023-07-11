Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31F3FC0015E
	for <mm-commits@archiver.kernel.org>; Tue, 11 Jul 2023 16:49:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230182AbjGKQtV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 11 Jul 2023 12:49:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230289AbjGKQtT (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 11 Jul 2023 12:49:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A810310C4
        for <mm-commits@vger.kernel.org>; Tue, 11 Jul 2023 09:49:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4621061578
        for <mm-commits@vger.kernel.org>; Tue, 11 Jul 2023 16:49:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BBDFC433C7;
        Tue, 11 Jul 2023 16:49:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1689094150;
        bh=ClM2Sn9WqG9bK7B6tYL+gFSG4FMNfGko+YkUnOD7Gy4=;
        h=Date:To:From:Subject:From;
        b=V9104BMQDK4SZHy3Qr+piyfGb4Gtt95px8Ifu/cK3PCi0YdO3DJQHBxHY2ioMOib+
         pIfR78AZ59hIVn2MF064sE/DGViPAEO495Nfeo8Ab1dukie0vfm8HxkNmX5ItmOHtH
         9WMcC7rXSZpwzyyEuYr2o7ErK7KcBcKiqTQ74R6I=
Date:   Tue, 11 Jul 2023 09:49:08 -0700
To:     mm-commits@vger.kernel.org, yujie.liu@intel.com,
        vincent.whitchurch@axis.com, vgupta@kernel.org, tj@kernel.org,
        mingo@kernel.org, akpm@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + signal-print-comm-and-exe-name-on-fatal-signals-fix.patch added to mm-nonmm-unstable branch
Message-Id: <20230711164910.9BBDFC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: signal-print-comm-and-exe-name-on-fatal-signals-fix
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     signal-print-comm-and-exe-name-on-fatal-signals-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/signal-print-comm-and-exe-name-on-fatal-signals-fix.patch

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
Subject: signal-print-comm-and-exe-name-on-fatal-signals-fix
Date: Tue Jul 11 09:47:45 AM PDT 2023

don't include linux/file.h twice

Reported-by: kernel test robot <yujie.liu@intel.com>
Closes: https://lore.kernel.org/r/202307081626.VOmT8STW-lkp@intel.com/
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Vincent Whitchurch <vincent.whitchurch@axis.com>
Cc: Vineet Gupta <vgupta@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/signal.c |    1 -
 1 file changed, 1 deletion(-)

--- a/kernel/signal.c~signal-print-comm-and-exe-name-on-fatal-signals-fix
+++ a/kernel/signal.c
@@ -25,7 +25,6 @@
 #include <linux/mm.h>
 #include <linux/proc_fs.h>
 #include <linux/tty.h>
-#include <linux/file.h>
 #include <linux/binfmts.h>
 #include <linux/coredump.h>
 #include <linux/security.h>
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-shmem-fix-race-in-shmem_undo_range-w-thp-fix.patch
swap-stop-add-to-avail-list-is-swap-is-full-checkpatch-fixes.patch
fs-buffer-clean-up-block_commit_write-fix.patch
mm-page_alloc-avoid-false-page-outside-zone-error-info-fix.patch
mm-make-pte_marker_swapin_error-more-general-fix.patch
signal-print-comm-and-exe-name-on-fatal-signals-fix.patch

