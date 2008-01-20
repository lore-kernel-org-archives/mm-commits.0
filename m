From: akpm@linux-foundation.org
Subject: + remove-bogus-duplicate-config_lguest_guest-entry.patch added to -mm tree
Date: Sat, 19 Jan 2008 17:03:56 -0800
Message-ID: <200801200103.m0K13aS3028952@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53189 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754057AbYATBE2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 19 Jan 2008 20:04:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rusty@rustcorp.com.au, bunk@kernel.org


The patch titled
     Remove bogus duplicate CONFIG_LGUEST_GUEST entry
has been added to the -mm tree.  Its filename is
     remove-bogus-duplicate-config_lguest_guest-entry.patch

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
Subject: Remove bogus duplicate CONFIG_LGUEST_GUEST entry
From: Rusty Russell <rusty@rustcorp.com.au>

It was moved to arch/x86/lguest/Kconfig, but I lost the deletion part in a
patch suffle.  My confused one-liner "fix" to turn it on is also reverted:
84f7466ee20cc094aa38617abfa2f3834871f054

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Reported-by: Adrian Bunk <bunk@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/lguest/Kconfig |    7 -------
 1 file changed, 7 deletions(-)

diff -puN drivers/lguest/Kconfig~remove-bogus-duplicate-config_lguest_guest-entry drivers/lguest/Kconfig
--- a/drivers/lguest/Kconfig~remove-bogus-duplicate-config_lguest_guest-entry
+++ a/drivers/lguest/Kconfig
@@ -2,7 +2,6 @@ config LGUEST
 	tristate "Linux hypervisor example code"
 	depends on X86_32 && EXPERIMENTAL && !X86_PAE && FUTEX && !(X86_VISWS || X86_VOYAGER)
 	select HVC_DRIVER
-	select LGUEST_GUEST
 	---help---
 	  This is a very simple module which allows you to run
 	  multiple instances of the same Linux kernel, using the
@@ -11,9 +10,3 @@ config LGUEST
 	  not "rustyvisor".  See Documentation/lguest/lguest.txt.
 
 	  If unsure, say N.  If curious, say M.  If masochistic, say Y.
-
-config LGUEST_GUEST
-	bool
-	help
-	  The guest needs code built-in, even if the host has lguest
-	  support as a module.
_

Patches currently in -mm which might be from rusty@rustcorp.com.au are

origin.patch
remove-bogus-duplicate-config_lguest_guest-entry.patch
git-kbuild.patch
git-kvm.patch
git-libata-all.patch
git-sched.patch
git-scsi-misc.patch
git-x86.patch
kallsyms-should-prefer-non-weak-symbols.patch
virtio_net-remove-double-ether_setup.patch
modules-handle-symbols-that-have-a-zero-value.patch
modules-include-sectionsh-to-avoid-defining-linker-variables.patch
modules-make-module_address_lookup-safe.patch
modules-make-module_address_lookup-safe-fix.patch
fixup-container_of-usage.patch
aio-partial-write-should-not-return-error-code.patch
aio-negative-offset-should-return-einval.patch
reiser4.patch
