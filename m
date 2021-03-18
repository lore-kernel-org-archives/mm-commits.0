Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB4E4C433E9
	for <mm-commits@archiver.kernel.org>; Thu, 18 Mar 2021 00:16:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5C35B64F2B
	for <mm-commits@archiver.kernel.org>; Thu, 18 Mar 2021 00:16:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229880AbhCRAPk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 17 Mar 2021 20:15:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:57556 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229613AbhCRAPX (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 17 Mar 2021 20:15:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1BA7564F26;
        Thu, 18 Mar 2021 00:15:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1616026521;
        bh=MgYcRYGO2M5IhL5SsQoS+biMqXLSkMXTflWEFspByIg=;
        h=Date:From:To:Subject:From;
        b=kVExCSWvhsXMgtMvd9E4DRy8E2iRQAu7KW6bsbew59LK2sncddenwpJ7bJg7TBdnD
         UjqaDX4IgKiuaySIGysOF5nTE/ppnrC8Lyf+Wkxj/+SmKnle7qoDdjHwgdjHL3LKX6
         rwCCznxFOKLpJuNmk5lTiiU5K3UCUR9D19sIBy4E=
Date:   Wed, 17 Mar 2021 17:15:20 -0700
From:   akpm@linux-foundation.org
To:     arnd@arndb.de, david@redhat.com, lkp@intel.com,
        mm-commits@vger.kernel.org, ndesaulniers@google.com,
        rppt@linux.ibm.com
Subject:  + memblock-fix-section-mismatch-warning-again.patch added
 to -mm tree
Message-ID: <20210318001520.XabflQiq1%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memblock: fix section mismatch warning again
has been added to the -mm tree.  Its filename is
     memblock-fix-section-mismatch-warning-again.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/memblock-fix-section-mismatch-warning-again.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/memblock-fix-section-mismatch-warning-again.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mike Rapoport <rppt@linux.ibm.com>
Subject: mm: memblock: fix section mismatch warning again

Commit 34dc2efb39a2 ("memblock: fix section mismatch warning") marked
memblock_bottom_up() and memblock_set_bottom_up() as __init, but they
could be referenced from non-init functions like
memblock_find_in_range_node() on architectures that enable
CONFIG_ARCH_KEEP_MEMBLOCK.

For such builds kernel test robot reports: All warnings (new ones prefixed
by >>, old ones prefixed by <<):

>> WARNING: modpost: vmlinux.o(.text+0x74fea4): Section mismatch in reference from the function memblock_find_in_range_node() to the function .init.text:memblock_bottom_up()
The function memblock_find_in_range_node() references
the function __init memblock_bottom_up().
This is often because memblock_find_in_range_node lacks a __init
annotation or the annotation of memblock_bottom_up is wrong.

Replace __init annotations with __init_memblock annotations so that the
appropriate section will be selected depending on
CONFIG_ARCH_KEEP_MEMBLOCK.

Link: https://lore.kernel.org/lkml/202103160133.UzhgY0wt-lkp@intel.com
Link: https://lkml.kernel.org/r/20210316171347.14084-1-rppt@kernel.org
Fixes: 34dc2efb39a2 ("memblock: fix section mismatch warning")
Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
Reviewed-by: Arnd Bergmann <arnd@arndb.de>
Reported-by: kernel test robot <lkp@intel.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Acked-by: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memblock.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/include/linux/memblock.h~memblock-fix-section-mismatch-warning-again
+++ a/include/linux/memblock.h
@@ -460,7 +460,7 @@ static inline void memblock_free_late(ph
 /*
  * Set the allocation direction to bottom-up or top-down.
  */
-static inline __init void memblock_set_bottom_up(bool enable)
+static inline __init_memblock void memblock_set_bottom_up(bool enable)
 {
 	memblock.bottom_up = enable;
 }
@@ -470,7 +470,7 @@ static inline __init void memblock_set_b
  * if this is true, that said, memblock will allocate memory
  * in bottom-up direction.
  */
-static inline __init bool memblock_bottom_up(void)
+static inline __init_memblock bool memblock_bottom_up(void)
 {
 	return memblock.bottom_up;
 }
_

Patches currently in -mm which might be from rppt@linux.ibm.com are

memblock-fix-section-mismatch-warning-again.patch
mm-add-definition-of-pmd_page_order.patch
mmap-make-mlock_future_check-global.patch
riscv-kconfig-make-direct-map-manipulation-options-depend-on-mmu.patch
set_memory-allow-set_direct_map__noflush-for-multiple-pages.patch
set_memory-allow-querying-whether-set_direct_map_-is-actually-enabled.patch
mm-introduce-memfd_secret-system-call-to-create-secret-memory-areas.patch
pm-hibernate-disable-when-there-are-active-secretmem-users.patch
arch-mm-wire-up-memfd_secret-system-call-where-relevant.patch
secretmem-test-add-basic-selftest-for-memfd_secret2.patch

