From: akpm@linux-foundation.org
Subject: [folded] walk-system-ram-range-fix-2.patch removed from -mm tree
Date: Tue, 22 Sep 2009 14:45:25 -0700
Message-ID: <200909222145.n8MLjPtZ004542@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49195 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751614AbZIVVqY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 Sep 2009 17:46:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kamezawa.hiroyu@jp.fujitsu.com, akpm@linux-foundation.org, rientjes@google.com, rolandd@cisco.com, xiyou.wangcong@gmail.com, mm-commits@vger.kernel.org


The patch titled
     walk-system-ram-range fix 2
has been removed from the -mm tree.  Its filename was
     walk-system-ram-range-fix-2.patch

This patch was dropped because it was folded into walk-system-ram-range=
=2Epatch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: walk-system-ram-range fix 2
=46rom: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

On Thu, 17 Sep 2009 17:06:42 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> drivers/infiniband/hw/ehca/ehca_mrmw.c: In function 'ehca_create_busm=
ap':
> drivers/infiniband/hw/ehca/ehca_mrmw.c:2466: error: implicit declarat=
ion of function 'walk_memory_resource'
>
Ya, yes. reported by David Rientjes <rientjes@google.com>
I'm sorry for messes around this.

Thanks,
-Kame
=3D=3D
walk-system-ram-range.patch failes to catch recent change in
inifiniband. This is a fix.

Cc: Am=E9rico Wang <xiyou.wangcong@gmail.com>
Reported-by: David Rientjes <rientjes@google.com>
Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Roland Dreier <rolandd@cisco.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/infiniband/hw/ehca/ehca_mrmw.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/infiniband/hw/ehca/ehca_mrmw.c~walk-system-ram-range-=
fix-2 drivers/infiniband/hw/ehca/ehca_mrmw.c
--- a/drivers/infiniband/hw/ehca/ehca_mrmw.c~walk-system-ram-range-fix-=
2
+++ a/drivers/infiniband/hw/ehca/ehca_mrmw.c
@@ -2463,7 +2463,7 @@ int ehca_create_busmap(void)
 	int ret;
=20
 	ehca_mr_len =3D 0;
-	ret =3D walk_memory_resource(0, 1ULL << MAX_PHYSMEM_BITS, NULL,
+	ret =3D walk_system_ram_range(0, 1ULL << MAX_PHYSMEM_BITS, NULL,
 				   ehca_create_busmap_callback);
 	return ret;
 }
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu=
=2Ecom are

origin.patch
kcore-fix-proc-kcores-statst_size.patch
kcore-use-usual-list-for-kclist.patch
kcore-add-kclist-types.patch
kcore-register-vmalloc-area-in-generic-way.patch
kcore-register-text-area-in-generic-way.patch
walk-system-ram-range.patch
walk-system-ram-range-fix-2.patch
kcore-use-registerd-physmem-information.patch
kcore-use-registerd-physmem-information-ia64-fix.patch
kcore-register-vmemmap-range.patch
kcore-register-vmemmap-range-fix.patch
kcore-register-module-area-in-generic-way.patch
kcore-more-fixes-for-init.patch
proc-kcore-fix-statst_size.patch
proc-kcore-update-statst_size-after-memory-hotplug.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
