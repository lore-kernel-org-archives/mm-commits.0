From: akpm@linux-foundation.org
Subject: + efirtc-explicitly-set-llseek-to-no_llseek.patch added to -mm tree
Date: Tue, 03 Nov 2009 15:48:12 -0800
Message-ID: <200911032348.nA3NmCDF017081@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54005 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752299AbZKCXsu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 Nov 2009 18:48:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jkacur@redhat.com


The patch titled
     efirtc: explicitly set llseek to no_llseek
has been added to the -mm tree.  Its filename is
     efirtc-explicitly-set-llseek-to-no_llseek.patch

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
Subject: efirtc: explicitly set llseek to no_llseek
From: John Kacur <jkacur@redhat.com>

Now that we've removed the BKL here, let's explicitly set llseek to
no_llseek since the default llseek is not used here.

Signed-off-by: John Kacur <jkacur@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN drivers/char/efirtc.c~efirtc-explicitly-set-llseek-to-no_llseek drivers/char/efirtc.c
--- a/drivers/char/efirtc.c~efirtc-explicitly-set-llseek-to-no_llseek
+++ a/drivers/char/efirtc.c
@@ -295,6 +295,7 @@ static const struct file_operations efi_
 	.unlocked_ioctl	= efi_rtc_ioctl,
 	.open		= efi_rtc_open,
 	.release	= efi_rtc_close,
+	.llseek		= no_llseek,
 };
 
 static struct miscdevice efi_rtc_dev= {
_

Patches currently in -mm which might be from jkacur@redhat.com are

origin.patch
linux-next.patch
mips-vpe-remove-leftover-unlock_kernel.patch
efirtc-explicitly-set-llseek-to-no_llseek.patch

