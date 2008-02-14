From: akpm@linux-foundation.org
Subject: + samples-build-fix.patch added to -mm tree
Date: Wed, 13 Feb 2008 19:52:38 -0800
Message-ID: <200802140352.m1E3qcwZ029677@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44389 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759277AbYBNDxL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Feb 2008 22:53:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: roland@redhat.com, sam@ravnborg.org


The patch titled
     samples: build fix
has been added to the -mm tree.  Its filename is
     samples-build-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: samples: build fix
From: Roland McGrath <roland@redhat.com>

The samples/ subdirectory contains only modules.  But the only make run
done there is in commands for vmlinux.  I can't see why this was ever done
in this nonstandard fashion.  As things stand, the modules don't get built
by 'make modules'.

I didn't make the addition of the directory use core-$(CONFIG_SAMPLES)
because there is no other conditional like that in the top-level Makefile
and samples/Makefile already uses obj-$(CONFIG_SAMPLES) as if it expects
always to be included.

Signed-off-by: Roland McGrath <roland@redhat.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Makefile |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff -puN Makefile~samples-build-fix Makefile
--- a/Makefile~samples-build-fix
+++ a/Makefile
@@ -602,7 +602,7 @@ export mod_strip_cmd
 
 
 ifeq ($(KBUILD_EXTMOD),)
-core-y		+= kernel/ mm/ fs/ ipc/ security/ crypto/ block/
+core-y		+= kernel/ mm/ fs/ ipc/ security/ crypto/ block/ samples/
 
 vmlinux-dirs	:= $(patsubst %/,%,$(filter %/, $(init-y) $(init-m) \
 		     $(core-y) $(core-m) $(drivers-y) $(drivers-m) \
@@ -802,9 +802,6 @@ vmlinux: $(vmlinux-lds) $(vmlinux-init) 
 ifdef CONFIG_HEADERS_CHECK
 	$(Q)$(MAKE) -f $(srctree)/Makefile headers_check
 endif
-ifdef CONFIG_SAMPLES
-	$(Q)$(MAKE) $(build)=samples
-endif
 	$(call vmlinux-modpost)
 	$(call if_changed_rule,vmlinux__)
 	$(Q)rm -f .old_version
_

Patches currently in -mm which might be from roland@redhat.com are

origin.patch
linux-kernel-markers-create-modpost-file.patch
samples-build-fix.patch
remove-unused-variable-from-send_signal.patch
turn-legacy_queue-macro-into-static-inline-function.patch
consolidate-checking-for-ignored-legacy-signals.patch
consolidate-checking-for-ignored-legacy-signals-simplify.patch
