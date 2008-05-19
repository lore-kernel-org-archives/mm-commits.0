From: akpm@linux-foundation.org
Subject: + bonding-fix-oops-when-arp_interval-is-set-to-a-low-value.patch added to -mm tree
Date: Mon, 19 May 2008 14:17:55 -0700
Message-ID: <200805192117.m4JLHtHp021009@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57265 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750906AbYESVS6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 19 May 2008 17:18:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: nicolas.2p.debian@free.fr, davem@davemloft.net, fubar@us.ibm.com


The patch titled
     bonding: fix oops when arp_interval is set to a low value
has been added to the -mm tree.  Its filename is
     bonding-fix-oops-when-arp_interval-is-set-to-a-low-value.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to =
find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: bonding: fix oops when arp_interval is set to a low value
=46rom: Nicolas de Peslo=FCan <nicolas.2p.debian@free.fr>

When setting arp_interval parameter to a very low value, delta_in_ticks
for next arp might become 0, causing an infinite loop.

See http://bugzilla.kernel.org/show_bug.cgi?id=3D10680

Same problem for miimon parameter already fixed, but fix might be
enhanced, by using msecs_to_jiffies() function.

Signed-off-by: Nicolas de Peslo=FCan <nicolas.2p.debian@free.fr>
Cc: Jay Vosburgh <fubar@us.ibm.com>
Cc "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/bonding/bond_main.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/net/bonding/bond_main.c~bonding-fix-oops-when-arp_int=
erval-is-set-to-a-low-value drivers/net/bonding/bond_main.c
--- a/drivers/net/bonding/bond_main.c~bonding-fix-oops-when-arp_interva=
l-is-set-to-a-low-value
+++ a/drivers/net/bonding/bond_main.c
@@ -2398,7 +2398,7 @@ void bond_mii_monitor(struct work_struct
 		read_lock(&bond->lock);
 	}
=20
-	delay =3D ((bond->params.miimon * HZ) / 1000) ? : 1;
+	delay =3D msecs_to_jiffies(bond->params.miimon);
 	read_unlock(&bond->lock);
 	queue_delayed_work(bond->wq, &bond->mii_work, delay);
 }
@@ -2708,7 +2708,7 @@ void bond_loadbalance_arp_mon(struct wor
=20
 	read_lock(&bond->lock);
=20
-	delta_in_ticks =3D (bond->params.arp_interval * HZ) / 1000;
+	delta_in_ticks =3D msecs_to_jiffies(bond->params.arp_interval);
=20
 	if (bond->kill_timers) {
 		goto out;
@@ -2838,7 +2838,7 @@ void bond_activebackup_arp_mon(struct wo
=20
 	read_lock(&bond->lock);
=20
-	delta_in_ticks =3D (bond->params.arp_interval * HZ) / 1000;
+	delta_in_ticks =3D msecs_to_jiffies(bond->params.arp_interval * HZ);
=20
 	if (bond->kill_timers) {
 		goto out;
_

Patches currently in -mm which might be from nicolas.2p.debian@free.fr =
are

bonding-fix-oops-when-arp_interval-is-set-to-a-low-value.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
