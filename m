From: akpm@linux-foundation.org
Subject: - lockdep-reduce-the-ifdeffery.patch removed from -mm tree
Date: Thu, 19 Jul 2007 13:03:36 -0700
Message-ID: <200707192003.l6JK3atM019878@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55485 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761308AbXGSU1X (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 16:27:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: a.p.zijlstra@chello.nl, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     lockdep: reduce the ifdeffery
has been removed from the -mm tree.  Its filename was
     lockdep-reduce-the-ifdeffery.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: lockdep: reduce the ifdeffery
From: Peter Zijlstra <a.p.zijlstra@chello.nl>

Move code around to get fewer but larger #ifdef sections.  Break some
in-function #ifdefs out into their own functions.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Acked-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/lockdep.c      | 1657 +++++++++++++++++++++-------------------
 kernel/lockdep_proc.c |    2 
 2 files changed, 873 insertions(+), 786 deletions(-)

diff -puN kernel/lockdep.c~lockdep-reduce-the-ifdeffery kernel/lockdep.c
--- a/kernel/lockdep.c~lockdep-reduce-the-ifdeffery
+++ a/kernel/lockdep.c
@@ -95,25 +95,6 @@ static int lockdep_initialized;
 unsigned long nr_list_entries;
 static struct lock_list list_entries[MAX_LOCKDEP_ENTRIES];
 
-#ifdef CONFIG_PROVE_LOCKING
-/*
- * Allocate a lockdep entry. (assumes the graph_lock held, returns
- * with NULL on failure)
- */
-static struct lock_list *alloc_list_entry(void)
-{
-	if (nr_list_entries >= MAX_LOCKDEP_ENTRIES) {
-		if (!debug_locks_off_graph_unlock())
-			return NULL;
-
-		printk("BUG: MAX_LOCKDEP_ENTRIES too low!\n");
-		printk("turning off the locking correctness validator.\n");
-		return NULL;
-	}
-	return list_entries + nr_list_entries++;
-}
-#endif
-
 /*
  * All data structures here are protected by the global debug_lock.
  *
@@ -141,11 +122,6 @@ LIST_HEAD(all_lock_classes);
 
 static struct list_head classhash_table[CLASSHASH_SIZE];
 
-unsigned long nr_lock_chains;
-#ifdef CONFIG_PROVE_LOCKING
-static struct lock_chain lock_chains[MAX_LOCKDEP_CHAINS];
-#endif
-
 /*
  * We put the lock dependency chains into a hash-table as well, to cache
  * their existence:
@@ -227,26 +203,6 @@ static int verbose(struct lock_class *cl
 	return 0;
 }
 
-#ifdef CONFIG_TRACE_IRQFLAGS
-
-static int hardirq_verbose(struct lock_class *class)
-{
-#if HARDIRQ_VERBOSE
-	return class_filter(class);
-#endif
-	return 0;
-}
-
-static int softirq_verbose(struct lock_class *class)
-{
-#if SOFTIRQ_VERBOSE
-	return class_filter(class);
-#endif
-	return 0;
-}
-
-#endif
-
 /*
  * Stack-trace: tightly packed array of stack backtrace
  * addresses. Protected by the graph_lock.
@@ -486,151 +442,392 @@ static void print_lock_dependencies(stru
 	}
 }
 
-#ifdef CONFIG_PROVE_LOCKING
+static void print_kernel_version(void)
+{
+	printk("%s %.*s\n", init_utsname()->release,
+		(int)strcspn(init_utsname()->version, " "),
+		init_utsname()->version);
+}
+
+static int very_verbose(struct lock_class *class)
+{
+#if VERY_VERBOSE
+	return class_filter(class);
+#endif
+	return 0;
+}
+
 /*
- * Add a new dependency to the head of the list:
+ * Is this the address of a static object:
  */
-static int add_lock_to_list(struct lock_class *class, struct lock_class *this,
-			    struct list_head *head, unsigned long ip, int distance)
+static int static_obj(void *obj)
 {
-	struct lock_list *entry;
+	unsigned long start = (unsigned long) &_stext,
+		      end   = (unsigned long) &_end,
+		      addr  = (unsigned long) obj;
+#ifdef CONFIG_SMP
+	int i;
+#endif
+
 	/*
-	 * Lock not present yet - get a new dependency struct and
-	 * add it to the list:
+	 * static variable?
 	 */
-	entry = alloc_list_entry();
-	if (!entry)
-		return 0;
-
-	entry->class = this;
-	entry->distance = distance;
-	if (!save_trace(&entry->trace))
-		return 0;
+	if ((addr >= start) && (addr < end))
+		return 1;
 
+#ifdef CONFIG_SMP
 	/*
-	 * Since we never remove from the dependency list, the list can
-	 * be walked lockless by other CPUs, it's only allocation
-	 * that must be protected by the spinlock. But this also means
-	 * we must make new entries visible only once writes to the
-	 * entry become visible - hence the RCU op:
+	 * percpu var?
 	 */
-	list_add_tail_rcu(&entry->entry, head);
-
-	return 1;
-}
-
-/*
- * Recursive, forwards-direction lock-dependency checking, used for
- * both noncyclic checking and for hardirq-unsafe/softirq-unsafe
- * checking.
- *
- * (to keep the stackframe of the recursive functions small we
- *  use these global variables, and we also mark various helper
- *  functions as noinline.)
- */
-static struct held_lock *check_source, *check_target;
-
-/*
- * Print a dependency chain entry (this is only done when a deadlock
- * has been detected):
- */
-static noinline int
-print_circular_bug_entry(struct lock_list *target, unsigned int depth)
-{
-	if (debug_locks_silent)
-		return 0;
-	printk("\n-> #%u", depth);
-	print_lock_name(target->class);
-	printk(":\n");
-	print_stack_trace(&target->trace, 6);
+	for_each_possible_cpu(i) {
+		start = (unsigned long) &__per_cpu_start + per_cpu_offset(i);
+		end   = (unsigned long) &__per_cpu_start + PERCPU_ENOUGH_ROOM
+					+ per_cpu_offset(i);
 
-	return 0;
-}
+		if ((addr >= start) && (addr < end))
+			return 1;
+	}
 #endif
 
-static void print_kernel_version(void)
-{
-	printk("%s %.*s\n", init_utsname()->release,
-		(int)strcspn(init_utsname()->version, " "),
-		init_utsname()->version);
+	/*
+	 * module var?
+	 */
+	return is_module_address(addr);
 }
 
-#ifdef CONFIG_PROVE_LOCKING
 /*
- * When a circular dependency is detected, print the
- * header first:
+ * To make lock name printouts unique, we calculate a unique
+ * class->name_version generation counter:
  */
-static noinline int
-print_circular_bug_header(struct lock_list *entry, unsigned int depth)
+static int count_matching_names(struct lock_class *new_class)
 {
-	struct task_struct *curr = current;
+	struct lock_class *class;
+	int count = 0;
 
-	if (!debug_locks_off_graph_unlock() || debug_locks_silent)
+	if (!new_class->name)
 		return 0;
 
-	printk("\n=======================================================\n");
-	printk(  "[ INFO: possible circular locking dependency detected ]\n");
-	print_kernel_version();
-	printk(  "-------------------------------------------------------\n");
-	printk("%s/%d is trying to acquire lock:\n",
-		curr->comm, curr->pid);
-	print_lock(check_source);
-	printk("\nbut task is already holding lock:\n");
-	print_lock(check_target);
-	printk("\nwhich lock already depends on the new lock.\n\n");
-	printk("\nthe existing dependency chain (in reverse order) is:\n");
-
-	print_circular_bug_entry(entry, depth);
+	list_for_each_entry(class, &all_lock_classes, lock_entry) {
+		if (new_class->key - new_class->subclass == class->key)
+			return class->name_version;
+		if (class->name && !strcmp(class->name, new_class->name))
+			count = max(count, class->name_version);
+	}
 
-	return 0;
+	return count + 1;
 }
 
-static noinline int print_circular_bug_tail(void)
+/*
+ * Register a lock's class in the hash-table, if the class is not present
+ * yet. Otherwise we look it up. We cache the result in the lock object
+ * itself, so actual lookup of the hash should be once per lock object.
+ */
+static inline struct lock_class *
+look_up_lock_class(struct lockdep_map *lock, unsigned int subclass)
 {
-	struct task_struct *curr = current;
-	struct lock_list this;
-
-	if (debug_locks_silent)
-		return 0;
-
-	this.class = check_source->class;
-	if (!save_trace(&this.trace))
-		return 0;
-
-	print_circular_bug_entry(&this, 0);
+	struct lockdep_subclass_key *key;
+	struct list_head *hash_head;
+	struct lock_class *class;
 
-	printk("\nother info that might help us debug this:\n\n");
-	lockdep_print_held_locks(curr);
+#ifdef CONFIG_DEBUG_LOCKDEP
+	/*
+	 * If the architecture calls into lockdep before initializing
+	 * the hashes then we'll warn about it later. (we cannot printk
+	 * right now)
+	 */
+	if (unlikely(!lockdep_initialized)) {
+		lockdep_init();
+		lockdep_init_error = 1;
+	}
+#endif
 
-	printk("\nstack backtrace:\n");
-	dump_stack();
+	/*
+	 * Static locks do not have their class-keys yet - for them the key
+	 * is the lock object itself:
+	 */
+	if (unlikely(!lock->key))
+		lock->key = (void *)lock;
 
-	return 0;
-}
+	/*
+	 * NOTE: the class-key must be unique. For dynamic locks, a static
+	 * lock_class_key variable is passed in through the mutex_init()
+	 * (or spin_lock_init()) call - which acts as the key. For static
+	 * locks we use the lock object itself as the key.
+	 */
+	BUILD_BUG_ON(sizeof(struct lock_class_key) > sizeof(struct lock_class));
 
-#define RECURSION_LIMIT 40
+	key = lock->key->subkeys + subclass;
 
-static int noinline print_infinite_recursion_bug(void)
-{
-	if (!debug_locks_off_graph_unlock())
-		return 0;
+	hash_head = classhashentry(key);
 
-	WARN_ON(1);
+	/*
+	 * We can walk the hash lockfree, because the hash only
+	 * grows, and we are careful when adding entries to the end:
+	 */
+	list_for_each_entry(class, hash_head, hash_entry)
+		if (class->key == key)
+			return class;
 
-	return 0;
+	return NULL;
 }
 
 /*
- * Prove that the dependency graph starting at <entry> can not
- * lead to <target>. Print an error and return 0 if it does.
+ * Register a lock's class in the hash-table, if the class is not present
+ * yet. Otherwise we look it up. We cache the result in the lock object
+ * itself, so actual lookup of the hash should be once per lock object.
  */
-static noinline int
-check_noncircular(struct lock_class *source, unsigned int depth)
+static inline struct lock_class *
+register_lock_class(struct lockdep_map *lock, unsigned int subclass, int force)
 {
-	struct lock_list *entry;
-
-	debug_atomic_inc(&nr_cyclic_check_recursions);
-	if (depth > max_recursion_depth)
+	struct lockdep_subclass_key *key;
+	struct list_head *hash_head;
+	struct lock_class *class;
+	unsigned long flags;
+
+	class = look_up_lock_class(lock, subclass);
+	if (likely(class))
+		return class;
+
+	/*
+	 * Debug-check: all keys must be persistent!
+ 	 */
+	if (!static_obj(lock->key)) {
+		debug_locks_off();
+		printk("INFO: trying to register non-static key.\n");
+		printk("the code is fine but needs lockdep annotation.\n");
+		printk("turning off the locking correctness validator.\n");
+		dump_stack();
+
+		return NULL;
+	}
+
+	key = lock->key->subkeys + subclass;
+	hash_head = classhashentry(key);
+
+	raw_local_irq_save(flags);
+	if (!graph_lock()) {
+		raw_local_irq_restore(flags);
+		return NULL;
+	}
+	/*
+	 * We have to do the hash-walk again, to avoid races
+	 * with another CPU:
+	 */
+	list_for_each_entry(class, hash_head, hash_entry)
+		if (class->key == key)
+			goto out_unlock_set;
+	/*
+	 * Allocate a new key from the static array, and add it to
+	 * the hash:
+	 */
+	if (nr_lock_classes >= MAX_LOCKDEP_KEYS) {
+		if (!debug_locks_off_graph_unlock()) {
+			raw_local_irq_restore(flags);
+			return NULL;
+		}
+		raw_local_irq_restore(flags);
+
+		printk("BUG: MAX_LOCKDEP_KEYS too low!\n");
+		printk("turning off the locking correctness validator.\n");
+		return NULL;
+	}
+	class = lock_classes + nr_lock_classes++;
+	debug_atomic_inc(&nr_unused_locks);
+	class->key = key;
+	class->name = lock->name;
+	class->subclass = subclass;
+	INIT_LIST_HEAD(&class->lock_entry);
+	INIT_LIST_HEAD(&class->locks_before);
+	INIT_LIST_HEAD(&class->locks_after);
+	class->name_version = count_matching_names(class);
+	/*
+	 * We use RCU's safe list-add method to make
+	 * parallel walking of the hash-list safe:
+	 */
+	list_add_tail_rcu(&class->hash_entry, hash_head);
+
+	if (verbose(class)) {
+		graph_unlock();
+		raw_local_irq_restore(flags);
+
+		printk("\nnew class %p: %s", class->key, class->name);
+		if (class->name_version > 1)
+			printk("#%d", class->name_version);
+		printk("\n");
+		dump_stack();
+
+		raw_local_irq_save(flags);
+		if (!graph_lock()) {
+			raw_local_irq_restore(flags);
+			return NULL;
+		}
+	}
+out_unlock_set:
+	graph_unlock();
+	raw_local_irq_restore(flags);
+
+	if (!subclass || force)
+		lock->class_cache = class;
+
+	if (DEBUG_LOCKS_WARN_ON(class->subclass != subclass))
+		return NULL;
+
+	return class;
+}
+
+#ifdef CONFIG_PROVE_LOCKING
+/*
+ * Allocate a lockdep entry. (assumes the graph_lock held, returns
+ * with NULL on failure)
+ */
+static struct lock_list *alloc_list_entry(void)
+{
+	if (nr_list_entries >= MAX_LOCKDEP_ENTRIES) {
+		if (!debug_locks_off_graph_unlock())
+			return NULL;
+
+		printk("BUG: MAX_LOCKDEP_ENTRIES too low!\n");
+		printk("turning off the locking correctness validator.\n");
+		return NULL;
+	}
+	return list_entries + nr_list_entries++;
+}
+
+/*
+ * Add a new dependency to the head of the list:
+ */
+static int add_lock_to_list(struct lock_class *class, struct lock_class *this,
+			    struct list_head *head, unsigned long ip, int distance)
+{
+	struct lock_list *entry;
+	/*
+	 * Lock not present yet - get a new dependency struct and
+	 * add it to the list:
+	 */
+	entry = alloc_list_entry();
+	if (!entry)
+		return 0;
+
+	entry->class = this;
+	entry->distance = distance;
+	if (!save_trace(&entry->trace))
+		return 0;
+
+	/*
+	 * Since we never remove from the dependency list, the list can
+	 * be walked lockless by other CPUs, it's only allocation
+	 * that must be protected by the spinlock. But this also means
+	 * we must make new entries visible only once writes to the
+	 * entry become visible - hence the RCU op:
+	 */
+	list_add_tail_rcu(&entry->entry, head);
+
+	return 1;
+}
+
+/*
+ * Recursive, forwards-direction lock-dependency checking, used for
+ * both noncyclic checking and for hardirq-unsafe/softirq-unsafe
+ * checking.
+ *
+ * (to keep the stackframe of the recursive functions small we
+ *  use these global variables, and we also mark various helper
+ *  functions as noinline.)
+ */
+static struct held_lock *check_source, *check_target;
+
+/*
+ * Print a dependency chain entry (this is only done when a deadlock
+ * has been detected):
+ */
+static noinline int
+print_circular_bug_entry(struct lock_list *target, unsigned int depth)
+{
+	if (debug_locks_silent)
+		return 0;
+	printk("\n-> #%u", depth);
+	print_lock_name(target->class);
+	printk(":\n");
+	print_stack_trace(&target->trace, 6);
+
+	return 0;
+}
+
+/*
+ * When a circular dependency is detected, print the
+ * header first:
+ */
+static noinline int
+print_circular_bug_header(struct lock_list *entry, unsigned int depth)
+{
+	struct task_struct *curr = current;
+
+	if (!debug_locks_off_graph_unlock() || debug_locks_silent)
+		return 0;
+
+	printk("\n=======================================================\n");
+	printk(  "[ INFO: possible circular locking dependency detected ]\n");
+	print_kernel_version();
+	printk(  "-------------------------------------------------------\n");
+	printk("%s/%d is trying to acquire lock:\n",
+		curr->comm, curr->pid);
+	print_lock(check_source);
+	printk("\nbut task is already holding lock:\n");
+	print_lock(check_target);
+	printk("\nwhich lock already depends on the new lock.\n\n");
+	printk("\nthe existing dependency chain (in reverse order) is:\n");
+
+	print_circular_bug_entry(entry, depth);
+
+	return 0;
+}
+
+static noinline int print_circular_bug_tail(void)
+{
+	struct task_struct *curr = current;
+	struct lock_list this;
+
+	if (debug_locks_silent)
+		return 0;
+
+	this.class = check_source->class;
+	if (!save_trace(&this.trace))
+		return 0;
+
+	print_circular_bug_entry(&this, 0);
+
+	printk("\nother info that might help us debug this:\n\n");
+	lockdep_print_held_locks(curr);
+
+	printk("\nstack backtrace:\n");
+	dump_stack();
+
+	return 0;
+}
+
+#define RECURSION_LIMIT 40
+
+static int noinline print_infinite_recursion_bug(void)
+{
+	if (!debug_locks_off_graph_unlock())
+		return 0;
+
+	WARN_ON(1);
+
+	return 0;
+}
+
+/*
+ * Prove that the dependency graph starting at <entry> can not
+ * lead to <target>. Print an error and return 0 if it does.
+ */
+static noinline int
+check_noncircular(struct lock_class *source, unsigned int depth)
+{
+	struct lock_list *entry;
+
+	debug_atomic_inc(&nr_cyclic_check_recursions);
+	if (depth > max_recursion_depth)
 		max_recursion_depth = depth;
 	if (depth >= RECURSION_LIMIT)
 		return print_infinite_recursion_bug();
@@ -646,17 +843,8 @@ check_noncircular(struct lock_class *sou
 	}
 	return 1;
 }
-#endif
 
-static int very_verbose(struct lock_class *class)
-{
-#if VERY_VERBOSE
-	return class_filter(class);
-#endif
-	return 0;
-}
 #ifdef CONFIG_TRACE_IRQFLAGS
-
 /*
  * Forwards and backwards subgraph searching, for the purposes of
  * proving that two subgraphs can be connected by a new dependency
@@ -829,9 +1017,80 @@ check_usage(struct task_struct *curr, st
 			bit_backwards, bit_forwards, irqclass);
 }
 
+static int
+check_prev_add_irq(struct task_struct *curr, struct held_lock *prev,
+		struct held_lock *next)
+{
+	/*
+	 * Prove that the new dependency does not connect a hardirq-safe
+	 * lock with a hardirq-unsafe lock - to achieve this we search
+	 * the backwards-subgraph starting at <prev>, and the
+	 * forwards-subgraph starting at <next>:
+	 */
+	if (!check_usage(curr, prev, next, LOCK_USED_IN_HARDIRQ,
+					LOCK_ENABLED_HARDIRQS, "hard"))
+		return 0;
+
+	/*
+	 * Prove that the new dependency does not connect a hardirq-safe-read
+	 * lock with a hardirq-unsafe lock - to achieve this we search
+	 * the backwards-subgraph starting at <prev>, and the
+	 * forwards-subgraph starting at <next>:
+	 */
+	if (!check_usage(curr, prev, next, LOCK_USED_IN_HARDIRQ_READ,
+					LOCK_ENABLED_HARDIRQS, "hard-read"))
+		return 0;
+
+	/*
+	 * Prove that the new dependency does not connect a softirq-safe
+	 * lock with a softirq-unsafe lock - to achieve this we search
+	 * the backwards-subgraph starting at <prev>, and the
+	 * forwards-subgraph starting at <next>:
+	 */
+	if (!check_usage(curr, prev, next, LOCK_USED_IN_SOFTIRQ,
+					LOCK_ENABLED_SOFTIRQS, "soft"))
+		return 0;
+	/*
+	 * Prove that the new dependency does not connect a softirq-safe-read
+	 * lock with a softirq-unsafe lock - to achieve this we search
+	 * the backwards-subgraph starting at <prev>, and the
+	 * forwards-subgraph starting at <next>:
+	 */
+	if (!check_usage(curr, prev, next, LOCK_USED_IN_SOFTIRQ_READ,
+					LOCK_ENABLED_SOFTIRQS, "soft"))
+		return 0;
+
+	return 1;
+}
+
+static void inc_chains(void)
+{
+	if (current->hardirq_context)
+		nr_hardirq_chains++;
+	else {
+		if (current->softirq_context)
+			nr_softirq_chains++;
+		else
+			nr_process_chains++;
+	}
+}
+
+#else
+
+static inline int
+check_prev_add_irq(struct task_struct *curr, struct held_lock *prev,
+		struct held_lock *next)
+{
+	return 1;
+}
+
+static inline void inc_chains(void)
+{
+	nr_process_chains++;
+}
+
 #endif
 
