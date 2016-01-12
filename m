From: akpm@linux-foundation.org
Subject: + linux-next-git-rejects.patch added to -mm tree
Date: Tue, 12 Jan 2016 15:28:29 -0800
Message-ID: <56958c1d.dRuoKWf6CEnuCSJC%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42240 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750915AbcALX2a (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 Jan 2016 18:28:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-git-rejects
has been added to the -mm tree.  Its filename is
     linux-next-git-rejects.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/linux-next-git-rejects.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/linux-next-git-rejects.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-git-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/mach-pxa/mioa701.c                  |    5 -
 arch/arm/mach-pxa/palmtreo.c                 |    4 
 arch/arm/mach-pxa/palmz72.c                  |    4 
 arch/h8300/Kconfig                           |    3 
 arch/ia64/include/asm/barrier.h              |    5 -
 arch/powerpc/include/asm/barrier.h           |    5 -
 arch/s390/include/asm/barrier.h              |   12 --
 drivers/media/dvb-frontends/au8522_decoder.c |    3 
 drivers/media/usb/au0828/au0828-video.c      |   61 -------------
 drivers/pinctrl/bcm/pinctrl-nsp-gpio.c       |   40 ---------
 include/asm-generic/barrier.h                |    4 
 tools/lib/bpf/Makefile                       |    8 -
 tools/perf/builtin-script.c                  |   75 -----------------
 tools/perf/builtin-stat.c                    |   15 ---
 tools/perf/builtin-top.c                     |    3 
 tools/perf/util/Build                        |    4 
 tools/perf/util/callchain.c                  |   31 -------
 tools/perf/util/callchain.h                  |    4 
 tools/perf/util/cpumap.c                     |   14 ---
 tools/perf/util/hist.c                       |   11 --
 tools/perf/util/symbol.h                     |    5 -
 21 files changed, 316 deletions(-)

diff -puN arch/arm/mach-pxa/mioa701.c~linux-next-git-rejects arch/arm/mach-pxa/mioa701.c
--- a/arch/arm/mach-pxa/mioa701.c~linux-next-git-rejects
+++ a/arch/arm/mach-pxa/mioa701.c
@@ -52,13 +52,8 @@
 #include <linux/platform_data/keypad-pxa27x.h>
 #include <linux/platform_data/video-pxafb.h>
 #include <linux/platform_data/mmc-pxamci.h>
-<<<<<<< HEAD
-#include <mach/udc.h>
-#include <mach/pxa27x-udc.h>
-=======
 #include "udc.h"
 #include "pxa27x-udc.h"
->>>>>>> linux-next/akpm-base
 #include <linux/platform_data/media/camera-pxa.h>
 #include <mach/audio.h>
 #include <mach/smemc.h>
diff -puN arch/arm/mach-pxa/palmtreo.c~linux-next-git-rejects arch/arm/mach-pxa/palmtreo.c
--- a/arch/arm/mach-pxa/palmtreo.c~linux-next-git-rejects
+++ a/arch/arm/mach-pxa/palmtreo.c
@@ -44,11 +44,7 @@
 #include <mach/pxa2xx-regs.h>
 #include <linux/platform_data/asoc-palm27x.h>
 #include <linux/platform_data/media/camera-pxa.h>
-<<<<<<< HEAD
-#include <mach/palm27x.h>
-=======
 #include "palm27x.h"
->>>>>>> linux-next/akpm-base
 
 #include <sound/pxa2xx-lib.h>
 
diff -puN arch/arm/mach-pxa/palmz72.c~linux-next-git-rejects arch/arm/mach-pxa/palmz72.c
--- a/arch/arm/mach-pxa/palmz72.c~linux-next-git-rejects
+++ a/arch/arm/mach-pxa/palmz72.c
@@ -48,11 +48,7 @@
 #include <linux/platform_data/asoc-palm27x.h>
 #include "palm27x.h"
 
-<<<<<<< HEAD
-#include <mach/pm.h>
-=======
 #include "pm.h"
->>>>>>> linux-next/akpm-base
 #include <linux/platform_data/media/camera-pxa.h>
 
 #include <media/soc_camera.h>
diff -puN arch/h8300/Kconfig~linux-next-git-rejects arch/h8300/Kconfig
--- a/arch/h8300/Kconfig~linux-next-git-rejects
+++ a/arch/h8300/Kconfig
@@ -17,11 +17,8 @@ config H8300
 	select HAVE_MEMBLOCK
 	select HAVE_DMA_ATTRS
 	select CLKSRC_OF
-<<<<<<< HEAD
-=======
 	select HAVE_ARCH_KGDB
 	select HAVE_KERNEL_LZO
->>>>>>> linux-next/akpm-base
 	select H8300_TMR8
 
 config RWSEM_GENERIC_SPINLOCK
diff -puN arch/ia64/include/asm/barrier.h~linux-next-git-rejects arch/ia64/include/asm/barrier.h
--- a/arch/ia64/include/asm/barrier.h~linux-next-git-rejects
+++ a/arch/ia64/include/asm/barrier.h
@@ -67,11 +67,6 @@ do {									\
 	___p1;								\
 })
 
