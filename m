From: akpm@linux-foundation.org
Subject: + ds2760_batteryc-fix-division-by-zero.patch added to -mm tree
Date: Mon, 09 Mar 2009 19:12:07 -0700
Message-ID: <200903100212.n2A2C7F6001522@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51213 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753816AbZCJCNY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Mar 2009 22:13:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: daniel@caiaq.de, cbou@mail.ru, dwmw2@infradead.org, mreimer@vpop.net, szabolcs.gyurko@tlt.hu


The patch titled
     ds2760_battery.c: fix division by zero
has been added to the -mm tree.  Its filename is
     ds2760_batteryc-fix-division-by-zero.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: ds2760_battery.c: fix division by zero
=46rom: Daniel Mack <daniel@caiaq.de>

The 'battery remaining capacity' calculation in
drivers/power/ds2760_battery.c lacks a parameter check to a division
operation which causes the kernel to oops on my board.

[   21.233750] Division by zero in kernel.
[   21.237646] [<c002955c>] (__div0+0x0/0x20) from [<c012561c>] (Ldiv0+=
0x8/0x10)
[   21.244816] [<c01bef34>] (ds2760_battery_read_status+0x0/0x2a4) from=
 [<c01bf3a4>] (ds2760_battery_get_property+0x30/0xdc)
[   21.255803]  r8:c03a22c0 r7:c7886100 r6:00000009 r5:c782fe7c r4:c788=
6084
[   21.262518] [<c01bf374>] (ds2760_battery_get_property+0x0/0xdc) from=
 [<c01bde98>] (power_supply_show_property+0x48/0x114)
[   21.273480]  r6:c7996000 r5:00000009 r4:00000000
[   21.278111] [<c01bde50>] (power_supply_show_property+0x0/0x114) from=
 [<c01be158>] (power_supply_uevent+0x188/0x280)
[   21.288537]  r8:00000001 r7:c7886100 r6:c7996000 r5:000000b4 r4:0000=
0000
[   21.295222] [<c01bdfd0>] (power_supply_uevent+0x0/0x280) from [<c015=
c664>] (dev_uevent+0xd4/0x10c)
[   21.304199] [<c015c590>] (dev_uevent+0x0/0x10c) from [<c0128440>] (k=
object_uevent_env+0x180/0x390)
[   21.313170]  r5:00000000 r4:c78860ac
[   21.316725] [<c01282c0>] (kobject_uevent_env+0x0/0x390) from [<c0128=
664>] (kobject_uevent+0x14/0x18)
[   21.325850] [<c0128650>] (kobject_uevent+0x0/0x18) from [<c01bdc34>]=
 (power_supply_changed_work+0x5c/0x70)
[   21.335506] [<c01bdbd8>] (power_supply_changed_work+0x0/0x70) from [=
<c004d290>] (run_workqueue+0xbc/0x144)
[   21.345167]  r4:c7812040
[   21.347716] [<c004d1d4>] (run_workqueue+0x0/0x144) from [<c004d94c>]=
 (worker_thread+0xa8/0xbc)
[   21.356296]  r7:c7812040 r6:c7820b00 r5:c782ffa4 r4:c7812048
[   21.361957] [<c004d8a4>] (worker_thread+0x0/0xbc) from [<c0051008>] =
(kthread+0x5c/0x94)
[   21.369971]  r7:00000000 r6:c004d8a4 r5:c7812040 r4:c782e000
[   21.375612] [<c0050fac>] (kthread+0x0/0x94) from [<c00403d0>] (do_ex=
it+0x0/0x688)

Signed-off-by: Daniel Mack <daniel@caiaq.de>
Cc: Szabolcs Gyurko <szabolcs.gyurko@tlt.hu>
Acked-by: Matt Reimer <mreimer@vpop.net>
Cc: Anton Vorontsov <cbou@mail.ru>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/power/ds2760_battery.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff -puN drivers/power/ds2760_battery.c~ds2760_batteryc-fix-division-b=
y-zero drivers/power/ds2760_battery.c
--- a/drivers/power/ds2760_battery.c~ds2760_batteryc-fix-division-by-ze=
ro
+++ a/drivers/power/ds2760_battery.c
@@ -180,10 +180,13 @@ static int ds2760_battery_read_status(st
 	di->empty_uAh =3D battery_interpolate(scale, di->temp_C / 10);
 	di->empty_uAh *=3D 1000; /* convert to =C2=B5Ah */
=20
-	/* From Maxim Application Note 131: remaining capacity =3D
-	 * ((ICA - Empty Value) / (Full Value - Empty Value)) x 100% */
-	di->rem_capacity =3D ((di->accum_current_uAh - di->empty_uAh) * 100L)=
 /
-			    (di->full_active_uAh - di->empty_uAh);
+	if (di->full_active_uAh =3D=3D di->empty_uAh)
+		di->rem_capacity =3D 0;
+	else
+		/* From Maxim Application Note 131: remaining capacity =3D
+		 * ((ICA - Empty Value) / (Full Value - Empty Value)) x 100% */
+		di->rem_capacity =3D ((di->accum_current_uAh - di->empty_uAh) * 100L=
) /
+				    (di->full_active_uAh - di->empty_uAh);
=20
 	if (di->rem_capacity < 0)
 		di->rem_capacity =3D 0;
_

Patches currently in -mm which might be from daniel@caiaq.de are

linux-next.patch
ds2760_batteryc-fix-division-by-zero.patch
w1-coding-style-cleanups-in-w1_ioc.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
