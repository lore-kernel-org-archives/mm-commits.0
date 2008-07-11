From: akpm@linux-foundation.org
Subject: + pci-dynidsuse_driver_data-considered-harmful.patch added to -mm tree
Date: Fri, 11 Jul 2008 11:38:17 -0700
Message-ID: <200807111843.m6BIhw9M030831@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47701 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754836AbYGKSpI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 11 Jul 2008 14:45:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: miltonm@bga.com, James.Bottomley@SteelEye.com, brking@us.ibm.com, gregkh@suse.de, htejun@gmail.com, jbarnes@virtuousgeek.org, jeff@garzik.org, khali@linux-fr.org, michael@ellerman.id.au


The patch titled
     pci: dynids.use_driver_data considered harmful
has been added to the -mm tree.  Its filename is
     pci-dynidsuse_driver_data-considered-harmful.patch

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
Subject: pci: dynids.use_driver_data considered harmful
From: Milton Miller <miltonm@bga.com>

The driver flag dynids.use_driver_data is almost consistently not set, and
causes more problems than it solves.  The only use of this flag is to prevent
the system administrator from telling a pci driver additional data when adding
a dynamic match table entry via sysfs.

We do not as a policy protect the kernel from bad acts by root.

If we are worried about drivers doing the wrong thing due the match data, we
should be setting a taint flag, not attempting to cut off the admin.

[1] Searching the next-20080709 tree shows the bit is set by exactly 3 pci
drivers.  However, the use of per-match-entry driver data is much more
prevalent: A boot of allyesconfig on a powerpc64 pseries with a debug patch
shows 27 drivers apparently use the field for a pointer, 14 use it for
setting flags, and 98 use it as a table index.  (Pointers are defined as
>PAGE_OFFSET, aka in the 64 bit kernel linear mapping.  Flags are defined as
the maximum value exceeds the number of entries in the match table.  Any
other nonzero value is classified as an index).

This behavior actually caused me several hours of debug recently.

I was working working with a cxgb3 card on a 2.6.24 driver.  The card was not
recognized by the system, because the subsystem device id (owned by the
subsystem vendor, not the silicon manufacturer) did not match the driver
specified value of 1.  I inspected the driver expected to handle the card,
found the mismatch, and attempted to add a dynamic id through sysfs to get the
driver to match.  I inspected the existing table in the code and noted that
the driver needed to be told "this is card type 2" via the additional data,
and added the appropriate number of zeros to place a 2 in the driver data
column.  However, the kernel quickly oopsed and crashed due to a bad function
call address.  Great, now the kernel is crashed, what is wrong with the
driver.  After coming back and trying another card, I had to start tracing
manually trying to find where the driver went astray.  I was able to quickly
determine the bad address was a text string, but that did not help me find the
problem.  The call site was in the middle of a large init function, and it was
not obvious even with the listing which function pointer was corrupted.  While
I was looking for some data dependent overwrite, vpd formating or parsing
problem, or endian issue, it turned out not to be the case.  I eventually
determined the following sequence of events:

The driver took the driver data and performed a range check.  It then indexed
into a table, and (since it was given 0 when I specified 2), it incorrectly
determined the card had two ports instead of one.  It then copied the vpd into
an array, and indexed into the array based on a template of what it thought
the vpd would contain (as opposed to parsing the tags in the vpd with their
length fields).  The code then searched for descriptions of the phy on each
port.  It found port 0, indexed into another table and filled out its
pointers.  It then searched for the non-existent port 1, searching for a
non-zero value.  Because the card actually only had one port, it went off the
end of the array and found some random number in memory.  It then used that
random value as the type to index into its second array to fill out the
function pointers to be used for the second port.  It proceeded on, in the
same function after inlining, to iterate over the ports on the card to
initialize each port.  It calls the function for the first port, all goes
well.  It advances a pointer to point to the next port, calls the first
function, and oopses.

