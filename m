From: akpm@linux-foundation.org
Subject: + hotplug-memory-add-add_memory_resource.patch added to -mm tree
Date: Mon, 31 Mar 2008 14:33:32 -0700
Message-ID: <200803312133.m2VLXXND027074@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39076 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756101AbYCaVef (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 31 Mar 2008 17:34:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jeremy@goop.org, clameter@sgi.com, dave@linux.vnet.ibm.com, jeremy.fitzhardinge@citrix.com, kamezawa.hiroyu@jp.fujitsu.com, mingo@elte.hu, tglx@linutronix.de, y-goto@jp.fujitsu.com


The patch titled
     hotplug-memory: add add_memory_resource
has been added to the -mm tree.  Its filename is
     hotplug-memory-add-add_memory_resource.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hotplug-memory: add add_memory_resource
From: Jeremy Fitzhardinge <jeremy@goop.org>

The Xen balloon driver uses hotplug memory to extend the amount of
pseudo-physical memory available to a virtual domain.  Since this memory is
virtual, it can go anywhere within the kernel's pseudo-physical address space.

This patch adds a new hotplug memory call, add_memory_resource(), which adds
memory corresponding to a pre-constructed resource.  This allows callers to
use allocate_resource() to allocate a suitable chunk of address space for the
new memory (as well as cosmetic details, like a descriptive name).

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Yasunori Goto <y-goto@jp.fujitsu.com>
Cc: Christoph Lameter <clameter@sgi.com>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memory_hotplug.h |    3 +++
 mm/memory_hotplug.c            |   20 ++++++++++++++++----
 2 files changed, 19 insertions(+), 4 deletions(-)

diff -puN include/linux/memory_hotplug.h~hotplug-memory-add-add_memory_resource include/linux/memory_hotplug.h
--- a/include/linux/memory_hotplug.h~hotplug-memory-add-add_memory_resource
+++ a/include/linux/memory_hotplug.h
@@ -171,7 +171,10 @@ static inline int mhp_notimplemented(con
 
 #endif /* ! CONFIG_MEMORY_HOTPLUG */
 
+struct resource;
+
 extern int add_memory(int nid, u64 start, u64 size);
+extern int add_memory_resource(int nid, struct resource *res);
 extern int arch_add_memory(int nid, u64 start, u64 size);
 extern int remove_memory(u64 start, u64 size);
 extern int sparse_add_one_section(struct zone *zone, unsigned long start_pfn,
diff -puN mm/memory_hotplug.c~hotplug-memory-add-add_memory_resource mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~hotplug-memory-add-add_memory_resource
+++ a/mm/memory_hotplug.c
@@ -278,8 +278,6 @@ static void rollback_node_hotadd(int nid
 
 int add_memory(int nid, u64 start, u64 size)
 {
-	pg_data_t *pgdat = NULL;
-	int new_pgdat = 0;
 	struct resource *res;
 	int ret;
 
@@ -287,6 +285,22 @@ int add_memory(int nid, u64 start, u64 s
 	if (!res)
 		return -EEXIST;
 
+	ret = add_memory_resource(nid, res);
+
+	if (ret)
+		release_memory_resource(res);
+
+	return ret;
+}
+
+int add_memory_resource(int nid, struct resource *res)
+{
+	pg_data_t *pgdat = NULL;
+	int new_pgdat = 0;
+	int ret;
+	u64 start = res->start;
+	u64 size = res->end - res->start + 1;
+
 	if (!node_online(nid)) {
 		pgdat = hotadd_new_pgdat(nid, start);
 		if (!pgdat)
@@ -320,8 +334,6 @@ error:
 	/* rollback pgdat allocation and others */
 	if (new_pgdat)
 		rollback_node_hotadd(nid, pgdat);
-	if (res)
-		release_memory_resource(res);
 
 	return ret;
 }
_

Patches currently in -mm which might be from jeremy@goop.org are

origin.patch
git-x86.patch
sparsemem-vmemmap-does-not-need-section-bits.patch
kbuild-create-a-way-to-create-preprocessor-constants-from-c-expressions.patch
pageflags-use-an-enum-for-the-flags.patch
pageflags-get-rid-of-flags_reserved.patch
pageflags-introduce-macros-to-generate-page-flag-functions.patch
pageflags-convert-to-the-use-of-new-macros.patch
pageflags-use-proper-page-flag-functions-in-xen.patch
pageflags-eliminate-pg_xxx-aliases.patch
hotplug-memory-add-add_memory_resource.patch
hotplug-memory-adding-non-section-aligned-memory-is-bad.patch
sparsemem-reduce-i386-pae-section-size.patch
paravirt_ops-dont-steal-memory-resources-in-paravirt_disable_iospace.patch
xen-make-blkif_getgeo-static.patch

