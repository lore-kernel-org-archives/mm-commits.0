From: akpm@linux-foundation.org
Subject: [merged] mm-slubc-convert-printk-to-pr_foo.patch removed from -mm tree
Date: Thu, 05 Jun 2014 12:43:12 -0700
Message-ID: <5390c850.pO3VGGzbJ867Fwwf%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55662 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751708AbaFETnN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jun 2014 15:43:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, penberg@kernel.org, joe@perches.com, cl@linux.com, fabf@skynet.be

Subject: [merged] mm-slubc-convert-printk-to-pr_foo.patch removed from -mm tree
To: fabf@skynet.be,cl@linux.com,joe@perches.com,penberg@kernel.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 05 Jun 2014 12:43:12 -0700


The patch titled
     Subject: mm/slub.c: convert printk to pr_foo()
has been removed from the -mm tree.  Its filename was
     mm-slubc-convert-printk-to-pr_foo.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Fabian Frederick <fabf@skynet.be>
Subject: mm/slub.c: convert printk to pr_foo()

- All printk(KERN_foo converted to pr_foo()

- Default printk converted to pr_warn()

- Coalesce format fragments

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Acked-by: Christoph Lameter <cl@linux.com>
Cc: Joe Perches <joe@perches.com>
Cc: Pekka Enberg <penberg@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |  129 ++++++++++++++++++++++------------------------------
 1 file changed, 57 insertions(+), 72 deletions(-)

diff -puN mm/slub.c~mm-slubc-convert-printk-to-pr_foo mm/slub.c
--- a/mm/slub.c~mm-slubc-convert-printk-to-pr_foo
+++ a/mm/slub.c
@@ -403,7 +403,7 @@ static inline bool __cmpxchg_double_slab
 	stat(s, CMPXCHG_DOUBLE_FAIL);
 
 #ifdef SLUB_DEBUG_CMPXCHG
-	printk(KERN_INFO "%s %s: cmpxchg double redo ", n, s->name);
+	pr_info("%s %s: cmpxchg double redo ", n, s->name);
 #endif
 
 	return 0;
@@ -444,7 +444,7 @@ static inline bool cmpxchg_double_slab(s
 	stat(s, CMPXCHG_DOUBLE_FAIL);
 
 #ifdef SLUB_DEBUG_CMPXCHG
-	printk(KERN_INFO "%s %s: cmpxchg double redo ", n, s->name);
+	pr_info("%s %s: cmpxchg double redo ", n, s->name);
 #endif
 
 	return 0;
@@ -546,14 +546,14 @@ static void print_track(const char *s, s
 	if (!t->addr)
 		return;
 
-	printk(KERN_ERR "INFO: %s in %pS age=%lu cpu=%u pid=%d\n",
-		s, (void *)t->addr, jiffies - t->when, t->cpu, t->pid);
+	pr_err("INFO: %s in %pS age=%lu cpu=%u pid=%d\n",
+	       s, (void *)t->addr, jiffies - t->when, t->cpu, t->pid);
 #ifdef CONFIG_STACKTRACE
 	{
 		int i;
 		for (i = 0; i < TRACK_ADDRS_COUNT; i++)
 			if (t->addrs[i])
-				printk(KERN_ERR "\t%pS\n", (void *)t->addrs[i]);
+				pr_err("\t%pS\n", (void *)t->addrs[i]);
 			else
 				break;
 	}
@@ -571,8 +571,7 @@ static void print_tracking(struct kmem_c
 
 static void print_page_info(struct page *page)
 {
-	printk(KERN_ERR
-	       "INFO: Slab 0x%p objects=%u used=%u fp=0x%p flags=0x%04lx\n",
+	pr_err("INFO: Slab 0x%p objects=%u used=%u fp=0x%p flags=0x%04lx\n",
 	       page, page->objects, page->inuse, page->freelist, page->flags);
 
 }
@@ -585,11 +584,9 @@ static void slab_bug(struct kmem_cache *
 	va_start(args, fmt);
 	vsnprintf(buf, sizeof(buf), fmt, args);
 	va_end(args);
-	printk(KERN_ERR "========================================"
-			"=====================================\n");
-	printk(KERN_ERR "BUG %s (%s): %s\n", s->name, print_tainted(), buf);
-	printk(KERN_ERR "----------------------------------------"
-			"-------------------------------------\n\n");
+	pr_err("=============================================================================\n");
+	pr_err("BUG %s (%s): %s\n", s->name, print_tainted(), buf);
+	pr_err("-----------------------------------------------------------------------------\n\n");
 
 	add_taint(TAINT_BAD_PAGE, LOCKDEP_NOW_UNRELIABLE);
 }
@@ -602,7 +599,7 @@ static void slab_fix(struct kmem_cache *
 	va_start(args, fmt);
 	vsnprintf(buf, sizeof(buf), fmt, args);
 	va_end(args);
-	printk(KERN_ERR "FIX %s: %s\n", s->name, buf);
+	pr_err("FIX %s: %s\n", s->name, buf);
 }
 
 static void print_trailer(struct kmem_cache *s, struct page *page, u8 *p)
@@ -614,8 +611,8 @@ static void print_trailer(struct kmem_ca
 
 	print_page_info(page);
 
-	printk(KERN_ERR "INFO: Object 0x%p @offset=%tu fp=0x%p\n\n",
-			p, p - addr, get_freepointer(s, p));
+	pr_err("INFO: Object 0x%p @offset=%tu fp=0x%p\n\n",
+	       p, p - addr, get_freepointer(s, p));
 
 	if (p > addr + 16)
 		print_section("Bytes b4 ", p - 16, 16);
@@ -698,7 +695,7 @@ static int check_bytes_and_report(struct
 		end--;
 
 	slab_bug(s, "%s overwritten", what);
-	printk(KERN_ERR "INFO: 0x%p-0x%p. First byte 0x%x instead of 0x%x\n",
+	pr_err("INFO: 0x%p-0x%p. First byte 0x%x instead of 0x%x\n",
 					fault, end - 1, fault[0], value);
 	print_trailer(s, page, object);
 
@@ -931,7 +928,7 @@ static void trace(struct kmem_cache *s,
 								int alloc)
 {
 	if (s->flags & SLAB_TRACE) {
-		printk(KERN_INFO "TRACE %s %s 0x%p inuse=%d fp=0x%p\n",
+		pr_info("TRACE %s %s 0x%p inuse=%d fp=0x%p\n",
 			s->name,
 			alloc ? "alloc" : "free",
 			object, page->inuse,
@@ -1134,9 +1131,8 @@ static noinline struct kmem_cache_node *
 			slab_err(s, page, "Attempt to free object(0x%p) "
 				"outside of slab", object);
 		} else if (!page->slab_cache) {
-			printk(KERN_ERR
-				"SLUB <none>: no slab for object 0x%p.\n",
-						object);
+			pr_err("SLUB <none>: no slab for object 0x%p.\n",
+			       object);
 			dump_stack();
 		} else
 			object_err(s, page, object,
@@ -1219,8 +1215,8 @@ static int __init setup_slub_debug(char
 			slub_debug |= SLAB_FAILSLAB;
 			break;
 		default:
-			printk(KERN_ERR "slub_debug option '%c' "
-				"unknown. skipped\n", *str);
+			pr_err("slub_debug option '%c' unknown. skipped\n",
+			       *str);
 		}
 	}
 
@@ -1770,19 +1766,19 @@ static inline void note_cmpxchg_failure(
 #ifdef SLUB_DEBUG_CMPXCHG
 	unsigned long actual_tid = __this_cpu_read(s->cpu_slab->tid);
 
-	printk(KERN_INFO "%s %s: cmpxchg redo ", n, s->name);
+	pr_info("%s %s: cmpxchg redo ", n, s->name);
 
 #ifdef CONFIG_PREEMPT
 	if (tid_to_cpu(tid) != tid_to_cpu(actual_tid))
-		printk("due to cpu change %d -> %d\n",
+		pr_warn("due to cpu change %d -> %d\n",
 			tid_to_cpu(tid), tid_to_cpu(actual_tid));
 	else
 #endif
 	if (tid_to_event(tid) != tid_to_event(actual_tid))
-		printk("due to cpu running other code. Event %ld->%ld\n",
+		pr_warn("due to cpu running other code. Event %ld->%ld\n",
 			tid_to_event(tid), tid_to_event(actual_tid));
 	else
-		printk("for unknown reason: actual=%lx was=%lx target=%lx\n",
+		pr_warn("for unknown reason: actual=%lx was=%lx target=%lx\n",
 			actual_tid, tid, next_tid(tid));
 #endif
 	stat(s, CMPXCHG_DOUBLE_CPU_FAIL);
@@ -2154,16 +2150,15 @@ slab_out_of_memory(struct kmem_cache *s,
 {
 	int node;
 
-	printk(KERN_WARNING
-		"SLUB: Unable to allocate memory on node %d (gfp=0x%x)\n",
+	pr_warn("SLUB: Unable to allocate memory on node %d (gfp=0x%x)\n",
 		nid, gfpflags);
-	printk(KERN_WARNING "  cache: %s, object size: %d, buffer size: %d, "
-		"default order: %d, min order: %d\n", s->name, s->object_size,
-		s->size, oo_order(s->oo), oo_order(s->min));
+	pr_warn("  cache: %s, object size: %d, buffer size: %d, default order: %d, min order: %d\n",
+		s->name, s->object_size, s->size, oo_order(s->oo),
+		oo_order(s->min));
 
 	if (oo_order(s->min) > get_order(s->object_size))
-		printk(KERN_WARNING "  %s debugging increased min order, use "
-		       "slub_debug=O to disable.\n", s->name);
+		pr_warn("  %s debugging increased min order, use slub_debug=O to disable.\n",
+			s->name);
 
 	for_each_online_node(node) {
 		struct kmem_cache_node *n = get_node(s, node);
@@ -2178,8 +2173,7 @@ slab_out_of_memory(struct kmem_cache *s,
 		nr_slabs = node_nr_slabs(n);
 		nr_objs  = node_nr_objs(n);
 
-		printk(KERN_WARNING
-			"  node %d: slabs: %ld, objs: %ld, free: %ld\n",
+		pr_warn("  node %d: slabs: %ld, objs: %ld, free: %ld\n",
 			node, nr_slabs, nr_objs, nr_free);
 	}
 }
@@ -2894,10 +2888,8 @@ static void early_kmem_cache_node_alloc(
 
 	BUG_ON(!page);
 	if (page_to_nid(page) != node) {
-		printk(KERN_ERR "SLUB: Unable to allocate memory from "
-				"node %d\n", node);
-		printk(KERN_ERR "SLUB: Allocating a useless per node structure "
-				"in order to be able to continue\n");
+		pr_err("SLUB: Unable to allocate memory from node %d\n", node);
+		pr_err("SLUB: Allocating a useless per node structure in order to be able to continue\n");
 	}
 
 	n = page->freelist;
@@ -3182,8 +3174,7 @@ static void list_slab_objects(struct kme
 	for_each_object(p, s, addr, page->objects) {
 
 		if (!test_bit(slab_index(p, s, addr), map)) {
-			printk(KERN_ERR "INFO: Object 0x%p @offset=%tu\n",
-							p, p - addr);
+			pr_err("INFO: Object 0x%p @offset=%tu\n", p, p - addr);
 			print_tracking(s, p);
 		}
 	}
@@ -3650,9 +3641,7 @@ void __init kmem_cache_init(void)
 	register_cpu_notifier(&slab_notifier);
 #endif
 
-	printk(KERN_INFO
-		"SLUB: HWalign=%d, Order=%d-%d, MinObjects=%d,"
-		" CPUs=%d, Nodes=%d\n",
+	pr_info("SLUB: HWalign=%d, Order=%d-%d, MinObjects=%d, CPUs=%d, Nodes=%d\n",
 		cache_line_size(),
 		slub_min_order, slub_max_order, slub_min_objects,
 		nr_cpu_ids, nr_node_ids);
@@ -3934,8 +3923,8 @@ static int validate_slab_node(struct kme
 		count++;
 	}
 	if (count != n->nr_partial)
-		printk(KERN_ERR "SLUB %s: %ld partial slabs counted but "
-			"counter=%ld\n", s->name, count, n->nr_partial);
+		pr_err("SLUB %s: %ld partial slabs counted but counter=%ld\n",
+		       s->name, count, n->nr_partial);
 
 	if (!(s->flags & SLAB_STORE_USER))
 		goto out;
@@ -3945,9 +3934,8 @@ static int validate_slab_node(struct kme
 		count++;
 	}
 	if (count != atomic_long_read(&n->nr_slabs))
-		printk(KERN_ERR "SLUB: %s %ld slabs counted but "
-			"counter=%ld\n", s->name, count,
-			atomic_long_read(&n->nr_slabs));
+		pr_err("SLUB: %s %ld slabs counted but counter=%ld\n",
+		       s->name, count, atomic_long_read(&n->nr_slabs));
 
 out:
 	spin_unlock_irqrestore(&n->list_lock, flags);
@@ -4211,53 +4199,50 @@ static void resiliency_test(void)
 
 	BUILD_BUG_ON(KMALLOC_MIN_SIZE > 16 || KMALLOC_SHIFT_HIGH < 10);
 
-	printk(KERN_ERR "SLUB resiliency testing\n");
-	printk(KERN_ERR "-----------------------\n");
-	printk(KERN_ERR "A. Corruption after allocation\n");
+	pr_err("SLUB resiliency testing\n");
+	pr_err("-----------------------\n");
+	pr_err("A. Corruption after allocation\n");
 
 	p = kzalloc(16, GFP_KERNEL);
 	p[16] = 0x12;
-	printk(KERN_ERR "\n1. kmalloc-16: Clobber Redzone/next pointer"
-			" 0x12->0x%p\n\n", p + 16);
+	pr_err("\n1. kmalloc-16: Clobber Redzone/next pointer 0x12->0x%p\n\n",
+	       p + 16);
 
 	validate_slab_cache(kmalloc_caches[4]);
 
 	/* Hmmm... The next two are dangerous */
 	p = kzalloc(32, GFP_KERNEL);
 	p[32 + sizeof(void *)] = 0x34;
-	printk(KERN_ERR "\n2. kmalloc-32: Clobber next pointer/next slab"
-			" 0x34 -> -0x%p\n", p);
-	printk(KERN_ERR
-		"If allocated object is overwritten then not detectable\n\n");
+	pr_err("\n2. kmalloc-32: Clobber next pointer/next slab 0x34 -> -0x%p\n",
+	       p);
+	pr_err("If allocated object is overwritten then not detectable\n\n");
 
 	validate_slab_cache(kmalloc_caches[5]);
 	p = kzalloc(64, GFP_KERNEL);
 	p += 64 + (get_cycles() & 0xff) * sizeof(void *);
 	*p = 0x56;
-	printk(KERN_ERR "\n3. kmalloc-64: corrupting random byte 0x56->0x%p\n",
-									p);
-	printk(KERN_ERR
-		"If allocated object is overwritten then not detectable\n\n");
+	pr_err("\n3. kmalloc-64: corrupting random byte 0x56->0x%p\n",
+	       p);
+	pr_err("If allocated object is overwritten then not detectable\n\n");
 	validate_slab_cache(kmalloc_caches[6]);
 
-	printk(KERN_ERR "\nB. Corruption after free\n");
+	pr_err("\nB. Corruption after free\n");
 	p = kzalloc(128, GFP_KERNEL);
 	kfree(p);
 	*p = 0x78;
-	printk(KERN_ERR "1. kmalloc-128: Clobber first word 0x78->0x%p\n\n", p);
+	pr_err("1. kmalloc-128: Clobber first word 0x78->0x%p\n\n", p);
 	validate_slab_cache(kmalloc_caches[7]);
 
 	p = kzalloc(256, GFP_KERNEL);
 	kfree(p);
 	p[50] = 0x9a;
-	printk(KERN_ERR "\n2. kmalloc-256: Clobber 50th byte 0x9a->0x%p\n\n",
-			p);
+	pr_err("\n2. kmalloc-256: Clobber 50th byte 0x9a->0x%p\n\n", p);
 	validate_slab_cache(kmalloc_caches[8]);
 
 	p = kzalloc(512, GFP_KERNEL);
 	kfree(p);
 	p[512] = 0xab;
-	printk(KERN_ERR "\n3. kmalloc-512: Clobber redzone 0xab->0x%p\n\n", p);
+	pr_err("\n3. kmalloc-512: Clobber redzone 0xab->0x%p\n\n", p);
 	validate_slab_cache(kmalloc_caches[9]);
 }
 #else
@@ -5303,7 +5288,7 @@ static int __init slab_sysfs_init(void)
 	slab_kset = kset_create_and_add("slab", &slab_uevent_ops, kernel_kobj);
 	if (!slab_kset) {
 		mutex_unlock(&slab_mutex);
-		printk(KERN_ERR "Cannot register slab subsystem.\n");
+		pr_err("Cannot register slab subsystem.\n");
 		return -ENOSYS;
 	}
 
@@ -5312,8 +5297,8 @@ static int __init slab_sysfs_init(void)
 	list_for_each_entry(s, &slab_caches, list) {
 		err = sysfs_slab_add(s);
 		if (err)
-			printk(KERN_ERR "SLUB: Unable to add boot slab %s"
-						" to sysfs\n", s->name);
+			pr_err("SLUB: Unable to add boot slab %s to sysfs\n",
+			       s->name);
 	}
 
 	while (alias_list) {
@@ -5322,8 +5307,8 @@ static int __init slab_sysfs_init(void)
 		alias_list = alias_list->next;
 		err = sysfs_slab_alias(al->s, al->name);
 		if (err)
-			printk(KERN_ERR "SLUB: Unable to add boot slab alias"
-					" %s to sysfs\n", al->name);
+			pr_err("SLUB: Unable to add boot slab alias %s to sysfs\n",
+			       al->name);
 		kfree(al);
 	}
 
_

Patches currently in -mm which might be from fabf@skynet.be are

origin.patch
fs-ceph-replace-pr_warning-by-pr_warn.patch
fs-ceph-debugfsc-replace-seq_printf-by-seq_puts.patch
fs-cifs-remove-obsolete-__constant.patch
kernel-posix-timersc-code-clean-up.patch
kernel-posix-timersc-code-clean-up-checkpatch-fixes.patch
fs-ext4-fsyncc-generic_file_fsync-call-based-on-barrier-flag.patch
fs-befs-linuxvfsc-replace-strncpy-by-strlcpy.patch
fs-befs-btreec-replace-strncpy-by-strlcpy-coding-style-fixing.patch
fs-befs-linuxvfsc-remove-positive-test-on-sector_t.patch
fs-befs-kernel-doc-fixes.patch
fs-isofs-logging-clean-up.patch
fs-coda-replace-printk-by-pr_foo.patch
fs-coda-logging-prefix-uniformization.patch
fs-coda-use-__func__.patch
fs-hfsplus-bnodec-replace-min-casting-by-min_t.patch
fs-hfsplus-optionsc-replace-seq_printf-by-seq_puts.patch
fs-hfsplus-wrapperc-replace-min-casting-by-min_t.patch
fs-hfsplus-wrapperc-replace-shift-loop-by-ilog2.patch
fs-hfsplus-fix-pr_foo-and-hfs_dbg-formats.patch
fs-ufs-ballocc-remove-err-parameter-in-ufs_add_fragments.patch
fs-hpfs-convert-printk-to-pr_foo.patch
fs-hpfs-use-pr_fmt-for-logging.patch
fs-hpfs-use-__func__-for-logging.patch
fs-hpfs-increase-pr_warn-level.patch
documentation-filesystems-seq_filetxt-create_proc_entry-deprecated.patch
fs-proc-task_mmuc-replace-seq_printf-by-seq_puts.patch
fs-proc-vmcorec-remove-null-assignment-on-static.patch
kernel-kexecc-convert-printk-to-pr_foo.patch
kernel-user_namespacec-kernel-doc-checkpatch-fixes.patch
fs-affs-filec-remove-unnecessary-function-parameters.patch
fs-affs-convert-printk-to-pr_foo.patch
fs-affs-pr_debug-cleanup.patch
kernel-profilec-convert-printk-to-pr_foo.patch
kernel-profilec-use-static-const-char-instead-of-static-char.patch
fs-pstore-logging-clean-up.patch
fs-pstore-logging-clean-up-fix.patch
fs-cachefiles-convert-printk-to-pr_foo.patch
fs-cachefiles-replace-kerror-by-pr_err.patch
fs-devpts-inodec-convert-printk-to-pr_foo.patch
fs-devpts-inodec-convert-printk-to-pr_foo-fix.patch
kernel-seccompc-kernel-doc-warning-fix.patch
linux-next.patch
kernel-watchdogc-convert-printk-pr_warning-to-pr_foo.patch
init-mainc-code-clean-up.patch
fs-reiserfs-bitmapc-coding-style-fixes.patch
fs-reiserfs-streec-remove-obsolete-__constant.patch
kernel-kprobesc-convert-printk-to-pr_foo.patch
fs-dlm-configc-convert-simple_str-to-kstr.patch
fs-dlm-lockspacec-convert-simple_str-to-kstr.patch
fs-dlm-debug_fsc-replace-seq_printf-by-seq_puts.patch
mm-kmemleak-testc-use-pr_fmt-for-logging.patch
ufs-sb-mutex-merge-mutex_destroy.patch

