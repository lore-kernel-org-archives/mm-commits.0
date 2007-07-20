From: akpm@linux-foundation.org
Subject: + spufs-add-spu-stats-in-sysfs-and-ctx-stat-file-in-spufs.patch added to -mm tree
Date: Fri, 20 Jul 2007 11:50:55 -0700
Message-ID: <200707201850.l6KIotFO010862@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37113 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760899AbXGTSvL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 20 Jul 2007 14:51:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adetsch@br.ibm.com, benh@kernel.crashing.org, jk@ozlabs.org, paulus@samba.org


The patch titled
     spufs: add spu stats in sysfs and ctx stat file in spufs
has been added to the -mm tree.  Its filename is
     spufs-add-spu-stats-in-sysfs-and-ctx-stat-file-in-spufs.patch

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to =
find
out what to do about this

------------------------------------------------------
Subject: spufs: add spu stats in sysfs and ctx stat file in spufs
=46rom: Andre Detsch <adetsch@br.ibm.com>

This patch exports per-context statistics in spufs as long as spu stati=
stics
in sysfs.

It was formed by merging:
"spufs: add spu stats in sysfs"   From: Christoph Hellwig
"spufs: add stat file to spufs"   From: Christoph Hellwig
"spufs: fix libassist accounting" From: Jeremy Kerr
"spusched: fix spu utilization statistics" From: Luke Browning
And some adjustments by myself, after suggestions on cbe-oss-dev.

Having separate patches was making the review process harder than it sh=
ould,
as we end up integrating spus and ctx statistics accounting much more t=
han it
was on the first implementation.

Signed-off-by: Andr=C3=A9 Detsch <adetsch@br.ibm.com>
Signed-off-by: Jeremy Kerr <jk@ozlabs.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/platforms/cell/spu_base.c      |   24 ++++--
 arch/powerpc/platforms/cell/spufs/context.c |    3=20
 arch/powerpc/platforms/cell/spufs/fault.c   |    8 --
 arch/powerpc/platforms/cell/spufs/file.c    |   32 ++++++---
 arch/powerpc/platforms/cell/spufs/run.c     |   10 ++
 arch/powerpc/platforms/cell/spufs/sched.c   |   22 ++----
 arch/powerpc/platforms/cell/spufs/spufs.h   |   63 +++++++-----------
 include/asm-powerpc/spu.h                   |   10 +-
 8 files changed, 94 insertions(+), 78 deletions(-)

diff -puN arch/powerpc/platforms/cell/spu_base.c~spufs-add-spu-stats-in=
-sysfs-and-ctx-stat-file-in-spufs arch/powerpc/platforms/cell/spu_base.=
c
--- a/arch/powerpc/platforms/cell/spu_base.c~spufs-add-spu-stats-in-sys=
fs-and-ctx-stat-file-in-spufs
+++ a/arch/powerpc/platforms/cell/spu_base.c
@@ -553,6 +553,7 @@ static int __init create_spu(void *data)
 	int ret;
 	static int number;
 	unsigned long flags;
+	struct timespec ts;
=20
 	ret =3D -ENOMEM;
 	spu =3D kzalloc(sizeof (*spu), GFP_KERNEL);
@@ -586,8 +587,9 @@ static int __init create_spu(void *data)
 	spin_unlock_irqrestore(&spu_list_lock, flags);
 	mutex_unlock(&spu_mutex);
=20
-	spu->stats.utilization_state =3D SPU_UTIL_IDLE;
-	spu->stats.tstamp =3D jiffies;
+	spu->stats.util_state =3D SPU_UTIL_IDLE_LOADED;
+	ktime_get_ts(&ts);
+	spu->stats.tstamp =3D timespec_to_ns(&ts);
=20
 	goto out;
