Return-Path: <SRS0=3wUv=CW=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A34BC433E2
	for <mm-commits@archiver.kernel.org>; Sun, 13 Sep 2020 00:00:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 18DFF21775
	for <mm-commits@archiver.kernel.org>; Sun, 13 Sep 2020 00:00:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1599955247;
	bh=9LCaYwcINaD0Jv+nIJKehIUVC9EVJThexrjgW8HYKjU=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=pFu448f/vN1wEBki1IQFzKCUbJlaRYY7SDlMQs7twf0zTqNYbQy657HRmQO9vIY+8
	 1hwexveHZ8QImoGql6R8hDZrUmHYiayEchKtz+m6fDM3lxulRbEoQt5/0+Pq5k1gQh
	 zKn+xMVzHM069GTFzKweIAW39ws2MG+gVBHHMvqk=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725908AbgIMAAq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 12 Sep 2020 20:00:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:57438 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725905AbgIMAAn (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 12 Sep 2020 20:00:43 -0400
Received: from X1 (unknown [209.33.215.130])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5E5D62087C;
        Sun, 13 Sep 2020 00:00:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599955242;
        bh=9LCaYwcINaD0Jv+nIJKehIUVC9EVJThexrjgW8HYKjU=;
        h=Date:From:To:Subject:From;
        b=bZY8RcAG9damxCbRO1gSSLrB9qLB9oOhkXMkBlc7eJSLAvIRJMPEAgFskv6kkYMwP
         +klKZ1oZ2GvA4hsS9vUz1HAwg350T67mC/570RBXlP8fW4CnBU92F+O8r0td1vckCz
         YzPV9BvLrVsgROaxZa8pl4GzFEIn5AfIzA5defCg=
Date:   Sat, 12 Sep 2020 17:00:40 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, wei.liu@kernel.org,
        vishal.l.verma@intel.com, tglx@linutronix.de,
        sthemmin@microsoft.com, sstabellini@kernel.org,
        roger.pau@citrix.com, rjw@rjwysocki.net,
        richardw.yang@linux.intel.com, paulus@samba.org,
        pankaj.gupta.linux@gmail.com, oohall@gmail.com,
        nathanl@linux.ibm.com, mst@redhat.com, mpe@ellerman.id.au,
        mhocko@suse.com, lpechacek@suse.cz, leobras.c@gmail.com,
        lenb@kernel.org, kys@microsoft.com, kernelfans@gmail.com,
        keescook@chromium.org, julien@xen.org, jgross@suse.com,
        jgg@ziepe.ca, jasowang@redhat.com, hca@linux.ibm.com,
        haiyangz@microsoft.com, gregkh@linuxfoundation.org,
        gor@linux.ibm.com, ebiederm@xmission.com, dave.jiang@intel.com,
        dan.j.williams@intel.com, borntraeger@de.ibm.com,
        boris.ostrovsky@oracle.com, bhe@redhat.com,
        benh@kernel.crashing.org, ardb@kernel.org, anton@ozlabs.org,
        david@redhat.com
Subject:  +
 kernel-resource-move-and-rename-ioresource_mem_driver_managed.patch added to
 -mm tree
Message-ID: <20200913000040.h08f0%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/resource: move and rename IORESOURCE_MEM_DRIVER_MANAGED
has been added to the -mm tree.  Its filename is
     kernel-resource-move-and-rename-ioresource_mem_driver_managed.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/kernel-resource-move-and-rena=
me-ioresource_mem_driver_managed.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/kernel-resource-move-and-rena=
me-ioresource_mem_driver_managed.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing=
 your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
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
@@ -520,7 +520,7 @@ static int locate_mem_hole_callback(stru
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
@@ -1160,7 +1160,7 @@ EXPORT_SYMBOL_GPL(add_memory);
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

mm-page_alloc-tweak-comments-in-has_unmovable_pages.patch
mm-page_isolation-exit-early-when-pageblock-is-isolated-in-set_migratetype_=
isolate.patch
mm-page_isolation-drop-warn_on_once-in-set_migratetype_isolate.patch
mm-page_isolation-cleanup-set_migratetype_isolate.patch
virtio-mem-dont-special-case-zone_movable.patch
mm-document-semantics-of-zone_movable.patch
mm-memory_hotplug-inline-__offline_pages-into-offline_pages.patch
mm-memory_hotplug-enforce-section-granularity-when-onlining-offlining.patch
mm-memory_hotplug-simplify-page-offlining.patch
mm-page_alloc-simplify-__offline_isolated_pages.patch
mm-memory_hotplug-drop-nr_isolate_pageblock-in-offline_pages.patch
mm-page_isolation-simplify-return-value-of-start_isolate_page_range.patch
mm-memory_hotplug-simplify-page-onlining.patch
mm-page_alloc-drop-stale-pageblock-comment-in-memmap_init_zone.patch
mm-pass-migratetype-into-memmap_init_zone-and-move_pfn_range_to_zone.patch
mm-memory_hotplug-mark-pageblocks-migrate_isolate-while-onlining-memory.pat=
ch
kernel-resource-make-release_mem_region_adjustable-never-fail.patch
kernel-resource-move-and-rename-ioresource_mem_driver_managed.patch
mm-memory_hotplug-guard-more-declarations-by-config_memory_hotplug.patch
mm-memory_hotplug-prepare-passing-flags-to-add_memory-and-friends.patch
mm-memory_hotplug-memhp_merge_resource-to-specify-merging-of-system-ram-res=
ources.patch
virtio-mem-try-to-merge-system-ram-resources.patch
xen-balloon-try-to-merge-system-ram-resources.patch
hv_balloon-try-to-merge-system-ram-resources.patch

