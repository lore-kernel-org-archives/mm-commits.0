From: akpm@linux-foundation.org
Subject: + scsi-aacraid-fix-memory-leak.patch added to -mm tree
Date: Thu, 10 Dec 2009 15:07:41 -0800
Message-ID: <200912102307.nBAN7fFv022978@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60822 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933078AbZLJXHj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 10 Dec 2009 18:07:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jirislaby@gmail.com, James.Bottomley@HansenPartnership.com


The patch titled
     SCSI: aacraid, fix memory leak
has been added to the -mm tree.  Its filename is
     scsi-aacraid-fix-memory-leak.patch

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
Subject: SCSI: aacraid, fix memory leak
From: Jiri Slaby <jirislaby@gmail.com>

Stanse found a memory leak on one fail path in aac_send_raw_srb. Add kfree
there.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/aacraid/commctrl.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/scsi/aacraid/commctrl.c~scsi-aacraid-fix-memory-leak drivers/scsi/aacraid/commctrl.c
--- a/drivers/scsi/aacraid/commctrl.c~scsi-aacraid-fix-memory-leak
+++ a/drivers/scsi/aacraid/commctrl.c
@@ -649,6 +649,7 @@ static int aac_send_raw_srb(struct aac_d
 				     AAC_OPT_NEW_COMM) ?
 				      (dev->scsi_host_ptr->max_sectors << 9) :
 				      65536) {
+					kfree (usg);
 					rcode = -EINVAL;
 					goto cleanup;
 				}
_

Patches currently in -mm which might be from jirislaby@gmail.com are

origin.patch
linux-next.patch
scsi-aacraid-fix-memory-leak.patch
scsi-remove-unnecessary-null-test.patch
scsi-lpfc-fix-memory-leak.patch
swap_info-include-first_swap_extent-fix.patch
swap_info-include-first_swap_extent-fix-fix.patch
char-cyclades-fix-compiler-warning.patch
cyclades-allow-overriding-isa-defaults-also-when-the-driver-is-built-in.patch
char-mxser-remove-unnecessary-tty-test.patch
isicomc-use-pr_fmt-and-pr_level.patch
moxa-remove-ifdef-module-completely.patch
reiser4.patch
fs-reiser4-add-parenths-around-x-y.patch

