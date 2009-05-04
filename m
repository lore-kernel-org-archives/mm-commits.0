From: akpm@linux-foundation.org
Subject: + doc-small-kernel-parameters-updates.patch added to -mm tree
Date: Mon, 04 May 2009 14:50:18 -0700
Message-ID: <200905042150.n44LoIWQ017896@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43312 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751912AbZEDVww (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 May 2009 17:52:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, chris.sylvain@gmail.com, jengelh@medozas.de


The patch titled
     doc: small kernel-parameters updates
has been added to the -mm tree.  Its filename is
     doc-small-kernel-parameters-updates.patch

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
Subject: doc: small kernel-parameters updates
From: Randy Dunlap <randy.dunlap@oracle.com>

Change last "i386" to X86-32 as is used throughout the rest of the file. 
Change combination of X86-32,X86-64 to just X86, as is done throughout the
rest of the file.

Add a note that hyphens and underscores are equivalent in parameter names,
with examples.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Jan Engelhardt <jengelh@medozas.de>
Cc: Christopher Sylvain <chris.sylvain@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/kernel-parameters.txt |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff -puN Documentation/kernel-parameters.txt~doc-small-kernel-parameters-updates Documentation/kernel-parameters.txt
--- a/Documentation/kernel-parameters.txt~doc-small-kernel-parameters-updates
+++ a/Documentation/kernel-parameters.txt
@@ -17,6 +17,12 @@ are specified on the kernel command line
 
 	usbcore.blinkenlights=1
 
+Hyphens (dashes) and underscores are equivalent in parameter names, so
+	log_buf_len=1M print-fatal-signals=1
+can also be entered as
+	log-buf-len=1M print_fatal_signals=1
+
+
 This document may not be entirely up to date and comprehensive. The command
 "modinfo -p ${modulename}" shows a current list of all parameters of a loadable
 module. Loadable modules, after being loaded into the running kernel, also
@@ -345,7 +351,7 @@ and is between 256 and 4096 characters. 
 			not play well with APC CPU idle - disable it if you have
 			APC and your system crashes randomly.
 
-	apic=		[APIC,i386] Advanced Programmable Interrupt Controller
+	apic=		[APIC,X86-32] Advanced Programmable Interrupt Controller
 			Change the output verbosity whilst booting
 			Format: { quiet (default) | verbose | debug }
 			Change the amount of debugging information output
@@ -702,7 +708,7 @@ and is between 256 and 4096 characters. 
 			to discrete, to make X server driver able to add WB
 			entry later. This parameter enables that.
 
-	enable_timer_pin_1 [i386,x86-64]
+	enable_timer_pin_1 [X86]
 			Enable PIN 1 of APIC timer
 			Can be useful to work around chipset bugs
 			(in particular on some ATI chipsets).
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
linux-next.patch
input-drivers-input-xpadc-improve-xbox-360-wireless-support-and-add-sysfs-interface-fix.patch
input-drivers-input-xpadc-improve-xbox-360-wireless-support-and-add-sysfs-interface-add-missing-prototype-and-update-history.patch
nfsd-use-c99-struct-initializers.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
qla2x-fix-printk-format-warnings.patch
menu-fix-embedded-menu-order.patch
doc-small-kernel-parameters-updates.patch
lockd-fix-file_locking=n-build-error.patch
kmap_types-make-most-arches-use-generic-header-file.patch
irqs-add-irqf_sample_random-to-the-feature-removal-scheduletxt-deprecated-list.patch
cgroups-make-messages-more-readable.patch
linuxpps-core-support.patch
reiser4-export-remove_from_page_cache-fix.patch

