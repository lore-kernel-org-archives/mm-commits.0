From: akpm@linux-foundation.org
Subject: [merged] libertas-down_interruptible-can-return-eintr-not-eintr.patch removed from -mm tree
Date: Wed, 05 Jan 2011 11:28:30 -0800
Message-ID: <201101051930.p05JU58W014079@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36440 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752398Ab1AETa1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 5 Jan 2011 14:30:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roel.kluin@gmail.com, dcbw@redhat.com, linville@tuxdriver.com, mm-commits@vger.kernel.org


The patch titled
     down_interruptible() can return -EINTR, not EINTR
has been removed from the -mm tree.  Its filename was
     libertas-down_interruptible-can-return-eintr-not-eintr.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

linux-next.patch
btrfs-dont-dereference-extent_mapping-if-null.patch
macintosh-wrong-test-in-fan_readwrite_reg.patch
frv-duplicate-output_buffer-of-e03.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch

