From: akpm@linux-foundation.org
Subject: + slqbinfo-eliminate-warnings.patch added to -mm tree
Date: Mon, 11 May 2009 14:07:50 -0700
Message-ID: <200905112107.n4BL7ogt021808@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55630 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756002AbZEKVKS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 11 May 2009 17:10:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, nickpiggin@yahoo.com.au, penberg@cs.helsinki.fi


The patch titled
     slqbinfo: eliminate warnings
has been added to the -mm tree.  Its filename is
     slqbinfo-eliminate-warnings.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: slqbinfo: eliminate warnings
From: Randy Dunlap <randy.dunlap@oracle.com>

Documentation/vm/slqbinfo.c:386: warning: unused variable 'total'
Documentation/vm/slqbinfo.c:512: warning: format '%5d' expects type 'int', but argument 9 has type 'long unsigned int'
Documentation/vm/slqbinfo.c:520: warning: format '%4ld' expects type 'long int', but argument 9 has type 'int'
Documentation/vm/slqbinfo.c:646: warning: unused variable 'total_partial'
Documentation/vm/slqbinfo.c:646: warning: unused variable 'avg_partial'
Documentation/vm/slqbinfo.c:645: warning: unused variable 'max_partial'
Documentation/vm/slqbinfo.c:645: warning: unused variable 'min_partial'
Documentation/vm/slqbinfo.c:860: warning: unused variable 'count'
Documentation/vm/slqbinfo.c:858: warning: unused variable 'p'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/vm/slqbinfo.c |   11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

diff -puN Documentation/vm/slqbinfo.c~slqbinfo-eliminate-warnings Documentation/vm/slqbinfo.c
--- a/Documentation/vm/slqbinfo.c~slqbinfo-eliminate-warnings
+++ a/Documentation/vm/slqbinfo.c
@@ -383,7 +383,6 @@ void slab_stats(struct slabinfo *s)
 {
 	unsigned long total_alloc;
 	unsigned long total_free;
-	unsigned long total;
 
 	total_alloc = s->alloc;
 	total_free = s->free;
@@ -501,7 +500,7 @@ void slabcache(struct slabinfo *s)
 		total_alloc = s->alloc;
 		total_free = s->free;
 
-		printf("%-21s %8ld %10ld %10ld %5ld %5ld %7ld %5d %7ld %8d\n",
+		printf("%-21s %8ld %10ld %10ld %5ld %5ld %7ld %5ld %7ld %8d\n",
 			s->name, s->objects,
 			total_alloc, total_free,
 			total_alloc ? (s->alloc_slab_fill * 100 / total_alloc) : 0,
@@ -512,7 +511,7 @@ void slabcache(struct slabinfo *s)
 			s->order);
 	}
 	else
-		printf("%-21s %8ld %7d %8s %4d %1d %3ld %4ld %s\n",
+		printf("%-21s %8ld %7d %8s %4d %1d %3ld %4d %s\n",
 			s->name, s->objects, s->object_size, size_str,
 			s->objs_per_slab, s->order,
 			s->slabs ? (s->objects * s->object_size * 100) /
@@ -641,10 +640,6 @@ void totals(void)
 	/* Object size */
 	unsigned long long min_objsize = max, max_objsize = 0, avg_objsize;
 
-	/* Number of partial slabs in a slabcache */
-	unsigned long long min_partial = max, max_partial = 0,
-				avg_partial, total_partial = 0;
-
 	/* Number of slabs in a slab cache */
 	unsigned long long min_slabs = max, max_slabs = 0,
 				avg_slabs, total_slabs = 0;
@@ -855,9 +850,7 @@ void read_slab_dir(void)
 	DIR *dir;
 	struct dirent *de;
 	struct slabinfo *slab = slabinfo;
-	char *p;
 	char *t;
-	int count;
 
 	if (chdir("/sys/kernel/slab") && chdir("/sys/slab"))
 		fatal("SYSFS support for SLUB not active\n");
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
linux-next.patch
dm-table-fix-printk-formats.patch
input-drivers-input-xpadc-improve-xbox-360-wireless-support-and-add-sysfs-interface-fix.patch
input-drivers-input-xpadc-improve-xbox-360-wireless-support-and-add-sysfs-interface-add-missing-prototype-and-update-history.patch
menu-fix-embedded-menu-presentation.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
qla2x-fix-printk-format-warnings.patch
slqbinfo-eliminate-warnings.patch
lockd-fix-file_locking=n-build-error.patch
xen-use-header-for-export_symbol_gpl.patch
kmap_types-make-most-arches-use-generic-header-file.patch
irqs-add-irqf_sample_random-to-the-feature-removal-scheduletxt-deprecated-list.patch
cgroups-make-messages-more-readable.patch
linuxpps-core-support.patch
reiser4-export-remove_from_page_cache-fix.patch

