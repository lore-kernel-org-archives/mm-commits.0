Return-Path: <SRS0=3wUv=CW=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6A06C2D0E0
	for <mm-commits@archiver.kernel.org>; Sun, 13 Sep 2020 00:01:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 68E8F21789
	for <mm-commits@archiver.kernel.org>; Sun, 13 Sep 2020 00:01:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1599955282;
	bh=HqGYniZy/hn52RsuLw1eCxJAAxLj7OqFbPYJ+l11iuI=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=dZr55sQ2U5/aO/UKObYWQyA825BVGy9xytZgU647oQvmw0GGwrciceGJJHE6bD1bT
	 i8i0NKkWCfjno9+rUKOa6JX/semOhCvXBMmvF3MfGqAHisdBfrtc6R9CNYxeSAwxvy
	 MjEZ5qeFbGpPlX17dCahVPx/Yu69BNmWZ0YO9618=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725909AbgIMABV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 12 Sep 2020 20:01:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:57898 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725910AbgIMABA (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 12 Sep 2020 20:01:00 -0400
Received: from X1 (unknown [209.33.215.130])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0DADF21789;
        Sun, 13 Sep 2020 00:00:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599955259;
        bh=HqGYniZy/hn52RsuLw1eCxJAAxLj7OqFbPYJ+l11iuI=;
        h=Date:From:To:Subject:From;
        b=O6JEunsy1Z8U6aEGdtZyIOQRRDiKmB0QTvWR1/meuSWBr1HEKwyMZpvAEd6JoixAd
         sy+vB1ncEuXvsuohN0N2jGXinJIiJvZn8ezkh5leeMNyaD+x1wXYjz9zgHTrA1IO2J
         lfyQPB/0kygUsN7UX6W3GhvFEHqtqSGfxfBQ5was=
Date:   Sat, 12 Sep 2020 17:00:57 -0700
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
Subject:  + virtio-mem-try-to-merge-system-ram-resources.patch added
 to -mm tree
Message-ID: <20200913000057.bNoKg%akpm@linux-foundation.org>
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
     Subject: virtio-mem: try to merge system ram resources
has been added to the -mm tree.  Its filename is
     virtio-mem-try-to-merge-system-ram-resources.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/virtio-mem-try-to-merge-syste=
m-ram-resources.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/virtio-mem-try-to-merge-syste=
m-ram-resources.patch

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
Subject: virtio-mem: try to merge system ram resources

virtio-mem adds memory in memory block granularity, to be able to remove
it in the same granularity again later, and to grow slowly on demand.=20
This, however, results in quite a lot of resources when adding a lot of
memory.  Resources are effectively stored in a list-based tree.  Having a
lot of resources not only wastes memory, it also makes traversing that
tree more expensive, and makes /proc/iomem explode in size (e.g.,
requiring kexec-tools to manually merge resources later when e.g., trying
to create a kdump header).

Before this patch, we get (/proc/iomem) when hotplugging 2G via virtio-mem
on x86-64:
        [...]
        100000000-13fffffff : System RAM
        140000000-33fffffff : virtio0
          140000000-147ffffff : System RAM (virtio_mem)
          148000000-14fffffff : System RAM (virtio_mem)
          150000000-157ffffff : System RAM (virtio_mem)
          158000000-15fffffff : System RAM (virtio_mem)
          160000000-167ffffff : System RAM (virtio_mem)
          168000000-16fffffff : System RAM (virtio_mem)
          170000000-177ffffff : System RAM (virtio_mem)
          178000000-17fffffff : System RAM (virtio_mem)
          180000000-187ffffff : System RAM (virtio_mem)
          188000000-18fffffff : System RAM (virtio_mem)
          190000000-197ffffff : System RAM (virtio_mem)
          198000000-19fffffff : System RAM (virtio_mem)
          1a0000000-1a7ffffff : System RAM (virtio_mem)
          1a8000000-1afffffff : System RAM (virtio_mem)
          1b0000000-1b7ffffff : System RAM (virtio_mem)
          1b8000000-1bfffffff : System RAM (virtio_mem)
        3280000000-32ffffffff : PCI Bus 0000:00

With this patch, we get (/proc/iomem):
        [...]
        fffc0000-ffffffff : Reserved
        100000000-13fffffff : System RAM
        140000000-33fffffff : virtio0
          140000000-1bfffffff : System RAM (virtio_mem)
        3280000000-32ffffffff : PCI Bus 0000:00

Of course, with more hotplugged memory, it gets worse.  When unplugging
memory blocks again, try_remove_memory() (via offline_and_remove_memory())
will properly split the resource up again.

Link: https://lkml.kernel.org/r/20200911103459.10306-7-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Pankaj Gupta <pankaj.gupta.linux@gmail.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Michael S. Tsirkin <mst@redhat.com>
Cc: Jason Wang <jasowang@redhat.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Wei Yang <richardw.yang@linux.intel.com>
Cc: Anton Blanchard <anton@ozlabs.org>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: Eric Biederman <ebiederm@xmission.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Haiyang Zhang <haiyangz@microsoft.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Juergen Gross <jgross@suse.com>
Cc: Julien Grall <julien@xen.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: Len Brown <lenb@kernel.org>
Cc: Leonardo Bras <leobras.c@gmail.com>
Cc: Libor Pechacek <lpechacek@suse.cz>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nathan Lynch <nathanl@linux.ibm.com>
Cc: "Oliver O'Halloran" <oohall@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Pingfan Liu <kernelfans@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Roger Pau Monn=C3=A9 <roger.pau@citrix.com>
Cc: Stefano Stabellini <sstabellini@kernel.org>
Cc: Stephen Hemminger <sthemmin@microsoft.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Cc: Wei Liu <wei.liu@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/virtio/virtio_mem.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/virtio/virtio_mem.c~virtio-mem-try-to-merge-system-ram-resour=
ces
+++ a/drivers/virtio/virtio_mem.c
@@ -424,7 +424,8 @@ static int virtio_mem_mb_add(struct virt
=20
 	dev_dbg(&vm->vdev->dev, "adding memory block: %lu\n", mb_id);
 	return add_memory_driver_managed(nid, addr, memory_block_size_bytes(),
-					 vm->resource_name, MHP_NONE);
+					 vm->resource_name,
+					 MEMHP_MERGE_RESOURCE);
 }
=20
 /*
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

