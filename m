From: akpm@linux-foundation.org
Subject: - sparsemem-make-sparsemem_vmemmap-selectable.patch removed from -mm tree
Date: Thu, 20 Dec 2007 15:35:58 -0800
Message-ID: <200712202335.lBKNZwJh018763@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40152 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753849AbXLTXgh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 20 Dec 2007 18:36:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: geoffrey.levand@am.sony.com, apw@shadowen.org, clameter@sgi.com, mboton@gmail.com, y-goto@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     sparsemem: make SPARSEMEM_VMEMMAP selectable
has been removed from the -mm tree.  Its filename was
     sparsemem-make-sparsemem_vmemmap-selectable.patch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

------------------------------------------------------
Subject: sparsemem: make SPARSEMEM_VMEMMAP selectable
=46rom: Geoff Levand <geoffrey.levand@am.sony.com>

SPARSEMEM_VMEMMAP needs to be a selectable config option to support
building the kernel both with and without sparsemem vmemmap support.  T=
his
selection is desirable for platforms which could be configured one way =
for
platform specific builds and the other for multi-platform builds.

Signed-off-by: Miguel Bot=F3n <mboton@gmail.com>
Signed-off-by: Geoff Levand <geoffrey.levand@am.sony.com>
Acked-by: Yasunori Goto <y-goto@jp.fujitsu.com>
Cc: Christoph Lameter <clameter@sgi.com>
Cc: Andy Whitcroft <apw@shadowen.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/Kconfig |   15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff -puN mm/Kconfig~sparsemem-make-sparsemem_vmemmap-selectable mm/Kco=
nfig
--- a/mm/Kconfig~sparsemem-make-sparsemem_vmemmap-selectable
+++ a/mm/Kconfig
@@ -112,18 +112,17 @@ config SPARSEMEM_EXTREME
 	def_bool y
 	depends on SPARSEMEM && !SPARSEMEM_STATIC
=20
-#
-# SPARSEMEM_VMEMMAP uses a virtually mapped mem_map to optimise pfn_to=
_page
-# and page_to_pfn.  The most efficient option where kernel virtual spa=
ce is
-# not under pressure.
-#
 config SPARSEMEM_VMEMMAP_ENABLE
 	def_bool n
=20
 config SPARSEMEM_VMEMMAP
-	bool
-	depends on SPARSEMEM
-	default y if (SPARSEMEM_VMEMMAP_ENABLE)
+	bool "Sparse Memory virtual memmap"
+	depends on SPARSEMEM && SPARSEMEM_VMEMMAP_ENABLE
+	default y
+	help
+	 SPARSEMEM_VMEMMAP uses a virtually mapped memmap to optimise
+	 pfn_to_page and page_to_pfn operations.  This is the most
+	 efficient option when sufficient kernel resources are available.
=20
 # eventually, we can have this option just 'select SPARSEMEM'
 config MEMORY_HOTPLUG
_

Patches currently in -mm which might be from geoffrey.levand@am.sony.co=
m are

origin.patch
ps3-vuart-fix-error-path-locking.patch
git-powerpc.patch
git-kgdb.patch
