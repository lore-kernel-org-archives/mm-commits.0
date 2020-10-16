Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04B78C43457
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 03:08:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9CEA620B1F
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 03:08:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602817734;
	bh=Qq92r1hjm7Dacn2JMjQ2jsWHVSccgT0Z9oJYyakD5AM=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=PWlq+wetKCcO6bsYhvvsLP+vgrMQQrXeU1ArdHMmDlzQqP1ye6jZNII+9fQ02PD2C
	 NjQTEYZAJiEJJiH8FrbJZV0OWfkSfyaMQfDpzaAoEj9RNDjyKu/7UtjT46fNGBGuLn
	 gagDbgImmDJzVsytn+ckahYTDJeD38V4haHSR/+s=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732457AbgJPDIy (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 15 Oct 2020 23:08:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:46458 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727382AbgJPDIy (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 15 Oct 2020 23:08:54 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6DB0720897;
        Fri, 16 Oct 2020 03:08:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602817732;
        bh=Qq92r1hjm7Dacn2JMjQ2jsWHVSccgT0Z9oJYyakD5AM=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=FGmMwMFAZVAZXJBLuqhcV80bF1euahTMbwh1P5T2g8XNfb5nbOyastsrv7lV/CI2V
         ln1grHUPdrLclIUvN6o7DsTdEsLhWxJH+svSygMAHHKGWd9vai4IUiNRZ8bInJJRFt
         U6hBkHXGTqbIcrjTGboa5Z0bs/EC8CwXGsMI/LnM=
Date:   Thu, 15 Oct 2020 20:08:49 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, anton@ozlabs.org, ardb@kernel.org,
        benh@kernel.crashing.org, bhe@redhat.com,
        boris.ostrovsky@oracle.com, borntraeger@de.ibm.com,
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
        torvalds@linux-foundation.org, vishal.l.verma@intel.com,
        wei.liu@kernel.org
Subject:  [patch 073/156] mm/memory_hotplug: MEMHP_MERGE_RESOURCE
 to specify merging of System RAM resources
Message-ID: <20201016030849.FV2gE3nmO%akpm@linux-foundation.org>
In-Reply-To: <20201015194043.84cda0c1d6ca2a6847f2384a@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

=46rom: David Hildenbrand <david@redhat.com>
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
@@ -1103,6 +1103,13 @@ int __ref add_memory_resource(int nid, s
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
