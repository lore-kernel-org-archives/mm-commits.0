From: akpm@linux-foundation.org
Subject: + libertas-down_interruptible-can-return-eintr-not-eintr.patch added to -mm tree
Date: Mon, 03 Jan 2011 12:03:44 -0800
Message-ID: <201101032003.p03K3i4N025984@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46508 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751257Ab1ACUEe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 3 Jan 2011 15:04:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: roel.kluin@gmail.com, dcbw@redhat.com, linville@tuxdriver.com


The patch titled
     down_interruptible() can return -EINTR, not EINTR
has been added to the -mm tree.  Its filename is
     libertas-down_interruptible-can-return-eintr-not-eintr.patch

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
Subject: down_interruptible() can return -EINTR, not EINTR
From: roel kluin <roel.kluin@gmail.com>

Fix test in lbs_spi_thread().  down_interruptible() can return -EINTR, but
not EINTR.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: Dan Williams <dcbw@redhat.com>
Cc: "John W. Linville" <linville@tuxdriver.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/wireless/libertas/if_spi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/net/wireless/libertas/if_spi.c~libertas-down_interruptible-can-return-eintr-not-eintr drivers/net/wireless/libertas/if_spi.c
--- a/drivers/net/wireless/libertas/if_spi.c~libertas-down_interruptible-can-return-eintr-not-eintr
+++ a/drivers/net/wireless/libertas/if_spi.c
@@ -784,7 +784,7 @@ static int lbs_spi_thread(void *data)
 				up(&card->spi_thread_terminated);
 				do_exit(0);
 			}
-		} while (err == EINTR);
+		} while (err == -EINTR);
 
 		/* Read the host interrupt status register to see what we
 		 * can do. */
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

btrfs-dont-dereference-extent_mapping-if-null.patch
regulator-missing-index-in-ptr_err-in-isl6271a_probe.patch
libertas-down_interruptible-can-return-eintr-not-eintr.patch
crypto-dont-return-ptr_err-of-wrong-pointer.patch
frv-duplicate-output_buffer-of-e03.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch

