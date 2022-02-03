Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4669C433F5
	for <mm-commits@archiver.kernel.org>; Thu,  3 Feb 2022 23:07:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347868AbiBCXHL (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 3 Feb 2022 18:07:11 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:40734 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233999AbiBCXHK (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 3 Feb 2022 18:07:10 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E3FDEB834DD
        for <mm-commits@vger.kernel.org>; Thu,  3 Feb 2022 23:07:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E016C340E8;
        Thu,  3 Feb 2022 23:07:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1643929628;
        bh=NhCmQF61kDUjuat5ajHuiwWlNp0dW96hnfbAFLfDVxE=;
        h=Date:To:From:Subject:From;
        b=Oz+JL6ujWSBWwfY1kP7O4U2rn9foDE7zNSUwIn/xe/n5i2rTCf9I3RdaBSbXsv9jY
         CA9NJxXNyWP+jzIkT0uTFgi0bUXPfhCozTGcZdC0D/MAuHqb5uD3iF+L1XX+NuSc/l
         3jMiUpQsBW3ZQDtZbZ3NgxlVWZVU5q87NIb9YMs4=
Received: by hp1 (sSMTP sendmail emulation); Thu, 03 Feb 2022 15:07:07 -0800
Date:   Thu, 03 Feb 2022 15:07:07 -0800
To:     mm-commits@vger.kernel.org, ying.huang@intel.com,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + numa-balancing-optimize-page-placement-for-memory-tiering-system-fix.patch added to -mm tree
Message-Id: <20220203230707.9E016C340E8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: numa-balancing-optimize-page-placement-for-memory-tiering-system-fix
has been added to the -mm tree.  Its filename is
     numa-balancing-optimize-page-placement-for-memory-tiering-system-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/numa-balancing-optimize-page-placement-for-memory-tiering-system-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/numa-balancing-optimize-page-placement-for-memory-tiering-system-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: numa-balancing-optimize-page-placement-for-memory-tiering-system-fix

Cc: "Huang, Ying" <ying.huang@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/sysctl/kernel.rst |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/Documentation/admin-guide/sysctl/kernel.rst~numa-balancing-optimize-page-placement-for-memory-tiering-system-fix
+++ a/Documentation/admin-guide/sysctl/kernel.rst
@@ -595,14 +595,14 @@ Documentation/admin-guide/kernel-paramet
 numa_balancing
 ==============
 
-Enables/disables and configure automatic page fault based NUMA memory
-balancing.  Memory is moved automatically to nodes that access it
-often.  The value to set can be the result to OR the following,
+Enables/disables and configures automatic page fault based NUMA memory
+balancing.  Memory is moved automatically to nodes that access it often. 
+The value to set can be the result of ORing the following,
 
 = =================================
-0x0 NUMA_BALANCING_DISABLED
-0x1 NUMA_BALANCING_NORMAL
-0x2 NUMA_BALANCING_MEMORY_TIERING
+0 NUMA_BALANCING_DISABLED
+1 NUMA_BALANCING_NORMAL
+2 NUMA_BALANCING_MEMORY_TIERING
 = =================================
 
 Or NUMA_BALANCING_NORMAL to optimize page placement among different
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

remove-bdi_congested-and-wb_congested-and-related-functions-fix.patch
mm.patch
documentation-vm-page_ownerrst-update-the-documentation-fix.patch
mm-move-page-writeback-sysctls-to-is-own-file-checkpatch-fixes.patch
mm-move-page-writeback-sysctls-to-is-own-file-fix.patch
mm-mempolicy-convert-from-atomic_t-to-refcount_t-on-mempolicy-refcnt-fix.patch
numa-balancing-optimize-page-placement-for-memory-tiering-system-fix.patch
proc-alloc-path_max-bytes-for-proc-pid-fd-symlinks-fix.patch
linux-next-rejects.patch
mutex-subsystem-synchro-test-module-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

