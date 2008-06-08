From: akpm@linux-foundation.org
Subject: + x86-fix-longstanding-setupc-printk-format-warning.patch added to -mm tree
Date: Sun, 08 Jun 2008 13:21:54 -0700
Message-ID: <200806082021.m58KLs8N018864@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40692 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752784AbYFHUWr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sun, 8 Jun 2008 16:22:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, mingo@elte.hu


The patch titled
     x86: fix longstanding setup.c printk format warning
has been added to the -mm tree.  Its filename is
     x86-fix-longstanding-setupc-printk-format-warning.patch

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
Subject: x86: fix longstanding setup.c printk format warning
From: Randy Dunlap <randy.dunlap@oracle.com>

Fix setup.c printk format warning:

linux-next-20080605/arch/x86/kernel/setup.c: In function 'setup_per_cpu_areas':
linux-next-20080605/arch/x86/kernel/setup.c:173: warning: format '%lu' expects type 'long unsigned int', but argument 2 has type 'ssize_t'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/setup.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/x86/kernel/setup.c~x86-fix-longstanding-setupc-printk-format-warning arch/x86/kernel/setup.c
--- a/arch/x86/kernel/setup.c~x86-fix-longstanding-setupc-printk-format-warning
+++ a/arch/x86/kernel/setup.c
@@ -169,7 +169,7 @@ void __init setup_per_cpu_areas(void)
 
 	/* Copy section for each CPU (we discard the original) */
 	size = PERCPU_ENOUGH_ROOM;
-	printk(KERN_INFO "PERCPU: Allocating %lu bytes of per cpu data\n",
+	printk(KERN_INFO "PERCPU: Allocating %zd bytes of per cpu data\n",
 			  size);
 
 	for_each_possible_cpu(cpu) {
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

linux-next.patch
x86-fix-longstanding-setupc-printk-format-warning.patch
dev_set_name-fix-missing-kernel-doc.patch
documentation-build-source-files-in-documentation-sub-dir.patch
documentation-build-source-files-in-documentation-sub-dir-disable.patch
8390-split-8390-support-into-a-pausing-and-a-non-pausing-driver-core.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
netfilter-conntrack_helper-needs-to-include-rculisth.patch
git-scsi-misc-fix-scsi_dh-build-errors.patch
git-unionfs.patch
uwb-fix-kconfig-causing-undefined-references.patch
audit-fix-kernel-doc-parameter-notation.patch
vmallocinfo-add-numa-information.patch
vmallocinfo-add-numa-information-fix.patch
flag-parameters-signalfd-fix.patch
flag-parameters-eventfd-fix.patch
bsdacct-stir-up-comments-around-acct_process.patch
profile-likely-unlikely-macros.patch

