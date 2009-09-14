From: akpm@linux-foundation.org
Subject: + kbuild-fix-ld-option-makefile-macro-to-really-work.patch added to -mm tree
Date: Mon, 14 Sep 2009 14:35:19 -0700
Message-ID: <200909142135.n8ELZJi9023941@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40498 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752910AbZINVf3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 14 Sep 2009 17:35:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: andi@firstfloor.org, ak@linux.intel.com, sam@ravnborg.org


The patch titled
     kbuild: fix ld-option Makefile macro to really work
has been added to the -mm tree.  Its filename is
     kbuild-fix-ld-option-makefile-macro-to-really-work.patch

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
Subject: kbuild: fix ld-option Makefile macro to really work
From: Andi Kleen <andi@firstfloor.org>

Needed for the next patch, "kbuild: check if linker supports the -X
option".

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/Kbuild.include |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN scripts/Kbuild.include~kbuild-fix-ld-option-makefile-macro-to-really-work scripts/Kbuild.include
--- a/scripts/Kbuild.include~kbuild-fix-ld-option-makefile-macro-to-really-work
+++ a/scripts/Kbuild.include
@@ -83,11 +83,12 @@ TMPOUT := $(if $(KBUILD_EXTMOD),$(firstw
 # is automatically cleaned up.
 try-run = $(shell set -e;		\
 	TMP="$(TMPOUT).$$$$.tmp";	\
+	TMPO="$(TMPOUT).$$$$.o";	\
 	if ($(1)) >/dev/null 2>&1;	\
 	then echo "$(2)";		\
 	else echo "$(3)";		\
 	fi;				\
-	rm -f "$$TMP")
+	rm -f "$$TMP" "$$TMPO")
 
 # as-option
 # Usage: cflags-y += $(call as-option,-Wa$(comma)-isa=foo,)
@@ -133,7 +134,7 @@ cc-ifversion = $(shell [ $(call cc-versi
 # ld-option
 # Usage: ldflags += $(call ld-option, -Wl$(comma)--hash-style=both)
 ld-option = $(call try-run,\
-	$(CC) $(1) -nostdlib -xc /dev/null -o "$$TMP",$(1),$(2))
+	$(CC) /dev/null -c -o "$$TMPO" ; $(LD) $(1) "$$TMPO" -o "$$TMP",$(1),$(2))
 
 ######
 
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

