From: akpm@linux-foundation.org
Subject: + input-add-a-shutdown-method-to-pnp-drivers.patch added to -mm tree
Date: Tue, 11 Aug 2009 14:07:40 -0700
Message-ID: <200908112107.n7BL7eiI012530@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44510 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752815AbZHKVIU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 11 Aug 2009 17:08:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: david@hardeman.nu, bjorn.helgaas@hp.com, dtor@mail.ru


The patch titled
     input: add a shutdown method to pnp drivers
has been added to the -mm tree.  Its filename is
     input-add-a-shutdown-method-to-pnp-drivers.patch

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
Subject: input: add a shutdown method to pnp drivers
=46rom: David H=E4rdeman <david@hardeman.nu>

The shutdown method is used by the winbond cir driver to setup the
hardware for wake-from-S5.

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
Signed-off-by: David H=E4rdeman <david@hardeman.nu>
Cc: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pnp/driver.c |   10 ++++++++++
 include/linux/pnp.h  |    1 +
 2 files changed, 11 insertions(+)

diff -puN drivers/pnp/driver.c~input-add-a-shutdown-method-to-pnp-drive=
rs drivers/pnp/driver.c
--- a/drivers/pnp/driver.c~input-add-a-shutdown-method-to-pnp-drivers
+++ a/drivers/pnp/driver.c
@@ -135,6 +135,15 @@ static int pnp_device_remove(struct devi
 	return 0;
 }
=20
+static void pnp_device_shutdown(struct device *dev)
+{
+	struct pnp_dev *pnp_dev =3D to_pnp_dev(dev);
+	struct pnp_driver *drv =3D pnp_dev->driver;
+
+	if (drv && drv->shutdown)
+		drv->shutdown(pnp_dev);
+}
+
 static int pnp_bus_match(struct device *dev, struct device_driver *drv=
)
 {
 	struct pnp_dev *pnp_dev =3D to_pnp_dev(dev);
@@ -203,6 +212,7 @@ struct bus_type pnp_bus_type =3D {
 	.match   =3D pnp_bus_match,
 	.probe   =3D pnp_device_probe,
 	.remove  =3D pnp_device_remove,
+	.shutdown =3D pnp_device_shutdown,
 	.suspend =3D pnp_bus_suspend,
 	.resume  =3D pnp_bus_resume,
 	.dev_attrs =3D pnp_interface_attrs,
diff -puN include/linux/pnp.h~input-add-a-shutdown-method-to-pnp-driver=
s include/linux/pnp.h
--- a/include/linux/pnp.h~input-add-a-shutdown-method-to-pnp-drivers
+++ a/include/linux/pnp.h
@@ -360,6 +360,7 @@ struct pnp_driver {
 	unsigned int flags;
 	int (*probe) (struct pnp_dev *dev, const struct pnp_device_id *dev_id=
);
 	void (*remove) (struct pnp_dev *dev);
+	void (*shutdown) (struct pnp_dev *dev);
 	int (*suspend) (struct pnp_dev *dev, pm_message_t state);
 	int (*resume) (struct pnp_dev *dev);
 	struct device_driver driver;
_

Patches currently in -mm which might be from david@hardeman.nu are

acpi-reintroduce-acpi_device_ops-shutdown-method.patch
input-add-a-shutdown-method-to-pnp-drivers.patch
input-add-a-driver-for-the-winbond-wpcd376i-consumer-ir-hardware.patch
add-a-driver-for-the-winbond-wpcd376i-ir-functionality.patch
add-a-driver-for-the-winbond-wpcd376i-ir-functionality-select-bitrevers=
e.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
