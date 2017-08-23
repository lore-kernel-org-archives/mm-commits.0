From: akpm@linux-foundation.org
Subject: +
 mm-zone_device-new-type-of-zone_device-for-unaddressable-memory-fix.patch
 added to -mm tree
Date: Wed, 23 Aug 2017 15:06:24 -0700
Message-ID: <599dfc60.wHPZmph1gpivrSqA%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44258 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751112AbdHWWGZ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 23 Aug 2017 18:06:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arnd@arndb.de, jglisse@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: swap: make free_swap_and_cache()/swapcache_prepare() inline functions
has been added to the -mm tree.  Its filename is
     mm-zone_device-new-type-of-zone_device-for-unaddressable-memory-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-zone_device-new-type-of-zone_device-for-unaddressable-memory-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-zone_device-new-type-of-zone_device-for-unaddressable-memory-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Arnd Bergmann <arnd@arndb.de>
Subject: mm: swap: make free_swap_and_cache()/swapcache_prepare() inline functions

We get a build warning from a boolean expression that is never used:

mm/madvise.c: In function 'madvise_free_pte_range':
include/linux/swap.h:490:55: error: value computed is not used [-Werror=unused-value]
 #define free_swap_and_cache(e) (is_migration_entry(e) || is_device_private_entry(e))
                                                       ^~
mm/madvise.c:353:4: note: in expansion of macro 'free_swap_and_cache'
    free_swap_and_cache(entry);

This changes the two macros to a compound expression that gcc does not
warn about.  Changing them to inline functions would have been nicer but
is not possible here because that would introduce a recursive header file
dependency.

Link: http://lkml.kernel.org/r/20170823133213.712917-1-arnd@arndb.de
Fixes: mmotm ("mm/ZONE_DEVICE: new type of ZONE_DEVICE for unaddressable memory")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Jérôme Glisse <jglisse@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swap.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN include/linux/swap.h~mm-zone_device-new-type-of-zone_device-for-unaddressable-memory-fix include/linux/swap.h
--- a/include/linux/swap.h~mm-zone_device-new-type-of-zone_device-for-unaddressable-memory-fix
+++ a/include/linux/swap.h
@@ -487,8 +487,8 @@ static inline void show_swap_cache_info(
 {
 }
 
-#define free_swap_and_cache(e) (is_migration_entry(e) || is_device_private_entry(e))
-#define swapcache_prepare(e) (is_migration_entry(e) || is_device_private_entry(e))
+#define free_swap_and_cache(e) ({(is_migration_entry(e) || is_device_private_entry(e));})
+#define swapcache_prepare(e) ({(is_migration_entry(e) || is_device_private_entry(e));})
 
 static inline int add_swap_count_continuation(swp_entry_t swp, gfp_t gfp_mask)
 {
_

Patches currently in -mm which might be from arnd@arndb.de are

adfs-use-unsigned-types-for-memcpy-length.patch
mm-zone_device-new-type-of-zone_device-for-unaddressable-memory-fix.patch
fs-proc-remove-priv-argument-from-is_stack-fix.patch
fscache-fix-fscache_objlist_show-format-processing.patch
ib-mlx4-fix-sprintf-format-warning.patch
iopoll-avoid-wint-in-bool-context-warning.patch

