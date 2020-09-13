Return-Path: <SRS0=3wUv=CW=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2EEE2C43461
	for <mm-commits@archiver.kernel.org>; Sun, 13 Sep 2020 00:01:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D3DC421974
	for <mm-commits@archiver.kernel.org>; Sun, 13 Sep 2020 00:01:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1599955279;
	bh=OU4blTHzpEuoT/HOs4jWqMzP6HQmAjVzvL5angFzVJY=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=z5shhb5KO8EaJE1Ev91vGYzwgBlq2d1Gdwpmr7ifkc/cIFrlwmuY1XJnlfN0oGfJF
	 KogOsjD4ObYJ396jihZXixMJhRfvSeKiQoYYXQT+6dTi6Rmb0or88Mh5YG/LEc/wBf
	 rmeK98c8r8EJ1BdKm/KnpEUgG1ES8R/sU4uGpEAs=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725907AbgIMABS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 12 Sep 2020 20:01:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:57778 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725909AbgIMAA4 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 12 Sep 2020 20:00:56 -0400
Received: from X1 (unknown [209.33.215.130])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 485A121775;
        Sun, 13 Sep 2020 00:00:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599955255;
        bh=OU4blTHzpEuoT/HOs4jWqMzP6HQmAjVzvL5angFzVJY=;
        h=Date:From:To:Subject:From;
        b=QrcqJmomPXzlmyDxVioe47cZD9D9v68PR/l16uqK4ZtJzXVSG+OtwrIT+khQZu52s
         ONTaP1OEMZ2QCBBZSU6f5azxzp5SBKH/H3AVKpvgRsNeYU5SYYkzoDGYEzJnYQbDKV
         tBXhx46ARvRGANgJ7TJ3A9gsc5cYuTlF7cWw8Cxw=
Date:   Sat, 12 Sep 2020 17:00:53 -0700
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
 =?us-ascii?Q?mm-memory=5Fhotplug-memhp=5Fmerge=5Fresource-to-specify-m?=
 =?us-ascii?Q?erging-of-system-ram-resources.patch?= added to -mm tree
Message-ID: <20200913000053.lm58Q%akpm@linux-foundation.org>
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
     Subject: mm/memory_hotplug: MEMHP_MERGE_RESOURCE to specify merging of=
 System RAM resources
has been added to the -mm tree.  Its filename is
     mm-memory_hotplug-memhp_merge_resource-to-specify-merging-of-system-ra=
m-resources.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-memory_hotplug-memhp_merge=
_resource-to-specify-merging-of-system-ram-resources.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-memory_hotplug-memhp_merge=
_resource-to-specify-merging-of-system-ram-resources.patch

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
Subject: mm/memory_hotplug: MEMHP_MERGE_RESOURCE to specify merging of Syst=
em RAM resources

Some add_memory*() users add memory in small, contiguous memory blocks.=20
Examples include virtio-mem, hyper-v balloon, and the XEN balloon.

This can quickly result in a lot of memory resources, whereby the actual
resource boundaries are not of interest (e.g., it might be relevant for
DIMMs, exposed via /proc/iomem to user space).  We really want to merge
added resources in this scenario where possible.

Let's provide a flag (MEMHP_MERGE_RESOURCE) to specify that a resource
either created within add_memory*() or passed via add_memory_resource()
shall be marked mergeable and merged with applicable siblings.

To implement that, we need a kernel/resource interface to mark selected
System RAM resources mergeable (IORESOURCE_SYSRAM_MERGEABLE) and trigger
merging.

Note: We really want to merge after the whole operation succeeded, not
directly when adding a resource to the resource tree (it would break
add_memory_resource() and require splitting resources again when the
operation failed - e.g., due to -ENOMEM).

Link: https://lkml.kernel.org/r/20200911103459.10306-6-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Pankaj Gupta <pankaj.gupta.linux@gmail.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Kees Cook <keescook@chromium.org>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: Haiyang Zhang <haiyangz@microsoft.com>
Cc: Stephen Hemminger <sthemmin@microsoft.com>
Cc: Wei Liu <wei.liu@kernel.org>
Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: Juergen Gross <jgross@suse.com>
Cc: Stefano Stabellini <sstabellini@kernel.org>
Cc: Roger Pau Monn=C3=A9 <roger.pau@citrix.com>
Cc: Julien Grall <julien@xen.org>
Cc: Baoquan He <bhe@redhat.com>
Cc: Wei Yang <richardw.yang@linux.intel.com>
Cc: Anton Blanchard <anton@ozlabs.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: Eric Biederman <ebiederm@xmission.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Jason Wang <jasowang@redhat.com>
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
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/ioport.h         |    4 ++
 include/linux/memory_hotplug.h |    7 +++
 kernel/resource.c              |   60 +++++++++++++++++++++++++++++++
 mm/memory_hotplug.c            |    7 +++
 4 files changed, 78 insertions(+)

