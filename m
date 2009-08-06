From: akpm@linux-foundation.org
Subject: - pcmcia-pccard-deadlock-fix.patch removed from -mm tree
Date: Thu, 06 Aug 2009 16:00:06 -0700
Message-ID: <200908062300.n76N06pB027958@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34951 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752717AbZHFXAO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 6 Aug 2009 19:00:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: markus.rechberger@amd.com, linux@dominikbrodowski.net, mm-commits@vger.kernel.org


The patch titled
     pcmcia/pccard deadlock fix
has been removed from the -mm tree.  Its filename was
     pcmcia-pccard-deadlock-fix.patch

This patch was dropped because I got tired of carrying it, sorry

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pcmcia/pccard deadlock fix
From: "Markus Rechberger" <markus.rechberger@amd.com>

Prevent a mutex/semaphore deadlock within the pcmcia framework when
ejecting devices multiple times using pccardctl eject.

For some more details see:
http://lkml.org/lkml/2007/2/19/58

Signed-off-by: Markus Rechberger <markus.rechberger@amd.com>
Cc: Dominik Brodowski <linux@dominikbrodowski.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pcmcia/cs.c |    3 ++-
 drivers/pcmcia/ds.c |    4 +++-
 2 files changed, 5 insertions(+), 2 deletions(-)

diff -puN drivers/pcmcia/cs.c~pcmcia-pccard-deadlock-fix drivers/pcmcia/cs.c
--- a/drivers/pcmcia/cs.c~pcmcia-pccard-deadlock-fix
+++ a/drivers/pcmcia/cs.c
@@ -861,7 +861,8 @@ int pcmcia_eject_card(struct pcmcia_sock
     
 	cs_dbg(skt, 1, "user eject request\n");
 
-	mutex_lock(&skt->skt_mutex);
+	if (!mutex_trylock(&skt->skt_mutex))
+		return -EAGAIN;
 	do {
 		if (!(skt->state & SOCKET_PRESENT)) {
 			ret = -ENODEV;
diff -puN drivers/pcmcia/ds.c~pcmcia-pccard-deadlock-fix drivers/pcmcia/ds.c
--- a/drivers/pcmcia/ds.c~pcmcia-pccard-deadlock-fix
+++ a/drivers/pcmcia/ds.c
@@ -1181,7 +1181,9 @@ static ssize_t pcmcia_store_allow_func_i
 	if (!count)
 		return -EINVAL;
 
-	mutex_lock(&p_dev->socket->skt_mutex);
+	if (!mutex_trylock(&p_dev->socket->skt_mutex))
+		return -EAGAIN;
+
 	p_dev->allow_func_id_match = 1;
 	mutex_unlock(&p_dev->socket->skt_mutex);
 
_

Patches currently in -mm which might be from markus.rechberger@amd.com are

linux-next.patch
pcmcia-pccard-deadlock-fix.patch

