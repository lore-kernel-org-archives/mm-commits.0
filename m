From: akpm@linux-foundation.org
Subject: + __initdata-is-not-an-identifier.patch added to -mm tree
Date: Thu, 14 Feb 2008 13:36:50 -0800
Message-ID: <200802142136.m1ELaob0004086@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37390 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752136AbYBNVhR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 14 Feb 2008 16:37:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: 12o3l@tiscali.nl, bjorn.helgaas@hp.com, lenb@kernel.org


The patch titled
     drivers/pnp/pnpacpi/core.c: __initdata is not an identifier
has been added to the -mm tree.  Its filename is
     __initdata-is-not-an-identifier.patch

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
Subject: drivers/pnp/pnpacpi/core.c: __initdata is not an identifier
From: Roel Kluin <12o3l@tiscali.nl>

sparse complains at drivers/pnp/pnpacpi/core.c:39 with the error: Trying to
use reserved word '__attribute__' as identifier Expected ) in function
declarator, got ".init.data"

and at drivers/pnp/pnpacpi/core.c:49:38 with the error:
undefined identifier 'excluded_id_list'

With the patch below these sparse complaints do not occur

Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pnp/pnpacpi/core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/pnp/pnpacpi/core.c~__initdata-is-not-an-identifier drivers/pnp/pnpacpi/core.c
--- a/drivers/pnp/pnpacpi/core.c~__initdata-is-not-an-identifier
+++ a/drivers/pnp/pnpacpi/core.c
@@ -36,7 +36,7 @@ static int num = 0;
  * have irqs (PIC, Timer) because we call acpi_register_gsi.
  * Finally, only devices that have a CRS method need to be in this list.
  */
-static struct __initdata acpi_device_id excluded_id_list[] = {
+static struct acpi_device_id excluded_id_list[] __initdata = {
 	{"PNP0C09", 0},		/* EC */
 	{"PNP0C0F", 0},		/* Link device */
 	{"PNP0000", 0},		/* PIC */
_

Patches currently in -mm which might be from 12o3l@tiscali.nl are

__initdata-is-not-an-identifier.patch
git-alsa.patch
git-cifs.patch
git-dvb.patch
ufs-e_add_cpu-conversion-in-return.patch
