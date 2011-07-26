From: akpm@linux-foundation.org
Subject: [merged] include-linux-ioporth-new-helper-to-define-common-struct-resource-constructs.patch removed from -mm tree
Date: Tue, 26 Jul 2011 00:55:03 -0700
Message-ID: <201107260754.p6Q7s6Kh003322@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46092 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752832Ab1GZHzK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Jul 2011 03:55:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: u.kleine-koenig@pengutronix.de, arnd@arndb.de, mm-commits@vger.kernel.org


The patch titled
     include/linux/ioport.h: new helper to define common struct resourc=
e constructs
has been removed from the -mm tree.  Its filename was
     include-linux-ioporth-new-helper-to-define-common-struct-resource-=
constructs.patch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: include/linux/ioport.h: new helper to define common struct res=
ource constructs
=46rom: Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.de>

Resource definitions that just define start, end and flags =3D
IORESOURCE_MEM or IORESOURCE_IRQ (with start=3Dend) are quite common.  =
So
introduce a shortcut for them.  For completeness add macros for
IORESOURCE_DMA and IORESOURCE_IO, too and also make available a set of
macros to specify named resources of all types which are less common.

Signed-off-by: Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.de>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/ioport.h |   30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff -puN include/linux/ioport.h~include-linux-ioporth-new-helper-to-de=
fine-common-struct-resource-constructs include/linux/ioport.h
--- a/include/linux/ioport.h~include-linux-ioporth-new-helper-to-define=
-common-struct-resource-constructs
+++ a/include/linux/ioport.h
@@ -109,6 +109,36 @@ struct resource_list {
 /* PCI control bits.  Shares IORESOURCE_BITS with above PCI ROM.  */
 #define IORESOURCE_PCI_FIXED		(1<<4)	/* Do not move resource */
=20
+
+/* helpers to define resources */
+#define DEFINE_RES_NAMED(_start, _size, _name, _flags)			\
+	{								\
+		.start =3D (_start),					\
+		.end =3D (_start) + (_size) - 1,				\
+		.name =3D (_name),					\
+		.flags =3D (_flags),					\
+	}
+
+#define DEFINE_RES_IO_NAMED(_start, _size, _name)			\
+	DEFINE_RES_NAMED((_start), (_size), (_name), IORESOURCE_IO)
+#define DEFINE_RES_IO(_start, _size)					\
+	DEFINE_RES_IO_NAMED((_start), (_size), NULL)
+
+#define DEFINE_RES_MEM_NAMED(_start, _size, _name)			\
+	DEFINE_RES_NAMED((_start), (_size), (_name), IORESOURCE_MEM)
+#define DEFINE_RES_MEM(_start, _size)					\
+	DEFINE_RES_MEM_NAMED((_start), (_size), NULL)
+
+#define DEFINE_RES_IRQ_NAMED(_irq, _name)				\
+	DEFINE_RES_NAMED((_irq), 1, (_name), IORESOURCE_IRQ)
+#define DEFINE_RES_IRQ(_irq)						\
+	DEFINE_RES_IRQ_NAMED((_irq), NULL)
+
+#define DEFINE_RES_DMA_NAMED(_dma, _name)				\
+	DEFINE_RES_NAMED((_dma), 1, (_name), IORESOURCE_DMA)
+#define DEFINE_RES_DMA(_dma)						\
+	DEFINE_RES_DMA_NAMED((_dma), NULL)
+
 /* PC/ISA/whatever - the normal PC address spaces: IO and memory */
 extern struct resource ioport_resource;
 extern struct resource iomem_resource;
_

Patches currently in -mm which might be from u.kleine-koenig@pengutroni=
x.de are

origin.patch
linux-next.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
