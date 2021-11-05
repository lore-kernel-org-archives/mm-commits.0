Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E269EC433EF
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:44:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CCD1861372
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:44:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233650AbhKEUrO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 5 Nov 2021 16:47:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:42218 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233734AbhKEUrM (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Nov 2021 16:47:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 294826135A;
        Fri,  5 Nov 2021 20:44:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636145072;
        bh=yAO+VlDBu97wORVA0p9i4rg/qgwwwfY8LfcvjMSRHBQ=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=vZK0XaJVV6GccvbzdFKCIicutoqxT2Czwkd3Fz2qBgGA7RiSaqu+QfWMq05UtQi72
         mBYdpZm0/9PEZRJ/nE2lYQN39k7FMX3VG1i0ddqXeOyLmrypmXfrMjnb94N9ywhHLh
         Gn0Ab/zuXL6Z6/SYkOHxVn5rUbgfRKHKeWLM1oIE=
Date:   Fri, 05 Nov 2021 13:44:31 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, alexs@kernel.org,
        benh@kernel.crashing.org, bp@alien8.de, corbet@lwn.net,
        dave.hansen@linux.intel.com, david@redhat.com,
        gregkh@linuxfoundation.org, hpa@zytor.com, jasowang@redhat.com,
        linux-mm@kvack.org, luto@kernel.org, mhocko@suse.com,
        mingo@redhat.com, mm-commits@vger.kernel.org, mpe@ellerman.id.au,
        mst@redhat.com, osalvador@suse.de, paulus@samba.org,
        peterz@infradead.org, rafael@kernel.org, rppt@kernel.org,
        shuah@kernel.org, tglx@linutronix.de, torvalds@linux-foundation.org
Subject:  [patch 189/262] mm/memory_hotplug: remove HIGHMEM
 leftovers
Message-ID: <20211105204431.s4Dse8GID%akpm@linux-foundation.org>
In-Reply-To: <20211105133408.cccbb98b71a77d5e8430aba1@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

=46rom: David Hildenbrand <david@redhat.com>
Subject: mm/memory_hotplug: remove HIGHMEM leftovers

We don't support CONFIG_MEMORY_HOTPLUG on 32 bit and consequently not
HIGHMEM.  Let's remove any leftover code -- including the unused
"status_change_nid_high" field part of the memory notifier.

Link: https://lkml.kernel.org/r/20210929143600.49379-5-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Cc: Alex Shi <alexs@kernel.org>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jason Wang <jasowang@redhat.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/core-api/memory-hotplug.rst                    |    3=20
 Documentation/translations/zh_CN/core-api/memory-hotplug.rst |    4 -
 include/linux/memory.h                                       |    1=20
 mm/memory_hotplug.c                                          |   36 ------=
----
 4 files changed, 2 insertions(+), 42 deletions(-)

--- a/Documentation/core-api/memory-hotplug.rst~mm-memory_hotplug-remove-hi=
ghmem-leftovers
+++ a/Documentation/core-api/memory-hotplug.rst
@@ -57,7 +57,6 @@ The third argument (arg) passes a pointe
 		unsigned long start_pfn;
 		unsigned long nr_pages;
 		int status_change_nid_normal;
-		int status_change_nid_high;
 		int status_change_nid;
 	}
=20
@@ -65,8 +64,6 @@ The third argument (arg) passes a pointe
 - nr_pages is # of pages of online/offline memory.
 - status_change_nid_normal is set node id when N_NORMAL_MEMORY of nodemask
   is (will be) set/clear, if this is -1, then nodemask status is not chang=
ed.
-- status_change_nid_high is set node id when N_HIGH_MEMORY of nodemask
-  is (will be) set/clear, if this is -1, then nodemask status is not chang=
ed.
 - status_change_nid is set node id when N_MEMORY of nodemask is (will be)
   set/clear. It means a new(memoryless) node gets new memory by online and=
 a
   node loses all memory. If this is -1, then nodemask status is not change=
d.
--- a/Documentation/translations/zh_CN/core-api/memory-hotplug.rst~mm-memor=
y_hotplug-remove-highmem-leftovers
+++ a/Documentation/translations/zh_CN/core-api/memory-hotplug.rst
@@ -63,7 +63,6 @@ memory_notify=E7=BB=93=E6=9E=84=E4=BD=93=E7=9A=84=E6=8C=
=87=E9=92=88::
 		unsigned long start_pfn;
 		unsigned long nr_pages;
 		int status_change_nid_normal;
