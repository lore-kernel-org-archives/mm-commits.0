From: akpm@linux-foundation.org
Subject: - export-acpi_check_resource_conflict-fix.patch removed from -mm tree
Date: Fri, 09 Nov 2007 13:30:40 -0800
Message-ID: <200711092130.lA9LUe6f032703@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46243 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757644AbXKIVbZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 9 Nov 2007 16:31:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jdelvare@suse.de, bjorn.helgaas@hp.com, kamalesh@linux.vnet.ibm.com, khali@linux-fr.org, lenb@kernel.org, mhoffman@lightlink.com, mm-commits@vger.kernel.org


The patch titled
     export-acpi_check_resource_conflict-fix
has been removed from the -mm tree.  Its filename was
     export-acpi_check_resource_conflict-fix.patch

This patch was dropped because it was folded into export-acpi_check_res=
ource_conflict.patch

------------------------------------------------------
Subject: export-acpi_check_resource_conflict-fix
=46rom: Jean Delvare <jdelvare@suse.de>

Le mardi 06 novembre 2007, Kamalesh Babulal a =C3=A9crit=C2=A0:
> Hi Andrew,
>
> The kernel build fails, on powerpc while compiling the kernel with al=
lyesconfig option
>
> drivers/hwmon/w83627hf.c:1631: error: implicit declaration of functio=
n `acpi_check_resource_conflict'
> make[2]: *** [drivers/hwmon/w83627hf.o] Error 1
> make[1]: *** [drivers/hwmon] Error 2
> make: *** [drivers] Error 2
>   CC      fs/xfs/xfs_error.o
> drivers/hwmon/w83627hf.c:1631: error: implicit declaration of functio=
n `acpi_check_resource_conflict'
> make[2]: *** [drivers/hwmon/w83627hf.o] Error 1
> make[1]: *** [drivers/hwmon] Error 2
> make: *** [drivers] Error 2
> drivers/i2c/busses/i2c-ali1535.c:163: error: implicit declaration of =
function `acpi_check_region'
> make[3]: *** [drivers/i2c/busses/i2c-ali1535.o] Error 1
> make[2]: *** [drivers/i2c/busses] Error 2
> make[1]: *** [drivers/i2c] Error 2
> drivers/hwmon/dme1737.c:2231: error: implicit declaration of function=
 `acpi_check_resource_conflict'
> make[2]: *** [drivers/hwmon/dme1737.o] Error 1
> make[1]: *** [drivers/hwmon] Error 2
> make: *** [drivers] Error 2

Odd. Thanks for reporting.

> The patches check-for-acpi-resource-conflicts-in-hwmon-drivers and
> check-for-acpi-resource-conflicts-in-i2c-bus-drivers.patch, causes th=
is build failure.
> The declaration of the functions are under ifdef CONFIG_ACPI.

There's an #else after that, and the functions are defined as inlines
doing nothing in the non-ACPI case. The code looks OK to me, but I can
reproduce the problem on x86_64 with CONFIG_ACPI=3Dn.

Aha, I see it now, there are nested #ifdef CONFIG_ACPI in acpi.h,
so the inner one is a no-op (and its #else counterpart is never
evaluated.) That's pretty confusing, I'll send a patch fixing this.

In the meantime, here's a quick fix so that you can go on testing
the mm snapshot. Apply this at the top of the series:

=46ix the <linux/acpi.h> breakage for CONFIG_ACPI=3Dn.

Signed-off-by: Jean Delvare <jdelvare@suse.de>
Cc: "Mark M. Hoffman" <mhoffman@lightlink.com>
Cc: Jean Delvare <khali@linux-fr.org>
Cc: Len Brown <lenb@kernel.org>
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/acpi.h |   23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)

diff -puN include/linux/acpi.h~export-acpi_check_resource_conflict-fix =
include/linux/acpi.h
--- a/include/linux/acpi.h~export-acpi_check_resource_conflict-fix
+++ a/include/linux/acpi.h
@@ -26,6 +26,7 @@
 #define _LINUX_ACPI_H
=20
=20
+#include <linux/ioport.h>
 #ifdef	CONFIG_ACPI
=20
 #ifndef _LINUX
@@ -134,17 +135,6 @@ int acpi_check_mem_region(resource_size_
=20
 #define acpi_mp_config	0
=20
-static inline int acpi_check_resource_conflict(struct resource *res)
-{ return 0; }
-
-static inline int acpi_check_region(resource_size_t start, resource_si=
ze_t n,
-				    const char *name)
-{ return 0; }
-
-static inline int acpi_check_mem_region(resource_size_t start,
-					resource_size_t n, const char *name)
-{ return 0; }
-
 #endif 	/* !CONFIG_ACPI */
=20
 int acpi_register_gsi (u32 gsi, int triggering, int polarity);
@@ -239,5 +229,16 @@ static inline int acpi_boot_table_init(v
 	return 0;
 }
=20
+static inline int acpi_check_resource_conflict(struct resource *res)
+{ return 0; }
+
+static inline int acpi_check_region(resource_size_t start, resource_si=
ze_t n,
+				    const char *name)
+{ return 0; }
+
+static inline int acpi_check_mem_region(resource_size_t start,
+					resource_size_t n, const char *name)
+{ return 0; }
+
 #endif	/* CONFIG_ACPI */
 #endif	/*_LINUX_ACPI_H*/
_

Patches currently in -mm which might be from jdelvare@suse.de are

export-acpi_check_resource_conflict.patch
export-acpi_check_resource_conflict-fix.patch
check-for-acpi-resource-conflicts-in-i2c-bus-drivers.patch
check-for-acpi-resource-conflicts-in-hwmon-drivers.patch
