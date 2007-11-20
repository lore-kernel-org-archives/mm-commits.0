From: akpm@linux-foundation.org
Subject: + ipmi-add-the-standard-watchdog-timeout-ioctls.patch added to -mm tree
Date: Tue, 20 Nov 2007 12:14:46 -0800
Message-ID: <200711202014.lAKKEkmF021353@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43042 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757073AbXKTUPI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 20 Nov 2007 15:15:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: cminyard@mvista.com, guillon@thalescomputers.fr, wim@iguana.be


The patch titled
     ipmi: add the standard watchdog timeout ioctls
has been added to the -mm tree.  Its filename is
     ipmi-add-the-standard-watchdog-timeout-ioctls.patch

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to =
find
out what to do about this

------------------------------------------------------
Subject: ipmi: add the standard watchdog timeout ioctls
=46rom: Corey Minyard <cminyard@mvista.com>

Add the standard IOCTLs to the IPMI driver for setting and getting
the pretimeout.  Tested by Beno=EEt Guillon.

Signed off by: Corey Minyard <cminyard@mvista.com>
Cc: Beno=EEt Guillon <guillon@thalescomputers.fr>
Cc: Wim Van Sebroeck <wim@iguana.be>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/ipmi/ipmi_watchdog.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN drivers/char/ipmi/ipmi_watchdog.c~ipmi-add-the-standard-watch=
dog-timeout-ioctls drivers/char/ipmi/ipmi_watchdog.c
--- a/drivers/char/ipmi/ipmi_watchdog.c~ipmi-add-the-standard-watchdog-=
timeout-ioctls
+++ a/drivers/char/ipmi/ipmi_watchdog.c
@@ -669,6 +669,7 @@ static int ipmi_ioctl(struct inode *inod
 		return 0;
=20
 	case WDIOC_SET_PRETIMEOUT:
+	case WDIOC_SETPRETIMEOUT:
 		i =3D copy_from_user(&val, argp, sizeof(int));
 		if (i)
 			return -EFAULT;
@@ -676,6 +677,7 @@ static int ipmi_ioctl(struct inode *inod
 		return ipmi_set_timeout(IPMI_SET_TIMEOUT_HB_IF_NECESSARY);
=20
 	case WDIOC_GET_PRETIMEOUT:
+	case WDIOC_GETPRETIMEOUT:
 		i =3D copy_to_user(argp, &pretimeout, sizeof(pretimeout));
 		if (i)
 			return -EFAULT;
_

Patches currently in -mm which might be from cminyard@mvista.com are

ipmi-add-the-standard-watchdog-timeout-ioctls.patch
