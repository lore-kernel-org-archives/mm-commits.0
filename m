From: akpm@linux-foundation.org
Subject: + firmware-dmi_scan-drop-obsolete-comment.patch added to -mm tree
Date: Wed, 10 Jul 2013 14:34:41 -0700
Message-ID: <51ddd371.6fLTM4R+ji6464Gl%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55225 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754630Ab3GJVem (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 10 Jul 2013 17:34:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, yinghai@kernel.org, mingo@kernel.org, joe@perches.com, jdelvare@suse.de

Subject: + firmware-dmi_scan-drop-obsolete-comment.patch added to -mm tree
To: jdelvare@suse.de,joe@perches.com,mingo@kernel.org,yinghai@kernel.org
From: akpm@linux-foundation.org
Date: Wed, 10 Jul 2013 14:34:41 -0700


The patch titled
     Subject: firmware/dmi_scan: drop obsolete comment
has been added to the -mm tree.  Its filename is
     firmware-dmi_scan-drop-obsolete-comment.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/firmware-dmi_scan-drop-obsolete-comment.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/firmware-dmi_scan-drop-obsolete-comment.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jean Delvare <jdelvare@suse.de>
Subject: firmware/dmi_scan: drop obsolete comment

This comment predates the introduction of early_ioremap.  Since then the
missing calls to dmi_iounmap have been added by Ingo and Yinghai in
commits 0d64484f7ea1 ("x86: fix DMI ioremap leak") and 3212bff370c2f
("x86: left over fix for leak of early_ioremp in dmi_scan") .  That was
over 5 years ago so it is about time to drop this now misleading comment.

Signed-off-by: Jean Delvare <jdelvare@suse.de>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/firmware/dmi_scan.c |    5 -----
 1 file changed, 5 deletions(-)

diff -puN drivers/firmware/dmi_scan.c~firmware-dmi_scan-drop-obsolete-comment drivers/firmware/dmi_scan.c
--- a/drivers/firmware/dmi_scan.c~firmware-dmi_scan-drop-obsolete-comment
+++ a/drivers/firmware/dmi_scan.c
@@ -504,11 +504,6 @@ void __init dmi_scan_machine(void)
 		}
 	}
 	else {
-		/*
-		 * no iounmap() for that ioremap(); it would be a no-op, but
-		 * it's so early in setup that sucker gets confused into doing
-		 * what it shouldn't if we actually call it.
-		 */
 		p = dmi_ioremap(0xF0000, 0x10000);
 		if (p == NULL)
 			goto error;
_

Patches currently in -mm which might be from jdelvare@suse.de are

origin.patch
linux-next.patch
dmi_scan-add-comments-on-dmi_present-and-the-loop-in-dmi_scan_machine.patch
firmware-dmi_scan-drop-obsolete-comment.patch
firmware-dmi_scan-fix-most-checkpatch-errors-and-warnings.patch
firmware-dmi_scan-constify-strings.patch
firmware-dmi_scan-drop-oom-messages.patch

