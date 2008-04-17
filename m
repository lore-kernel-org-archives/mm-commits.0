From: akpm@linux-foundation.org
Subject: + capifs-fix-memory-leak-on-remount.patch added to -mm tree
Date: Thu, 17 Apr 2008 14:48:17 -0700
Message-ID: <200804172148.m3HLmHRZ029508@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54286 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753404AbYDQVsu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 17 Apr 2008 17:48:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: gorcunov@gmail.com, kkeil@suse.de


The patch titled
     capifs: fix memory leak on remount
has been added to the -mm tree.  Its filename is
     capifs-fix-memory-leak-on-remount.patch

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
Subject: capifs: fix memory leak on remount
From: Cyrill Gorcunov <gorcunov@gmail.com>

capifs_remount may reach 'return' statement without freeing of memory
allocated by kstrdup call

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Karsten Keil <kkeil@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/isdn/capi/capifs.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/isdn/capi/capifs.c~capifs-fix-memory-leak-on-remount drivers/isdn/capi/capifs.c
--- a/drivers/isdn/capi/capifs.c~capifs-fix-memory-leak-on-remount
+++ a/drivers/isdn/capi/capifs.c
@@ -69,6 +69,7 @@ static int capifs_remount(struct super_b
 		} else if (sscanf(this_char, "mode=%o%c", &n, &dummy) == 1)
 			mode = n & ~S_IFMT;
 		else {
+			kfree(new_opt);
 			printk("capifs: called with bogus options\n");
 			return -EINVAL;
 		}
_

Patches currently in -mm which might be from gorcunov@gmail.com are

thinkpad-acpi-fix-possible-null-pointer-dereference.patch
git-x86.patch
git-avr32.patch
git-dvb.patch
git-gfs2-nmw.patch
m32r-cleanup-drop-dataidt-section-in-vmlinuxlds-script.patch
nfs-fix-potential-null-pointer-dereference-v2.patch
capifs-fix-memory-leak-on-remount.patch
elf-use-ei_nident-instead-of-numeric-value.patch
binfmt-fill_elf_header-cleanup-use-straight-memset-first.patch

