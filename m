Return-Path: <SRS0=3wUv=CW=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D6DCC43461
	for <mm-commits@archiver.kernel.org>; Sun, 13 Sep 2020 00:00:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 56A0521775
	for <mm-commits@archiver.kernel.org>; Sun, 13 Sep 2020 00:00:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1599955248;
	bh=46PP9qEJ2GbBkyGEfhWDgradjxhhGvNRsyfYnkf9qds=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=GRB6qB5BlpeL8Cu8rvozHdgx7Pm1GfncNd0Lf2g97jXYo6gwEHy5BQQOQF96+xYD6
	 tXGoeZQ68Ea3LARyscZRsaFHdoHrClmh344ch27CxUfI+Ipkfero/bvbnalPV8TcyU
	 qWonuTyoA+gcXB3Q5D8uR0L/nL6TxC2Y/190pOfc=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725905AbgIMAAs (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 12 Sep 2020 20:00:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:57550 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725907AbgIMAAq (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 12 Sep 2020 20:00:46 -0400
Received: from X1 (unknown [209.33.215.130])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E53ED21531;
        Sun, 13 Sep 2020 00:00:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599955246;
        bh=46PP9qEJ2GbBkyGEfhWDgradjxhhGvNRsyfYnkf9qds=;
        h=Date:From:To:Subject:From;
        b=AiYGY6IoEsEoBxfOXz9HnJZQgswMVvsj0x9QTli0u6lcwWeZrwwC5seFl5cYFYVea
         tw/e7u9zKkBqCFgMuXJVjyOUvZ8Z11F984jEE/zCr2VX+SvbElSDgySBxdVJyBBlQB
         y0QHipWwbXNmPK0QU2nJQ5qyvui02oRi96LDC1TA=
Date:   Sat, 12 Sep 2020 17:00:44 -0700
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
 mm-memory_hotplug-guard-more-declarations-by-config_memory_hotplug.patch
 added to -mm tree
Message-ID: <20200913000044.e3GN_%akpm@linux-foundation.org>
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
     Subject: mm/memory_hotplug: guard more declarations by CONFIG_MEMORY_H=
OTPLUG
has been added to the -mm tree.  Its filename is
     mm-memory_hotplug-guard-more-declarations-by-config_memory_hotplug.pat=
ch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-memory_hotplug-guard-more-=
declarations-by-config_memory_hotplug.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-memory_hotplug-guard-more-=
declarations-by-config_memory_hotplug.patch

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
Subject: mm/memory_hotplug: guard more declarations by CONFIG_MEMORY_HOTPLUG

We soon want to pass flags via a new type to add_memory() and friends.=20
That revealed that we currently don't guard some declarations by
CONFIG_MEMORY_HOTPLUG.

While some definitions could be moved to different places, let's keep it
minimal for now and use CONFIG_MEMORY_HOTPLUG for all functions only
compiled with CONFIG_MEMORY_HOTPLUG.

Wrap sparse_decode_mem_map() into CONFIG_MEMORY_HOTPLUG, it's only called
from CONFIG_MEMORY_HOTPLUG code.

While at it, remove allow_online_pfn_range(), which is no longer around,
and mhp_notimplemented(), which is unused.

Link: https://lkml.kernel.org/r/20200911103459.10306-4-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Pankaj Gupta <pankaj.gupta.linux@gmail.com>
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
Cc: Jason Wang <jasowang@redhat.com>
Cc: Juergen Gross <jgross@suse.com>
Cc: Julien Grall <julien@xen.org>
Cc: Kees Cook <keescook@chromium.org>
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
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Cc: Wei Liu <wei.liu@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memory_hotplug.h |   12 +++---------
 mm/sparse.c                    |    2 ++
 2 files changed, 5 insertions(+), 9 deletions(-)

--- a/include/linux/memory_hotplug.h~mm-memory_hotplug-guard-more-declarati=
ons-by-config_memory_hotplug
+++ a/include/linux/memory_hotplug.h
@@ -247,13 +247,6 @@ static inline void zone_span_writelock(s
 static inline void zone_span_writeunlock(struct zone *zone) {}
 static inline void zone_seqlock_init(struct zone *zone) {}
=20
-static inline int mhp_notimplemented(const char *func)
-{
-	printk(KERN_WARNING "%s() called, with CONFIG_MEMORY_HOTPLUG disabled\n",=
 func);
-	dump_stack();
-	return -ENOSYS;
-}
-
 static inline void register_page_bootmem_info_node(struct pglist_data *pgd=
at)
 {
 }
@@ -344,6 +337,7 @@ static inline void __remove_memory(int n
 extern void set_zone_contiguous(struct zone *zone);
 extern void clear_zone_contiguous(struct zone *zone);
=20
+#ifdef CONFIG_MEMORY_HOTPLUG
 extern void __ref free_area_init_core_hotplug(int nid);
 extern int __add_memory(int nid, u64 start, u64 size);
 extern int add_memory(int nid, u64 start, u64 size);
@@ -364,8 +358,8 @@ extern void sparse_remove_section(struct
 		unsigned long map_offset, struct vmem_altmap *altmap);
 extern struct page *sparse_decode_mem_map(unsigned long coded_mem_map,
 					  unsigned long pnum);
-extern bool allow_online_pfn_range(int nid, unsigned long pfn, unsigned lo=
ng nr_pages,
-		int online_type);
 extern struct zone *zone_for_pfn_range(int online_type, int nid, unsigned =
start_pfn,
 		unsigned long nr_pages);
+#endif /* CONFIG_MEMORY_HOTPLUG */
+
 #endif /* __LINUX_MEMORY_HOTPLUG_H */
--- a/mm/sparse.c~mm-memory_hotplug-guard-more-declarations-by-config_memor=
y_hotplug
+++ a/mm/sparse.c
@@ -312,6 +312,7 @@ static unsigned long sparse_encode_mem_m
 	return coded_mem_map;
 }
=20
+#ifdef CONFIG_MEMORY_HOTPLUG
 /*
  * Decode mem_map from the coded memmap
  */
@@ -321,6 +322,7 @@ struct page *sparse_decode_mem_map(unsig
 	coded_mem_map &=3D SECTION_MAP_MASK;
 	return ((struct page *)coded_mem_map) + section_nr_to_pfn(pnum);
 }
+#endif /* CONFIG_MEMORY_HOTPLUG */
=20
 static void __meminit sparse_init_one_section(struct mem_section *ms,
 		unsigned long pnum, struct page *mem_map,
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

