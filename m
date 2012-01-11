From: akpm@linux-foundation.org
Subject: [merged] bootmem-micro-optimize-freeing-pages-in-bulks.patch removed from -mm tree
Date: Wed, 11 Jan 2012 13:27:44 -0800
Message-ID: <20120111212745.0A2DB20004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:59956 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934048Ab2AKV1q (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Jan 2012 16:27:46 -0500
Received: by mail-ey0-f202.google.com with SMTP id d12so32537eaa.1
        for <mm-commits@vger.kernel.org>; Wed, 11 Jan 2012 13:27:45 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: u.kleine-koenig@pengutronix.de, hannes@saeurebad.de, mm-commits@vger.kernel.org


The patch titled
     Subject: bootmem: micro optimize freeing pages in bulk
has been removed from the -mm tree.  Its filename was
     bootmem-micro-optimize-freeing-pages-in-bulks.patch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
=46rom: Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.de>
Subject: bootmem: micro optimize freeing pages in bulk

The first entry of bdata->node_bootmem_map holds the data for
bdata->node_min_pfn up to bdata->node_min_pfn + BITS_PER_LONG - 1.  So =
the
test for freeing all pages of a single map entry can be slightly relaxe=
d.

Moreover use DIV_ROUND_UP in another place instead of open coding it.

Signed-off-by: Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.de>
Cc: Johannes Weiner <hannes@saeurebad.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/bootmem.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/bootmem.c~bootmem-micro-optimize-freeing-pages-in-bulks mm=
/bootmem.c
--- a/mm/bootmem.c~bootmem-micro-optimize-freeing-pages-in-bulks
+++ a/mm/bootmem.c
@@ -56,7 +56,7 @@ early_param("bootmem_debug", bootmem_deb
=20
 static unsigned long __init bootmap_bytes(unsigned long pages)
 {
-	unsigned long bytes =3D (pages + 7) / 8;
+	unsigned long bytes =3D DIV_ROUND_UP(pages, 8);
=20
 	return ALIGN(bytes, sizeof(long));
 }
@@ -197,7 +197,7 @@ static unsigned long __init free_all_boo
 		idx =3D start - bdata->node_min_pfn;
 		vec =3D ~map[idx / BITS_PER_LONG];
=20
-		if (aligned && vec =3D=3D ~0UL && start + BITS_PER_LONG < end) {
+		if (aligned && vec =3D=3D ~0UL && start + BITS_PER_LONG <=3D end) {
 			int order =3D ilog2(BITS_PER_LONG);
=20
 			__free_pages_bootmem(pfn_to_page(start), order);
_

Patches currently in -mm which might be from u.kleine-koenig@pengutroni=
x.de are

origin.patch
linux-next.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