-#ifdef CONFIG_PROVE_LOCKING
 static int
 print_deadlock_bug(struct task_struct *curr, struct held_lock *prev,
 		   struct held_lock *next)
@@ -931,47 +1190,10 @@ check_prev_add(struct task_struct *curr,
 	if (!(check_noncircular(next->class, 0)))
 		return print_circular_bug_tail();
 
-#ifdef CONFIG_TRACE_IRQFLAGS
-	/*
-	 * Prove that the new dependency does not connect a hardirq-safe
-	 * lock with a hardirq-unsafe lock - to achieve this we search
-	 * the backwards-subgraph starting at <prev>, and the
-	 * forwards-subgraph starting at <next>:
-	 */
-	if (!check_usage(curr, prev, next, LOCK_USED_IN_HARDIRQ,
-					LOCK_ENABLED_HARDIRQS, "hard"))
-		return 0;
-
-	/*
-	 * Prove that the new dependency does not connect a hardirq-safe-read
-	 * lock with a hardirq-unsafe lock - to achieve this we search
-	 * the backwards-subgraph starting at <prev>, and the
-	 * forwards-subgraph starting at <next>:
-	 */
-	if (!check_usage(curr, prev, next, LOCK_USED_IN_HARDIRQ_READ,
-					LOCK_ENABLED_HARDIRQS, "hard-read"))
+	if (!check_prev_add_irq(curr, prev, next))
 		return 0;
 
 	/*
-	 * Prove that the new dependency does not connect a softirq-safe
-	 * lock with a softirq-unsafe lock - to achieve this we search
-	 * the backwards-subgraph starting at <prev>, and the
-	 * forwards-subgraph starting at <next>:
-	 */
-	if (!check_usage(curr, prev, next, LOCK_USED_IN_SOFTIRQ,
-					LOCK_ENABLED_SOFTIRQS, "soft"))
-		return 0;
-	/*
-	 * Prove that the new dependency does not connect a softirq-safe-read
-	 * lock with a softirq-unsafe lock - to achieve this we search
-	 * the backwards-subgraph starting at <prev>, and the
-	 * forwards-subgraph starting at <next>:
-	 */
-	if (!check_usage(curr, prev, next, LOCK_USED_IN_SOFTIRQ_READ,
-					LOCK_ENABLED_SOFTIRQS, "soft"))
-		return 0;
-#endif
-	/*
 	 * For recursive read-locks we do all the dependency checks,
 	 * but we dont store read-triggered dependencies (only
 	 * write-triggered dependencies). This ensures that only the
@@ -1013,310 +1235,93 @@ check_prev_add(struct task_struct *curr,
 		return 0;
 
 	/*
-	 * Debugging printouts:
-	 */
-	if (verbose(prev->class) || verbose(next->class)) {
-		graph_unlock();
-		printk("\n new dependency: ");
-		print_lock_name(prev->class);
-		printk(" => ");
-		print_lock_name(next->class);
-		printk("\n");
-		dump_stack();
-		return graph_lock();
-	}
-	return 1;
-}
-
-/*
- * Add the dependency to all directly-previous locks that are 'relevant'.
- * The ones that are relevant are (in increasing distance from curr):
- * all consecutive trylock entries and the final non-trylock entry - or
- * the end of this context's lock-chain - whichever comes first.
- */
-static int
-check_prevs_add(struct task_struct *curr, struct held_lock *next)
-{
-	int depth = curr->lockdep_depth;
-	struct held_lock *hlock;
-
-	/*
-	 * Debugging checks.
-	 *
-	 * Depth must not be zero for a non-head lock:
-	 */
-	if (!depth)
-		goto out_bug;
-	/*
-	 * At least two relevant locks must exist for this
-	 * to be a head:
-	 */
-	if (curr->held_locks[depth].irq_context !=
-			curr->held_locks[depth-1].irq_context)
-		goto out_bug;
-
-	for (;;) {
-		int distance = curr->lockdep_depth - depth + 1;
-		hlock = curr->held_locks + depth-1;
-		/*
-		 * Only non-recursive-read entries get new dependencies
-		 * added:
-		 */
-		if (hlock->read != 2) {
-			if (!check_prev_add(curr, hlock, next, distance))
-				return 0;
-			/*
-			 * Stop after the first non-trylock entry,
-			 * as non-trylock entries have added their
-			 * own direct dependencies already, so this
-			 * lock is connected to them indirectly:
-			 */
-			if (!hlock->trylock)
-				break;
-		}
-		depth--;
-		/*
-		 * End of lock-stack?
-		 */
-		if (!depth)
-			break;
-		/*
-		 * Stop the search if we cross into another context:
-		 */
-		if (curr->held_locks[depth].irq_context !=
-				curr->held_locks[depth-1].irq_context)
-			break;
-	}
-	return 1;
-out_bug:
-	if (!debug_locks_off_graph_unlock())
-		return 0;
-
-	WARN_ON(1);
-
-	return 0;
-}
-#endif
-
-/*
- * Is this the address of a static object:
- */
-static int static_obj(void *obj)
-{
-	unsigned long start = (unsigned long) &_stext,
-		      end   = (unsigned long) &_end,
-		      addr  = (unsigned long) obj;
-#ifdef CONFIG_SMP
-	int i;
-#endif
-
-	/*
-	 * static variable?
-	 */
-	if ((addr >= start) && (addr < end))
-		return 1;
-
-#ifdef CONFIG_SMP
-	/*
-	 * percpu var?
-	 */
-	for_each_possible_cpu(i) {
-		start = (unsigned long) &__per_cpu_start + per_cpu_offset(i);
-		end   = (unsigned long) &__per_cpu_start + PERCPU_ENOUGH_ROOM
-					+ per_cpu_offset(i);
-
-		if ((addr >= start) && (addr < end))
-			return 1;
-	}
-#endif
-
-	/*
-	 * module var?
-	 */
-	return is_module_address(addr);
-}
-
-/*
- * To make lock name printouts unique, we calculate a unique
- * class->name_version generation counter:
- */
-static int count_matching_names(struct lock_class *new_class)
-{
-	struct lock_class *class;
-	int count = 0;
-
-	if (!new_class->name)
-		return 0;
-
-	list_for_each_entry(class, &all_lock_classes, lock_entry) {
-		if (new_class->key - new_class->subclass == class->key)
-			return class->name_version;
-		if (class->name && !strcmp(class->name, new_class->name))
-			count = max(count, class->name_version);
-	}
-
-	return count + 1;
-}
-
-/*
- * Register a lock's class in the hash-table, if the class is not present
- * yet. Otherwise we look it up. We cache the result in the lock object
- * itself, so actual lookup of the hash should be once per lock object.
- */
-static inline struct lock_class *
-look_up_lock_class(struct lockdep_map *lock, unsigned int subclass)
-{
-	struct lockdep_subclass_key *key;
-	struct list_head *hash_head;
-	struct lock_class *class;
-
-#ifdef CONFIG_DEBUG_LOCKDEP
-	/*
-	 * If the architecture calls into lockdep before initializing
-	 * the hashes then we'll warn about it later. (we cannot printk
-	 * right now)
-	 */
-	if (unlikely(!lockdep_initialized)) {
-		lockdep_init();
-		lockdep_init_error = 1;
-	}
-#endif
-
-	/*
-	 * Static locks do not have their class-keys yet - for them the key
-	 * is the lock object itself:
-	 */
-	if (unlikely(!lock->key))
-		lock->key = (void *)lock;
-
-	/*
-	 * NOTE: the class-key must be unique. For dynamic locks, a static
-	 * lock_class_key variable is passed in through the mutex_init()
-	 * (or spin_lock_init()) call - which acts as the key. For static
-	 * locks we use the lock object itself as the key.
-	 */
-	BUILD_BUG_ON(sizeof(struct lock_class_key) > sizeof(struct lock_class));
-
-	key = lock->key->subkeys + subclass;
-
-	hash_head = classhashentry(key);
-
-	/*
-	 * We can walk the hash lockfree, because the hash only
-	 * grows, and we are careful when adding entries to the end:
-	 */
-	list_for_each_entry(class, hash_head, hash_entry)
-		if (class->key == key)
-			return class;
-
-	return NULL;
-}
-
-/*
- * Register a lock's class in the hash-table, if the class is not present
- * yet. Otherwise we look it up. We cache the result in the lock object
- * itself, so actual lookup of the hash should be once per lock object.
- */
-static inline struct lock_class *
-register_lock_class(struct lockdep_map *lock, unsigned int subclass, int force)
-{
-	struct lockdep_subclass_key *key;
-	struct list_head *hash_head;
-	struct lock_class *class;
-	unsigned long flags;
-
-	class = look_up_lock_class(lock, subclass);
-	if (likely(class))
-		return class;
-
-	/*
-	 * Debug-check: all keys must be persistent!
- 	 */
-	if (!static_obj(lock->key)) {
-		debug_locks_off();
-		printk("INFO: trying to register non-static key.\n");
-		printk("the code is fine but needs lockdep annotation.\n");
-		printk("turning off the locking correctness validator.\n");
+	 * Debugging printouts:
+	 */
+	if (verbose(prev->class) || verbose(next->class)) {
+		graph_unlock();
+		printk("\n new dependency: ");
+		print_lock_name(prev->class);
+		printk(" => ");
+		print_lock_name(next->class);
+		printk("\n");
 		dump_stack();
-
-		return NULL;
+		return graph_lock();
 	}
+	return 1;
+}
 
-	key = lock->key->subkeys + subclass;
-	hash_head = classhashentry(key);
+/*
+ * Add the dependency to all directly-previous locks that are 'relevant'.
+ * The ones that are relevant are (in increasing distance from curr):
+ * all consecutive trylock entries and the final non-trylock entry - or
+ * the end of this context's lock-chain - whichever comes first.
+ */
+static int
+check_prevs_add(struct task_struct *curr, struct held_lock *next)
+{
+	int depth = curr->lockdep_depth;
+	struct held_lock *hlock;
 
-	raw_local_irq_save(flags);
-	if (!graph_lock()) {
-		raw_local_irq_restore(flags);
-		return NULL;
-	}
-	/*
-	 * We have to do the hash-walk again, to avoid races
-	 * with another CPU:
-	 */
-	list_for_each_entry(class, hash_head, hash_entry)
-		if (class->key == key)
-			goto out_unlock_set;
 	/*
-	 * Allocate a new key from the static array, and add it to
-	 * the hash:
+	 * Debugging checks.
+	 *
+	 * Depth must not be zero for a non-head lock:
 	 */
-	if (nr_lock_classes >= MAX_LOCKDEP_KEYS) {
-		if (!debug_locks_off_graph_unlock()) {
-			raw_local_irq_restore(flags);
-			return NULL;
-		}
-		raw_local_irq_restore(flags);
-
-		printk("BUG: MAX_LOCKDEP_KEYS too low!\n");
-		printk("turning off the locking correctness validator.\n");
-		return NULL;
-	}
-	class = lock_classes + nr_lock_classes++;
-	debug_atomic_inc(&nr_unused_locks);
-	class->key = key;
-	class->name = lock->name;
-	class->subclass = subclass;
-	INIT_LIST_HEAD(&class->lock_entry);
-	INIT_LIST_HEAD(&class->locks_before);
-	INIT_LIST_HEAD(&class->locks_after);
-	class->name_version = count_matching_names(class);
+	if (!depth)
+		goto out_bug;
 	/*
-	 * We use RCU's safe list-add method to make
-	 * parallel walking of the hash-list safe:
+	 * At least two relevant locks must exist for this
+	 * to be a head:
 	 */
-	list_add_tail_rcu(&class->hash_entry, hash_head);
-
-	if (verbose(class)) {
-		graph_unlock();
-		raw_local_irq_restore(flags);
-
-		printk("\nnew class %p: %s", class->key, class->name);
-		if (class->name_version > 1)
-			printk("#%d", class->name_version);
-		printk("\n");
-		dump_stack();
+	if (curr->held_locks[depth].irq_context !=
+			curr->held_locks[depth-1].irq_context)
+		goto out_bug;
 
-		raw_local_irq_save(flags);
-		if (!graph_lock()) {
-			raw_local_irq_restore(flags);
-			return NULL;
+	for (;;) {
+		int distance = curr->lockdep_depth - depth + 1;
+		hlock = curr->held_locks + depth-1;
+		/*
+		 * Only non-recursive-read entries get new dependencies
+		 * added:
+		 */
+		if (hlock->read != 2) {
+			if (!check_prev_add(curr, hlock, next, distance))
+				return 0;
+			/*
+			 * Stop after the first non-trylock entry,
+			 * as non-trylock entries have added their
+			 * own direct dependencies already, so this
+			 * lock is connected to them indirectly:
+			 */
+			if (!hlock->trylock)
+				break;
 		}
+		depth--;
+		/*
+		 * End of lock-stack?
+		 */
+		if (!depth)
+			break;
+		/*
+		 * Stop the search if we cross into another context:
+		 */
+		if (curr->held_locks[depth].irq_context !=
+				curr->held_locks[depth-1].irq_context)
+			break;
 	}
-out_unlock_set:
-	graph_unlock();
-	raw_local_irq_restore(flags);
-
-	if (!subclass || force)
-		lock->class_cache = class;
+	return 1;
+out_bug:
+	if (!debug_locks_off_graph_unlock())
+		return 0;
 
-	if (DEBUG_LOCKS_WARN_ON(class->subclass != subclass))
-		return NULL;
+	WARN_ON(1);
 
-	return class;
+	return 0;
 }
 
-#ifdef CONFIG_PROVE_LOCKING
+unsigned long nr_lock_chains;
+static struct lock_chain lock_chains[MAX_LOCKDEP_CHAINS];
+
 /*
  * Look up a dependency chain. If the key is not present yet then
  * add it and return 1 - in this case the new dependency chain is
@@ -1376,21 +1381,71 @@ cache_hit:
 	chain->chain_key = chain_key;
 	list_add_tail_rcu(&chain->entry, hash_head);
 	debug_atomic_inc(&chain_lookup_misses);
-#ifdef CONFIG_TRACE_IRQFLAGS
-	if (current->hardirq_context)
-		nr_hardirq_chains++;
-	else {
-		if (current->softirq_context)
-			nr_softirq_chains++;
-		else
-			nr_process_chains++;
-	}
-#else
-	nr_process_chains++;
-#endif
+	inc_chains();
+
+	return 1;
+}
+
+static int validate_chain(struct task_struct *curr, struct lockdep_map *lock,
+	       	struct held_lock *hlock, int chain_head)
+{
+	/*
+	 * Trylock needs to maintain the stack of held locks, but it
+	 * does not add new dependencies, because trylock can be done
+	 * in any order.
+	 *
+	 * We look up the chain_key and do the O(N^2) check and update of
+	 * the dependencies only if this is a new dependency chain.
+	 * (If lookup_chain_cache() returns with 1 it acquires
+	 * graph_lock for us)
+	 */
+	if (!hlock->trylock && (hlock->check == 2) &&
+			lookup_chain_cache(curr->curr_chain_key, hlock->class)) {
+		/*
+		 * Check whether last held lock:
+		 *
+		 * - is irq-safe, if this lock is irq-unsafe
+		 * - is softirq-safe, if this lock is hardirq-unsafe
+		 *
+		 * And check whether the new lock's dependency graph
+		 * could lead back to the previous lock.
+		 *
+		 * any of these scenarios could lead to a deadlock. If
+		 * All validations
+		 */
+		int ret = check_deadlock(curr, hlock, lock, hlock->read);
+
+		if (!ret)
+			return 0;
+		/*
+		 * Mark recursive read, as we jump over it when
+		 * building dependencies (just like we jump over
+		 * trylock entries):
+		 */
+		if (ret == 2)
+			hlock->read = 2;
+		/*
+		 * Add dependency only if this lock is not the head
+		 * of the chain, and if it's not a secondary read-lock:
+		 */
+		if (!chain_head && ret != 2)
+			if (!check_prevs_add(curr, hlock))
+				return 0;
+		graph_unlock();
+	} else
+		/* after lookup_chain_cache(): */
+		if (unlikely(!debug_locks))
+			return 0;
 
 	return 1;
 }
+#else
+static inline int validate_chain(struct task_struct *curr,
+	       	struct lockdep_map *lock, struct held_lock *hlock,
+		int chain_head)
+{
+	return 1;
+}
 #endif
 
 /*
@@ -1436,6 +1491,57 @@ static void check_chain_key(struct task_
 #endif
 }
 
+static int
+print_usage_bug(struct task_struct *curr, struct held_lock *this,
+		enum lock_usage_bit prev_bit, enum lock_usage_bit new_bit)
+{
+	if (!debug_locks_off_graph_unlock() || debug_locks_silent)
+		return 0;
+
+	printk("\n=================================\n");
+	printk(  "[ INFO: inconsistent lock state ]\n");
+	print_kernel_version();
+	printk(  "---------------------------------\n");
+
+	printk("inconsistent {%s} -> {%s} usage.\n",
+		usage_str[prev_bit], usage_str[new_bit]);
+
+	printk("%s/%d [HC%u[%lu]:SC%u[%lu]:HE%u:SE%u] takes:\n",
+		curr->comm, curr->pid,
+		trace_hardirq_context(curr), hardirq_count() >> HARDIRQ_SHIFT,
+		trace_softirq_context(curr), softirq_count() >> SOFTIRQ_SHIFT,
+		trace_hardirqs_enabled(curr),
+		trace_softirqs_enabled(curr));
+	print_lock(this);
+
+	printk("{%s} state was registered at:\n", usage_str[prev_bit]);
+	print_stack_trace(this->class->usage_traces + prev_bit, 1);
+
+	print_irqtrace_events(curr);
+	printk("\nother info that might help us debug this:\n");
+	lockdep_print_held_locks(curr);
+
+	printk("\nstack backtrace:\n");
+	dump_stack();
+
+	return 0;
+}
+
+/*
+ * Print out an error if an invalid bit is set:
+ */
+static inline int
+valid_state(struct task_struct *curr, struct held_lock *this,
+	    enum lock_usage_bit new_bit, enum lock_usage_bit bad_bit)
+{
+	if (unlikely(this->class->usage_mask & (1 << bad_bit)))
+		return print_usage_bug(curr, this, bad_bit, new_bit);
+	return 1;
+}
+
+static int mark_lock(struct task_struct *curr, struct held_lock *this,
+		     enum lock_usage_bit new_bit);
+
 #ifdef CONFIG_TRACE_IRQFLAGS
 
 /*
@@ -1529,90 +1635,30 @@ void print_irqtrace_events(struct task_s
 	print_ip_sym(curr->softirq_disable_ip);
 }
 
-#endif
-
-static int
-print_usage_bug(struct task_struct *curr, struct held_lock *this,
-		enum lock_usage_bit prev_bit, enum lock_usage_bit new_bit)
+static int hardirq_verbose(struct lock_class *class)
 {
-	if (!debug_locks_off_graph_unlock() || debug_locks_silent)
-		return 0;
-
-	printk("\n=================================\n");
-	printk(  "[ INFO: inconsistent lock state ]\n");
-	print_kernel_version();
-	printk(  "---------------------------------\n");
-
-	printk("inconsistent {%s} -> {%s} usage.\n",
-		usage_str[prev_bit], usage_str[new_bit]);
-
-	printk("%s/%d [HC%u[%lu]:SC%u[%lu]:HE%u:SE%u] takes:\n",
-		curr->comm, curr->pid,
-		trace_hardirq_context(curr), hardirq_count() >> HARDIRQ_SHIFT,
-		trace_softirq_context(curr), softirq_count() >> SOFTIRQ_SHIFT,
-		trace_hardirqs_enabled(curr),
-		trace_softirqs_enabled(curr));
-	print_lock(this);
-
-	printk("{%s} state was registered at:\n", usage_str[prev_bit]);
-	print_stack_trace(this->class->usage_traces + prev_bit, 1);
-
-	print_irqtrace_events(curr);
-	printk("\nother info that might help us debug this:\n");
-	lockdep_print_held_locks(curr);
-
-	printk("\nstack backtrace:\n");
-	dump_stack();
-
+#if HARDIRQ_VERBOSE
+	return class_filter(class);
+#endif
 	return 0;
 }
 
-/*
- * Print out an error if an invalid bit is set:
- */
-static inline int
-valid_state(struct task_struct *curr, struct held_lock *this,
-	    enum lock_usage_bit new_bit, enum lock_usage_bit bad_bit)
+static int softirq_verbose(struct lock_class *class)
 {
-	if (unlikely(this->class->usage_mask & (1 << bad_bit)))
-		return print_usage_bug(curr, this, bad_bit, new_bit);
-	return 1;
+#if SOFTIRQ_VERBOSE
+	return class_filter(class);
+#endif
+	return 0;
 }
 
 #define STRICT_READ_CHECKS	1
 
-/*
- * Mark a lock with a usage bit, and validate the state transition:
- */
-static int mark_lock(struct task_struct *curr, struct held_lock *this,
-		     enum lock_usage_bit new_bit)
+static int mark_lock_irq(struct task_struct *curr, struct held_lock *this,
+		enum lock_usage_bit new_bit)
 {
-	unsigned int new_mask = 1 << new_bit, ret = 1;
-
-	/*
-	 * If already set then do not dirty the cacheline,
-	 * nor do any checks:
-	 */
-	if (likely(this->class->usage_mask & new_mask))
-		return 1;
-
-	if (!graph_lock())
-		return 0;
-	/*
-	 * Make sure we didnt race:
-	 */
-	if (unlikely(this->class->usage_mask & new_mask)) {
-		graph_unlock();
-		return 1;
-	}
-
-	this->class->usage_mask |= new_mask;
+	int ret = 1;
 
-	if (!save_trace(this->class->usage_traces + new_bit))
-		return 0;
-
-	switch (new_bit) {
-#ifdef CONFIG_TRACE_IRQFLAGS
+	switch(new_bit) {
 	case LOCK_USED_IN_HARDIRQ:
 		if (!valid_state(curr, this, new_bit, LOCK_ENABLED_HARDIRQS))
 			return 0;
@@ -1771,37 +1817,14 @@ static int mark_lock(struct task_struct 
 		if (softirq_verbose(this->class))
 			ret = 2;
 		break;
-#endif
-	case LOCK_USED:
-		/*
-		 * Add it to the global list of classes:
-		 */
-		list_add_tail_rcu(&this->class->lock_entry, &all_lock_classes);
-		debug_atomic_dec(&nr_unused_locks);
-		break;
 	default:
-		if (!debug_locks_off_graph_unlock())
-			return 0;
 		WARN_ON(1);
-		return 0;
-	}
-
-	graph_unlock();
-
-	/*
-	 * We must printk outside of the graph_lock:
-	 */
-	if (ret == 2) {
-		printk("\nmarked lock as {%s}:\n", usage_str[new_bit]);
-		print_lock(this);
-		print_irqtrace_events(curr);
-		dump_stack();
+		break;
 	}
 
 	return ret;
 }
 
-#ifdef CONFIG_TRACE_IRQFLAGS
 /*
  * Mark all held locks with a usage bit:
  */
@@ -1890,101 +1913,268 @@ void trace_hardirqs_on(void)
 		if (!mark_held_locks(curr, 0))
 			return;
 
-	curr->hardirq_enable_ip = ip;
-	curr->hardirq_enable_event = ++curr->irq_events;
-	debug_atomic_inc(&hardirqs_on_events);
+	curr->hardirq_enable_ip = ip;
+	curr->hardirq_enable_event = ++curr->irq_events;
+	debug_atomic_inc(&hardirqs_on_events);
+}
+
+EXPORT_SYMBOL(trace_hardirqs_on);
+
+/*
+ * Hardirqs were disabled:
+ */
+void trace_hardirqs_off(void)
+{
+	struct task_struct *curr = current;
+
+	if (unlikely(!debug_locks || current->lockdep_recursion))
+		return;
+
+	if (DEBUG_LOCKS_WARN_ON(!irqs_disabled()))
+		return;
+
+	if (curr->hardirqs_enabled) {
+		/*
+		 * We have done an ON -> OFF transition:
+		 */
+		curr->hardirqs_enabled = 0;
+		curr->hardirq_disable_ip = _RET_IP_;
+		curr->hardirq_disable_event = ++curr->irq_events;
+		debug_atomic_inc(&hardirqs_off_events);
+	} else
+		debug_atomic_inc(&redundant_hardirqs_off);
+}
+
+EXPORT_SYMBOL(trace_hardirqs_off);
+
+/*
+ * Softirqs will be enabled:
+ */
+void trace_softirqs_on(unsigned long ip)
+{
+	struct task_struct *curr = current;
+
+	if (unlikely(!debug_locks))
+		return;
+
+	if (DEBUG_LOCKS_WARN_ON(!irqs_disabled()))
+		return;
+
+	if (curr->softirqs_enabled) {
+		debug_atomic_inc(&redundant_softirqs_on);
+		return;
+	}
+
+	/*
+	 * We'll do an OFF -> ON transition:
+	 */
+	curr->softirqs_enabled = 1;
+	curr->softirq_enable_ip = ip;
+	curr->softirq_enable_event = ++curr->irq_events;
+	debug_atomic_inc(&softirqs_on_events);
+	/*
+	 * We are going to turn softirqs on, so set the
+	 * usage bit for all held locks, if hardirqs are
+	 * enabled too:
+	 */
+	if (curr->hardirqs_enabled)
+		mark_held_locks(curr, 0);
+}
+
+/*
+ * Softirqs were disabled:
+ */
+void trace_softirqs_off(unsigned long ip)
+{
+	struct task_struct *curr = current;
+
+	if (unlikely(!debug_locks))
+		return;
+
+	if (DEBUG_LOCKS_WARN_ON(!irqs_disabled()))
+		return;
+
+	if (curr->softirqs_enabled) {
+		/*
+		 * We have done an ON -> OFF transition:
+		 */
+		curr->softirqs_enabled = 0;
+		curr->softirq_disable_ip = ip;
+		curr->softirq_disable_event = ++curr->irq_events;
+		debug_atomic_inc(&softirqs_off_events);
+		DEBUG_LOCKS_WARN_ON(!softirq_count());
+	} else
+		debug_atomic_inc(&redundant_softirqs_off);
+}
+
+static int mark_irqflags(struct task_struct *curr, struct held_lock *hlock)
+{
+	/*
+	 * If non-trylock use in a hardirq or softirq context, then
+	 * mark the lock as used in these contexts:
+	 */
+	if (!hlock->trylock) {
+		if (hlock->read) {
+			if (curr->hardirq_context)
+				if (!mark_lock(curr, hlock,
+						LOCK_USED_IN_HARDIRQ_READ))
+					return 0;
+			if (curr->softirq_context)
+				if (!mark_lock(curr, hlock,
+						LOCK_USED_IN_SOFTIRQ_READ))
+					return 0;
+		} else {
+			if (curr->hardirq_context)
+				if (!mark_lock(curr, hlock, LOCK_USED_IN_HARDIRQ))
+					return 0;
+			if (curr->softirq_context)
+				if (!mark_lock(curr, hlock, LOCK_USED_IN_SOFTIRQ))
+					return 0;
+		}
+	}
+	if (!hlock->hardirqs_off) {
+		if (hlock->read) {
+			if (!mark_lock(curr, hlock,
+					LOCK_ENABLED_HARDIRQS_READ))
+				return 0;
+			if (curr->softirqs_enabled)
+				if (!mark_lock(curr, hlock,
+						LOCK_ENABLED_SOFTIRQS_READ))
+					return 0;
+		} else {
+			if (!mark_lock(curr, hlock,
+					LOCK_ENABLED_HARDIRQS))
+				return 0;
+			if (curr->softirqs_enabled)
+				if (!mark_lock(curr, hlock,
+						LOCK_ENABLED_SOFTIRQS))
+					return 0;
+		}
+	}
+
+	return 1;
+}
+
+static int separate_irq_context(struct task_struct *curr,
+		struct held_lock *hlock)
+{
+	unsigned int depth = curr->lockdep_depth;
+
+	/*
+	 * Keep track of points where we cross into an interrupt context:
+	 */
+	hlock->irq_context = 2*(curr->hardirq_context ? 1 : 0) +
+				curr->softirq_context;
+	if (depth) {
+		struct held_lock *prev_hlock;
+
+		prev_hlock = curr->held_locks + depth-1;
+		/*
+		 * If we cross into another context, reset the
+		 * hash key (this also prevents the checking and the
+		 * adding of the dependency to 'prev'):
+		 */
+		if (prev_hlock->irq_context != hlock->irq_context)
+			return 1;
+	}
+	return 0;
 }
 
-EXPORT_SYMBOL(trace_hardirqs_on);
+#else
 
-/*
- * Hardirqs were disabled:
- */
-void trace_hardirqs_off(void)
+static inline
+int mark_lock_irq(struct task_struct *curr, struct held_lock *this,
+		enum lock_usage_bit new_bit)
 {
-	struct task_struct *curr = current;
-
-	if (unlikely(!debug_locks || current->lockdep_recursion))
-		return;
+	WARN_ON(1);
+	return 1;
+}
 
-	if (DEBUG_LOCKS_WARN_ON(!irqs_disabled()))
-		return;
+static inline int mark_irqflags(struct task_struct *curr,
+		struct held_lock *hlock)
+{
+	return 1;
+}
 
-	if (curr->hardirqs_enabled) {
-		/*
-		 * We have done an ON -> OFF transition:
-		 */
-		curr->hardirqs_enabled = 0;
-		curr->hardirq_disable_ip = _RET_IP_;
-		curr->hardirq_disable_event = ++curr->irq_events;
-		debug_atomic_inc(&hardirqs_off_events);
-	} else
-		debug_atomic_inc(&redundant_hardirqs_off);
+static inline int separate_irq_context(struct task_struct *curr,
+		struct held_lock *hlock)
+{
+	return 0;
 }
 
-EXPORT_SYMBOL(trace_hardirqs_off);
+#endif
 
 /*
- * Softirqs will be enabled:
+ * Mark a lock with a usage bit, and validate the state transition:
  */
-void trace_softirqs_on(unsigned long ip)
+static int mark_lock(struct task_struct *curr, struct held_lock *this,
+		     enum lock_usage_bit new_bit)
 {
-	struct task_struct *curr = current;
-
-	if (unlikely(!debug_locks))
-		return;
-
-	if (DEBUG_LOCKS_WARN_ON(!irqs_disabled()))
-		return;
-
-	if (curr->softirqs_enabled) {
-		debug_atomic_inc(&redundant_softirqs_on);
-		return;
-	}
+	unsigned int new_mask = 1 << new_bit, ret = 1;
 
 	/*
-	 * We'll do an OFF -> ON transition:
+	 * If already set then do not dirty the cacheline,
+	 * nor do any checks:
 	 */
-	curr->softirqs_enabled = 1;
-	curr->softirq_enable_ip = ip;
-	curr->softirq_enable_event = ++curr->irq_events;
-	debug_atomic_inc(&softirqs_on_events);
+	if (likely(this->class->usage_mask & new_mask))
+		return 1;
+
+	if (!graph_lock())
+		return 0;
 	/*
-	 * We are going to turn softirqs on, so set the
-	 * usage bit for all held locks, if hardirqs are
-	 * enabled too:
+	 * Make sure we didnt race:
 	 */
-	if (curr->hardirqs_enabled)
-		mark_held_locks(curr, 0);
-}
-
-/*
- * Softirqs were disabled:
- */
-void trace_softirqs_off(unsigned long ip)
-{
-	struct task_struct *curr = current;
+	if (unlikely(this->class->usage_mask & new_mask)) {
+		graph_unlock();
+		return 1;
+	}
 
-	if (unlikely(!debug_locks))
-		return;
+	this->class->usage_mask |= new_mask;
 
-	if (DEBUG_LOCKS_WARN_ON(!irqs_disabled()))
-		return;
+	if (!save_trace(this->class->usage_traces + new_bit))
+		return 0;
 
-	if (curr->softirqs_enabled) {
+	switch (new_bit) {
+	case LOCK_USED_IN_HARDIRQ:
+	case LOCK_USED_IN_SOFTIRQ:
+	case LOCK_USED_IN_HARDIRQ_READ:
+	case LOCK_USED_IN_SOFTIRQ_READ:
+	case LOCK_ENABLED_HARDIRQS:
+	case LOCK_ENABLED_SOFTIRQS:
+	case LOCK_ENABLED_HARDIRQS_READ:
+	case LOCK_ENABLED_SOFTIRQS_READ:
+		ret = mark_lock_irq(curr, this, new_bit);
+		if (!ret)
+			return 0;
+		break;
+	case LOCK_USED:
 		/*
-		 * We have done an ON -> OFF transition:
+		 * Add it to the global list of classes:
 		 */
-		curr->softirqs_enabled = 0;
-		curr->softirq_disable_ip = ip;
-		curr->softirq_disable_event = ++curr->irq_events;
-		debug_atomic_inc(&softirqs_off_events);
-		DEBUG_LOCKS_WARN_ON(!softirq_count());
-	} else
-		debug_atomic_inc(&redundant_softirqs_off);
-}
+		list_add_tail_rcu(&this->class->lock_entry, &all_lock_classes);
+		debug_atomic_dec(&nr_unused_locks);
+		break;
+	default:
+		if (!debug_locks_off_graph_unlock())
+			return 0;
+		WARN_ON(1);
+		return 0;
+	}
 
-#endif
+	graph_unlock();
+
+	/*
+	 * We must printk outside of the graph_lock:
+	 */
+	if (ret == 2) {
+		printk("\nmarked lock as {%s}:\n", usage_str[new_bit]);
+		print_lock(this);
+		print_irqtrace_events(curr);
+		dump_stack();
+	}
+
+	return ret;
+}
 
 /*
  * Initialize a lock instance's lock-class mapping info:
@@ -2082,56 +2272,13 @@ static int __lock_acquire(struct lockdep
 	hlock->check = check;
 	hlock->hardirqs_off = hardirqs_off;
 
-	if (check != 2)
-		goto out_calc_hash;
-#ifdef CONFIG_TRACE_IRQFLAGS
-	/*
-	 * If non-trylock use in a hardirq or softirq context, then
-	 * mark the lock as used in these contexts:
-	 */
-	if (!trylock) {
-		if (read) {
-			if (curr->hardirq_context)
-				if (!mark_lock(curr, hlock,
-						LOCK_USED_IN_HARDIRQ_READ))
-					return 0;
-			if (curr->softirq_context)
-				if (!mark_lock(curr, hlock,
-						LOCK_USED_IN_SOFTIRQ_READ))
-					return 0;
-		} else {
-			if (curr->hardirq_context)
-				if (!mark_lock(curr, hlock, LOCK_USED_IN_HARDIRQ))
-					return 0;
-			if (curr->softirq_context)
-				if (!mark_lock(curr, hlock, LOCK_USED_IN_SOFTIRQ))
-					return 0;
-		}
-	}
-	if (!hardirqs_off) {
-		if (read) {
-			if (!mark_lock(curr, hlock,
-					LOCK_ENABLED_HARDIRQS_READ))
-				return 0;
-			if (curr->softirqs_enabled)
-				if (!mark_lock(curr, hlock,
-						LOCK_ENABLED_SOFTIRQS_READ))
-					return 0;
-		} else {
-			if (!mark_lock(curr, hlock,
-					LOCK_ENABLED_HARDIRQS))
-				return 0;
-			if (curr->softirqs_enabled)
-				if (!mark_lock(curr, hlock,
-						LOCK_ENABLED_SOFTIRQS))
-					return 0;
-		}
-	}
-#endif
+	if (check == 2 && !mark_irqflags(curr, hlock))
+		return 0;
+
 	/* mark it as used: */
 	if (!mark_lock(curr, hlock, LOCK_USED))
 		return 0;
-out_calc_hash:
+
 	/*
 	 * Calculate the chain hash: it's the combined has of all the
 	 * lock keys along the dependency chain. We save the hash value
@@ -2154,77 +2301,15 @@ out_calc_hash:
 	}
 
 	hlock->prev_chain_key = chain_key;
-
-#ifdef CONFIG_TRACE_IRQFLAGS
-	/*
-	 * Keep track of points where we cross into an interrupt context:
-	 */
-	hlock->irq_context = 2*(curr->hardirq_context ? 1 : 0) +
-				curr->softirq_context;
-	if (depth) {
-		struct held_lock *prev_hlock;
-
-		prev_hlock = curr->held_locks + depth-1;
-		/*
-		 * If we cross into another context, reset the
-		 * hash key (this also prevents the checking and the
-		 * adding of the dependency to 'prev'):
-		 */
-		if (prev_hlock->irq_context != hlock->irq_context) {
-			chain_key = 0;
-			chain_head = 1;
-		}
+	if (separate_irq_context(curr, hlock)) {
+		chain_key = 0;
+		chain_head = 1;
 	}
-#endif
 	chain_key = iterate_chain_key(chain_key, id);
 	curr->curr_chain_key = chain_key;
 
-	/*
-	 * Trylock needs to maintain the stack of held locks, but it
-	 * does not add new dependencies, because trylock can be done
-	 * in any order.
-	 *
-	 * We look up the chain_key and do the O(N^2) check and update of
-	 * the dependencies only if this is a new dependency chain.
-	 * (If lookup_chain_cache() returns with 1 it acquires
-	 * graph_lock for us)
-	 */
-	if (!trylock && (check == 2) && lookup_chain_cache(chain_key, class)) {
-		/*
-		 * Check whether last held lock:
-		 *
-		 * - is irq-safe, if this lock is irq-unsafe
-		 * - is softirq-safe, if this lock is hardirq-unsafe
-		 *
-		 * And check whether the new lock's dependency graph
-		 * could lead back to the previous lock.
-		 *
-		 * any of these scenarios could lead to a deadlock. If
-		 * All validations
-		 */
-		int ret = check_deadlock(curr, hlock, lock, read);
-
-		if (!ret)
-			return 0;
-		/*
-		 * Mark recursive read, as we jump over it when
-		 * building dependencies (just like we jump over
-		 * trylock entries):
-		 */
-		if (ret == 2)
-			hlock->read = 2;
-		/*
-		 * Add dependency only if this lock is not the head
-		 * of the chain, and if it's not a secondary read-lock:
-		 */
-		if (!chain_head && ret != 2)
-			if (!check_prevs_add(curr, hlock))
-				return 0;
-		graph_unlock();
-	} else
-		/* after lookup_chain_cache(): */
-		if (unlikely(!debug_locks))
-			return 0;
+	if (!validate_chain(curr, lock, hlock, chain_head))
+		return 0;
 
 	curr->lockdep_depth++;
 	check_chain_key(curr);
diff -puN kernel/lockdep_proc.c~lockdep-reduce-the-ifdeffery kernel/lockdep_proc.c
--- a/kernel/lockdep_proc.c~lockdep-reduce-the-ifdeffery
+++ a/kernel/lockdep_proc.c
@@ -271,8 +271,10 @@ static int lockdep_stats_show(struct seq
 	if (nr_list_entries)
 		factor = sum_forward_deps / nr_list_entries;
 
+#ifdef CONFIG_PROVE_LOCKING
 	seq_printf(m, " dependency chains:             %11lu [max: %lu]\n",
 			nr_lock_chains, MAX_LOCKDEP_CHAINS);
+#endif
 
 #ifdef CONFIG_TRACE_IRQFLAGS
 	seq_printf(m, " in-hardirq chains:             %11u\n",
_

Patches currently in -mm which might be from a.p.zijlstra@chello.nl are

origin.patch
intel-iommu-dmar-detection-and-parsing-logic.patch
intel-iommu-pci-generic-helper-function.patch
intel-iommu-clflush_cache_range-now-takes-size-param.patch
intel-iommu-iova-allocation-and-management-routines.patch
intel-iommu-intel-iommu-driver.patch
intel-iommu-avoid-memory-allocation-failures-in-dma-map-api-calls.patch
intel-iommu-intel-iommu-cmdline-option-forcedac.patch
intel-iommu-dmar-fault-handling-support.patch
intel-iommu-iommu-gfx-workaround.patch
intel-iommu-iommu-floppy-workaround.patch