--- a/include/linux/ioport.h~mm-memory_hotplug-memhp_merge_resource-to-spec=
ify-merging-of-system-ram-resources
+++ a/include/linux/ioport.h
@@ -60,6 +60,7 @@ struct resource {
=20
 /* IORESOURCE_SYSRAM specific bits. */
 #define IORESOURCE_SYSRAM_DRIVER_MANAGED	0x02000000 /* Always detected via=
 a driver. */
+#define IORESOURCE_SYSRAM_MERGEABLE		0x04000000 /* Resource can be merged.=
 */
=20
 #define IORESOURCE_EXCLUSIVE	0x08000000	/* Userland may not map this resou=
rce */
=20
@@ -253,6 +254,9 @@ extern void __release_region(struct reso
 extern void release_mem_region_adjustable(struct resource *, resource_size=
_t,
 					  resource_size_t);
 #endif
+#ifdef CONFIG_MEMORY_HOTPLUG
+extern void merge_system_ram_resource(struct resource *res);
+#endif
=20
 /* Wrappers for managed devices */
 struct device;
--- a/include/linux/memory_hotplug.h~mm-memory_hotplug-memhp_merge_resource=
-to-specify-merging-of-system-ram-resources
+++ a/include/linux/memory_hotplug.h
@@ -62,6 +62,13 @@ typedef int __bitwise mhp_t;
=20
 /* No special request */
 #define MHP_NONE		((__force mhp_t)0)
+/*
+ * Allow merging of the added System RAM resource with adjacent,
+ * mergeable resources. After a successful call to add_memory_resource()
+ * with this flag set, the resource pointer must no longer be used as it
+ * might be stale, or the resource might have changed.
+ */
+#define MEMHP_MERGE_RESOURCE	((__force mhp_t)BIT(0))
=20
 /*
  * Extended parameters for memory hotplug:
--- a/kernel/resource.c~mm-memory_hotplug-memhp_merge_resource-to-specify-m=
erging-of-system-ram-resources
+++ a/kernel/resource.c
@@ -1363,6 +1363,66 @@ retry:
 }
 #endif	/* CONFIG_MEMORY_HOTREMOVE */
=20
+#ifdef CONFIG_MEMORY_HOTPLUG
+static bool system_ram_resources_mergeable(struct resource *r1,
+					   struct resource *r2)
+{
+	/* We assume either r1 or r2 is IORESOURCE_SYSRAM_MERGEABLE. */
+	return r1->flags =3D=3D r2->flags && r1->end + 1 =3D=3D r2->start &&
+	       r1->name =3D=3D r2->name && r1->desc =3D=3D r2->desc &&
+	       !r1->child && !r2->child;
+}
+
+/*
+ * merge_system_ram_resource - mark the System RAM resource mergeable and =
try to
+ * merge it with adjacent, mergeable resources
+ * @res: resource descriptor
+ *
+ * This interface is intended for memory hotplug, whereby lots of contiguo=
us
+ * system ram resources are added (e.g., via add_memory*()) by a driver, a=
nd
+ * the actual resource boundaries are not of interest (e.g., it might be
+ * relevant for DIMMs). Only resources that are marked mergeable, that hav=
e the
+ * same parent, and that don't have any children are considered. All merge=
able
+ * resources must be immutable during the request.
+ *
+ * Note:
+ * - The caller has to make sure that no pointers to resources that are
+ *   marked mergeable are used anymore after this call - the resource might
+ *   be freed and the pointer might be stale!
+ * - release_mem_region_adjustable() will split on demand on memory hotunp=
lug
+ */
+void merge_system_ram_resource(struct resource *res)
+{
+	const unsigned long flags =3D IORESOURCE_SYSTEM_RAM | IORESOURCE_BUSY;
+	struct resource *cur;
+
+	if (WARN_ON_ONCE((res->flags & flags) !=3D flags))
+		return;
+
+	write_lock(&resource_lock);
+	res->flags |=3D IORESOURCE_SYSRAM_MERGEABLE;
+
+	/* Try to merge with next item in the list. */
+	cur =3D res->sibling;
+	if (cur && system_ram_resources_mergeable(res, cur)) {
+		res->end =3D cur->end;
+		res->sibling =3D cur->sibling;
+		free_resource(cur);
+	}
+
+	/* Try to merge with previous item in the list. */
+	cur =3D res->parent->child;
+	while (cur && cur->sibling !=3D res)
+		cur =3D cur->sibling;
+	if (cur && system_ram_resources_mergeable(cur, res)) {
+		cur->end =3D res->end;
+		cur->sibling =3D res->sibling;
+		free_resource(res);
+	}
+	write_unlock(&resource_lock);
+}
+#endif	/* CONFIG_MEMORY_HOTPLUG */
+
 /*
  * Managed region resource
  */
--- a/mm/memory_hotplug.c~mm-memory_hotplug-memhp_merge_resource-to-specify=
-merging-of-system-ram-resources
+++ a/mm/memory_hotplug.c
@@ -1102,6 +1102,13 @@ int __ref add_memory_resource(int nid, s
 	/* device_online() will take the lock when calling online_pages() */
 	mem_hotplug_done();
=20
+	/*
+	 * In case we're allowed to merge the resource, flag it and trigger
+	 * merging now that adding succeeded.
+	 */
+	if (mhp_flags & MEMHP_MERGE_RESOURCE)
+		merge_system_ram_resource(res);
+
 	/* online pages if requested */
 	if (memhp_default_online_type !=3D MMOP_OFFLINE)
 		walk_memory_blocks(start, size, NULL, online_memory_block);
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

