Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5FF3CC6FD1F
	for <mm-commits@archiver.kernel.org>; Sun, 19 Mar 2023 18:37:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229508AbjCSShA (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 19 Mar 2023 14:37:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbjCSSg7 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 19 Mar 2023 14:36:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C836C1B543
        for <mm-commits@vger.kernel.org>; Sun, 19 Mar 2023 11:36:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 634366114C
        for <mm-commits@vger.kernel.org>; Sun, 19 Mar 2023 18:36:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4B87C433EF;
        Sun, 19 Mar 2023 18:36:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1679251017;
        bh=v+S/hE9D2tPotYe3bdTUjXiGVZXOs19hdYXlAH0byJ4=;
        h=Date:To:From:Subject:From;
        b=MrWEIShyhcp9MAWMgB+pPAkX5sO//6yfM8uFYfQsQ75jh+f1szWcZbL280+qtTeOx
         zjEB1/I2p8veQluhDyYFfKamjc2LpvEcEsxg+/6OEBbwqtaWkeaLmPvHG4ALFQ7+Mf
         DxZunG3w9ItRw00L4LcEepVs8UfRQwchmRl0xLTQ=
Date:   Sun, 19 Mar 2023 11:36:56 -0700
To:     mm-commits@vger.kernel.org, ziy@nvidia.com, lkp@intel.com,
        kirill@shutemov.name, akpm@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-treewide-redefine-max_order-sanely-fix-3-fix.patch added to mm-unstable branch
Message-Id: <20230319183657.B4B87C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-treewide-redefine-max_order-sanely-fix-3-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-treewide-redefine-max_order-sanely-fix-3-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-treewide-redefine-max_order-sanely-fix-3-fix.patch

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
Subject: mm-treewide-redefine-max_order-sanely-fix-3-fix
Date: Sun Mar 19 11:36:07 AM PDT 2023

fix underlining

Reported-by: kernel test robot <lkp@intel.com>
  Link: https://lore.kernel.org/oe-kbuild-all/202303191025.VRCTk6mP-lkp@intel.com/
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/Documentation/admin-guide/kdump/vmcoreinfo.rst~mm-treewide-redefine-max_order-sanely-fix-3-fix
+++ a/Documentation/admin-guide/kdump/vmcoreinfo.rst
@@ -190,7 +190,7 @@ information. Makedumpfile gets the start
 from this.
 
 (zone.free_area, MAX_ORDER + 1)
----------------------------
+-------------------------------
 
 Free areas descriptor. User-space tools use this value to iterate the
 free_area ranges. MAX_ORDER is used by the zone buddy allocator.
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-page_alloc-reduce-page-alloc-free-sanity-checks-checkpatch-fixes.patch
mm-page_alloc-reduce-page-alloc-free-sanity-checks-fix.patch
mm-userfaultfd-support-wp-on-multiple-vmas-fix.patch
mm-add-new-api-to-enable-ksm-per-process-fix.patch
vmstat-add-pcp-remote-node-draining-via-cpu_vm_stats_fold-fix.patch
mm-treewide-redefine-max_order-sanely-fix-2.patch
mm-treewide-redefine-max_order-sanely-fix-3-fix.patch
memcg-do-not-drain-charge-pcp-caches-on-remote-isolated-cpus-fix.patch
scripts-link-vmlinuxsh-fix-error-message-presentation.patch
notifiers-add-tracepoints-to-the-notifiers-infrastructure-checkpatch-fixes.patch

