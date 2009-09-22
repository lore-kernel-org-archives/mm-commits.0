From: akpm@linux-foundation.org
Subject: [merged] mm-kmem_cache_create-make-it-easier-to-catch-null-cache-names.patch removed from -mm tree
Date: Tue, 22 Sep 2009 13:40:34 -0700
Message-ID: <200909222040.n8MKeYto005840@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47649 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752610AbZIVUlG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 Sep 2009 16:41:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: benh@kernel.crashing.org, penberg@cs.helsinki.fi, mm-commits@vger.kernel.org


The patch titled
     mm: kmem_cache_create(): make it easier to catch NULL cache names
has been removed from the -mm tree.  Its filename was
     mm-kmem_cache_create-make-it-easier-to-catch-null-cache-names.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: kmem_cache_create(): make it easier to catch NULL cache names
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>

Right now, if you inadvertently pass NULL to kmem_cache_create() at boot
time, it crashes much later after boot somewhere deep inside sysfs which
makes it very non obvious to figure out what's going on.

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN mm/slub.c~mm-kmem_cache_create-make-it-easier-to-catch-null-cache-names mm/slub.c
--- a/mm/slub.c~mm-kmem_cache_create-make-it-easier-to-catch-null-cache-names
+++ a/mm/slub.c
@@ -3345,6 +3345,9 @@ struct kmem_cache *kmem_cache_create(con
 {
 	struct kmem_cache *s;
 
+	if (WARN_ON(!name))
+		return NULL;
+
 	down_write(&slub_lock);
 	s = find_mergeable(size, align, flags, name, ctor);
 	if (s) {
_

Patches currently in -mm which might be from benh@kernel.crashing.org are

origin.patch
linux-next.patch
powerpc-sky-cpu-redundant-or-incorrect-tests-on-unsigned.patch
powerpc-introduce-and-document-sdhciwp-inverted-property-for-esdhc.patch
powerpc-85xx-add-esdhc-support-for-mpc8536ds-boards.patch
kcore-use-usual-list-for-kclist.patch
kcore-add-kclist-types.patch
kcore-register-vmalloc-area-in-generic-way.patch
kcore-register-text-area-in-generic-way.patch
walk-system-ram-range.patch
walk-system-ram-range-fix.patch
kcore-use-registerd-physmem-information.patch
kcore-register-vmemmap-range.patch
kcore-register-vmemmap-range-fix.patch
kcore-register-module-area-in-generic-way.patch
spi-add-support-for-device-table-matching.patch
mtd-m25p80-convert-to-device-table-matching.patch
of-remove-stmm25p40-alias.patch
hwmon-adxx-convert-to-device-table-matching.patch
hwmon-lm70-convert-to-device-table-matching.patch
spi-prefix-modalias-with-spi.patch
platinumfb-misplaced-parenthesis.patch