-		int status_change_nid_high;
 		int status_change_nid;
 	}
=20
@@ -74,9 +73,6 @@ memory_notify=E7=BB=93=E6=9E=84=E4=BD=93=E7=9A=84=E6=8C=
=87=E9=92=88::
 - status_change_nid_normal=E6=98=AF=E5=BD=93nodemask=E7=9A=84N_NORMAL_MEMO=
RY=E8=A2=AB=E8=AE=BE=E7=BD=AE/=E6=B8=85=E9=99=A4=E6=97=B6=E8=AE=BE=E7=BD=AE=
=E8=8A=82
   =E7=82=B9id=EF=BC=8C=E5=A6=82=E6=9E=9C=E6=98=AF-1=EF=BC=8C=E5=88=99nodem=
ask=E7=8A=B6=E6=80=81=E4=B8=8D=E6=94=B9=E5=8F=98=E3=80=82
=20
-- status_change_nid_high=E6=98=AF=E5=BD=93nodemask=E7=9A=84N_HIGH_MEMORY=
=E8=A2=AB=E8=AE=BE=E7=BD=AE/=E6=B8=85=E9=99=A4=E6=97=B6=E8=AE=BE=E7=BD=AE=
=E7=9A=84=E8=8A=82=E7=82=B9
-  id=EF=BC=8C=E5=A6=82=E6=9E=9C=E8=BF=99=E4=B8=AA=E5=80=BC=E4=B8=BA-1=EF=
=BC=8C=E9=82=A3=E4=B9=88nodemask=E7=8A=B6=E6=80=81=E4=B8=8D=E4=BC=9A=E6=94=
=B9=E5=8F=98=E3=80=82
-
 - status_change_nid=E6=98=AF=E5=BD=93nodemask=E7=9A=84N_MEMORY=E8=A2=AB=EF=
=BC=88=E5=B0=86=EF=BC=89=E8=AE=BE=E7=BD=AE/=E6=B8=85=E9=99=A4=E6=97=B6=E8=
=AE=BE=E7=BD=AE=E7=9A=84=E8=8A=82=E7=82=B9id=E3=80=82=E8=BF=99
   =E6=84=8F=E5=91=B3=E7=9D=80=E4=B8=80=E4=B8=AA=E6=96=B0=E7=9A=84=EF=BC=88=
=E6=B2=A1=E4=B8=8A=E7=BA=BF=E7=9A=84=EF=BC=89=E8=8A=82=E7=82=B9=E9=80=9A=E8=
=BF=87=E8=81=94=E6=9C=BA=E8=8E=B7=E5=BE=97=E6=96=B0=E7=9A=84=E5=86=85=E5=AD=
=98=EF=BC=8C=E8=80=8C=E4=B8=80=E4=B8=AA=E8=8A=82=E7=82=B9=E5=A4=B1=E5=8E=BB=
=E4=BA=86=E6=89=80=E6=9C=89=E7=9A=84=E5=86=85
   =E5=AD=98=E3=80=82=E5=A6=82=E6=9E=9C=E8=BF=99=E4=B8=AA=E5=80=BC=E4=B8=BA-=
1=EF=BC=8C=E9=82=A3=E4=B9=88nodemask=E7=9A=84=E7=8A=B6=E6=80=81=E5=B0=B1=E4=
=B8=8D=E4=BC=9A=E6=94=B9=E5=8F=98=E3=80=82
--- a/include/linux/memory.h~mm-memory_hotplug-remove-highmem-leftovers
+++ a/include/linux/memory.h
@@ -96,7 +96,6 @@ struct memory_notify {
 	unsigned long start_pfn;
 	unsigned long nr_pages;
 	int status_change_nid_normal;
-	int status_change_nid_high;
 	int status_change_nid;
 };
=20
--- a/mm/memory_hotplug.c~mm-memory_hotplug-remove-highmem-leftovers
+++ a/mm/memory_hotplug.c
@@ -21,7 +21,6 @@
 #include <linux/memory.h>
 #include <linux/memremap.h>
 #include <linux/memory_hotplug.h>
