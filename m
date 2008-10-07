From: akpm@linux-foundation.org
Subject: - cpualloc-use-cpu-allocator-instead-of-the-builtin-modules-per-cpu-allocator.patch removed from -mm tree
Date: Tue, 07 Oct 2008 16:35:33 -0700
Message-ID: <200810072335.m97NZXGD009266@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46106 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755219AbYJGXfo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Oct 2008 19:35:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cl@linux-foundation.org, penberg@cs.helsinki.fi, rusty@rustcorp.com.au, mm-commits@vger.kernel.org


The patch titled
     cpualloc: use cpu allocator instead of the builtin modules per cpu allocator
has been removed from the -mm tree.  Its filename was
     cpualloc-use-cpu-allocator-instead-of-the-builtin-modules-per-cpu-allocator.patch

This patch was dropped because it got shat on

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cpualloc: use cpu allocator instead of the builtin modules per cpu allocator
From: Christoph Lameter <cl@linux-foundation.org>

Remove the builtin per cpu allocator from modules.c and use cpu_alloc instead.

Signed-off-by: Christoph Lameter <cl@linux-foundation.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/module.h |    1 
 kernel/module.c        |  173 ++-------------------------------------
 2 files changed, 12 insertions(+), 162 deletions(-)

diff -puN include/linux/module.h~cpualloc-use-cpu-allocator-instead-of-the-builtin-modules-per-cpu-allocator include/linux/module.h
--- a/include/linux/module.h~cpualloc-use-cpu-allocator-instead-of-the-builtin-modules-per-cpu-allocator
+++ a/include/linux/module.h
@@ -324,6 +324,7 @@ struct module
 
 	/* Per-cpu data. */
 	void *percpu;
+	int percpu_size;
 
 	/* The command line arguments (may be mangled).  People like
 	   keeping pointers to this stuff */
diff -puN kernel/module.c~cpualloc-use-cpu-allocator-instead-of-the-builtin-modules-per-cpu-allocator kernel/module.c
--- a/kernel/module.c~cpualloc-use-cpu-allocator-instead-of-the-builtin-modules-per-cpu-allocator
+++ a/kernel/module.c
@@ -339,121 +339,6 @@ static struct module *find_module(const 
 	return NULL;
 }
 
-#ifdef CONFIG_SMP
-/* Number of blocks used and allocated. */
-static unsigned int pcpu_num_used, pcpu_num_allocated;
-/* Size of each block.  -ve means used. */
-static int *pcpu_size;
-
-static int split_block(unsigned int i, unsigned short size)
-{
-	/* Reallocation required? */
-	if (pcpu_num_used + 1 > pcpu_num_allocated) {
-		int *new;
-
-		new = krealloc(pcpu_size, sizeof(new[0])*pcpu_num_allocated*2,
-			       GFP_KERNEL);
-		if (!new)
-			return 0;
-
-		pcpu_num_allocated *= 2;
-		pcpu_size = new;
-	}
-
-	/* Insert a new subblock */
-	memmove(&pcpu_size[i+1], &pcpu_size[i],
-		sizeof(pcpu_size[0]) * (pcpu_num_used - i));
-	pcpu_num_used++;
-
-	pcpu_size[i+1] -= size;
-	pcpu_size[i] = size;
-	return 1;
-}
-
-static inline unsigned int block_size(int val)
-{
-	if (val < 0)
-		return -val;
-	return val;
-}
-
-static void *percpu_modalloc(unsigned long size, unsigned long align,
-			     const char *name)
-{
-	unsigned long extra;
-	unsigned int i;
-	void *ptr;
-
-	if (align > PAGE_SIZE) {
-		printk(KERN_WARNING "%s: per-cpu alignment %li > %li\n",
-		       name, align, PAGE_SIZE);
-		align = PAGE_SIZE;
-	}
-
-	ptr = __per_cpu_start;
-	for (i = 0; i < pcpu_num_used; ptr += block_size(pcpu_size[i]), i++) {
-		/* Extra for alignment requirement. */
-		extra = ALIGN((unsigned long)ptr, align) - (unsigned long)ptr;
-		BUG_ON(i == 0 && extra != 0);
-
-		if (pcpu_size[i] < 0 || pcpu_size[i] < extra + size)
-			continue;
-
-		/* Transfer extra to previous block. */
-		if (pcpu_size[i-1] < 0)
-			pcpu_size[i-1] -= extra;
-		else
-			pcpu_size[i-1] += extra;
-		pcpu_size[i] -= extra;
-		ptr += extra;
-
-		/* Split block if warranted */
-		if (pcpu_size[i] - size > sizeof(unsigned long))
-			if (!split_block(i, size))
-				return NULL;
-
-		/* Mark allocated */
-		pcpu_size[i] = -pcpu_size[i];
-		return ptr;
-	}
-
-	printk(KERN_WARNING "Could not allocate %lu bytes percpu data\n",
-	       size);
-	return NULL;
-}
-
-static void percpu_modfree(void *freeme)
-{
-	unsigned int i;
-	void *ptr = __per_cpu_start + block_size(pcpu_size[0]);
-
-	/* First entry is core kernel percpu data. */
-	for (i = 1; i < pcpu_num_used; ptr += block_size(pcpu_size[i]), i++) {
-		if (ptr == freeme) {
-			pcpu_size[i] = -pcpu_size[i];
-			goto free;
-		}
-	}
-	BUG();
-
- free:
-	/* Merge with previous? */
-	if (pcpu_size[i-1] >= 0) {
-		pcpu_size[i-1] += pcpu_size[i];
-		pcpu_num_used--;
-		memmove(&pcpu_size[i], &pcpu_size[i+1],
-			(pcpu_num_used - i) * sizeof(pcpu_size[0]));
-		i--;
-	}
-	/* Merge with next? */
-	if (i+1 < pcpu_num_used && pcpu_size[i+1] >= 0) {
-		pcpu_size[i] += pcpu_size[i+1];
-		pcpu_num_used--;
-		memmove(&pcpu_size[i+1], &pcpu_size[i+2],
-			(pcpu_num_used - (i+1)) * sizeof(pcpu_size[0]));
-	}
-}
-
 static unsigned int find_pcpusec(Elf_Ehdr *hdr,
 				 Elf_Shdr *sechdrs,
 				 const char *secstrings)
