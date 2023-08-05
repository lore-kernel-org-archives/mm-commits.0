Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03BE4C0015E
	for <mm-commits@archiver.kernel.org>; Sat,  5 Aug 2023 17:00:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229584AbjHERAC (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 5 Aug 2023 13:00:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbjHERAB (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 5 Aug 2023 13:00:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53055E4A
        for <mm-commits@vger.kernel.org>; Sat,  5 Aug 2023 10:00:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C84DF60C25
        for <mm-commits@vger.kernel.org>; Sat,  5 Aug 2023 16:59:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1677EC433C8;
        Sat,  5 Aug 2023 16:59:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691254799;
        bh=PF5Zj04k4IswtZMBZr0eQBapR4Qh7ttym03zNLUq+QQ=;
        h=Date:To:From:Subject:From;
        b=Hq+zCu66gL3c08NM5Naj8kMnHJzBW8pet185Vda3ksvneBlihJoN4I4yRawWvyjbR
         1D14/TNs5iQ806TiUyuCq1FBDyvbNEtu2uRrq060Ho0VSE5e8CszJgnJuXmX/Bmicd
         6+Pl6JRtDGFYB3Db2APd5cGcTN1HswDHt4Gn45aw=
Date:   Sat, 05 Aug 2023 09:59:57 -0700
To:     mm-commits@vger.kernel.org, pmladek@suse.com, mhocko@suse.com,
        lkp@intel.com, lecopzer.chen@mediatek.com, kernelfans@gmail.com,
        dianders@chromium.org, akpm@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + nmi_backtrace-allow-excluding-an-arbitrary-cpu-fix.patch added to mm-nonmm-unstable branch
Message-Id: <20230805165959.1677EC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: nmi_backtrace-allow-excluding-an-arbitrary-cpu-fix
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     nmi_backtrace-allow-excluding-an-arbitrary-cpu-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/nmi_backtrace-allow-excluding-an-arbitrary-cpu-fix.patch

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
Subject: nmi_backtrace-allow-excluding-an-arbitrary-cpu-fix
Date: Sat Aug  5 09:58:07 AM PDT 2023

fix trigger_allbutcpu_cpu_backtrace() stub

Cc: Douglas Anderson <dianders@chromium.org>
Cc: kernel test robot <lkp@intel.com>
Cc: Lecopzer Chen <lecopzer.chen@mediatek.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Pingfan Liu <kernelfans@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/nmi.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/nmi.h~nmi_backtrace-allow-excluding-an-arbitrary-cpu-fix
+++ a/include/linux/nmi.h
@@ -190,7 +190,7 @@ static inline bool trigger_all_cpu_backt
 {
 	return false;
 }
-static inline bool trigger_allbutcpu_cpu_backtrace(void)
+static inline bool trigger_allbutcpu_cpu_backtrace(int exclude_cpu)
 {
 	return false;
 }
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-shmem-fix-race-in-shmem_undo_range-w-thp-fix.patch
swap-stop-add-to-avail-list-is-swap-is-full-checkpatch-fixes.patch
fs-buffer-clean-up-block_commit_write-fix.patch
mm-page_alloc-avoid-false-page-outside-zone-error-info-fix.patch
mm-make-pte_marker_swapin_error-more-general-fix.patch
mm-kfence-allocate-kfence_metadata-at-runtime-fix.patch
acpi-hmat-calculate-abstract-distance-with-hmat-checkpatch-fixes.patch
signal-print-comm-and-exe-name-on-fatal-signals-fix.patch
drm-i915-move-abs_diff-to-mathh-fix-fix.patch
nmi_backtrace-allow-excluding-an-arbitrary-cpu-fix.patch