-#include <linux/highmem.h>
 #include <linux/vmalloc.h>
 #include <linux/ioport.h>
 #include <linux/delay.h>
@@ -585,10 +584,6 @@ void generic_online_page(struct page *pa
 	debug_pagealloc_map_pages(page, 1 << order);
 	__free_pages_core(page, order);
 	totalram_pages_add(1UL << order);
-#ifdef CONFIG_HIGHMEM
-	if (PageHighMem(page))
-		totalhigh_pages_add(1UL << order);
-#endif
 }
 EXPORT_SYMBOL_GPL(generic_online_page);
=20
@@ -625,16 +620,11 @@ static void node_states_check_changes_on
=20
 	arg->status_change_nid =3D NUMA_NO_NODE;
 	arg->status_change_nid_normal =3D NUMA_NO_NODE;
-	arg->status_change_nid_high =3D NUMA_NO_NODE;
=20
 	if (!node_state(nid, N_MEMORY))
 		arg->status_change_nid =3D nid;
 	if (zone_idx(zone) <=3D ZONE_NORMAL && !node_state(nid, N_NORMAL_MEMORY))
 		arg->status_change_nid_normal =3D nid;
-#ifdef CONFIG_HIGHMEM
-	if (zone_idx(zone) <=3D ZONE_HIGHMEM && !node_state(nid, N_HIGH_MEMORY))
-		arg->status_change_nid_high =3D nid;
-#endif
 }
=20
 static void node_states_set_node(int node, struct memory_notify *arg)
@@ -642,9 +632,6 @@ static void node_states_set_node(int nod
 	if (arg->status_change_nid_normal >=3D 0)
 		node_set_state(node, N_NORMAL_MEMORY);
=20
-	if (arg->status_change_nid_high >=3D 0)
-		node_set_state(node, N_HIGH_MEMORY);
-
 	if (arg->status_change_nid >=3D 0)
 		node_set_state(node, N_MEMORY);
 }
@@ -1801,7 +1788,6 @@ static void node_states_check_changes_of
=20
 	arg->status_change_nid =3D NUMA_NO_NODE;
 	arg->status_change_nid_normal =3D NUMA_NO_NODE;
-	arg->status_change_nid_high =3D NUMA_NO_NODE;
=20
 	/*
 	 * Check whether node_states[N_NORMAL_MEMORY] will be changed.
@@ -1816,24 +1802,9 @@ static void node_states_check_changes_of
 	if (zone_idx(zone) <=3D ZONE_NORMAL && nr_pages >=3D present_pages)
 		arg->status_change_nid_normal =3D zone_to_nid(zone);
=20
-#ifdef CONFIG_HIGHMEM
 	/*
-	 * node_states[N_HIGH_MEMORY] contains nodes which
-	 * have normal memory or high memory.
-	 * Here we add the present_pages belonging to ZONE_HIGHMEM.
-	 * If the zone is within the range of [0..ZONE_HIGHMEM), and
-	 * we determine that the zones in that range become empty,
-	 * we need to clear the node for N_HIGH_MEMORY.
-	 */
-	present_pages +=3D pgdat->node_zones[ZONE_HIGHMEM].present_pages;
-	if (zone_idx(zone) <=3D ZONE_HIGHMEM && nr_pages >=3D present_pages)
-		arg->status_change_nid_high =3D zone_to_nid(zone);
-#endif
-
-	/*
-	 * We have accounted the pages from [0..ZONE_NORMAL), and
-	 * in case of CONFIG_HIGHMEM the pages from ZONE_HIGHMEM
-	 * as well.
+	 * We have accounted the pages from [0..ZONE_NORMAL); ZONE_HIGHMEM
+	 * does not apply as we don't support 32bit.
 	 * Here we count the possible pages from ZONE_MOVABLE.
 	 * If after having accounted all the pages, we see that the nr_pages
 	 * to be offlined is over or equal to the accounted pages,
@@ -1851,9 +1822,6 @@ static void node_states_clear_node(int n
 	if (arg->status_change_nid_normal >=3D 0)
 		node_clear_state(node, N_NORMAL_MEMORY);
=20
-	if (arg->status_change_nid_high >=3D 0)
-		node_clear_state(node, N_HIGH_MEMORY);
-
 	if (arg->status_change_nid >=3D 0)
 		node_clear_state(node, N_MEMORY);
 }
_