@@ -469,48 +354,6 @@ static void percpu_modcopy(void *pcpudes
 		memcpy(pcpudest + per_cpu_offset(cpu), from, size);
 }
 
-static int percpu_modinit(void)
-{
-	pcpu_num_used = 2;
-	pcpu_num_allocated = 2;
-	pcpu_size = kmalloc(sizeof(pcpu_size[0]) * pcpu_num_allocated,
-			    GFP_KERNEL);
-	/* Static in-kernel percpu data (used). */
-	pcpu_size[0] = -(__per_cpu_end-__per_cpu_start);
-	/* Free room. */
-	pcpu_size[1] = PERCPU_AREA_SIZE + pcpu_size[0];
-	if (pcpu_size[1] < 0) {
-		printk(KERN_ERR "No per-cpu room for modules.\n");
-		pcpu_num_used = 1;
-	}
-
-	return 0;
-}
-__initcall(percpu_modinit);
-#else /* ... !CONFIG_SMP */
-static inline void *percpu_modalloc(unsigned long size, unsigned long align,
-				    const char *name)
-{
-	return NULL;
-}
-static inline void percpu_modfree(void *pcpuptr)
-{
-	BUG();
-}
-static inline unsigned int find_pcpusec(Elf_Ehdr *hdr,
-					Elf_Shdr *sechdrs,
-					const char *secstrings)
-{
-	return 0;
-}
-static inline void percpu_modcopy(void *pcpudst, const void *src,
-				  unsigned long size)
-{
-	/* pcpusec should be 0, and size of that section should be 0. */
-	BUG_ON(size != 0);
-}
-#endif /* CONFIG_SMP */
-
 #define MODINFO_ATTR(field)	\
 static void setup_modinfo_##field(struct module *mod, const char *s)  \
 {                                                                     \
@@ -1439,7 +1282,7 @@ static void free_module(struct module *m
 	module_free(mod, mod->module_init);
 	kfree(mod->args);
 	if (mod->percpu)
-		percpu_modfree(mod->percpu);
+		cpu_free(mod->percpu, mod->percpu_size);
 
 	/* Free lock-classes: */
 	lockdep_free_key_range(mod->module_core, mod->core_size);
@@ -1870,6 +1713,7 @@ static noinline struct module *load_modu
 	unsigned int mcountindex;
 	struct module *mod;
 	long err = 0;
+	unsigned long percpu_size = 0;
 	void *percpu = NULL, *ptr = NULL; /* Stops spurious gcc warning */
 	void *mseg;
 	struct exception_table_entry *extable;
@@ -2019,15 +1863,20 @@ static noinline struct module *load_modu
 
 	if (pcpuindex) {
 		/* We have a special allocation for this section. */
-		percpu = percpu_modalloc(sechdrs[pcpuindex].sh_size,
-					 sechdrs[pcpuindex].sh_addralign,
-					 mod->name);
+		unsigned long align = sechdrs[pcpuindex].sh_addralign;
+
+		percpu_size = sechdrs[pcpuindex].sh_size;
+		percpu = cpu_alloc(percpu_size, GFP_KERNEL|__GFP_ZERO, align);
+		if (!percpu)
+			printk(KERN_WARNING "Could not allocate %lu bytes percpu data\n",
+	      							percpu_size);
 		if (!percpu) {
 			err = -ENOMEM;
 			goto free_mod;
 		}
 		sechdrs[pcpuindex].sh_flags &= ~(unsigned long)SHF_ALLOC;
 		mod->percpu = percpu;
+		mod->percpu_size = percpu_size;
 	}
 
 	/* Determine total sizes, and put offsets in sh_entsize.  For now
@@ -2306,7 +2155,7 @@ static noinline struct module *load_modu
 	module_free(mod, mod->module_core);
  free_percpu:
 	if (percpu)
-		percpu_modfree(percpu);
+		cpu_free(percpu, percpu_size);
  free_mod:
 	kfree(args);
  free_hdr:
_

Patches currently in -mm which might be from cl@linux-foundation.org are

repeatable-slab-corruption-with-ltp-msgctl08.patch
git-tip.patch
git-slab.patch
vmscan-use-an-indexed-array-for-lru-variables.patch
cpualloc-use-cpu-allocator-instead-of-the-builtin-modules-per-cpu-allocator.patch
cpualloc-use-cpu-allocator-instead-of-the-builtin-modules-per-cpu-allocator-checkpatch-fixes.patch
reiser4.patch
page-owner-tracking-leak-detector.patch
slab-leaks3-default-y.patch

