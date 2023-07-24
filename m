Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCA20C001B0
	for <mm-commits@archiver.kernel.org>; Mon, 24 Jul 2023 18:00:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230332AbjGXSAr (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 24 Jul 2023 14:00:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229527AbjGXSAd (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 24 Jul 2023 14:00:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B621C94
        for <mm-commits@vger.kernel.org>; Mon, 24 Jul 2023 11:00:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 21E7D61329
        for <mm-commits@vger.kernel.org>; Mon, 24 Jul 2023 18:00:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38BFDC433C8;
        Mon, 24 Jul 2023 18:00:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1690221631;
        bh=50ZUMXWKrtrQWr3T7CEWhf4exGH1C8WVHkBYftJk4gU=;
        h=Date:To:From:Subject:From;
        b=LVdDABKIkjCm/fTjfEefnX9jbXTfQPZkPXBbI+5n47XDzD2Ert6Lkd6vcCXT9FGIi
         dkw2u2o4vsZ3X+gUvKcvTUHZ9s/Vker8AX5k54LC4GD1httbVf+x7utRQyetu9prMf
         Gru2VEyZm788Qaj5FG0PuX4YptvWM9DH2/LWoHpA=
Date:   Mon, 24 Jul 2023 11:00:30 -0700
To:     mm-commits@vger.kernel.org, ying.huang@intel.com,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + acpi-hmat-calculate-abstract-distance-with-hmat-checkpatch-fixes.patch added to mm-unstable branch
Message-Id: <20230724180031.38BFDC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: acpi-hmat-calculate-abstract-distance-with-hmat-checkpatch-fixes
has been added to the -mm mm-unstable branch.  Its filename is
     acpi-hmat-calculate-abstract-distance-with-hmat-checkpatch-fixes.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/acpi-hmat-calculate-abstract-distance-with-hmat-checkpatch-fixes.patch

This patch will later appear in the mm-unstable branch at
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
Subject: acpi-hmat-calculate-abstract-distance-with-hmat-checkpatch-fixes
Date: Mon Jul 24 10:59:52 AM PDT 2023


WARNING: Avoid logging continuation uses where feasible
#54: FILE: drivers/acpi/numa/hmat.c:768:
+	pr_cont("read_latency: %u, write_latency: %u, read_bandwidth: %u, write_bandwidth: %u\n",

WARNING: __meminitdata should be placed after hmat_adist_nb
#174: FILE: drivers/acpi/numa/hmat.c:888:
+static __meminitdata struct notifier_block hmat_adist_nb =

ERROR: that open brace { should be on the previous line
#175: FILE: drivers/acpi/numa/hmat.c:889:
+static __meminitdata struct notifier_block hmat_adist_nb =
+{

WARNING: From:/Signed-off-by: email name mismatch: 'From: Huang Ying <ying.huang@intel.com>' != 'Signed-off-by: "Huang, Ying" <ying.huang@intel.com>'

total: 1 errors, 3 warnings, 185 lines checked

NOTE: For some of the reported defects, checkpatch may be able to
      mechanically convert to the typical style using --fix or --fix-inplace.

./patches/acpi-hmat-calculate-abstract-distance-with-hmat.patch has style problems, please review.

NOTE: If any of the errors are false positives, please report
      them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: "Huang, Ying" <ying.huang@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/numa/hmat.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/acpi/numa/hmat.c~acpi-hmat-calculate-abstract-distance-with-hmat-checkpatch-fixes
+++ a/drivers/acpi/numa/hmat.c
@@ -885,8 +885,7 @@ static int hmat_calculate_adistance(stru
 	return NOTIFY_STOP;
 }
 
-static __meminitdata struct notifier_block hmat_adist_nb =
-{
+static __meminitdata struct notifier_block hmat_adist_nb = {
 	.notifier_call = hmat_calculate_adistance,
 	.priority = 100,
 };
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-shmem-fix-race-in-shmem_undo_range-w-thp-fix.patch
swap-stop-add-to-avail-list-is-swap-is-full-checkpatch-fixes.patch
fs-buffer-clean-up-block_commit_write-fix.patch
mm-page_alloc-avoid-false-page-outside-zone-error-info-fix.patch
mm-make-pte_marker_swapin_error-more-general-fix.patch
selinux-use-vma_is_stack-and-vma_is_heap-fix.patch
mm-kfence-allocate-kfence_metadata-at-runtime-fix.patch
acpi-hmat-calculate-abstract-distance-with-hmat-checkpatch-fixes.patch
signal-print-comm-and-exe-name-on-fatal-signals-fix.patch

