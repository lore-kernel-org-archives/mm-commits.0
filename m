Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0B7BC433E7
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 02:45:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5625320EDD
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 02:45:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602816336;
	bh=g6AhpKokmq74695JMXO8SZaTScLUPgaFiOlU0m4a6Ns=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=JzuP+tWthCpNaQXGTYuo6F2TwD2CXx2BaD56mPvZ5ZkMIQck1BXDoWP8v7eRwUSOZ
	 COpRT9n07pLDGl6mYP95KPMtZMbAy8/f6ceChq7tnEoXmQGkHkckX+k9SSVxvrhRrL
	 3tQydUAdoy6mbUov0dwsEmfgW0xdG/gpowskNVCs=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393841AbgJPCpg (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 15 Oct 2020 22:45:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:33050 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388337AbgJPCpf (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 15 Oct 2020 22:45:35 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 702482087D;
        Fri, 16 Oct 2020 02:45:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602816334;
        bh=g6AhpKokmq74695JMXO8SZaTScLUPgaFiOlU0m4a6Ns=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=ShUVzGC3S8MrUb4Zh5EeWSTxNZnrivQjCGVHEz2NPUqz5D91z7ti7qlOu6OpVMaBu
         WcpcLgrqn+nf/e5d5dX4VnbSs66DbIULIDi/9gkhLhBjxc8Fc6JyyJ1ey7oTig60XR
         UJo5rjA7sykGrNpkjg/EFgYaoFdZZkvyQ/g1ulCk=
Date:   Thu, 15 Oct 2020 19:45:31 -0700
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
        leobras.c@gmail.com, linux-mm@kvack.org, lpechacek@suse.cz,
        mhocko@suse.com, mm-commits@vger.kernel.org, mpe@ellerman.id.au,
        mst@redhat.com, nathanl@linux.ibm.com, oohall@gmail.com,
        pankaj.gupta.linux@gmail.com, paulus@samba.org,
        richardw.yang@linux.intel.com, rjw@rjwysocki.net,
        roger.pau@citrix.com, sstabellini@kernel.org,
        sthemmin@microsoft.com, tglx@linutronix.de,
        torvalds@linux-foundation.org, vishal.l.verma@intel.com,
        wei.liu@kernel.org
Subject:  [patch 071/156] mm/memory_hotplug: guard more
 declarations by CONFIG_MEMORY_HOTPLUG
Message-ID: <20201016024531.Dzz59QLFY%akpm@linux-foundation.org>
In-Reply-To: <20201015192732.f448da14e9854c7cb7299956@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

=46rom: David Hildenbrand <david@redhat.com>
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
