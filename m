From: akpm@linux-foundation.org
Subject: [merged] cris-fix-i-o-macros.patch removed from -mm tree
Date: Wed, 19 Dec 2012 12:39:19 -0800
Message-ID: <20121219203920.1BFE620004E__13657.8933721923$1355949586$gmane$org@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wi0-f201.google.com ([209.85.212.201]:32812 "EHLO
	mail-wi0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754858Ab2LSUjW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 19 Dec 2012 15:39:22 -0500
Received: by mail-wi0-f201.google.com with SMTP id hm2so133890wib.2
        for <mm-commits@vger.kernel.org>; Wed, 19 Dec 2012 12:39:21 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cminyard@mvista.com, geert@linux-m68k.org, jesper.nilsson@axis.com, stable@vger.kernel.org, starvik@axis.com, mm-commits@vger.kernel.org


The patch titled
     Subject: CRIS: fix I/O macros
has been removed from the -mm tree.  Its filename was
     cris-fix-i-o-macros.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Corey Minyard <cminyard@mvista.com>
Subject: CRIS: fix I/O macros

The inb/outb macros for CRIS are broken from a number of points of view,
missing () around parameters and they have an unprotected if statement in
them.  This was breaking the compile of IPMI on CRIS and thus I was being
annoyed by build regressions, so I fixed them.

Plus I don't think they would have worked at all, since the data values
were missing "&" and the outsl had a "3" instead of a "4" for the size. 
From what I can tell, this stuff is not used at all, so this can't be any
more broken than it was before, anyway.

Signed-off-by: Corey Minyard <cminyard@mvista.com>
Cc: Jesper Nilsson <jesper.nilsson@axis.com>
Cc: Mikael Starvik <starvik@axis.com>
Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/cris/include/asm/io.h |   39 +++++++++++++++++++++++++++++------
 1 file changed, 33 insertions(+), 6 deletions(-)

diff -puN arch/cris/include/asm/io.h~cris-fix-i-o-macros arch/cris/include/asm/io.h
--- a/arch/cris/include/asm/io.h~cris-fix-i-o-macros
+++ a/arch/cris/include/asm/io.h
@@ -133,12 +133,39 @@ static inline void writel(unsigned int b
 #define insb(port,addr,count) (cris_iops ? cris_iops->read_io(port,addr,1,count) : 0)
 #define insw(port,addr,count) (cris_iops ? cris_iops->read_io(port,addr,2,count) : 0)
 #define insl(port,addr,count) (cris_iops ? cris_iops->read_io(port,addr,4,count) : 0)
-#define outb(data,port) if (cris_iops) cris_iops->write_io(port,(void*)(unsigned)data,1,1)
-#define outw(data,port) if (cris_iops) cris_iops->write_io(port,(void*)(unsigned)data,2,1)
-#define outl(data,port) if (cris_iops) cris_iops->write_io(port,(void*)(unsigned)data,4,1)
-#define outsb(port,addr,count) if(cris_iops) cris_iops->write_io(port,(void*)addr,1,count)
-#define outsw(port,addr,count) if(cris_iops) cris_iops->write_io(port,(void*)addr,2,count)
-#define outsl(port,addr,count) if(cris_iops) cris_iops->write_io(port,(void*)addr,3,count)
+static inline void outb(unsigned char data, unsigned int port)
+{
+	if (cris_iops)
+		cris_iops->write_io(port, (void *) &data, 1, 1);
+}
+static inline void outw(unsigned short data, unsigned int port)
+{
+	if (cris_iops)
+		cris_iops->write_io(port, (void *) &data, 2, 1);
+}
+static inline void outl(unsigned int data, unsigned int port)
+{
+	if (cris_iops)
+		cris_iops->write_io(port, (void *) &data, 4, 1);
+}
+static inline void outsb(unsigned int port, const void *addr,
+			 unsigned long count)
+{
+	if (cris_iops)
+		cris_iops->write_io(port, (void *)addr, 1, count);
+}
+static inline void outsw(unsigned int port, const void *addr,
+			 unsigned long count)
+{
+	if (cris_iops)
+		cris_iops->write_io(port, (void *)addr, 2, count);
+}
+static inline void outsl(unsigned int port, const void *addr,
+			 unsigned long count)
+{
+	if (cris_iops)
+		cris_iops->write_io(port, (void *)addr, 4, count);
+}
 
 /*
  * Convert a physical pointer to a virtual kernel pointer for /dev/mem
_

Patches currently in -mm which might be from cminyard@mvista.com are

origin.patch

