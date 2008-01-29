From: akpm@linux-foundation.org
Subject: - intel-agp-enable-i915-recognition.patch removed from -mm tree
Date: Mon, 28 Jan 2008 17:48:32 -0800
Message-ID: <200801290148.m0T1mW00027359@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46580 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754513AbYA2B6q (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Jan 2008 20:58:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: david@dgreaves.com, airlied@linux.ie, mm-commits@vger.kernel.org


The patch titled
     intel-agp: enable i915 recognition
has been removed from the -mm tree.  Its filename was
     intel-agp-enable-i915-recognition.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: intel-agp: enable i915 recognition
From: David Greaves <david@dgreaves.com>

Taken from http://bugzilla.kernel.org/show_bug.cgi?id=6988.  Needs changelog
and signed-off-by and such.

Cc: Dave Airlie <airlied@linux.ie>

On Wed, 21 Nov 2007 23:12:55 +0000 (GMT)
Dave Airlie <airlied@linux.ie> wrote:

> On Wed, 21 Nov 2007, akpm@linux-foundation.org wrote:
> 
> > From: David Greaves <david@dgreaves.com>
> > 
> > Taken from http://bugzilla.kernel.org/show_bug.cgi?id=6988.  Needs changelog
> > and signed-off-by and such.
> > 
> 
> It doesn't work from what I can see on that bug.. the aperture is crap 
> from the bugzilla..
> 
> I've contacted Intel to see if they can help out..

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/agp/intel-agp.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN drivers/char/agp/intel-agp.c~intel-agp-enable-i915-recognition drivers/char/agp/intel-agp.c
--- a/drivers/char/agp/intel-agp.c~intel-agp-enable-i915-recognition
+++ a/drivers/char/agp/intel-agp.c
@@ -10,6 +10,7 @@
 #include <linux/agp_backend.h>
 #include "agp.h"
 
+#define PCI_DEVICE_ID_INTEL_7221_0          0x2588
 #define PCI_DEVICE_ID_INTEL_82946GZ_HB      0x2970
 #define PCI_DEVICE_ID_INTEL_82946GZ_IG      0x2972
 #define PCI_DEVICE_ID_INTEL_82965G_1_HB     0x2980
@@ -2050,6 +2051,7 @@ static const struct intel_driver_descrip
 		NULL, &intel_i965_driver },
 	{ PCI_DEVICE_ID_INTEL_82965GME_HB, PCI_DEVICE_ID_INTEL_82965GME_IG, 0, "965GME/GLE",
 		NULL, &intel_i965_driver },
+	{ PCI_DEVICE_ID_INTEL_7221_0, 0, 0, "E7221", &intel_7505_driver, NULL },
 	{ PCI_DEVICE_ID_INTEL_7505_0, 0, 0, "E7505", &intel_7505_driver, NULL },
 	{ PCI_DEVICE_ID_INTEL_7205_0, 0, 0, "E7205", &intel_7505_driver, NULL },
 	{ PCI_DEVICE_ID_INTEL_G33_HB, PCI_DEVICE_ID_INTEL_G33_IG, 0, "G33",
@@ -2405,6 +2407,7 @@ static struct pci_device_id agp_intel_pc
 	ID(PCI_DEVICE_ID_INTEL_82875_HB),
 	ID(PCI_DEVICE_ID_INTEL_7505_0),
 	ID(PCI_DEVICE_ID_INTEL_7205_0),
+	ID(PCI_DEVICE_ID_INTEL_7221_0),
 	ID(PCI_DEVICE_ID_INTEL_82915G_HB),
 	ID(PCI_DEVICE_ID_INTEL_82915GM_HB),
 	ID(PCI_DEVICE_ID_INTEL_82945G_HB),
_

Patches currently in -mm which might be from david@dgreaves.com are
