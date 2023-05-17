Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DB5EC7EE22
	for <mm-commits@archiver.kernel.org>; Wed, 17 May 2023 20:00:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229475AbjEQUAP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 17 May 2023 16:00:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229497AbjEQUAO (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 17 May 2023 16:00:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 443361BD8
        for <mm-commits@vger.kernel.org>; Wed, 17 May 2023 13:00:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CCD9E64998
        for <mm-commits@vger.kernel.org>; Wed, 17 May 2023 20:00:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 274B9C433D2;
        Wed, 17 May 2023 20:00:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1684353612;
        bh=aerQzWHyjz0beBGRI2jQRtKSlKIAl5tw4kr3CK2bh/k=;
        h=Date:To:From:Subject:From;
        b=srPn2e18VUIMSJ/56+uPsaHCAGeVf/cshS8mqk7w/ql8iLnL+VfNoVluAffJsMAzQ
         eL0Uh3JHQl4TnBHQ6bbGUsMpmXBzORU8AliOaCOOoNtUAoENB938a8D8FnQPxdvCt6
         ON5EMXRl70bCBYeHiKJvXgcp7yO979ms+d1+22P0=
Date:   Wed, 17 May 2023 13:00:11 -0700
To:     mm-commits@vger.kernel.org, osalvador@suse.de, lkp@intel.com,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_owner-add-page_owner_stacks-file-to-print-out-only-stacks-and-their-counte-fix.patch added to mm-unstable branch
Message-Id: <20230517200012.274B9C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-page_owner-add-page_owner_stacks-file-to-print-out-only-stacks-and-their-counte-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_owner-add-page_owner_stacks-file-to-print-out-only-stacks-and-their-counte-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_owner-add-page_owner_stacks-file-to-print-out-only-stacks-and-their-counte-fix.patch

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
Subject: mm-page_owner-add-page_owner_stacks-file-to-print-out-only-stacks-and-their-counte-fix
Date: Wed May 17 12:58:14 PM PDT 2023

build fix

include/linux/stackdepot.h:116:26: error: declaration of 'struct seq_file' will not be visible outside of this function

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202305171411.iw7APiY8-lkp@intel.com/
Cc: Oscar Salvador <osalvador@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/stackdepot.h |    1 +
 1 file changed, 1 insertion(+)

--- a/include/linux/stackdepot.h~mm-page_owner-add-page_owner_stacks-file-to-print-out-only-stacks-and-their-counte-fix
+++ a/include/linux/stackdepot.h
@@ -25,6 +25,7 @@
 #include <linux/gfp.h>
 
 typedef u32 depot_stack_handle_t;
+struct seq_file;
 
 /*
  * Number of bits in the handle that stack depot doesn't use. Users may store
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-compaction-optimize-compact_memory-to-comply-with-the-admin-guide-fix.patch
maple_tree-add-mas_next_range-and-mas_find_range-interfaces-checkpatch-fixes.patch
mm-gup-remove-unused-vmas-parameter-from-pin_user_pages_remote-fix.patch
mm-gup-remove-vmas-parameter-from-get_user_pages_remote-fix.patch
mm-page_owner-add-page_owner_stacks-file-to-print-out-only-stacks-and-their-counte-fix.patch
fork-optimize-memcg_charge_kernel_stack-a-bit-fix.patch

