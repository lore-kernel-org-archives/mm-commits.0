From: akpm@linux-foundation.org
Subject: + knfsd-provide-sunrpc-pool_mode-module-option.patch added to -mm tree
Date: Mon, 05 Mar 2007 20:58:14 -0800
Message-ID: <200703060458.l264wE3w012405@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:51013 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752868AbXCFE6U (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 5 Mar 2007 23:58:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: gnb@sgi.com, gnb@melbourne.sgi.com, neilb@suse.de


The patch titled
     knfsd: provide sunrpc pool_mode module option
has been added to the -mm tree.  Its filename is
     knfsd-provide-sunrpc-pool_mode-module-option.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: knfsd: provide sunrpc pool_mode module option
From: Greg Banks <gnb@sgi.com>

Provide a module param "pool_mode" for sunrpc.ko which allows a sysadmin to
choose the mode for mapping NFS thread service pools to CPUs.  Values are:

auto	    choose a mapping mode heuristically
global	    (default, same as the pre-2.6.19 code) a single global pool
percpu	    one pool per CPU
pernode	    one pool per NUMA node

Note that since 2.6.19 the hardcoded behaviour has been "auto", this patch
makes the default "global".

The pool mode can be changed after boot/modprobe using /sys, if the NFS and
lockd services have been shut down.  A useful side effect of this change is to
fix a small memory leak when unloading the module.

Signed-off-by: Greg Banks <gnb@melbourne.sgi.com>
Signed-off-by: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/kernel-parameters.txt |   16 +++
 net/sunrpc/svc.c                    |  133 ++++++++++++++++++++++----
 2 files changed, 130 insertions(+), 19 deletions(-)

diff -puN Documentation/kernel-parameters.txt~knfsd-provide-sunrpc-pool_mode-module-option Documentation/kernel-parameters.txt
--- a/Documentation/kernel-parameters.txt~knfsd-provide-sunrpc-pool_mode-module-option
+++ a/Documentation/kernel-parameters.txt
@@ -1685,6 +1685,22 @@ and is between 256 and 4096 characters. 
 	stifb=		[HW]
 			Format: bpp:<bpp1>[:<bpp2>[:<bpp3>...]]
 
+	sunrpc.pool_mode=
+			[NFS]
+			Control how the NFS server code allocates CPUs to
+			service thread pools.  Depending on how many NICs
+			you have and where their interrupts are bound, this
+			option will affect which CPUs will do NFS serving.
+			Note: this parameter cannot be changed while the
+			NFS server is running.
+
+			auto	    the server chooses an appropriate mode
+				    automatically using heuristics
+			global	    a single global pool contains all CPUs
+			percpu	    one pool for each CPU
+			pernode	    one pool for each NUMA node (equivalent
+				    to global on non-NUMA machines)
+
 	swiotlb=	[IA-64] Number of I/O TLB slabs
 
 	switches=	[HW,M68k]
diff -puN net/sunrpc/svc.c~knfsd-provide-sunrpc-pool_mode-module-option net/sunrpc/svc.c
--- a/net/sunrpc/svc.c~knfsd-provide-sunrpc-pool_mode-module-option
+++ a/net/sunrpc/svc.c
@@ -27,22 +27,26 @@
 
 #define RPCDBG_FACILITY	RPCDBG_SVCDSP
 
+#define svc_serv_is_pooled(serv)    ((serv)->sv_function)
+
 /*
  * Mode for mapping cpus to pools.
  */
 enum {
-	SVC_POOL_NONE = -1,	/* uninitialised, choose one of the others */
+	SVC_POOL_AUTO = -1,	/* choose one of the others */
 	SVC_POOL_GLOBAL,	/* no mapping, just a single global pool
 				 * (legacy & UP mode) */
 	SVC_POOL_PERCPU,	/* one pool per cpu */
 	SVC_POOL_PERNODE	/* one pool per numa node */
 };
+#define SVC_POOL_DEFAULT	SVC_POOL_GLOBAL
 
 /*
  * Structure for mapping cpus to pools and vice versa.
  * Setup once during sunrpc initialisation.
  */
 static struct svc_pool_map {
+	int count;			/* How many svc_servs use us */
 	int mode;			/* Note: int not enum to avoid
 					 * warnings about "enumeration value
 					 * not handled in switch" */
@@ -50,9 +54,63 @@ static struct svc_pool_map {
 	unsigned int *pool_to;		/* maps pool id to cpu or node */
 	unsigned int *to_pool;		/* maps cpu or node to pool id */
 } svc_pool_map = {
-	.mode = SVC_POOL_NONE
+	.count = 0,
+	.mode = SVC_POOL_DEFAULT
 };
+static DEFINE_MUTEX(svc_pool_map_mutex);/* protects svc_pool_map.count only */
+
+static int
+param_set_pool_mode(const char *val, struct kernel_param *kp)
+{
+	int *ip = (int *)kp->arg;
+	struct svc_pool_map *m = &svc_pool_map;
+	int err;
+
+	mutex_lock(&svc_pool_map_mutex);
+
+	err = -EBUSY;
+	if (m->count)
+		goto out;
+
+	err = 0;
+	if (!strncmp(val, "auto", 4))
+		*ip = SVC_POOL_AUTO;
+	else if (!strncmp(val, "global", 6))
+		*ip = SVC_POOL_GLOBAL;
+	else if (!strncmp(val, "percpu", 6))
+		*ip = SVC_POOL_PERCPU;
+	else if (!strncmp(val, "pernode", 7))
+		*ip = SVC_POOL_PERNODE;
+	else
+		err = -EINVAL;
+
+out:
+	mutex_unlock(&svc_pool_map_mutex);
+	return err;
+}
+
+static int
+param_get_pool_mode(char *buf, struct kernel_param *kp)
+{
+	int *ip = (int *)kp->arg;
+
+	switch (*ip)
+	{
+	case SVC_POOL_AUTO:
+		return strlcpy(buf, "auto", 20);
+	case SVC_POOL_GLOBAL:
+		return strlcpy(buf, "global", 20);
+	case SVC_POOL_PERCPU:
+		return strlcpy(buf, "percpu", 20);
+	case SVC_POOL_PERNODE:
+		return strlcpy(buf, "pernode", 20);
+	default:
+		return sprintf(buf, "%d", *ip);
+	}
+}
 
+module_param_call(pool_mode, param_set_pool_mode, param_get_pool_mode,
+		 &svc_pool_map.mode, 0644);
 
 /*
  * Detect best pool mapping mode heuristically,
@@ -166,18 +224,25 @@ svc_pool_map_init_pernode(struct svc_poo
 
 
 /*
- * Build the global map of cpus to pools and vice versa.
+ * Add a reference to the global map of cpus to pools (and
+ * vice versa).  Initialise the map if we're the first user.
+ * Returns the number of pools.
  */
 static unsigned int
-svc_pool_map_init(void)
+svc_pool_map_get(void)
 {
 	struct svc_pool_map *m = &svc_pool_map;
 	int npools = -1;
 
-	if (m->mode != SVC_POOL_NONE)
+	mutex_lock(&svc_pool_map_mutex);
+
+	if (m->count++) {
+		mutex_unlock(&svc_pool_map_mutex);
 		return m->npools;
+	}
 
-	m->mode = svc_pool_map_choose_mode();
+	if (m->mode == SVC_POOL_AUTO)
+		m->mode = svc_pool_map_choose_mode();
 
 	switch (m->mode) {
 	case SVC_POOL_PERCPU:
@@ -195,9 +260,36 @@ svc_pool_map_init(void)
 	}
 	m->npools = npools;
 
+	mutex_unlock(&svc_pool_map_mutex);
 	return m->npools;
 }
 
+
+/*
+ * Drop a reference to the global map of cpus to pools.
+ * When the last reference is dropped, the map data is
+ * freed; this allows the sysadmin to change the pool
+ * mode using the pool_mode module option without
+ * rebooting or re-loading sunrpc.ko.
+ */
+static void
+svc_pool_map_put(void)
+{
+	struct svc_pool_map *m = &svc_pool_map;
+
+	mutex_lock(&svc_pool_map_mutex);
+
+	if (!--m->count) {
+		m->mode = SVC_POOL_DEFAULT;
+		kfree(m->to_pool);
+		kfree(m->pool_to);
+		m->npools = 0;
+	}
+
+	mutex_unlock(&svc_pool_map_mutex);
+}
+
+
 /*
  * Set the current thread's cpus_allowed mask so that it
  * will only run on cpus in the given pool.
@@ -212,10 +304,9 @@ svc_pool_map_set_cpumask(unsigned int pi
 
 	/*
 	 * The caller checks for sv_nrpools > 1, which
-	 * implies that we've been initialized and the
-	 * map mode is not NONE.
+	 * implies that we've been initialized.
 	 */
-	BUG_ON(m->mode == SVC_POOL_NONE);
+	BUG_ON(m->count == 0);
 
 	switch (m->mode)
 	{
@@ -246,18 +337,19 @@ svc_pool_for_cpu(struct svc_serv *serv, 
 	unsigned int pidx = 0;
 
 	/*
-	 * SVC_POOL_NONE happens in a pure client when
+	 * An uninitialised map happens in a pure client when
 	 * lockd is brought up, so silently treat it the
 	 * same as SVC_POOL_GLOBAL.
 	 */
-
-	switch (m->mode) {
-	case SVC_POOL_PERCPU:
-		pidx = m->to_pool[cpu];
-		break;
-	case SVC_POOL_PERNODE:
-		pidx = m->to_pool[cpu_to_node(cpu)];
-		break;
+	if (svc_serv_is_pooled(serv)) {
+		switch (m->mode) {
+		case SVC_POOL_PERCPU:
+			pidx = m->to_pool[cpu];
+			break;
+		case SVC_POOL_PERNODE:
+			pidx = m->to_pool[cpu_to_node(cpu)];
+			break;
+		}
 	}
 	return &serv->sv_pools[pidx % serv->sv_nrpools];
 }
@@ -347,7 +439,7 @@ svc_create_pooled(struct svc_program *pr
 		  svc_thread_fn func, int sig, struct module *mod)
 {
 	struct svc_serv *serv;
-	unsigned int npools = svc_pool_map_init();
+	unsigned int npools = svc_pool_map_get();
 
 	serv = __svc_create(prog, bufsize, npools, shutdown);
 
@@ -397,6 +489,9 @@ svc_destroy(struct svc_serv *serv)
 
 	cache_clean_deferred(serv);
 
+	if (svc_serv_is_pooled(serv))
+		svc_pool_map_put();
+
 	/* Unregister service with the portmapper */
 	svc_register(serv, 0, 0);
 	kfree(serv->sv_pools);
_

Patches currently in -mm which might be from gnb@sgi.com are

knfsd-provide-sunrpc-pool_mode-module-option.patch
