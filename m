From: akpm@linux-foundation.org
Subject: [merged] efirtc-explicitly-set-llseek-to-no_llseek.patch removed from -mm tree
Date: Wed, 16 Dec 2009 12:34:38 -0800
Message-ID: <200912162034.nBGKYcP0013035@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44417 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935166AbZLPUe4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 Dec 2009 15:34:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jkacur@redhat.com, mm-commits@vger.kernel.org


The patch titled
     efirtc: explicitly set llseek to no_llseek
has been removed from the -mm tree.  Its filename was
     efirtc-explicitly-set-llseek-to-no_llseek.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: efirtc: explicitly set llseek to no_llseek
From: John Kacur <jkacur@redhat.com>

Now that we've removed the BKL here, let's explicitly set llseek to
no_llseek since the default llseek is not used here.

The default_llseek function still contains the BKL.  When we are auditing
code to see if we can remove the BKL, this is one of the hidden
considerations we need to take into account.  i.e., is there
syncronization between code that has the BKL and llseek.

At the same time we remove the BKL it would be a good idea to do indicate
when no llseek function is required, so we don't have to revisit this code
again, when we are trying to determine if we can remove the BKL from the
default_llseek.

Signed-off-by: John Kacur <jkacur@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/efirtc.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/char/efirtc.c~efirtc-explicitly-set-llseek-to-no_llseek drivers/char/efirtc.c
--- a/drivers/char/efirtc.c~efirtc-explicitly-set-llseek-to-no_llseek
+++ a/drivers/char/efirtc.c
@@ -285,6 +285,7 @@ static const struct file_operations efi_
 	.unlocked_ioctl	= efi_rtc_ioctl,
 	.open		= efi_rtc_open,
 	.release	= efi_rtc_close,
+	.llseek		= no_llseek,
 };
 
 static struct miscdevice efi_rtc_dev= {
_

Patches currently in -mm which might be from jkacur@redhat.com are

origin.patch

