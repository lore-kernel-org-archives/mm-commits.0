From: akpm@linux-foundation.org
Subject: + net-hso-driver-uses-rfkill-functions.patch added to -mm tree
Date: Mon, 12 May 2008 15:02:13 -0700
Message-ID: <200805122202.m4CM2DJ3011385@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46265 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751197AbYELWDI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 May 2008 18:03:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, davem@davemloft.net, greg@kroah.com, jeff@garzik.org, paulius.zaleckas@teltonika.lt


The patch titled
     net: hso driver uses rfkill functions
has been added to the -mm tree.  Its filename is
     net-hso-driver-uses-rfkill-functions.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: net: hso driver uses rfkill functions
From: Randy Dunlap <randy.dunlap@oracle.com>

hso driver uses rfkill functions so should either depend on RFKILL
or select it.  This patch uses depends on RFKILL.

drivers/built-in.o: In function `hso_disconnect':
hso.c:(.text+0x868c9): undefined reference to `rfkill_unregister'
drivers/built-in.o: In function `hso_probe':
hso.c:(.text+0x88226): undefined reference to `rfkill_allocate'
hso.c:(.text+0x8829e): undefined reference to `rfkill_register'
hso.c:(.text+0x8860f): undefined reference to `rfkill_free'
make[1]: *** [.tmp_vmlinux1] Error 1

On Mon, 12 May 2008 11:29:20 +0300
Paulius Zaleckas <paulius.zaleckas@teltonika.lt> wrote:

> AFAIK Greg has (or he is going to do it) patch for rfkill so no more 
> depends or select RFKILL will be needed.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Paulius Zaleckas <paulius.zaleckas@teltonika.lt>
Cc: Greg KH <greg@kroah.com>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/usb/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/net/usb/Kconfig~net-hso-driver-uses-rfkill-functions drivers/net/usb/Kconfig
--- a/drivers/net/usb/Kconfig~net-hso-driver-uses-rfkill-functions
+++ a/drivers/net/usb/Kconfig
@@ -156,7 +156,7 @@ config USB_NET_AX8817X
 
 config USB_HSO
 	tristate "Option USB High Speed Mobile Devices"
-	depends on USB
+	depends on USB && RFKILL
 	default n
 	help
 	  Choose this option if you have an Option HSDPA/HSUPA card.
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

linux-next.patch
net-hso-driver-uses-rfkill-functions.patch
8390-split-8390-support-into-a-pausing-and-a-non-pausing-driver-core.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
git-unionfs.patch
documentation-build-source-files-in-documentation-sub-dir.patch
documentation-build-source-files-in-documentation-sub-dir-disable.patch
profile-likely-unlikely-macros.patch

