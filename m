Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3E67C433E7
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 20:52:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A4086216C4
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 20:52:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602881575;
	bh=/EAojn0p7RlvrKBCO4Z+0Kr4gm/tYDqUHCr3b9uKMZs=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=vBwsj7FayeXqZWI6ybG6op0PmloOBoqIBIx8SP/WYbqGZinFcmydfnACsWT/je6jC
	 CJE0P0kJj/SDSQs6H4DbG/6e5ZQOLtLEvxxQSo8D+NZyo1As+ika8ty3d9wWhlAAH4
	 qTsPaybRXEFIdzJFPda8L+IPg0PjGHRNjdfe1GJE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409066AbgJPUwz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 16 Oct 2020 16:52:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:39658 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392725AbgJPUu4 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 16 Oct 2020 16:50:56 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 52510216C4;
        Fri, 16 Oct 2020 20:50:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602881454;
        bh=/EAojn0p7RlvrKBCO4Z+0Kr4gm/tYDqUHCr3b9uKMZs=;
        h=Date:From:To:Subject:From;
        b=uXFm9/y4AALPTzV8haGArdlTvZDssZfO1x66+CJlNqOqd5hchvafRmbRj6WB2oqUD
         n7ZwnoX1XpcVS46j+UeztGlF8savkhy+7cZ0B80STX2PKSMdZycFwCudRrLM/a8QcJ
         uEk6Nvc0CPaoHUuPskr59W1pF1LQilCDwBhflWL8=
Date:   Fri, 16 Oct 2020 13:50:51 -0700
From:   akpm@linux-foundation.org
To:     anton@ozlabs.org, ardb@kernel.org, benh@kernel.crashing.org,
        bhe@redhat.com, boris.ostrovsky@oracle.com, borntraeger@de.ibm.com,
        dan.j.williams@intel.com, dave.jiang@intel.com, david@redhat.com,
        ebiederm@xmission.com, gor@linux.ibm.com,
        gregkh@linuxfoundation.org, haiyangz@microsoft.com,
        hca@linux.ibm.com, jasowang@redhat.com, jgg@ziepe.ca,
        jgross@suse.com, julien@xen.org, keescook@chromium.org,
        kernelfans@gmail.com, kys@microsoft.com, lenb@kernel.org,
        leobras.c@gmail.com, lpechacek@suse.cz, mhocko@suse.com,
        mm-commits@vger.kernel.org, mpe@ellerman.id.au, mst@redhat.com,
        nathanl@linux.ibm.com, oohall@gmail.com,
        pankaj.gupta.linux@gmail.com, paulus@samba.org,
        richardw.yang@linux.intel.com, rjw@rjwysocki.net,
        roger.pau@citrix.com, sstabellini@kernel.org,
        sthemmin@microsoft.com, tglx@linutronix.de,
        vishal.l.verma@intel.com, wei.liu@kernel.org
Subject:  [merged]
 kernel-resource-move-and-rename-ioresource_mem_driver_managed.patch removed
 from -mm tree
Message-ID: <20201016205051.-C2_qcHWc%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/resource: move and rename IORESOURCE_MEM_DRIVER_MANAGED
has been removed from the -mm tree.  Its filename was
     kernel-resource-move-and-rename-ioresource_mem_driver_managed.patch

This patch was dropped because it was merged into mainline or a subsystem t=
ree

------------------------------------------------------
=46rom: David Hildenbrand <david@redhat.com>
Subject: kernel/resource: move and rename IORESOURCE_MEM_DRIVER_MANAGED

IORESOURCE_MEM_DRIVER_MANAGED currently uses an unused PnP bit, which is
always set to 0 by hardware.  This is far from beautiful (and confusing),
and the bit only applies to SYSRAM.  So let's move it out of the
bus-specific (PnP) defined bits.

We'll add another SYSRAM specific bit soon.  If we ever need more bits for
other purposes, we can steal some from "desc", or reshuffle/regroup what
we have.