Of course, when debugging, one sees some function pointer is garbage.  But
which one?  (This was on PowerPC64, so the function pointer is a descriptor
pointer.  The pointer itself looks valid, but instead of pointing to a
descriptor with a code address and a constant pool, it points to random kernel
data.

Only after careful analysis of the driver data structure did I find it was
looking for more ports.  After all, I had told the driver to use slot two, and
only expected the card to have one port described in adapter info table>

While there is could certainly be more defensive coding in the driver (eg:
parse the vpd instead of relying on knowing the tag layout, only search until
the end of the vpd data, range check the port type before indexing into an
array), the whole session should have been avoided once I looked at the driver
and carefully set the driver data to entry 2, to match the other users of the
silicon.

Signed-off-by: Milton Miller <miltonm@bga.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Brian King <brking@us.ibm.com>
Cc: Jean Delvare <khali@linux-fr.org>
Cc: Tejun Heo <htejun@gmail.com>
Cc: Michael Ellerman <michael@ellerman.id.au>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/i2c/busses/i2c-amd756.c |    1 -
 drivers/i2c/busses/i2c-viapro.c |    1 -
 drivers/pci/pci-driver.c        |    3 +--
 drivers/scsi/ipr.c              |    1 -
 include/linux/pci.h             |    1 -
 5 files changed, 1 insertion(+), 6 deletions(-)

diff -puN drivers/i2c/busses/i2c-amd756.c~pci-dynidsuse_driver_data-considered-harmful drivers/i2c/busses/i2c-amd756.c
--- a/drivers/i2c/busses/i2c-amd756.c~pci-dynidsuse_driver_data-considered-harmful
+++ a/drivers/i2c/busses/i2c-amd756.c
@@ -412,7 +412,6 @@ static struct pci_driver amd756_driver =
 	.id_table	= amd756_ids,
 	.probe		= amd756_probe,
 	.remove		= __devexit_p(amd756_remove),
-	.dynids.use_driver_data = 1,
 };
 
 static int __init amd756_init(void)
diff -puN drivers/i2c/busses/i2c-viapro.c~pci-dynidsuse_driver_data-considered-harmful drivers/i2c/busses/i2c-viapro.c
--- a/drivers/i2c/busses/i2c-viapro.c~pci-dynidsuse_driver_data-considered-harmful
+++ a/drivers/i2c/busses/i2c-viapro.c
@@ -468,7 +468,6 @@ static struct pci_driver vt596_driver = 
 	.name		= "vt596_smbus",
 	.id_table	= vt596_ids,
 	.probe		= vt596_probe,
-	.dynids.use_driver_data = 1,
 };
 
 static int __init i2c_vt596_init(void)
diff -puN drivers/pci/pci-driver.c~pci-dynidsuse_driver_data-considered-harmful drivers/pci/pci-driver.c
--- a/drivers/pci/pci-driver.c~pci-dynidsuse_driver_data-considered-harmful
+++ a/drivers/pci/pci-driver.c
@@ -65,8 +65,7 @@ store_new_id(struct device_driver *drive
 	dynid->id.subdevice = subdevice;
 	dynid->id.class = class;
 	dynid->id.class_mask = class_mask;
-	dynid->id.driver_data = pdrv->dynids.use_driver_data ?
-		driver_data : 0UL;
+	dynid->id.driver_data = driver_data;
 
 	spin_lock(&pdrv->dynids.lock);
 	list_add_tail(&dynid->node, &pdrv->dynids.list);
diff -puN drivers/scsi/ipr.c~pci-dynidsuse_driver_data-considered-harmful drivers/scsi/ipr.c
--- a/drivers/scsi/ipr.c~pci-dynidsuse_driver_data-considered-harmful
+++ a/drivers/scsi/ipr.c
@@ -7854,7 +7854,6 @@ static struct pci_driver ipr_driver = {
 	.remove = ipr_remove,
 	.shutdown = ipr_shutdown,
 	.err_handler = &ipr_err_handler,
-	.dynids.use_driver_data = 1
 };
 
 /**
diff -puN include/linux/pci.h~pci-dynidsuse_driver_data-considered-harmful include/linux/pci.h
--- a/include/linux/pci.h~pci-dynidsuse_driver_data-considered-harmful
+++ a/include/linux/pci.h
@@ -339,7 +339,6 @@ struct pci_bus_region {
 struct pci_dynids {
 	spinlock_t lock;            /* protects list, index */
 	struct list_head list;      /* for IDs added at runtime */
-	unsigned int use_driver_data:1; /* pci_device_id->driver_data is used */
 };
 
 /* ---------------------------------------------------------------- */
_

Patches currently in -mm which might be from miltonm@bga.com are

alsa-correct-kcalloc-usage.patch
pci-dynidsuse_driver_data-considered-harmful.patch
kcalloc-remove-runtime-division.patch

