From: akpm@linux-foundation.org
Subject: [merged]
 zswap-update-docs-for-runtime-changeable-attributes.patch removed from -mm
 tree
Date: Fri, 11 Sep 2015 11:11:05 -0700
Message-ID: <55f31939.mAZPPsuS3Y2llP18%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53543 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750862AbbIKSLG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 11 Sep 2015 14:11:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ddstreet@ieee.org, sergey.senozhatsky.work@gmail.com, sjennings@variantweb.net, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: zswap: update docs for runtime-changeable attributes
has been removed from the -mm tree.  Its filename was
     zswap-update-docs-for-runtime-changeable-attributes.patch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

------------------------------------------------------
=46rom: Dan Streetman <ddstreet@ieee.org>
Subject: zswap: update docs for runtime-changeable attributes

Change the Documentation/vm/zswap.txt doc to indicate that the "zpool" =
and
"compressor" params are now changeable at runtime.

Signed-off-by: Dan Streetman <ddstreet@ieee.org>
Cc: Seth Jennings <sjennings@variantweb.net>
Cc: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/vm/zswap.txt |   36 +++++++++++++++++++++++++++--------
 1 file changed, 28 insertions(+), 8 deletions(-)

diff -puN Documentation/vm/zswap.txt~zswap-update-docs-for-runtime-chan=
geable-attributes Documentation/vm/zswap.txt
--- a/Documentation/vm/zswap.txt~zswap-update-docs-for-runtime-changeab=
le-attributes
+++ a/Documentation/vm/zswap.txt
@@ -32,7 +32,7 @@ can also be enabled and disabled at runt
 An example command to enable zswap at runtime, assuming sysfs is mount=
ed
 at /sys, is:
=20
-echo 1 > /sys/modules/zswap/parameters/enabled
+echo 1 > /sys/module/zswap/parameters/enabled
=20
 When zswap is disabled at runtime it will stop storing pages that are
 being swapped out.  However, it will _not_ immediately write out or fa=
ult
@@ -49,14 +49,26 @@ Zswap receives pages for compression thr
 evict pages from its own compressed pool on an LRU basis and write the=
m back to
 the backing swap device in the case that the compressed pool is full.
=20
-Zswap makes use of zbud for the managing the compressed memory pool.  =
Each
-allocation in zbud is not directly accessible by address.  Rather, a h=
andle is
+Zswap makes use of zpool for the managing the compressed memory pool. =
 Each
+allocation in zpool is not directly accessible by address.  Rather, a =
handle is
 returned by the allocation routine and that handle must be mapped befo=
re being
 accessed.  The compressed memory pool grows on demand and shrinks as c=
ompressed
-pages are freed.  The pool is not preallocated.
+pages are freed.  The pool is not preallocated.  By default, a zpool o=
f type
+zbud is created, but it can be selected at boot time by setting the "z=
pool"
+attribute, e.g. zswap.zpool=3Dzbud.  It can also be changed at runtime=
 using the
+sysfs "zpool" attribute, e.g.
+
+echo zbud > /sys/module/zswap/parameters/zpool
+
+The zbud type zpool allocates exactly 1 page to store 2 compressed pag=
es, which
+means the compression ratio will always be 2:1 or worse (because of ha=
lf-full
+zbud pages).  The zsmalloc type zpool has a more complex compressed pa=
ge
+storage method, and it can achieve greater storage densities.  However=
,
+zsmalloc does not implement compressed page eviction, so once zswap fi=
lls it
+cannot evict the oldest page, it can only reject new pages.
=20
 When a swap page is passed from frontswap to zswap, zswap maintains a =
mapping
-of the swap entry, a combination of the swap type and swap offset, to =
the zbud
+of the swap entry, a combination of the swap type and swap offset, to =
the zpool
 handle that references that compressed swap page.  This mapping is ach=
ieved
 with a red-black tree per swap type.  The swap offset is the search ke=
y for the
 tree nodes.
@@ -74,9 +86,17 @@ controlled policy:
 * max_pool_percent - The maximum percentage of memory that the compres=
sed
     pool can occupy.
=20
-Zswap allows the compressor to be selected at kernel boot time by sett=
ing the
-=E2=80=9Ccompressor=E2=80=9D attribute.  The default compressor is lzo=
=2E  e.g.
-zswap.compressor=3Ddeflate
+The default compressor is lzo, but it can be selected at boot time by =
setting
+the =E2=80=9Ccompressor=E2=80=9D attribute, e.g. zswap.compressor=3Dlz=
o.  It can also be changed
+at runtime using the sysfs "compressor" attribute, e.g.
+
+echo lzo > /sys/module/zswap/parameters/compressor
+
+When the zpool and/or compressor parameter is changed at runtime, any =
existing
+compressed pages are not modified; they are left in their own zpool.  =
When a
+request is made for a page in an old zpool, it is uncompressed using i=
ts
+original compressor.  Once all pages are removed from an old zpool, th=
e zpool
+and its compressor are freed.
=20
 A debugfs interface is provided for various statistic about pool size,=
 number
 of pages stored, and various counters for the reasons pages are reject=
ed.
_

Patches currently in -mm which might be from ddstreet@ieee.org are


--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
