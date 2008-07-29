From: akpm@linux-foundation.org
Subject: + hpwdt-dont-use-static-flags.patch added to -mm tree
Date: Mon, 28 Jul 2008 19:41:28 -0700
Message-ID: <200807290241.m6T2fSfa010094@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58799 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752068AbYG2CmO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Jul 2008 22:42:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adobriyan@gmail.com, thomas.mingarelli@hp.com, wim@iguana.be


The patch titled
     hpwdt: don't use static flags
has been added to the -mm tree.  Its filename is
     hpwdt-dont-use-static-flags.patch

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
Subject: hpwdt: don't use static flags
From: Alexey Dobriyan <adobriyan@gmail.com>

Static (read: global) is potential problem.  Two threads can corrupt each
other's interrupt status, better avoid this.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Wim Van Sebroeck <wim@iguana.be>
Cc: Thomas Mingarelli <thomas.mingarelli@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/watchdog/hpwdt.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/watchdog/hpwdt.c~hpwdt-dont-use-static-flags drivers/watchdog/hpwdt.c
--- a/drivers/watchdog/hpwdt.c~hpwdt-dont-use-static-flags
+++ a/drivers/watchdog/hpwdt.c
@@ -420,7 +420,7 @@ static int __devinit detect_cru_service(
 static int hpwdt_pretimeout(struct notifier_block *nb, unsigned long ulReason,
 			    void *data)
 {
-	static unsigned long rom_pl;
+	unsigned long rom_pl;
 	static int die_nmi_called;
 
 	if (ulReason != DIE_NMI && ulReason != DIE_NMI_IPI)
_

Patches currently in -mm which might be from adobriyan@gmail.com are

origin.patch
fix-__ratelimit-re-flags-cant-be-static.patch
hpwdt-dont-use-static-flags.patch
linux-next.patch
mpt-remove-unused-struct-mpt_proc_entry_t.patch
cdc-acm-dont-unlock-acm-mutex-on-error-path.patch
slb-drop-kmem-cache-argument-from-constructor-fix-fix-logfs.patch
proc-use-non-racy-method-for-proc-page_owner-creation-page_owner.patch
likely_prof-changed-to-use-proc_create.patch
proc-remove-proc_root-from-drivers-likelyprof.patch