-<<<<<<< HEAD
-#define smp_store_mb(var, value) do { WRITE_ONCE(var, value); smp_mb(); } while (0)
-
-=======
->>>>>>> linux-next/akpm-base
 /*
  * The group barrier in front of the rsm & ssm are necessary to ensure
  * that none of the previous instructions in the same group are
diff -puN arch/powerpc/include/asm/barrier.h~linux-next-git-rejects arch/powerpc/include/asm/barrier.h
--- a/arch/powerpc/include/asm/barrier.h~linux-next-git-rejects
+++ a/arch/powerpc/include/asm/barrier.h
@@ -34,11 +34,6 @@
 #define rmb()  __asm__ __volatile__ ("sync" : : : "memory")
 #define wmb()  __asm__ __volatile__ ("sync" : : : "memory")
 
-<<<<<<< HEAD
-#define smp_store_mb(var, value) do { WRITE_ONCE(var, value); smp_mb(); } while (0)
-
-=======
->>>>>>> linux-next/akpm-base
 #ifdef __SUBARCH_HAS_LWSYNC
 #    define SMPWMB      LWSYNC
 #else
diff -puN arch/s390/include/asm/barrier.h~linux-next-git-rejects arch/s390/include/asm/barrier.h
--- a/arch/s390/include/asm/barrier.h~linux-next-git-rejects
+++ a/arch/s390/include/asm/barrier.h
@@ -30,19 +30,7 @@
 #define __smp_rmb()			rmb()
 #define __smp_wmb()			wmb()
 
-<<<<<<< HEAD
-#define read_barrier_depends()		do { } while (0)
-#define smp_read_barrier_depends()	do { } while (0)
-
-#define smp_mb__before_atomic()		smp_mb()
-#define smp_mb__after_atomic()		smp_mb()
-
-#define smp_store_mb(var, value)	do { WRITE_ONCE(var, value); smp_mb(); } while (0)
-
-#define smp_store_release(p, v)						\
-=======
 #define __smp_store_release(p, v)					\
->>>>>>> linux-next/akpm-base
 do {									\
 	compiletime_assert_atomic_type(*p);				\
 	barrier();							\
diff -puN drivers/media/dvb-frontends/au8522_decoder.c~linux-next-git-rejects drivers/media/dvb-frontends/au8522_decoder.c
--- a/drivers/media/dvb-frontends/au8522_decoder.c~linux-next-git-rejects
+++ a/drivers/media/dvb-frontends/au8522_decoder.c
@@ -730,12 +730,9 @@ static int au8522_probe(struct i2c_clien
 	struct v4l2_ctrl_handler *hdl;
 	struct v4l2_subdev *sd;
 	int instance;
-<<<<<<< HEAD
-=======
 #ifdef CONFIG_MEDIA_CONTROLLER
 	int ret;
 #endif
->>>>>>> linux-next/akpm-base
 
 	/* Check if the adapter supports the needed features */
 	if (!i2c_check_functionality(client->adapter,
diff -puN drivers/media/usb/au0828/au0828-video.c~linux-next-git-rejects drivers/media/usb/au0828/au0828-video.c
--- a/drivers/media/usb/au0828/au0828-video.c~linux-next-git-rejects
+++ a/drivers/media/usb/au0828/au0828-video.c
@@ -638,67 +638,6 @@ static inline int au0828_isoc_copy(struc
 	return rc;
 }
 
-<<<<<<< HEAD
-=======
-static int au0828_enable_analog_tuner(struct au0828_dev *dev)
-{
-#ifdef CONFIG_MEDIA_CONTROLLER
-	struct media_device *mdev = dev->media_dev;
-	struct media_entity *source;
-	struct media_link *link, *found_link = NULL;
-	int ret, active_links = 0;
-
-	if (!mdev || !dev->decoder)
-		return 0;
-
-	/*
-	 * This will find the tuner that is connected into the decoder.
-	 * Technically, this is not 100% correct, as the device may be
-	 * using an analog input instead of the tuner. However, as we can't
-	 * do DVB streaming while the DMA engine is being used for V4L2,
-	 * this should be enough for the actual needs.
-	 */
-	list_for_each_entry(link, &dev->decoder->links, list) {
-		if (link->sink->entity == dev->decoder) {
-			found_link = link;
-			if (link->flags & MEDIA_LNK_FL_ENABLED)
-				active_links++;
-			break;
-		}
-	}
-
-	if (active_links == 1 || !found_link)
-		return 0;
-
-	source = found_link->source->entity;
-	list_for_each_entry(link, &source->links, list) {
-		struct media_entity *sink;
-		int flags = 0;
-
-		sink = link->sink->entity;
-
-		if (sink == dev->decoder)
-			flags = MEDIA_LNK_FL_ENABLED;
-
-		ret = media_entity_setup_link(link, flags);
-		if (ret) {
-			pr_err(
-				"Couldn't change link %s->%s to %s. Error %d\n",
-				source->name, sink->name,
-				flags ? "enabled" : "disabled",
-				ret);
-			return ret;
-		} else
-			au0828_isocdbg(
-				"link %s->%s was %s\n",
-				source->name, sink->name,
-				flags ? "ENABLED" : "disabled");
-	}
-#endif
-	return 0;
-}
-
->>>>>>> linux-next/akpm-base
 static int queue_setup(struct vb2_queue *vq,
 		       unsigned int *nbuffers, unsigned int *nplanes,
 		       unsigned int sizes[], void *alloc_ctxs[])
diff -puN drivers/pinctrl/bcm/pinctrl-nsp-gpio.c~linux-next-git-rejects drivers/pinctrl/bcm/pinctrl-nsp-gpio.c
--- a/drivers/pinctrl/bcm/pinctrl-nsp-gpio.c~linux-next-git-rejects
+++ a/drivers/pinctrl/bcm/pinctrl-nsp-gpio.c
@@ -18,11 +18,7 @@
  * through the interaction with the NSP IOMUX controller.
  */
 
-<<<<<<< HEAD
-#include <linux/gpio.h>
-=======
 #include <linux/gpio/driver.h>
->>>>>>> linux-next/akpm-base
 #include <linux/interrupt.h>
 #include <linux/io.h>
 #include <linux/ioport.h>
@@ -85,14 +81,6 @@ enum base_type {
 	IO_CTRL
 };
 
-<<<<<<< HEAD
-static inline struct nsp_gpio *to_nsp_gpio(struct gpio_chip *gc)
-{
-	return container_of(gc, struct nsp_gpio, gc);
-}
-
-=======
->>>>>>> linux-next/akpm-base
 /*
  * Mapping from PINCONF pins to GPIO pins is 1-to-1
  */
@@ -304,11 +292,7 @@ static void nsp_gpio_free(struct gpio_ch
 
 static int nsp_gpio_direction_input(struct gpio_chip *gc, unsigned gpio)
 {
-<<<<<<< HEAD
-	struct nsp_gpio *chip = to_nsp_gpio(gc);
-=======
 	struct nsp_gpio *chip = gpiochip_get_data(gc);
->>>>>>> linux-next/akpm-base
 	unsigned long flags;
 
 	spin_lock_irqsave(&chip->lock, flags);
@@ -322,11 +306,7 @@ static int nsp_gpio_direction_input(stru
 static int nsp_gpio_direction_output(struct gpio_chip *gc, unsigned gpio,
 				     int val)
 {
-<<<<<<< HEAD
-	struct nsp_gpio *chip = to_nsp_gpio(gc);
-=======
 	struct nsp_gpio *chip = gpiochip_get_data(gc);
->>>>>>> linux-next/akpm-base
 	unsigned long flags;
 
 	spin_lock_irqsave(&chip->lock, flags);
@@ -340,11 +320,7 @@ static int nsp_gpio_direction_output(str
 
 static void nsp_gpio_set(struct gpio_chip *gc, unsigned gpio, int val)
 {
-<<<<<<< HEAD
-	struct nsp_gpio *chip = to_nsp_gpio(gc);
-=======
 	struct nsp_gpio *chip = gpiochip_get_data(gc);
->>>>>>> linux-next/akpm-base
 	unsigned long flags;
 
 	spin_lock_irqsave(&chip->lock, flags);
@@ -356,22 +332,14 @@ static void nsp_gpio_set(struct gpio_chi
 
 static int nsp_gpio_get(struct gpio_chip *gc, unsigned gpio)
 {
-<<<<<<< HEAD
-	struct nsp_gpio *chip = to_nsp_gpio(gc);
-=======
 	struct nsp_gpio *chip = gpiochip_get_data(gc);
->>>>>>> linux-next/akpm-base
 
 	return !!(readl(chip->base + NSP_GPIO_DATA_IN) & BIT(gpio));
 }
 
 static int nsp_gpio_to_irq(struct gpio_chip *gc, unsigned offset)
 {
-<<<<<<< HEAD
-	struct nsp_gpio *chip = to_nsp_gpio(gc);
-=======
 	struct nsp_gpio *chip = gpiochip_get_data(gc);
->>>>>>> linux-next/akpm-base
 
 	return irq_linear_revmap(chip->irq_domain, offset);
 }
@@ -696,11 +664,7 @@ static int nsp_gpio_probe(struct platfor
 	gc->can_sleep = false;
 	gc->ngpio = val;
 	gc->label = dev_name(dev);
-<<<<<<< HEAD
-	gc->dev = dev;
-=======
 	gc->parent = dev;
->>>>>>> linux-next/akpm-base
 	gc->of_node = dev->of_node;
 	gc->request = nsp_gpio_request;
 	gc->free = nsp_gpio_free;
@@ -745,11 +709,7 @@ static int nsp_gpio_probe(struct platfor
 		writel(val, (chip->base + NSP_CHIP_A_INT_MASK));
 	}
 
-<<<<<<< HEAD
-	ret = gpiochip_add(gc);
-=======
 	ret = gpiochip_add_data(gc, chip);
->>>>>>> linux-next/akpm-base
 	if (ret < 0) {
 		dev_err(dev, "unable to add GPIO chip\n");
 		return ret;
diff -puN include/asm-generic/barrier.h~linux-next-git-rejects include/asm-generic/barrier.h
--- a/include/asm-generic/barrier.h~linux-next-git-rejects
+++ a/include/asm-generic/barrier.h
@@ -164,11 +164,7 @@ do {									\
 #else	/* !CONFIG_SMP */
 
 #ifndef smp_store_mb
-<<<<<<< HEAD
-#define smp_store_mb(var, value)  do { WRITE_ONCE(var, value); smp_mb(); } while (0)
-=======
 #define smp_store_mb(var, value)  do { WRITE_ONCE(var, value); barrier(); } while (0)
->>>>>>> linux-next/akpm-base
 #endif
 
 #ifndef smp_mb__before_atomic
diff -puN tools/lib/bpf/Makefile~linux-next-git-rejects tools/lib/bpf/Makefile
--- a/tools/lib/bpf/Makefile~linux-next-git-rejects
+++ a/tools/lib/bpf/Makefile
@@ -80,15 +80,7 @@ endif
 endif
 
 ifeq ($(check_feat),1)
-<<<<<<< HEAD
-ifeq ($(FEATURES_DUMP),)
 include $(srctree)/tools/build/Makefile.feature
-else
-include $(FEATURES_DUMP)
-endif
-=======
-include $(srctree)/tools/build/Makefile.feature
->>>>>>> linux-next/akpm-base
 endif
 
 export prefix libdir src obj
diff -puN tools/perf/builtin-script.c~linux-next-git-rejects tools/perf/builtin-script.c
--- a/tools/perf/builtin-script.c~linux-next-git-rejects
+++ a/tools/perf/builtin-script.c
@@ -614,33 +614,9 @@ struct perf_script {
 	bool			show_task_events;
 	bool			show_mmap_events;
 	bool			show_switch_events;
-<<<<<<< HEAD
-	bool			allocated;
-	struct cpu_map		*cpus;
-	struct thread_map	*threads;
-	int			name_width;
-};
-
-static int perf_evlist__max_name_len(struct perf_evlist *evlist)
-{
-	struct perf_evsel *evsel;
-	int max = 0;
-
-	evlist__for_each(evlist, evsel) {
-		int len = strlen(perf_evsel__name(evsel));
-
-		max = MAX(len, max);
-	}
-
-	return max;
-}
-
-static void process_event(struct perf_script *script, union perf_event *event,
-=======
 };
 
 static void process_event(struct perf_script *script __maybe_unused, union perf_event *event,
->>>>>>> linux-next/akpm-base
 			  struct perf_sample *sample, struct perf_evsel *evsel,
 			  struct addr_location *al)
 {
@@ -703,57 +679,6 @@ static void process_event(struct perf_sc
 
 static struct scripting_ops	*scripting_ops;
 
-<<<<<<< HEAD
-static void __process_stat(struct perf_evsel *counter, u64 tstamp)
-{
-	int nthreads = thread_map__nr(counter->threads);
-	int ncpus = perf_evsel__nr_cpus(counter);
-	int cpu, thread;
-	static int header_printed;
-
-	if (counter->system_wide)
-		nthreads = 1;
-
-	if (!header_printed) {
-		printf("%3s %8s %15s %15s %15s %15s %s\n",
-		       "CPU", "THREAD", "VAL", "ENA", "RUN", "TIME", "EVENT");
-		header_printed = 1;
-	}
-
-	for (thread = 0; thread < nthreads; thread++) {
-		for (cpu = 0; cpu < ncpus; cpu++) {
-			struct perf_counts_values *counts;
-
-			counts = perf_counts(counter->counts, cpu, thread);
-
-			printf("%3d %8d %15" PRIu64 " %15" PRIu64 " %15" PRIu64 " %15" PRIu64 " %s\n",
-				counter->cpus->map[cpu],
-				thread_map__pid(counter->threads, thread),
-				counts->val,
-				counts->ena,
-				counts->run,
-				tstamp,
-				perf_evsel__name(counter));
-		}
-	}
-}
-
-static void process_stat(struct perf_evsel *counter, u64 tstamp)
-{
-	if (scripting_ops && scripting_ops->process_stat)
-		scripting_ops->process_stat(&stat_config, counter, tstamp);
-	else
-		__process_stat(counter, tstamp);
-}
-
-static void process_stat_interval(u64 tstamp)
-{
-	if (scripting_ops && scripting_ops->process_stat_interval)
-		scripting_ops->process_stat_interval(tstamp);
-}
-
-=======
->>>>>>> linux-next/akpm-base
 static void setup_scripting(void)
 {
 	setup_perl_scripting();
diff -puN tools/perf/builtin-stat.c~linux-next-git-rejects tools/perf/builtin-stat.c
--- a/tools/perf/builtin-stat.c~linux-next-git-rejects
+++ a/tools/perf/builtin-stat.c
@@ -184,26 +184,11 @@ static int create_perf_stat_counter(stru
 	 * like tracepoints. Clear it up for counting.
 	 */
 	attr->sample_period = 0;
-<<<<<<< HEAD
-
-	/*
-	 * But set sample_type to PERF_SAMPLE_IDENTIFIER, which should be harmless
-	 * while avoiding that older tools show confusing messages.
-	 *
-	 * However for pipe sessions we need to keep it zero,
-	 * because script's perf_evsel__check_attr is triggered
-	 * by attr->sample_type != 0, and we can't run it on
-	 * stat sessions.
-	 */
-	if (!(STAT_RECORD && perf_stat.file.is_pipe))
-		attr->sample_type = PERF_SAMPLE_IDENTIFIER;
-=======
 	/*
 	 * But set sample_type to PERF_SAMPLE_IDENTIFIER, which should be harmless
 	 * while avoiding that older tools show confusing messages.
 	 */
 	attr->sample_type   = PERF_SAMPLE_IDENTIFIER;
->>>>>>> linux-next/akpm-base
 
 	/*
 	 * Disabling all counters initially, they will be enabled
diff -puN tools/perf/builtin-top.c~linux-next-git-rejects tools/perf/builtin-top.c
--- a/tools/perf/builtin-top.c~linux-next-git-rejects
+++ a/tools/perf/builtin-top.c
@@ -1282,15 +1282,12 @@ int cmd_top(int argc, const char **argv,
 	if (perf_evlist__create_maps(top.evlist, target) < 0) {
 		ui__error("Couldn't create thread/CPU maps: %s\n",
 			  errno == ENOENT ? "No such process" : strerror_r(errno, errbuf, sizeof(errbuf)));
-<<<<<<< HEAD
-=======
 		goto out_delete_evlist;
 	}
 
 	if (!top.evlist->nr_entries &&
 	    perf_evlist__add_default(top.evlist) < 0) {
 		ui__error("Not enough memory for event selector list\n");
->>>>>>> linux-next/akpm-base
 		goto out_delete_evlist;
 	}
 
diff -puN tools/perf/util/Build~linux-next-git-rejects tools/perf/util/Build
--- a/tools/perf/util/Build~linux-next-git-rejects
+++ a/tools/perf/util/Build
@@ -9,11 +9,7 @@ libperf-y += env.o
 libperf-y += event.o
 libperf-y += evlist.o
 libperf-y += evsel.o
-<<<<<<< HEAD
-libperf-y += find_bit.o
-=======
 libperf-y += find_next_bit.o
->>>>>>> linux-next/akpm-base
 libperf-y += kallsyms.o
 libperf-y += levenshtein.o
 libperf-y += llvm-utils.o
diff -puN tools/perf/util/callchain.c~linux-next-git-rejects tools/perf/util/callchain.c
--- a/tools/perf/util/callchain.c~linux-next-git-rejects
+++ a/tools/perf/util/callchain.c
@@ -925,37 +925,6 @@ void free_callchain(struct callchain_roo
 	free_callchain_node(&root->node);
 }
 
-<<<<<<< HEAD
-static u64 decay_callchain_node(struct callchain_node *node)
-{
-	struct callchain_node *child;
-	struct rb_node *n;
-	u64 child_hits = 0;
-
-	n = rb_first(&node->rb_root_in);
-	while (n) {
-		child = container_of(n, struct callchain_node, rb_node_in);
-
-		child_hits += decay_callchain_node(child);
-		n = rb_next(n);
-	}
-
-	node->hit = (node->hit * 7) / 8;
-	node->children_hit = child_hits;
-
-	return node->hit;
-}
-
-void decay_callchain(struct callchain_root *root)
-{
-	if (!symbol_conf.use_callchain)
-		return;
-
-	decay_callchain_node(&root->node);
-}
-
-=======
->>>>>>> linux-next/akpm-base
 int callchain_node__make_parent_list(struct callchain_node *node)
 {
 	struct callchain_node *parent = node->parent;
diff -puN tools/perf/util/callchain.h~linux-next-git-rejects tools/perf/util/callchain.h
--- a/tools/perf/util/callchain.h~linux-next-git-rejects
+++ a/tools/perf/util/callchain.h
@@ -253,10 +253,6 @@ int callchain_node__fprintf_value(struct
 				  FILE *fp, u64 total);
 
 void free_callchain(struct callchain_root *root);
-<<<<<<< HEAD
-void decay_callchain(struct callchain_root *root);
-=======
->>>>>>> linux-next/akpm-base
 int callchain_node__make_parent_list(struct callchain_node *node);
 
 #endif	/* __PERF_CALLCHAIN_H */
diff -puN tools/perf/util/cpumap.c~linux-next-git-rejects tools/perf/util/cpumap.c
--- a/tools/perf/util/cpumap.c~linux-next-git-rejects
+++ a/tools/perf/util/cpumap.c
@@ -188,22 +188,8 @@ static struct cpu_map *cpu_map__from_ent
 	if (map) {
 		unsigned i;
 
-<<<<<<< HEAD
-		for (i = 0; i < cpus->nr; i++) {
-			/*
-			 * Special treatment for -1, which is not real cpu number,
-			 * and we need to use (int) -1 to initialize map[i],
-			 * otherwise it would become 65535.
-			 */
-			if (cpus->cpu[i] == (u16) -1)
-				map->map[i] = -1;
-			else
-				map->map[i] = (int) cpus->cpu[i];
-		}
-=======
 		for (i = 0; i < cpus->nr; i++)
 			map->map[i] = (int)cpus->cpu[i];
->>>>>>> linux-next/akpm-base
 	}
 
 	return map;
diff -puN tools/perf/util/hist.c~linux-next-git-rejects tools/perf/util/hist.c
--- a/tools/perf/util/hist.c~linux-next-git-rejects
+++ a/tools/perf/util/hist.c
@@ -1624,17 +1624,6 @@ static void hists_evsel__exit(struct per
 	hists__delete_all_entries(hists);
 }
 
-<<<<<<< HEAD
-static int hists_evsel__init(struct perf_evsel *evsel)
-{
-	struct hists *hists = evsel__hists(evsel);
-
-	__hists__init(hists);
-	return 0;
-}
-
-=======
->>>>>>> linux-next/akpm-base
 /*
  * XXX We probably need a hists_evsel__exit() to free the hist_entries
  * stored in the rbtree...
diff -puN tools/perf/util/symbol.h~linux-next-git-rejects tools/perf/util/symbol.h
--- a/tools/perf/util/symbol.h~linux-next-git-rejects
+++ a/tools/perf/util/symbol.h
@@ -109,12 +109,7 @@ struct symbol_conf {
 			branch_callstack,
 			has_filter,
 			show_ref_callgraph,
-<<<<<<< HEAD
-			hide_unresolved,
-			raw_trace;
-=======
 			hide_unresolved;
->>>>>>> linux-next/akpm-base
 	const char	*vmlinux_name,
 			*kallsyms_name,
 			*source_prefix,
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-gpu-drm-i915-intel_spritec-fix-build.patch
drivers-gpu-drm-i915-intel_tvc-fix-build.patch
ocfs2-fix-slot-overwritten-if-storage-link-down-during-mount-checkpatch-fixes.patch
ocfs2-fix-ip_unaligned_aio-deadlock-with-dio-work-queue-fix.patch
include-linux-dcacheh-remove-semicolons-from-hash_len_declare.patch
mm.patch
account-certain-kmem-allocations-to-memcg-checkpatch-fixes.patch
include-define-__phys_to_pfn-as-phys_pfn-fix.patch
mempolicy-convert-the-shared_policy-lock-to-a-rwlock-fix-2.patch
mm-zonelist-enumerate-zonelists-array-index-checkpatch-fixes.patch
mm-zonelist-enumerate-zonelists-array-index-fix.patch
mm-get-rid-of-__alloc_pages_high_priority-checkpatch-fixes.patch
fs-block_devc-bdev_write_page-use-blk_queue_enter-gfp_noio.patch
arm64-mm-support-arch_mmap_rnd_bits-fix.patch
ksm-introduce-ksm_max_page_sharing-per-page-deduplication-limit-fix-2.patch
page-flags-define-pg_locked-behavior-on-compound-pages-fix.patch
mm-rework-mapcount-accounting-to-enable-4k-mapping-of-thps-fix.patch
mm-hwpoison-adjust-for-new-thp-refcounting-fix.patch
mm-prepare-page_referenced-and-page_idle-to-new-thp-refcounting-checkpatch-fixes.patch
thp-add-debugfs-handle-to-split-all-huge-pages-fix.patch
mm-support-madvisemadv_free-fix-2-fix.patch
arch-uapi-asm-mmanh-let-madv_free-have-same-value-for-all-architectures-fix.patch
arch-uapi-asm-mmanh-let-madv_free-have-same-value-for-all-architectures-fix-fix-2.patch
arch-uapi-asm-mmanh-let-madv_free-have-same-value-for-all-architectures-fix-fix-2-fix-3.patch
mm-oom-rework-oom-detection-checkpatch-fixes.patch
mm-use-watermak-checks-for-__gfp_repeat-high-order-allocations-checkpatch-fixes.patch
sched-add-schedule_timeout_idle.patch
mm-mlockc-change-can_do_mlock-return-value-type-to-boolean-fix.patch
mm-page_allocc-introduce-kernelcore=mirror-option-fix.patch
mm-page_allocc-rework-code-layout-in-memmap_init_zone.patch
mm-hugetlbfs-unmap-pages-if-page-fault-raced-with-hole-punch-fix.patch
kernel-stop_machinec-remove-config_smp-dependencies.patch
kernel-stop_machinec-remove-config_smp-dependencies-fix.patch
lib-vsprintfc-expand-field_width-to-24-bits-fix.patch
lib-test_printfc-test-dentry-printing-fix.patch
printk-help-pr_debug-and-pr_devel-to-optimize-out-arguments-fix.patch
printk-nmi-generic-solution-for-safe-printk-in-nmi-v4-fix-fix.patch
printk-nmi-warn-when-some-message-has-been-lost-in-nmi-context-fix.patch
ptrace-task_stopped_codeptrace-=-true-cant-see-task_stopped-task-fix.patch
ptrace-use-fsuid-fsgid-effective-creds-for-fs-access-checks-fix.patch
fs-coredump-prevent-core-path-components-fix.patch
ubsan-run-time-undefined-behavior-sanity-checker-fix.patch
ubsan-run-time-undefined-behavior-sanity-checker-fix-3.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
fs-overlayfs-superc-needs-pagemaph.patch
drivers-net-wireless-intel-iwlwifi-dvm-calibc-fix-min-warning.patch
fs-adfs-adfsh-tidy-up-comments.patch
net-drop-tcp_memcontrolc-fix.patch
mm-memcontrol-reign-in-the-config-space-madness-fix.patch
mm-memcontrol-reign-in-the-config-space-madness-fix-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

