Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 960B6C77B6C
	for <mm-commits@archiver.kernel.org>; Wed, 12 Apr 2023 21:06:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229532AbjDLVGo (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 12 Apr 2023 17:06:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229839AbjDLVGj (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 12 Apr 2023 17:06:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 004106E9B
        for <mm-commits@vger.kernel.org>; Wed, 12 Apr 2023 14:06:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8CCEA63942
        for <mm-commits@vger.kernel.org>; Wed, 12 Apr 2023 21:06:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E25F1C433D2;
        Wed, 12 Apr 2023 21:06:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1681333591;
        bh=ZaNFUJSxIY4t3F/ZjYWfraqCB3vkJnkxjKmg5iWprD0=;
        h=Date:To:From:Subject:From;
        b=YMcR6hlTAvQTwQQj7+emGpfe+nx0syn9DGsi+pPQPov4Y6rv1nzxCfnYGnAuD0FZE
         6lzmjy0oUWw+JPWLofplpfGCudwtxkomzY4Aoc/2c7KIz/E3dRESCfd5+0Tij4I9ds
         ZSoYXUpS8japfrjcrvlyqKrfodZWKxWaR32vEjFk=
Date:   Wed, 12 Apr 2023 14:06:30 -0700
To:     mm-commits@vger.kernel.org, urezki@gmail.com,
        mail.dipanjan.das@gmail.com, lkp@intel.com, hch@infradead.org,
        glider@google.com, elver@google.com, dvyukov@google.com,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-kmsan-handle-alloc-failures-in-kmsan_ioremap_page_range-fix.patch added to mm-hotfixes-unstable branch
Message-Id: <20230412210630.E25F1C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-kmsan-handle-alloc-failures-in-kmsan_ioremap_page_range-fix
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-kmsan-handle-alloc-failures-in-kmsan_ioremap_page_range-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-kmsan-handle-alloc-failures-in-kmsan_ioremap_page_range-fix.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-kmsan-handle-alloc-failures-in-kmsan_ioremap_page_range-fix
Date: Wed Apr 12 02:04:27 PM PDT 2023

fix build error

Reported-by: kernel test robot <lkp@intel.com>
  Link: https://lore.kernel.org/oe-kbuild-all/202304130223.epEIvA1E-lkp@intel.com/
Cc: Alexander Potapenko <glider@google.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Dipanjan Das <mail.dipanjan.das@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Marco Elver <elver@google.com>
Cc: Uladzislau Rezki (Sony) <urezki@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kmsan.h |    1 +
 1 file changed, 1 insertion(+)

--- a/include/linux/kmsan.h~mm-kmsan-handle-alloc-failures-in-kmsan_ioremap_page_range-fix
+++ a/include/linux/kmsan.h
@@ -289,6 +289,7 @@ static inline int kmsan_vmap_pages_range
 						 struct page **pages,
 						 unsigned int page_shift)
 {
+	return 0;
 }
 
 static inline void kmsan_vunmap_range_noflush(unsigned long start,
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-khugepaged-fix-kernel-bug-in-hpage_collapse_scan_file-fix.patch
mm-kmsan-handle-alloc-failures-in-kmsan_ioremap_page_range-fix.patch
mm-treewide-redefine-max_order-sanely-fix-fix-fix.patch
memcg-do-not-drain-charge-pcp-caches-on-remote-isolated-cpus-fix.patch
vmstat-add-pcp-remote-node-draining-via-cpu_vm_stats_fold-fix.patch
lib-test_vmallocc-add-vm_map_ram-vm_unmap_ram-test-case-fix.patch
scripts-gdb-create-linux-vfspy-for-vfs-related-gdb-helpers-fix.patch

