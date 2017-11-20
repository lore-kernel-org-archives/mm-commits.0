From: akpm@linux-foundation.org
Subject: [merged] rapidio-idt_gen2-constify-rio_device_id.patch
 removed from -mm tree
Date: Mon, 20 Nov 2017 13:26:01 -0800
Message-ID: <20171120212601.MUKVbVEV1%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40800 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753116AbdKTV0C (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 20 Nov 2017 16:26:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alexandre.bounine@idt.com, arvind.yadav.cs@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rapidio: constify rio_device_id
has been removed from the -mm tree.  Its filename was
     rapidio-idt_gen2-constify-rio_device_id.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Arvind Yadav <arvind.yadav.cs@gmail.com>
Subject: rapidio: constify rio_device_id

rio_device_id are not supposed to change at runtime.  rio driver is
working with const 'id_table'.  So mark the non-const rio_device_id
structs as const.

Link: http://lkml.kernel.org/r/1503734627-6058-2-git-send-email-arvind.yadav.cs@gmail.com
Link: http://lkml.kernel.org/r/1503734627-6058-3-git-send-email-arvind.yadav.cs@gmail.com
Link: http://lkml.kernel.org/r/1503734627-6058-4-git-send-email-arvind.yadav.cs@gmail.com
Link: http://lkml.kernel.org/r/1503734627-6058-5-git-send-email-arvind.yadav.cs@gmail.com
Link: http://lkml.kernel.org/r/1503734627-6058-6-git-send-email-arvind.yadav.cs@gmail.com
Signed-off-by: Arvind Yadav <arvind.yadav.cs@gmail.com>
Acked-by: Alexandre Bounine <alexandre.bounine@idt.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rapidio/switches/idt_gen2.c |    2 +-
 drivers/rapidio/switches/idt_gen3.c |    2 +-
 drivers/rapidio/switches/idtcps.c   |    2 +-
 drivers/rapidio/switches/tsi568.c   |    2 +-
 drivers/rapidio/switches/tsi57x.c   |    2 +-
 5 files changed, 5 insertions(+), 5 deletions(-)

diff -puN drivers/rapidio/switches/idtcps.c~rapidio-idt_gen2-constify-rio_device_id drivers/rapidio/switches/idtcps.c
--- a/drivers/rapidio/switches/idtcps.c~rapidio-idt_gen2-constify-rio_device_id
+++ a/drivers/rapidio/switches/idtcps.c
@@ -168,7 +168,7 @@ static void idtcps_remove(struct rio_dev
 	spin_unlock(&rdev->rswitch->lock);
 }
 
-static struct rio_device_id idtcps_id_table[] = {
+static const struct rio_device_id idtcps_id_table[] = {
 	{RIO_DEVICE(RIO_DID_IDTCPS6Q, RIO_VID_IDT)},
 	{RIO_DEVICE(RIO_DID_IDTCPS8, RIO_VID_IDT)},
 	{RIO_DEVICE(RIO_DID_IDTCPS10Q, RIO_VID_IDT)},
diff -puN drivers/rapidio/switches/idt_gen2.c~rapidio-idt_gen2-constify-rio_device_id drivers/rapidio/switches/idt_gen2.c
--- a/drivers/rapidio/switches/idt_gen2.c~rapidio-idt_gen2-constify-rio_device_id
+++ a/drivers/rapidio/switches/idt_gen2.c
@@ -458,7 +458,7 @@ static void idtg2_remove(struct rio_dev
 	idtg2_sysfs(rdev, false);
 }
 
-static struct rio_device_id idtg2_id_table[] = {
+static const struct rio_device_id idtg2_id_table[] = {
 	{RIO_DEVICE(RIO_DID_IDTCPS1848, RIO_VID_IDT)},
 	{RIO_DEVICE(RIO_DID_IDTCPS1616, RIO_VID_IDT)},
 	{RIO_DEVICE(RIO_DID_IDTVPS1616, RIO_VID_IDT)},
diff -puN drivers/rapidio/switches/idt_gen3.c~rapidio-idt_gen2-constify-rio_device_id drivers/rapidio/switches/idt_gen3.c
--- a/drivers/rapidio/switches/idt_gen3.c~rapidio-idt_gen2-constify-rio_device_id
+++ a/drivers/rapidio/switches/idt_gen3.c
@@ -348,7 +348,7 @@ static void idtg3_shutdown(struct rio_de
 	}
 }
 
-static struct rio_device_id idtg3_id_table[] = {
+static const struct rio_device_id idtg3_id_table[] = {
 	{RIO_DEVICE(RIO_DID_IDTRXS1632, RIO_VID_IDT)},
 	{RIO_DEVICE(RIO_DID_IDTRXS2448, RIO_VID_IDT)},
 	{ 0, }	/* terminate list */
diff -puN drivers/rapidio/switches/tsi568.c~rapidio-idt_gen2-constify-rio_device_id drivers/rapidio/switches/tsi568.c
--- a/drivers/rapidio/switches/tsi568.c~rapidio-idt_gen2-constify-rio_device_id
+++ a/drivers/rapidio/switches/tsi568.c
@@ -169,7 +169,7 @@ static void tsi568_remove(struct rio_dev
 	spin_unlock(&rdev->rswitch->lock);
 }
 
-static struct rio_device_id tsi568_id_table[] = {
+static const struct rio_device_id tsi568_id_table[] = {
 	{RIO_DEVICE(RIO_DID_TSI568, RIO_VID_TUNDRA)},
 	{ 0, }	/* terminate list */
 };
diff -puN drivers/rapidio/switches/tsi57x.c~rapidio-idt_gen2-constify-rio_device_id drivers/rapidio/switches/tsi57x.c
--- a/drivers/rapidio/switches/tsi57x.c~rapidio-idt_gen2-constify-rio_device_id
+++ a/drivers/rapidio/switches/tsi57x.c
@@ -336,7 +336,7 @@ static void tsi57x_remove(struct rio_dev
 	spin_unlock(&rdev->rswitch->lock);
 }
 
-static struct rio_device_id tsi57x_id_table[] = {
+static const struct rio_device_id tsi57x_id_table[] = {
 	{RIO_DEVICE(RIO_DID_TSI572, RIO_VID_TUNDRA)},
 	{RIO_DEVICE(RIO_DID_TSI574, RIO_VID_TUNDRA)},
 	{RIO_DEVICE(RIO_DID_TSI577, RIO_VID_TUNDRA)},
_

Patches currently in -mm which might be from arvind.yadav.cs@gmail.com are


