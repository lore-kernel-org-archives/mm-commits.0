From: akpm@linux-foundation.org
Subject: + kbuild-set-fconserve-stack-option-for-gcc-45.patch added to -mm tree
Date: Mon, 14 Sep 2009 14:35:28 -0700
Message-ID: <200909142135.n8ELZSW9024225@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42028 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752306AbZINVfq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 14 Sep 2009 17:35:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: andi@firstfloor.org, ak@linux.intel.com, sam@ravnborg.org


The patch titled
     kbuild: set -fconserve-stack option for gcc 4.5
has been added to the -mm tree.  Its filename is
     kbuild-set-fconserve-stack-option-for-gcc-45.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kbuild: set -fconserve-stack option for gcc 4.5
From: Andi Kleen <andi@firstfloor.org>

The upcomming gcc 4.5 has a new -fconserve-stack option that tells the
inliner to take stack frame size in account.  Set it if the compiler
supports it.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Makefile |    3 +++
 1 file changed, 3 insertions(+)

diff -puN Makefile~kbuild-set-fconserve-stack-option-for-gcc-45 Makefile
--- a/Makefile~kbuild-set-fconserve-stack-option-for-gcc-45
+++ a/Makefile
@@ -573,6 +573,9 @@ KBUILD_CFLAGS	+= $(call cc-option,-fno-s
 # revert to pre-gcc-4.4 behaviour of .eh_frame
 KBUILD_CFLAGS	+= $(call cc-option,-fno-dwarf2-cfi-asm)
 
+# conserve stack if available
+KBUILD_CFLAGS   += $(call cc-option,-fconserve-stack)
+
 # Add user supplied CPPFLAGS, AFLAGS and CFLAGS as the last assignments
 # But warn user when we do so
 warn-assign = \
_

Patches currently in -mm which might be from andi@firstfloor.org are

linux-next.patch
mm-memory-failure-remove-config_unevictable_lru-config-option.patch
kbuild-fix-ld-option-makefile-macro-to-really-work.patch
kbuild-check-if-linker-supports-the-x-option.patch
kbuild-echo-the-record_mcount-command.patch
kbuild-fail-build-if-recordmcountpl-fails.patch
kbuild-set-fconserve-stack-option-for-gcc-45.patch
vfs-optimization-for-touch_atime.patch
vfs-optimize-touch_time-too.patch
hugetlb-restore-interleaving-of-bootmem-huge-pages.patch
documentation-memorytxt-remove-some-very-outdated-recommendations.patch
build_bug_on-fix-it-and-a-couple-of-bogus-uses-of-it.patch
video-console-use-div_round_up.patch
time-add-function-to-convert-between-calendar-time-and-broken-down-time-for-universal-use.patch
fatfs-use-common-time_to_tm-in-fat_time_unix2fat.patch
page-types-add-feature-for-walking-process-address-space.patch
memcg-improve-resource-counter-scalability.patch
memcg-improve-resource-counter-scalability-v5.patch
exec-make-do_coredump-more-resilient-to-recursive-crashes-v9.patch
exec-let-do_coredump-limit-the-number-of-concurrent-dumps-to-pipes-v9.patch
exec-allow-do_coredump-to-wait-for-user-space-pipe-readers-to-complete-v9.patch

