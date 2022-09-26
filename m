Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70210C32771
	for <mm-commits@archiver.kernel.org>; Mon, 26 Sep 2022 20:56:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229789AbiIZU4d (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 26 Sep 2022 16:56:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230506AbiIZU4a (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 26 Sep 2022 16:56:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8774D40E2D
        for <mm-commits@vger.kernel.org>; Mon, 26 Sep 2022 13:56:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 98EF161372
        for <mm-commits@vger.kernel.org>; Mon, 26 Sep 2022 20:56:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9DE5C433D6;
        Mon, 26 Sep 2022 20:56:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664225781;
        bh=0Ck5q1MUggUX1RSoShXmfA9sQmyvvBzKrkxZaIIJq9g=;
        h=Date:To:From:Subject:From;
        b=2cWhdFo9NrhR7Z2JxozPsqpOl1V2MIdrnKV5D6d49byLUXnlo4IfKvOujmqvEL2JN
         KGcNUN6B95g8QrrVuVtVJH14HeH9hIGfckN6ow2eKsrkdzNJNJTLgK1ev7nC+2W5J5
         LVBD1RwA2OWk+n9pmzp+Tm9okzrxUmUakHWbutw4=
Date:   Mon, 26 Sep 2022 13:56:20 -0700
To:     mm-commits@vger.kernel.org, lkp@intel.com, peterx@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-swap-cache-maximum-swapfile-size-when-init-swap-fix.patch removed from -mm tree
Message-Id: <20220926205620.E9DE5C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm-swap-cache-maximum-swapfile-size-when-init-swap-fix
has been removed from the -mm tree.  Its filename was
     mm-swap-cache-maximum-swapfile-size-when-init-swap-fix.patch

This patch was dropped because it was folded into mm-swap-cache-maximum-swapfile-size-when-init-swap.patch

------------------------------------------------------
From: Peter Xu <peterx@redhat.com>
Subject: mm-swap-cache-maximum-swapfile-size-when-init-swap-fix
Date: Sun Sep  4 11:00:02 AM PDT 2022

declare arch_max_swapfile_size) in swapfile.h

Link: https://lkml.kernel.org/r/YxTh1GuC6ro5fKL5@xz-m1.local
Signed-off-by: Peter Xu <peterx@redhat.com>
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swapfile.h |    2 ++
 1 file changed, 2 insertions(+)

--- a/include/linux/swapfile.h~mm-swap-cache-maximum-swapfile-size-when-init-swap-fix
+++ a/include/linux/swapfile.h
@@ -8,6 +8,8 @@
  */
 extern struct swap_info_struct *swap_info[];
 extern unsigned long generic_max_swapfile_size(void);
+unsigned long arch_max_swapfile_size(void);
+
 /* Maximum swapfile size supported for the arch (not inclusive). */
 extern unsigned long swapfile_maximum_size;
 
_

Patches currently in -mm which might be from peterx@redhat.com are

mm-x86-use-swp_type_bits-in-3-level-swap-macros.patch
mm-swap-comment-all-the-ifdef-in-swapopsh.patch
mm-swap-add-swp_offset_pfn-to-fetch-pfn-from-swap-entry.patch
mm-thp-carry-over-dirty-bit-when-thp-splits-on-pmd.patch
mm-remember-young-dirty-bit-for-page-migrations.patch
mm-swap-cache-maximum-swapfile-size-when-init-swap.patch
mm-swap-cache-swap-migration-a-d-bits-support.patch