=20
@@ -608,12 +610,20 @@ static const char *spu_state_names[] =3D {
 static unsigned long long spu_acct_time(struct spu *spu,
 		enum spu_utilization_state state)
 {
+	struct timespec ts;
 	unsigned long long time =3D spu->stats.times[state];
=20
-	if (spu->stats.utilization_state =3D=3D state)
-		time +=3D jiffies - spu->stats.tstamp;
+	/*
+	 * If the spu is idle or the context is stopped, utilization
+	 * statistics are not updated.  Apply the time delta from the
+	 * last recorded state of the spu.
+	 */
+	if (spu->stats.util_state =3D=3D state) {
+		ktime_get_ts(&ts);
+		time +=3D timespec_to_ns(&ts) - spu->stats.tstamp;
+	}
=20
-	return jiffies_to_msecs(time);
+	return time / NSEC_PER_MSEC;
 }
=20
=20
@@ -623,11 +633,11 @@ static ssize_t spu_stat_show(struct sys_
=20
 	return sprintf(buf, "%s %llu %llu %llu %llu "
 		      "%llu %llu %llu %llu %llu %llu %llu %llu\n",
-		spu_state_names[spu->stats.utilization_state],
+		spu_state_names[spu->stats.util_state],
 		spu_acct_time(spu, SPU_UTIL_USER),
 		spu_acct_time(spu, SPU_UTIL_SYSTEM),
 		spu_acct_time(spu, SPU_UTIL_IOWAIT),
-		spu_acct_time(spu, SPU_UTIL_IDLE),
+		spu_acct_time(spu, SPU_UTIL_IDLE_LOADED),
 		spu->stats.vol_ctx_switch,
 		spu->stats.invol_ctx_switch,
 		spu->stats.slb_flt,
diff -puN arch/powerpc/platforms/cell/spufs/context.c~spufs-add-spu-sta=
ts-in-sysfs-and-ctx-stat-file-in-spufs arch/powerpc/platforms/cell/spuf=
s/context.c
--- a/arch/powerpc/platforms/cell/spufs/context.c~spufs-add-spu-stats-i=
n-sysfs-and-ctx-stat-file-in-spufs
+++ a/arch/powerpc/platforms/cell/spufs/context.c
@@ -60,8 +60,7 @@ struct spu_context *alloc_spu_context(st
 		spu_gang_add_ctx(gang, ctx);
 	ctx->cpus_allowed =3D current->cpus_allowed;
 	spu_set_timeslice(ctx);
-	ctx->stats.execution_state =3D SPUCTX_UTIL_USER;
-	ctx->stats.tstamp =3D jiffies;
+	ctx->stats.util_state =3D SPU_UTIL_IDLE_LOADED;
=20
 	atomic_inc(&nr_spu_contexts);
 	goto out;
diff -puN arch/powerpc/platforms/cell/spufs/fault.c~spufs-add-spu-stats=
-in-sysfs-and-ctx-stat-file-in-spufs arch/powerpc/platforms/cell/spufs/=
fault.c
--- a/arch/powerpc/platforms/cell/spufs/fault.c~spufs-add-spu-stats-in-=
sysfs-and-ctx-stat-file-in-spufs
+++ a/arch/powerpc/platforms/cell/spufs/fault.c
@@ -179,16 +179,14 @@ int spufs_handle_class1(struct spu_conte
 	if (!(dsisr & (MFC_DSISR_PTE_NOT_FOUND | MFC_DSISR_ACCESS_DENIED)))
 		return 0;
=20
-	spuctx_switch_state(ctx, SPUCTX_UTIL_IOWAIT);
+	spuctx_switch_state(ctx, SPU_UTIL_IOWAIT);
=20
 	pr_debug("ctx %p: ea %016lx, dsisr %016lx state %d\n", ctx, ea,
 		dsisr, ctx->state);
=20
 	ctx->stats.hash_flt++;
-	if (ctx->state =3D=3D SPU_STATE_RUNNABLE) {
+	if (ctx->state =3D=3D SPU_STATE_RUNNABLE)
 		ctx->spu->stats.hash_flt++;
-		spu_switch_state(ctx->spu, SPU_UTIL_IOWAIT);
-	}
=20
 	/* we must not hold the lock when entering spu_handle_mm_fault */
 	spu_release(ctx);
@@ -226,7 +224,7 @@ int spufs_handle_class1(struct spu_conte
 	} else
 		spufs_handle_dma_error(ctx, ea, SPE_EVENT_SPE_DATA_STORAGE);
=20
-	spuctx_switch_state(ctx, SPUCTX_UTIL_SYSTEM);
+	spuctx_switch_state(ctx, SPU_UTIL_SYSTEM);
 	return ret;
 }
 EXPORT_SYMBOL_GPL(spufs_handle_class1);
diff -puN arch/powerpc/platforms/cell/spufs/file.c~spufs-add-spu-stats-=
in-sysfs-and-ctx-stat-file-in-spufs arch/powerpc/platforms/cell/spufs/f=
ile.c
--- a/arch/powerpc/platforms/cell/spufs/file.c~spufs-add-spu-stats-in-s=
ysfs-and-ctx-stat-file-in-spufs
+++ a/arch/powerpc/platforms/cell/spufs/file.c
@@ -2079,14 +2079,26 @@ static const char *ctx_state_names[] =3D {
 };
=20
 static unsigned long long spufs_acct_time(struct spu_context *ctx,
-		enum spuctx_execution_state state)
+		enum spu_utilization_state state)
 {
-	unsigned long time =3D ctx->stats.times[state];
+	struct timespec ts;
+	unsigned long long time =3D ctx->stats.times[state];
=20
-	if (ctx->stats.execution_state =3D=3D state)
-		time +=3D jiffies - ctx->stats.tstamp;
+	/*
+	 * In general, utilization statistics are updated by the controlling
+	 * thread as the spu context moves through various well defined
+	 * state transitions, but if the context is lazily loaded its
+	 * utilization statistics are not updated as the controlling thread
+	 * is not tightly coupled with the execution of the spu context.  We
+	 * calculate and apply the time delta from the last recorded state
+	 * of the spu context.
+	 */
+	if (ctx->spu && ctx->stats.util_state =3D=3D state) {
+		ktime_get_ts(&ts);
+		time +=3D timespec_to_ns(&ts) - ctx->stats.tstamp;
+	}
=20
-	return jiffies_to_msecs(time);
+	return time / NSEC_PER_MSEC;
 }
=20
 static unsigned long long spufs_slb_flts(struct spu_context *ctx)
@@ -2121,11 +2133,11 @@ static int spufs_show_stat(struct seq_fi
 	spu_acquire(ctx);
 	seq_printf(s, "%s %llu %llu %llu %llu "
 		      "%llu %llu %llu %llu %llu %llu %llu %llu\n",
-		ctx_state_names[ctx->stats.execution_state],
-		spufs_acct_time(ctx, SPUCTX_UTIL_USER),
-		spufs_acct_time(ctx, SPUCTX_UTIL_SYSTEM),
-		spufs_acct_time(ctx, SPUCTX_UTIL_IOWAIT),
-		spufs_acct_time(ctx, SPUCTX_UTIL_LOADED),
+		ctx_state_names[ctx->stats.util_state],
+		spufs_acct_time(ctx, SPU_UTIL_USER),
+		spufs_acct_time(ctx, SPU_UTIL_SYSTEM),
+		spufs_acct_time(ctx, SPU_UTIL_IOWAIT),
+		spufs_acct_time(ctx, SPU_UTIL_IDLE_LOADED),
 		ctx->stats.vol_ctx_switch,
 		ctx->stats.invol_ctx_switch,
 		spufs_slb_flts(ctx),
diff -puN arch/powerpc/platforms/cell/spufs/run.c~spufs-add-spu-stats-i=
n-sysfs-and-ctx-stat-file-in-spufs arch/powerpc/platforms/cell/spufs/ru=
n.c
--- a/arch/powerpc/platforms/cell/spufs/run.c~spufs-add-spu-stats-in-sy=
sfs-and-ctx-stat-file-in-spufs
+++ a/arch/powerpc/platforms/cell/spufs/run.c
@@ -128,6 +128,8 @@ out:
=20
 static int spu_run_init(struct spu_context *ctx, u32 *npc)
 {
+	spuctx_switch_state(ctx, SPU_UTIL_SYSTEM);
+
 	if (ctx->flags & SPU_CREATE_ISOLATE) {
 		unsigned long runcntl;
=20
@@ -153,6 +155,8 @@ static int spu_run_init(struct spu_conte
 		ctx->ops->runcntl_write(ctx, SPU_RUNCNTL_RUNNABLE);
 	}
=20
+	spuctx_switch_state(ctx, SPU_UTIL_USER);
+
 	return 0;
 }
=20
@@ -163,6 +167,8 @@ static int spu_run_fini(struct spu_conte
=20
 	*status =3D ctx->ops->status_read(ctx);
 	*npc =3D ctx->ops->npc_read(ctx);
+
+	spuctx_switch_state(ctx, SPU_UTIL_IDLE_LOADED);
 	spu_release(ctx);
=20
 	if (signal_pending(current))
@@ -332,6 +338,9 @@ long spufs_run_spu(struct file *file, st
 		spu =3D ctx->spu;
 		if (unlikely(ret))
 			break;
+
+ 		spuctx_switch_state(ctx, SPU_UTIL_SYSTEM);
+
 		if (unlikely(test_and_clear_bit(SPU_SCHED_NOTIFY_ACTIVE,
 						&ctx->sched_flags))) {
 			if (!(status & SPU_STATUS_STOPPED_BY_STOP)) {
@@ -367,6 +376,7 @@ long spufs_run_spu(struct file *file, st
 	    (ctx->state =3D=3D SPU_STATE_RUNNABLE))
 		ctx->stats.libassist++;
=20
+
 	ctx->ops->master_stop(ctx);
 	ret =3D spu_run_fini(ctx, npc, &status);
 	spu_yield(ctx);
diff -puN arch/powerpc/platforms/cell/spufs/sched.c~spufs-add-spu-stats=
-in-sysfs-and-ctx-stat-file-in-spufs arch/powerpc/platforms/cell/spufs/=
sched.c
--- a/arch/powerpc/platforms/cell/spufs/sched.c~spufs-add-spu-stats-in-=
sysfs-and-ctx-stat-file-in-spufs
+++ a/arch/powerpc/platforms/cell/spufs/sched.c
@@ -258,6 +258,7 @@ static void spu_bind_context(struct spu=20
 {
 	pr_debug("%s: pid=3D%d SPU=3D%d NODE=3D%d\n", __FUNCTION__, current->=
pid,
 		 spu->number, spu->node);
+	spuctx_switch_state(ctx, SPU_UTIL_SYSTEM);
=20
 	ctx->stats.slb_flt_base =3D spu->stats.slb_flt;
 	ctx->stats.class2_intr_base =3D spu->stats.class2_intr;
@@ -281,7 +282,8 @@ static void spu_bind_context(struct spu=20
 	spu_cpu_affinity_set(spu, raw_smp_processor_id());
 	spu_switch_notify(spu, ctx);
 	ctx->state =3D SPU_STATE_RUNNABLE;
-	spu_switch_state(spu, SPU_UTIL_SYSTEM);
+
+	spuctx_switch_state(ctx, SPU_UTIL_IDLE_LOADED);
 }
=20
 /**
@@ -293,8 +295,7 @@ static void spu_unbind_context(struct sp
 {
 	pr_debug("%s: unbind pid=3D%d SPU=3D%d NODE=3D%d\n", __FUNCTION__,
 		 spu->pid, spu->number, spu->node);
-
-	spu_switch_state(spu, SPU_UTIL_IDLE);
+	spuctx_switch_state(ctx, SPU_UTIL_SYSTEM);
=20
 	spu_switch_notify(spu, NULL);
 	spu_unmap_mappings(ctx);
@@ -310,7 +311,6 @@ static void spu_unbind_context(struct sp
 	spu->pid =3D 0;
 	spu->tgid =3D 0;
 	ctx->ops =3D &spu_backing_ops;
-	ctx->spu =3D NULL;
 	spu->flags =3D 0;
 	spu->ctx =3D NULL;
=20
@@ -318,6 +318,10 @@ static void spu_unbind_context(struct sp
 		(spu->stats.slb_flt - ctx->stats.slb_flt_base);
 	ctx->stats.class2_intr +=3D
 		(spu->stats.class2_intr - ctx->stats.class2_intr_base);
+
+	/* This maps the underlying spu state to idle */
+	spuctx_switch_state(ctx, SPU_UTIL_IDLE_LOADED);
+	ctx->spu =3D NULL;
 }
=20
 /**
@@ -486,8 +490,6 @@ static struct spu *find_victim(struct sp
  */
 int spu_activate(struct spu_context *ctx, unsigned long flags)
 {
-	spuctx_switch_state(ctx, SPUCTX_UTIL_SYSTEM);
-
 	do {
 		struct spu *spu;
=20
@@ -582,7 +584,6 @@ static int __spu_deactivate(struct spu_c
 void spu_deactivate(struct spu_context *ctx)
 {
 	__spu_deactivate(ctx, 1, MAX_PRIO);
-	spuctx_switch_state(ctx, SPUCTX_UTIL_USER);
 }
=20
 /**
@@ -597,12 +598,7 @@ void spu_yield(struct spu_context *ctx)
 {
 	if (!(ctx->flags & SPU_CREATE_NOSCHED)) {
 		mutex_lock(&ctx->state_mutex);
-		if (__spu_deactivate(ctx, 0, MAX_PRIO))
-			spuctx_switch_state(ctx, SPUCTX_UTIL_USER);
-		else {
-			spuctx_switch_state(ctx, SPUCTX_UTIL_LOADED);
-			spu_switch_state(ctx->spu, SPU_UTIL_USER);
-		}
+		__spu_deactivate(ctx, 0, MAX_PRIO);
 		mutex_unlock(&ctx->state_mutex);
 	}
 }
diff -puN arch/powerpc/platforms/cell/spufs/spufs.h~spufs-add-spu-stats=
-in-sysfs-and-ctx-stat-file-in-spufs arch/powerpc/platforms/cell/spufs/=
spufs.h
--- a/arch/powerpc/platforms/cell/spufs/spufs.h~spufs-add-spu-stats-in-=
sysfs-and-ctx-stat-file-in-spufs
+++ a/arch/powerpc/platforms/cell/spufs/spufs.h
@@ -40,19 +40,6 @@ enum {
 struct spu_context_ops;
 struct spu_gang;
=20
-/*
- * This is the state for spu utilization reporting to userspace.
- * Because this state is visible to userspace it must never change and=
 needs
- * to be kept strictly separate from any internal state kept by the ke=
rnel.
- */
-enum spuctx_execution_state {
-	SPUCTX_UTIL_USER =3D 0,
-	SPUCTX_UTIL_SYSTEM,
-	SPUCTX_UTIL_IOWAIT,
-	SPUCTX_UTIL_LOADED,
-	SPUCTX_UTIL_MAX
-};
-
 /* ctx->sched_flags */
 enum {
 	SPU_SCHED_NOTIFY_ACTIVE,
@@ -111,9 +98,9 @@ struct spu_context {
 	/* statistics */
 	struct {
 		/* updates protected by ctx->state_mutex */
-		enum spuctx_execution_state execution_state;
-		unsigned long tstamp;		/* time of last ctx switch */
-		unsigned long times[SPUCTX_UTIL_MAX];
+		enum spu_utilization_state util_state;
+		unsigned long long tstamp;	/* time of last state switch */
+		unsigned long long times[SPU_UTIL_MAX];
 		unsigned long long vol_ctx_switch;
 		unsigned long long invol_ctx_switch;
 		unsigned long long min_flt;
@@ -301,30 +288,34 @@ extern int spufs_coredump_num_notes;
  * line.
  */
 static inline void spuctx_switch_state(struct spu_context *ctx,
-		enum spuctx_execution_state new_state)
+		enum spu_utilization_state new_state)
 {
-	WARN_ON(!mutex_is_locked(&ctx->state_mutex));
-
-	if (ctx->stats.execution_state !=3D new_state) {
-		unsigned long curtime =3D jiffies;
+	unsigned long long curtime;
+	signed long long delta;
+	struct timespec ts;
+	struct spu *spu;
+	enum spu_utilization_state old_state;
+
+	ktime_get_ts(&ts);
+	curtime =3D timespec_to_ns(&ts);
+	delta =3D curtime - ctx->stats.tstamp;
=20
-		ctx->stats.times[ctx->stats.execution_state] +=3D
-				 curtime - ctx->stats.tstamp;
-		ctx->stats.tstamp =3D curtime;
-		ctx->stats.execution_state =3D new_state;
-	}
-}
-
-static inline void spu_switch_state(struct spu *spu,
-		enum spuctx_execution_state new_state)
-{
-	if (spu->stats.utilization_state !=3D new_state) {
-		unsigned long curtime =3D jiffies;
+	WARN_ON(!mutex_is_locked(&ctx->state_mutex));
+	WARN_ON(delta < 0);
=20
-		spu->stats.times[spu->stats.utilization_state] +=3D
-				 curtime - spu->stats.tstamp;
+	spu =3D ctx->spu;
+	old_state =3D ctx->stats.util_state;
+	ctx->stats.util_state =3D new_state;
+	ctx->stats.tstamp =3D curtime;
+
+	/*
+	 * Update the physical SPU utilization statistics.
+	 */
+	if (spu) {
+		ctx->stats.times[old_state] +=3D delta;
+		spu->stats.times[old_state] +=3D delta;
+		spu->stats.util_state =3D new_state;
 		spu->stats.tstamp =3D curtime;
-		spu->stats.utilization_state =3D new_state;
 	}
 }
=20
diff -puN include/asm-powerpc/spu.h~spufs-add-spu-stats-in-sysfs-and-ct=
x-stat-file-in-spufs include/asm-powerpc/spu.h
--- a/include/asm-powerpc/spu.h~spufs-add-spu-stats-in-sysfs-and-ctx-st=
at-file-in-spufs
+++ a/include/asm-powerpc/spu.h
@@ -107,10 +107,10 @@ struct spu_runqueue;
 struct device_node;
=20
 enum spu_utilization_state {
-	SPU_UTIL_SYSTEM,
 	SPU_UTIL_USER,
+	SPU_UTIL_SYSTEM,
 	SPU_UTIL_IOWAIT,
-	SPU_UTIL_IDLE,
+	SPU_UTIL_IDLE_LOADED,
 	SPU_UTIL_MAX
 };
=20
@@ -168,9 +168,9 @@ struct spu {
=20
 	struct {
 		/* protected by interrupt reentrancy */
-		enum spu_utilization_state utilization_state;
-		unsigned long tstamp;		/* time of last ctx switch */
-		unsigned long times[SPU_UTIL_MAX];
+		enum spu_utilization_state util_state;
+		unsigned long long tstamp;
+		unsigned long long times[SPU_UTIL_MAX];
 		unsigned long long vol_ctx_switch;
 		unsigned long long invol_ctx_switch;
 		unsigned long long min_flt;
_

Patches currently in -mm which might be from adetsch@br.ibm.com are

spufs-add-spu-stats-in-sysfs-and-ctx-stat-file-in-spufs.patch
