From: akpm@linux-foundation.org
Subject: + slub-place-kmem_cache_cpu-structures-in-a-numa-aware-way-fix.patch added to -mm tree
Date: Mon, 15 Oct 2007 12:54:52 -0700
Message-ID: <200710151954.l9FJsqia022020@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:32811 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933344AbXJOTzI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Oct 2007 15:55:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akinobu.mita@gmail.com, clameter@sgi.com, penberg@cs.helsinki.fi


The patch titled
     slub: fix cpu hotplug offline/online path
has been added to the -mm tree.  Its filename is
     slub-place-kmem_cache_cpu-structures-in-a-numa-aware-way-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: slub: fix cpu hotplug offline/online path
From: Akinobu Mita <akinobu.mita@gmail.com>

On Wed, Oct 10, 2007 at 10:39:32AM -0700, Christoph Lameter wrote:
> On Wed, 10 Oct 2007, Akinobu Mita wrote:
>
> > I couldn't use get_cpu_slab() for that check. But I reviced the patch to do
> > what you said.
>
> Why would get_cpu_slab not work?

        case CPU_DEAD:
        case CPU_DEAD_FROZEN:
                down_read(&slub_lock);
                list_for_each_entry(s, &slab_caches, list) {
                        struct kmem_cache_cpu *c = get_cpu_slab(s, cpu);

                        local_irq_save(flags);
                        __flush_cpu_slab(s, cpu);
                        local_irq_restore(flags);
                        free_kmem_cache_cpu(c, cpu);
                        s->cpu_slab[cpu] = NULL; <----------------------
                }
                up_read(&slub_lock);
                break;

When CPU is offlined, cpu-hotplug notifier sets s->cpu_slab[cpu] = NULL.
This means get_cpu_slab() always return NULL when CPU is being onlined.
So I can't use get_cpu_slab to check whether kmem_cache_cpu_free
initalization for the CPU has already been done or not.

>
> > +	if (per_cpu(kmem_cache_cpu_free, cpu)) {
> > +		/* Already initialized once */
> > +		return;
> > +	}
> > +
>
> kmem_cache_cpu_free is not only NULL if the cpu is not up yet but it is
> also NULL if the per cpu pool of kmem_cache_cpu structures was
> exhausted.

cpu-hotplug notifier by CPU_DEAD event frees kmem_cache_cpu structures
for the CPU being offlined. So we have 100 kmem_cache cpu structures
when the CPU will be onlined again.

But I agree that it is not so trivial. It is why I added the comment
/* Already initialized once */ in previous patch.

This is another approach for the fix.
Use cpumask to check whether kmem_cache_cpu_free initalization for
the CPU has already been done or not.

Acked-by: Christoph Lameter <clameter@sgi.com>
Cc: "Pekka Enberg" <penberg@cs.helsinki.fi>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN mm/slub.c~slub-place-kmem_cache_cpu-structures-in-a-numa-aware-way-fix mm/slub.c
--- a/mm/slub.c~slub-place-kmem_cache_cpu-structures-in-a-numa-aware-way-fix
+++ a/mm/slub.c
@@ -1895,6 +1895,7 @@ static DEFINE_PER_CPU(struct kmem_cache_
 				kmem_cache_cpu)[NR_KMEM_CACHE_CPU];
 
 static DEFINE_PER_CPU(struct kmem_cache_cpu *, kmem_cache_cpu_free);
+static cpumask_t kmem_cach_cpu_free_init_once = CPU_MASK_NONE;
 
 static struct kmem_cache_cpu *alloc_kmem_cache_cpu(struct kmem_cache *s,
 							int cpu, gfp_t flags)
@@ -1969,8 +1970,13 @@ static void init_alloc_cpu_cpu(int cpu)
 {
 	int i;
 
+	if (cpu_isset(cpu, kmem_cach_cpu_free_init_once))
+		return;
+
 	for (i = NR_KMEM_CACHE_CPU - 1; i >= 0; i--)
 		free_kmem_cache_cpu(&per_cpu(kmem_cache_cpu, cpu)[i], cpu);
+
+	cpu_set(cpu, kmem_cach_cpu_free_init_once);
 }
 
 static void __init init_alloc_cpu(void)
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

origin.patch
slub-place-kmem_cache_cpu-structures-in-a-numa-aware-way-fix.patch
module-return-error-when-mod_sysfs_init-failed.patch
cpu-hotplug-slab-cleanup-cpuup_callback.patch
cpu-hotplug-slab-fix-memory-leak-in-cpu-hotplug-error-path.patch
cpu-hotplug-cpu-deliver-cpu_up_canceled-only-to-notify_oked-callbacks-with-cpu_up_prepare.patch
cpu-hotplug-topology-remove-topology_dev_map.patch
cpu-hotplug-thermal_throttle-fix-cpu-hotplug-error-handling.patch
cpu-hotplug-msr-fix-cpu-hotplug-error-handling.patch
cpu-hotplug-mce-fix-cpu-hotplug-error-handling.patch
cpu-hotplug-intel_cacheinfo-fix-cpu-hotplug-error-handling.patch
cpu-hotplug-intel_cacheinfo-fix-cpu-hotplug-error-handling-fix-a-section-mismatch-warning.patch
do-cpu_dead-migrating-under-read_locktasklist-instead-of-write_lock_irqtasklist.patch
do-cpu_dead-migrating-under-read_locktasklist-instead-of-write_lock_irqtasklist-fix.patch
migration_callcpu_dead-use-spin_lock_irq-instead-of-task_rq_lock.patch
