From: akpm@linux-foundation.org
Subject: +
 include-linux-memblockh-add-__init-to-memblock_set_bottom_up.patch added to -mm tree
Date: Wed, 11 Jun 2014 14:33:33 -0700
Message-ID: <5398cb2d.1gcsS4nemiXRkLo1%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51416 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752158AbaFKVdd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Jun 2014 17:33:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tangchen@cn.fujitsu.com, fabf@skynet.be

Subject: + include-linux-memblockh-add-__init-to-memblock_set_bottom_up.patch added to -mm tree
To: fabf@skynet.be,tangchen@cn.fujitsu.com
From: akpm@linux-foundation.org
Date: Wed, 11 Jun 2014 14:33:33 -0700


The patch titled
     Subject: include/linux/memblock.h: add __init to memblock_set_bottom_up()
has been added to the -mm tree.  Its filename is
     include-linux-memblockh-add-__init-to-memblock_set_bottom_up.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/include-linux-memblockh-add-__init-to-memblock_set_bottom_up.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/include-linux-memblockh-add-__init-to-memblock_set_bottom_up.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Fabian Frederick <fabf@skynet.be>
Subject: include/linux/memblock.h: add __init to memblock_set_bottom_up()

memblock_set_bottom_up() is only called by __init
cmdline_parse_movable_node() and __init numa_init().

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Reviewed-by: Tang Chen<tangchen@cn.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memblock.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN include/linux/memblock.h~include-linux-memblockh-add-__init-to-memblock_set_bottom_up include/linux/memblock.h
--- a/include/linux/memblock.h~include-linux-memblockh-add-__init-to-memblock_set_bottom_up
+++ a/include/linux/memblock.h
@@ -249,7 +249,7 @@ phys_addr_t memblock_alloc(phys_addr_t s
 /*
  * Set the allocation direction to bottom-up or top-down.
  */
-static inline void memblock_set_bottom_up(bool enable)
+static inline void __init memblock_set_bottom_up(bool enable)
 {
 	memblock.bottom_up = enable;
 }
@@ -264,7 +264,7 @@ static inline bool memblock_bottom_up(vo
 	return memblock.bottom_up;
 }
 #else
-static inline void memblock_set_bottom_up(bool enable) {}
+static inline void __init memblock_set_bottom_up(bool enable) {}
 static inline bool memblock_bottom_up(void) { return false; }
 #endif
 
_

Patches currently in -mm which might be from fabf@skynet.be are

origin.patch
fs-cifs-remove-obsolete-__constant.patch
kernel-posix-timersc-code-clean-up.patch
kernel-posix-timersc-code-clean-up-checkpatch-fixes.patch
fs-ext4-fsyncc-generic_file_fsync-call-based-on-barrier-flag.patch
mm-slabc-add-__init-to-init_lock_keys.patch
mm-readaheadc-remove-unused-file_ra_state-from-count_history_pages.patch
mm-memory_hotplugc-add-__meminit-to-grow_zone_span-grow_pgdat_span.patch
mm-page_alloc-add-__meminit-to-alloc_pages_exact_nid.patch
mm-page_allocc-unexport-alloc_pages_exact_nid.patch
include-linux-memblockh-add-__init-to-memblock_set_bottom_up.patch
mm-zswapc-add-__init-to-zswap_entry_cache_destroy.patch
fs-isofs-logging-clean-up.patch
fs-proc-kcorec-use-page_align-instead-of-alignpage_size.patch
fs-cachefiles-daemonc-remove-unnecessary-tests-on-unsigned-values.patch
linux-next.patch
init-mainc-code-clean-up.patch
kernel-kprobesc-convert-printk-to-pr_foo.patch
kernel-watchdogc-convert-printk-pr_warning-to-pr_foo.patch

