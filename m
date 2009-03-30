From: akpm@linux-foundation.org
Subject: + dell-laptop-fix-uninitialized-wrong-return-value.patch added to -mm tree
Date: Mon, 30 Mar 2009 14:38:37 -0700
Message-ID: <200903302138.n2ULcbRX026579@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48521 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761831AbZC3VlK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Mar 2009 17:41:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ilpo.jarvinen@helsinki.fi, khali@linux-fr.org, len.brown@intel.com


The patch titled
     dell-laptop: fix uninitialized/wrong return value
has been added to the -mm tree.  Its filename is
     dell-laptop-fix-uninitialized-wrong-return-value.patch

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
Subject: dell-laptop: fix uninitialized/wrong return value
=46rom: Ilpo J=E4rvinen <ilpo.jarvinen@helsinki.fi>

Seriously, a helper would be much nicer here instead of all that copy
paste but I leave that as future work item.

Signed-off-by: Ilpo J=E4rvinen <ilpo.jarvinen@helsinki.fi>
Cc: Len Brown <len.brown@intel.com>
Cc: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/platform/x86/dell-laptop.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff -puN drivers/platform/x86/dell-laptop.c~dell-laptop-fix-uninitiali=
zed-wrong-return-value drivers/platform/x86/dell-laptop.c
--- a/drivers/platform/x86/dell-laptop.c~dell-laptop-fix-uninitialized-=
wrong-return-value
+++ a/drivers/platform/x86/dell-laptop.c
@@ -249,8 +249,10 @@ static int dell_setup_rfkill(void)
=20
 	if ((status & (1<<2|1<<8)) =3D=3D (1<<2|1<<8)) {
 		wifi_rfkill =3D rfkill_allocate(NULL, RFKILL_TYPE_WLAN);
-		if (!wifi_rfkill)
+		if (!wifi_rfkill) {
+			ret =3D -ENOMEM;
 			goto err_wifi;
+		}
 		wifi_rfkill->name =3D "dell-wifi";
 		wifi_rfkill->toggle_radio =3D dell_wifi_set;
 		wifi_rfkill->get_state =3D dell_wifi_get;
@@ -261,8 +263,10 @@ static int dell_setup_rfkill(void)
=20
 	if ((status & (1<<3|1<<9)) =3D=3D (1<<3|1<<9)) {
 		bluetooth_rfkill =3D rfkill_allocate(NULL, RFKILL_TYPE_BLUETOOTH);
-		if (!bluetooth_rfkill)
+		if (!bluetooth_rfkill) {
+			ret =3D -ENOMEM;
 			goto err_bluetooth;
+		}
 		bluetooth_rfkill->name =3D "dell-bluetooth";
 		bluetooth_rfkill->toggle_radio =3D dell_bluetooth_set;
 		bluetooth_rfkill->get_state =3D dell_bluetooth_get;
@@ -273,8 +277,10 @@ static int dell_setup_rfkill(void)
=20
 	if ((status & (1<<4|1<<10)) =3D=3D (1<<4|1<<10)) {
 		wwan_rfkill =3D rfkill_allocate(NULL, RFKILL_TYPE_WWAN);
-		if (!wwan_rfkill)
+		if (!wwan_rfkill) {
+			ret =3D -ENOMEM;
 			goto err_wwan;
+		}
 		wwan_rfkill->name =3D "dell-wwan";
 		wwan_rfkill->toggle_radio =3D dell_wwan_set;
 		wwan_rfkill->get_state =3D dell_wwan_get;
_

Patches currently in -mm which might be from ilpo.jarvinen@helsinki.fi =
are

origin.patch
dell-laptop-fix-uninitialized-wrong-return-value.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
