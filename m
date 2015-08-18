From: akpm@linux-foundation.org
Subject: + zswap-update-docs-for-runtime-changeable-attributes.patch added to -mm tree
Date: Tue, 18 Aug 2015 16:20:42 -0700
Message-ID: <55d3bdca.IpazDdcMW+3abEn2%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48795 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751153AbbHRXUn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Aug 2015 19:20:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ddstreet@ieee.org, sergey.senozhatsky.work@gmail.com, sjennings@variantweb.net, mm-commits@vger.kernel.org


The patch titled
     Subject: zswap: update docs for runtime-changeable attributes
has been added to the -mm tree.  Its filename is
     zswap-update-docs-for-runtime-changeable-attributes.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/zswap-update-docs-for-runt=
ime-changeable-attributes.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/zswap-update-docs-for-runt=
ime-changeable-attributes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
=46rom: Dan Streetman <ddstreet@ieee.org>
Subject: zswap: update docs for runtime-changeable attributes

Change the Documentation/vm/zswap.txt doc to indicate that the "zpool" =
and
"compressor" params are now changeable at runtime.

Signed-off-by: Dan Streetman <ddstreet@ieee.org>
Cc: Seth Jennings <sjennings@variantweb.net>
Cc: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/vm/zswap.txt |   31 +++++++++++++++++++++++--------
 1 file changed, 23 insertions(+), 8 deletions(-)

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
@@ -49,14 +49,27 @@ Zswap receives pages for compression thr
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
+means the compression ratio will always be exactly 2:1 (not including =
half-full
+zbud pages), and any page that compresses to more than 1/2 page in siz=
e will be
+rejected (and written to the swap disk).  The zsmalloc type zpool has =
a more
+complex compressed page storage method, and it can achieve greater sto=
rage
+densities.  However, zsmalloc does not implement compressed page evict=
ion, so
+once zswap fills it cannot evict the oldest page, it can only reject n=
ew pages.
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
@@ -74,9 +87,11 @@ controlled policy:
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
=20
 A debugfs interface is provided for various statistic about pool size,=
 number
 of pages stored, and various counters for the reasons pages are reject=
ed.
_

Patches currently in -mm which might be from ddstreet@ieee.org are

mm-zpool-constify-the-zpool_ops.patch
mm-zbud-constify-the-zbud_ops.patch
zpool-add-zpool_has_pool.patch
zpool-add-zpool_has_pool-fix.patch
zswap-dynamic-pool-creation.patch
zswap-dynamic-pool-creation-fix.patch
zswap-dynamic-pool-creation-fix-2.patch
zswap-change-zpool-compressor-at-runtime.patch
zswap-change-zpool-compressor-at-runtime-fix.patch
zswap-update-docs-for-runtime-changeable-attributes.patch
zpool-remove-no-op-module-init-exit.patch
linux-next.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
