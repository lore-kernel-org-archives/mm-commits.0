From: akpm@linux-foundation.org
Subject: + mmc-fix-the-use-of-kunmap_atomic-in-tmio_mmch.patch added to -mm tree
Date: Thu, 26 Aug 2010 16:05:31 -0700
Message-ID: <201008262305.o7QN5VEj020023@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38838 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751887Ab0HZXFk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 26 Aug 2010 19:05:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: g.liakhovetski@gmx.de, damm@opensource.se, eric.y.miao@gmail.com


The patch titled
     mmc: fix the use of kunmap_atomic() in tmio_mmc.h
has been added to the -mm tree.  Its filename is
     mmc-fix-the-use-of-kunmap_atomic-in-tmio_mmch.patch

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
Subject: mmc: fix the use of kunmap_atomic() in tmio_mmc.h
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Acked-by: Eric Miao <eric.y.miao@gmail.com>
Tested-by: Magnus Damm <damm@opensource.se>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/host/tmio_mmc.c |    7 ++++---
 drivers/mmc/host/tmio_mmc.h |    8 +++-----
 2 files changed, 7 insertions(+), 8 deletions(-)

diff -puN drivers/mmc/host/tmio_mmc.c~mmc-fix-the-use-of-kunmap_atomic-in-tmio_mmch drivers/mmc/host/tmio_mmc.c
--- a/drivers/mmc/host/tmio_mmc.c~mmc-fix-the-use-of-kunmap_atomic-in-tmio_mmch
+++ a/drivers/mmc/host/tmio_mmc.c
@@ -164,6 +164,7 @@ tmio_mmc_start_command(struct tmio_mmc_h
 static void tmio_mmc_pio_irq(struct tmio_mmc_host *host)
 {
 	struct mmc_data *data = host->data;
+	void *sg_virt;
 	unsigned short *buf;
 	unsigned int count;
 	unsigned long flags;
@@ -173,8 +174,8 @@ static void tmio_mmc_pio_irq(struct tmio
 		return;
 	}
 
-	buf = (unsigned short *)(tmio_mmc_kmap_atomic(host, &flags) +
-	      host->sg_off);
+	sg_virt = tmio_mmc_kmap_atomic(host->sg_ptr, &flags);
+	buf = (unsigned short *)(sg_virt + host->sg_off);
 
 	count = host->sg_ptr->length - host->sg_off;
 	if (count > data->blksz)
@@ -191,7 +192,7 @@ static void tmio_mmc_pio_irq(struct tmio
 
 	host->sg_off += count;
 
-	tmio_mmc_kunmap_atomic(host, &flags);
+	tmio_mmc_kunmap_atomic(sg_virt, &flags);
 
 	if (host->sg_off == host->sg_ptr->length)
 		tmio_mmc_next_sg(host);
diff -puN drivers/mmc/host/tmio_mmc.h~mmc-fix-the-use-of-kunmap_atomic-in-tmio_mmch drivers/mmc/host/tmio_mmc.h
--- a/drivers/mmc/host/tmio_mmc.h~mmc-fix-the-use-of-kunmap_atomic-in-tmio_mmch
+++ a/drivers/mmc/host/tmio_mmc.h
@@ -174,19 +174,17 @@ static inline int tmio_mmc_next_sg(struc
 	return --host->sg_len;
 }
 
-static inline char *tmio_mmc_kmap_atomic(struct tmio_mmc_host *host,
+static inline char *tmio_mmc_kmap_atomic(struct scatterlist *sg,
 	unsigned long *flags)
 {
-	struct scatterlist *sg = host->sg_ptr;
