From: akpm@linux-foundation.org
Subject: + pcmcia-pccard-deadlock-fix.patch added to -mm tree
Date: Sun, 25 Feb 2007 04:52:37 -0800
Message-ID: <200702251252.l1PCqdOc029609@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:35421 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964872AbXBYMwu (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 25 Feb 2007 07:52:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: markus.rechberger@amd.com, linux@dominikbrodowski.net


The patch titled
     pcmcia/pccard deadlock fix
has been added to the -mm tree.  Its filename is
     pcmcia-pccard-deadlock-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -856,7 +856,8 @@ int pcmcia_eject_card(struct pcmcia_sock
     
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
@@ -1100,7 +1100,9 @@ static ssize_t pcmcia_store_allow_func_i
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

pcmcia-pccard-deadlock-fix.patch
kvm-vmx-hack-set_cr0_no_modeswitch-to-actually-do.patch
kvm-use-page_private-set_page_private-apis.patch
