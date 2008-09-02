From: akpm@linux-foundation.org
Subject: + dyn_array-use-%pf-instead-of-print_fn_descriptor_symbol.patch added to -mm tree
Date: Tue, 02 Sep 2008 15:59:30 -0700
Message-ID: <200809022259.m82MxUCi017219@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47423 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753224AbYIBW7u (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Sep 2008 18:59:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: yhlu.kernel@gmail.com, mingo@elte.hu


The patch titled
     dyn_array: use %pF instead of print_fn_descriptor_symbol
has been added to the -mm tree.  Its filename is
     dyn_array-use-%pf-instead-of-print_fn_descriptor_symbol.patch

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
Subject: dyn_array: use %pF instead of print_fn_descriptor_symbol
From: Yinghai Lu <yhlu.kernel@gmail.com>

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/dyn_array.c |   21 +++++++++------------
 1 file changed, 9 insertions(+), 12 deletions(-)

diff -puN init/dyn_array.c~dyn_array-use-%pf-instead-of-print_fn_descriptor_symbol init/dyn_array.c
--- a/init/dyn_array.c~dyn_array-use-%pf-instead-of-print_fn_descriptor_symbol
+++ a/init/dyn_array.c
@@ -17,10 +17,9 @@ void __init pre_alloc_dyn_array(void)
 	for (daa = __dyn_array_start ; daa < __dyn_array_end; daa++) {
 		struct dyn_array *da = *daa;
 
+		printk(KERN_DEBUG "dyn_array %pF size:%#lx nr:%d align:%#lx\n",
+			da->name, da->size, *da->nr, da->align);
 		size = da->size * (*da->nr);
-		print_fn_descriptor_symbol("dyn_array %s ", da->name);
-		printk(KERN_CONT "size:%#lx nr:%d align:%#lx\n",
-			da->size, *da->nr, da->align);
 		total_size += roundup(size, da->align);
 		if (da->align > max_align)
 			max_align = da->align;
@@ -42,11 +41,10 @@ void __init pre_alloc_dyn_array(void)
 		struct dyn_array *da = *daa;
 
 		size = da->size * (*da->nr);
-		print_fn_descriptor_symbol("dyn_array %s ", da->name);
-
 		phys = roundup(phys, da->align);
+		printk(KERN_DEBUG "dyn_array %pF ==> [%#lx - %#lx]\n",
+			da->name, phys, phys + size);
 		*da->name = phys_to_virt(phys);
-		printk(KERN_CONT " ==> [%#lx - %#lx]\n", phys, phys + size);
 
 		phys += size;
 
@@ -74,10 +72,9 @@ unsigned long __init per_cpu_dyn_array_s
 	for (daa = __per_cpu_dyn_array_start ; daa < __per_cpu_dyn_array_end; daa++) {
 		struct dyn_array *da = *daa;
 
+		printk(KERN_DEBUG "per_cpu_dyn_array %pF size:%#lx nr:%d align:%#lx\n",
+			da->name, da->size, *da->nr, da->align);
 		size = da->size * (*da->nr);
-		print_fn_descriptor_symbol("per_cpu_dyn_array %s ", da->name);
-		printk(KERN_CONT "size:%#lx nr:%d align:%#lx\n",
-			da->size, *da->nr, da->align);
 		total_size += roundup(size, da->align);
 		if (da->align > max_align)
 			max_align = da->align;
@@ -104,15 +101,15 @@ void __init per_cpu_alloc_dyn_array(int 
 		struct dyn_array *da = *daa;
 
 		size = da->size * (*da->nr);
-		print_fn_descriptor_symbol("per_cpu_dyn_array %s ", da->name);