Link: https://lkml.kernel.org/r/20200911103459.10306-3-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Kees Cook <keescook@chromium.org>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: Pankaj Gupta <pankaj.gupta.linux@gmail.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Wei Yang <richardw.yang@linux.intel.com>
Cc: Eric Biederman <ebiederm@xmission.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Anton Blanchard <anton@ozlabs.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: Haiyang Zhang <haiyangz@microsoft.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Jason Wang <jasowang@redhat.com>
Cc: Juergen Gross <jgross@suse.com>
Cc: Julien Grall <julien@xen.org>
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: Len Brown <lenb@kernel.org>
Cc: Leonardo Bras <leobras.c@gmail.com>
Cc: Libor Pechacek <lpechacek@suse.cz>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Nathan Lynch <nathanl@linux.ibm.com>
Cc: "Oliver O'Halloran" <oohall@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Pingfan Liu <kernelfans@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Roger Pau Monn=C3=A9 <roger.pau@citrix.com>
Cc: Stefano Stabellini <sstabellini@kernel.org>
Cc: Stephen Hemminger <sthemmin@microsoft.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Cc: Wei Liu <wei.liu@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/ioport.h |    4 +++-
 kernel/kexec_file.c    |    2 +-
 mm/memory_hotplug.c    |    4 ++--
 3 files changed, 6 insertions(+), 4 deletions(-)

--- a/include/linux/ioport.h~kernel-resource-move-and-rename-ioresource_mem=
_driver_managed
+++ a/include/linux/ioport.h
@@ -58,6 +58,9 @@ struct resource {
 #define IORESOURCE_EXT_TYPE_BITS 0x01000000	/* Resource extended types */
 #define IORESOURCE_SYSRAM	0x01000000	/* System RAM (modifier) */
=20
+/* IORESOURCE_SYSRAM specific bits. */
+#define IORESOURCE_SYSRAM_DRIVER_MANAGED	0x02000000 /* Always detected via=
 a driver. */
+
 #define IORESOURCE_EXCLUSIVE	0x08000000	/* Userland may not map this resou=
rce */
=20
 #define IORESOURCE_DISABLED	0x10000000
@@ -103,7 +106,6 @@ struct resource {
 #define IORESOURCE_MEM_32BIT		(3<<3)
 #define IORESOURCE_MEM_SHADOWABLE	(1<<5)	/* dup: IORESOURCE_SHADOWABLE */
 #define IORESOURCE_MEM_EXPANSIONROM	(1<<6)
-#define IORESOURCE_MEM_DRIVER_MANAGED	(1<<7)
=20
 /* PnP I/O specific bits (IORESOURCE_BITS) */
 #define IORESOURCE_IO_16BIT_ADDR	(1<<0)
--- a/kernel/kexec_file.c~kernel-resource-move-and-rename-ioresource_mem_dr=
iver_managed
+++ a/kernel/kexec_file.c
@@ -521,7 +521,7 @@ static int locate_mem_hole_callback(stru
 	/* Returning 0 will take to next memory range */
=20
 	/* Don't use memory that will be detected and handled by a driver. */
-	if (res->flags & IORESOURCE_MEM_DRIVER_MANAGED)
+	if (res->flags & IORESOURCE_SYSRAM_DRIVER_MANAGED)
 		return 0;
=20
 	if (sz < kbuf->memsz)
--- a/mm/memory_hotplug.c~kernel-resource-move-and-rename-ioresource_mem_dr=
iver_managed
+++ a/mm/memory_hotplug.c
@@ -105,7 +105,7 @@ static struct resource *register_memory_
 	unsigned long flags =3D  IORESOURCE_SYSTEM_RAM | IORESOURCE_BUSY;
=20
 	if (strcmp(resource_name, "System RAM"))
-		flags |=3D IORESOURCE_MEM_DRIVER_MANAGED;
+		flags |=3D IORESOURCE_SYSRAM_DRIVER_MANAGED;
=20
 	/*
 	 * Make sure value parsed from 'mem=3D' only restricts memory adding
@@ -1161,7 +1161,7 @@ EXPORT_SYMBOL_GPL(add_memory);
  *
  * For this memory, no entries in /sys/firmware/memmap ("raw firmware-prov=
ided
  * memory map") are created. Also, the created memory resource is flagged
- * with IORESOURCE_MEM_DRIVER_MANAGED, so in-kernel users can special-case
+ * with IORESOURCE_SYSRAM_DRIVER_MANAGED, so in-kernel users can special-c=
ase
  * this memory as well (esp., not place kexec images onto it).
  *
  * The resource_name (visible via /proc/iomem) has to have the format
_

Patches currently in -mm which might be from david@redhat.com are


