From: akpm@linux-foundation.org
Subject: - statistics-infrastructure.patch removed from -mm tree
Date: Fri, 24 Aug 2007 22:19:18 -0700
Message-ID: <200708250519.l7P5JIVx031964@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38746 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756074AbXHYFdB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 25 Aug 2007 01:33:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mp3@de.ibm.com, mm-commits@vger.kernel.org


The patch titled
     statistics infrastructure
has been removed from the -mm tree.  Its filename was
     statistics-infrastructure.patch

This patch was dropped because it isn't in the present -mm lineup

------------------------------------------------------
Subject: statistics infrastructure
From: Martin Peschke <mp3@de.ibm.com>

Add statistics infrastructure as common code.

Signed-off-by: Martin Peschke <mp3@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/statistics.txt |  146 ++-
 MAINTAINERS                  |    7 
 arch/s390/Kconfig            |    2 
 arch/s390/oprofile/Kconfig   |    5 
 include/linux/jiffies.h      |    2 
 include/linux/statistic.h    |  281 +++++
 lib/Kconfig.statistic        |   11 
 lib/Makefile                 |    2 
 lib/statistic.c              | 1564 +++++++++++++++++++++++++++++++++
 9 files changed, 1978 insertions(+), 42 deletions(-)

diff -puN Documentation/statistics.txt~statistics-infrastructure Documentation/statistics.txt
--- a/Documentation/statistics.txt~statistics-infrastructure
+++ a/Documentation/statistics.txt
@@ -33,7 +33,7 @@ kernel code as well as users.
  USER	       :			KERNEL
 	       :
 	  user	       statistics	     programming
-	  interface    infrastructure	     interface	  exploiter
+	  interface    infrastructure	     interface	  client
 	       :       +------------------+	  :	  +-----------------+
 	       :       | process data and |	  :	  | collect and     |
  "data"        :       | provide output   |	(X, Y)	  | report data     |
@@ -62,13 +62,13 @@ compute and store, as well as display st
 current settings.
 
 
-	The role of exploiters
+	The role of clients
 
-It is the exploiter's (e.g. device driver's) responsibility to feed the
+It is the client's (e.g. device driver's) responsibility to feed the
 statistics infrastructure with sampled data for the statistics maintained by the
-statistics infrastructure on behalf of the exploiter.
+statistics infrastructure on behalf of the client.
 
-It would be nice of any exploiter to provide a default configuration for each
+It would be nice of any client to provide a default configuration for each
 statistic that most likely works best for general purpose use.
 
 
@@ -85,7 +85,7 @@ a quantity for the main characteristic o
 or request latency, and with Y being a qualifier for that characteristic,
 i.e. the occurrence of a particular X-value.
 
-Thus, the Y-part can be seen as an optimisation that allows exploiters
+Thus, the Y-part can be seen as an optimisation that allows clients
 to report a bunch of similar measurements in one call (see statistic_add()).
 For the programmer's convenience, Y can be omitted when it would be always 1
 (see statistic_inc()).
@@ -95,7 +95,7 @@ For the programmer's convenience, Y can 
 
 There are two methods how such data can be provided to the statistics
 infrastructure, a push interface and a pull interface. Each statistic
-is either a pull-type or push-type statistic as determined by the exploiter.
+is either a pull-type or push-type statistic as determined by the client.
 
 The push-interface is suitable for data feeds that report incremental updates
 to statistics, and where actual accumulation can be left to the statistics
@@ -104,8 +104,8 @@ infrastructure. New measurements usually
 
 The pull-interface is suitable for data that already comes in an aggregated
 form, like hardware measurement data or counters already maintained and
-used by exploiters for other purposes. Reading statistics data from files
-triggers an optional callback of the exploiter, which can update pull-type
+used by clients for other purposes. Reading statistics data from files
+triggers an optional callback of the client, which can update pull-type
 statistics then (see statistic_set()).
 
 
@@ -131,7 +131,7 @@ according to their needs.
 
 	How statistics are organised
 
-Statistics are grouped within "interfaces" (debugfs entries) by exploiters,
+Statistics are grouped within "interfaces" (debugfs entries) by clients,
 in order to reflect collections of related statistics of an entity,
 which is also quite efficient with regard to memory use.
 
@@ -199,7 +199,11 @@ has been implemented:
   size_write 0x14000 12			|
   ...					|
   size_write 0x9000 1			/
-  queue_used_depth 970 1 18.122 32		> num min avg max for a queue
+  queue_used_depth samples 970			\
+  queue_used_depth minimum 1			|
+  queue_used_depth average 18.122		> utilisation of a queue
+  queue_used_depth maximum 32			|
+  queue_used_depth variance 53.324		/
 
 Such output can grow as needed in debugfs files. It is human-readable and
 could be parsed and postprocessed by simple scripts that are aware of what the
@@ -208,7 +212,7 @@ output of the various data processing mo
 
 	State machine
 
-Each statistic has a state that should be initialised by exploiters.
+Each statistic has a state that should be initialised by clients.
 Users probably want to adjust this state, e.g. enable
 data gathering. Defined states and transitions are:
 
@@ -219,7 +223,7 @@ data gathering. Defined states and trans
 	V
   state=released	(mode of data processing has been defined, but memory
 	A		 required for data gathering has not yet been allocated
-	|		 - would be a good default setup provided by exploiters)
+	|		 - would be a good default setup provided by clients)
 	|
 	V
   state=off		(all memory required for the defined mode of data
@@ -245,7 +249,7 @@ FIXME
 
 	Per-CPU data
 
-Measurements reported by exploiters are accumulated into per-CPU data areas
+Measurements reported by clients are accumulated into per-CPU data areas
 in order to avoid the introduction of serialisation during the
 execution of statistic_add(). Locking of per-CPU data is done by disabling
 preemption and interrupts per CPU for the short time of a statistic update.
@@ -326,6 +330,7 @@ Provides a set of values comprising:
 - the minimum X
 - the average X
 - the maximum X
+- the variance of X
 
 This appears to be a useful fill level indicator for queues etc.
 
@@ -400,7 +405,7 @@ in the source code:
 The statistics infrastructure's user interface is in the
 /sys/kernel/debug/statistics directory, assuming debugfs has been mounted at
 /sys/kernel/debug.  The "statistics" directory holds interface subdirectories
-created on the behalf of exploiters, for example:
+created on the behalf of clients, for example:
 
   drwxr-xr-x 2 root root 0 Jul 28 02:16 zfcp-0.0.50d4
 
@@ -542,18 +547,26 @@ this:
   foo 0x1000 4
   foo 0x2000 1
   foo 0x5000 2
-  bar 961 1 42.000 128
+  bar samples 961
+  bar minimum 1
+  bar average 42.000
+  bar maximum 128
+  bar variance 149.254
 
 
 	Output formats of different statistic types
 
   Statistic Type	Output Format				Number of Lines
 
-  counter_inc		<name> <total of Y>				1
+  counter_inc		<name> <total of Y>			1
 
-  counter_prod		<name> <total of Xi*Yi>				1
+  counter_prod		<name> <total of Xi*Yi>			1
 
-  utilisation		<name> <total of Y> <min X> <avg X> <max X>	1
+  utilisation		<name> "samples" <total of Y>		5
+			<name> "minimum" <minimum X>
+			<name> "average" <average X>
+			<name> "maximum" <maximum X>
+			<name> "variance" <variance of X>
 
   sparse		<name> <Xn> <total of Y for Xn>		<= entries
 			...
@@ -590,6 +603,15 @@ representing some entity, the following 
 
 stat is an array of N statistics of various sorts.
 
+An enum that helps addressing individual statistics of an array comes in handy:
+
+  enum my_entitiy_stat_num {
+	  MY_ENTITY_STAT_REFUND,
+	  MY_ENTITY_STAT_FILL,
+	  ...
+	  N
+  };
+
 Since one might want to create several instances of struct my_entity
 each coming with its own set of statistics (stat[N]) setup using the
 same template, provisions for such a template have been made as part of the
@@ -597,20 +619,22 @@ programming interface. An array of struc
 array of struct statistic.
 
   struct statistic_info[] {
-	  { "refund", "cent", "bottle", 0, "type=counter_prod" },
-	  { "fill_level", "millilitre", "bottle", 1, "type=utilisation" },
+	  [MY_ENTITY_STAT_REFUND] = {
+		  .name     = "refund",
+		  .x_unit   = "cent",
+		  .y_unit   = "bottle",
+		  .defaults = "type=counter_prod"
+	  },
+	  [MY_ENTITY_STAT_FILL] = {
+		  .name     = "fill_level",
+		  .x_unit   = "millilitre",
+		  .y_unit   = "bottle",
+		  .flags    = STATISTIC_FLAGS_NOINCR,
+		  .defaults = "type=utilisation"
+	  },
 	  ...
   } my_entity_stat_info;
 
-An enum that helps addressing individual statistics of an array comes in handy:
-
-  enum my_entitiy_stat_num {
-	  MY_ENTITY_STAT_REFUND,
-	  MY_ENTITY_STAT_FILL,
-	  ...
-	  N
-  };
-
 Now, here is how to tie the knot for statistics and templates:
 
   {
@@ -635,6 +659,33 @@ Now, here is how to tie the knot for sta
 
 	Reporting statistics data
 
+In short, this is the complete list of function that can be used
+to update a statistic:
+
+  _statistic_add()
+  _statistic_inc()
+
+   statistic_add()
+   statistic_inc()
+
+  _statistic_add_as()
+  _statistic_inc_as()
+
+   statistic_add_as()
+   statistic_inc_as()
+
+   statistic_set()
+
+Function names starting with an "_" indicate that the function leaves it to
+the calling code to make updates smp-safe (see details below).
+
+The *statistic_*_as() functions are stripped down version that are faster and
+less flexible from the user's perspective (see details below).
+
+While the add/inc-functions are used for accumulating incremental statistics
+data, the set-function is used for storing statistics coming as total numbers
+(see details below).
+
 Add statistic_add*() or statistic_inc*() calls where appropriate for
 reporting statistics data. Data to be reported through these functions has the
 form of (X, Y) as explained above:
@@ -663,7 +714,7 @@ Of course, this example is not optimal. 
 statistic_inc() compare. Sometimes statistic_inc() might be just what you need.
 
 If there is a bunch of statistics to be updated in one go, consider these
-flavours of statistic_add() which require the exploiter to lock per-CPU data
+flavours of statistic_add() which require the client to lock per-CPU data
 in one go for improved performance:
 
   {
@@ -672,20 +723,43 @@ in one go for improved performance:
 	  ...
 
 	  local_irq_save(flags);
-	  statistic_inc_nolock(&one->stat, MY_ENTITY_STAT_X, x);
-	  statistic_inc_nolock(&one->stat, MY_ENTITY_STAT_Y, y);
-	  statistic_add_nolock(&one->stat, MY_ENTITY_STAT_Z, z, number);
+	  _statistic_inc(&one->stat, MY_ENTITY_STAT_X, x);
+	  _statistic_inc(&one->stat, MY_ENTITY_STAT_Y, y);
+	  _statistic_add(&one->stat, MY_ENTITY_STAT_Z, z, number);
 	  ...
 	  local_irq_restore(flags);
   }
 
+You may use the *statistic_*_as() functions instead if you feel that - for your
+purposes - the performance gain outweighs the flexibility of statistic_add() &
+friends. The *statistic_*_as() functions do not allow user's to change the way
+data processing is done (that is the "type=" attribute), but require the client
+to provide this information through an additional parameter passed to the
+*statistic_*_as() functions. For example, the counter named MY_ENTITY_STAT_O
+can't be inflated to a histogram at run time.
+
+  {
+	  struct my_entity *one;
+	  unsigned long flags;
+	  ...
+
+	  local_irq_save(flags);
+	  _statistic_inc_as(STAT_CNTR_INC, &one->stat, MY_ENTITY_STAT_O, o);
+	  _statistic_add_as(STAT_UTIL, &one->stat, MY_ENTITY_STAT_P, p, number);
+	  ...
+	  local_irq_restore(flags);
+  }
+
+Make sure you have set the STATISTIC_FLAGS_NOFLEX flag for statistics
+which are fed through *statistic_*_as() function to prohibit the alteration
+of the "type=" attribute.
+
 The above examples show statistics that feed on incremental updates that
 get accumulated by the statistics infrastructure on top of data already
 gathered by the statistics infrastructure.
-That is why statistic_add() or statistic_inc() respectively are used.
 
 There might be statistics that come as total numbers, e.g. because they feed
-on counters already maintained by the exploiter or some hardware feature.
+on counters already maintained by the client or some hardware feature.
 These numbers can be exported through the statistics infrastructure along
 with any other statistic. In this case, use statistic_set() to report data.
 Usually it is sufficient to do so when the user opens the corresponding
diff -puN MAINTAINERS~statistics-infrastructure MAINTAINERS
--- a/MAINTAINERS~statistics-infrastructure
+++ a/MAINTAINERS
@@ -3381,6 +3381,13 @@ STARMODE RADIO IP (STRIP) PROTOCOL DRIVE
 W:	http://mosquitonet.Stanford.EDU/strip.html
 S:	Unsupported ?
 
+STATISTICS INFRASTRUCTURE
+P:	Martin Peschke
+M:	mpeschke@de.ibm.com
+M:	linux390@de.ibm.com
+W:	http://www.ibm.com/developerworks/linux/linux390/
+S:	Supported
+
 STRADIS MPEG-2 DECODER DRIVER
 P:	Nathan Laredo
 M:	laredo@gnu.org
diff -puN arch/s390/Kconfig~statistics-infrastructure arch/s390/Kconfig
--- a/arch/s390/Kconfig~statistics-infrastructure
+++ a/arch/s390/Kconfig
@@ -547,6 +547,8 @@ config KPROBES
 	  for kernel debugging, non-intrusive instrumentation and testing.
 	  If in doubt, say "N".
 
+source "lib/Kconfig.statistic"
+
 endmenu
 
 source "arch/s390/Kconfig.debug"
diff -puN arch/s390/oprofile/Kconfig~statistics-infrastructure arch/s390/oprofile/Kconfig
--- a/arch/s390/oprofile/Kconfig~statistics-infrastructure
+++ a/arch/s390/oprofile/Kconfig
@@ -1,6 +1,3 @@
-
-menu "Profiling support"
-
 config PROFILING
 	bool "Profiling support"
 	help
@@ -18,5 +15,3 @@ config OPROFILE
 
 	  If unsure, say N.
 
-endmenu
-
diff -puN include/linux/jiffies.h~statistics-infrastructure include/linux/jiffies.h
--- a/include/linux/jiffies.h~statistics-infrastructure
+++ a/include/linux/jiffies.h
@@ -278,7 +278,7 @@ extern u64 nsec_to_clock_t(u64 x);
 
 #define TIMESTAMP_SIZE	30
 
-static inline int nsec_to_timestamp(char *s, unsigned long long t)
+static inline int nsec_to_timestamp(char *s, u64 t)
 {
 	unsigned long nsec_rem = do_div(t, NSEC_PER_SEC);
 	return sprintf(s, "[%5lu.%06lu]", (unsigned long)t,
diff -puN /dev/null include/linux/statistic.h
--- /dev/null
+++ a/include/linux/statistic.h
@@ -0,0 +1,281 @@
+/*
+ * include/linux/statistic.h
+ *
+ * Statistics facility
+ *
+ * (C) Copyright IBM Corp. 2005, 2006
+ *
+ * Author(s): Martin Peschke <mpeschke@de.ibm.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2, or (at your option)
+ * any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+
+#ifndef STATISTIC_H
+#define STATISTIC_H
+
+#include <linux/fs.h>
+#include <linux/types.h>
+#include <linux/percpu.h>
+
+/**
+ * struct statistic_info - description of a class of statistics
+ * @name: pointer to name name string
+ * @x_unit: pointer to string describing unit of X of (X, Y) data pair
+ * @y_unit: pointer to string describing unit of Y of (X, Y) data pair
+ * @flags: bits describing special settings
+ * @defaults: pointer to string describing defaults setting for attributes
+ *
+ * Exploiters must setup an array of struct statistic_info for a
+ * corresponding array of struct statistic, which are then pointed to
+ * by struct statistic_interface.
+ *
+ * Struct statistic_info and all members and addressed strings must stay for
+ * the lifetime of corresponding statistics created with statistic_create().
+ *
+ * Except for the name string, all other members may be left blank.
+ * It would be nice of clients to fill it out completely, though.
+ */
+struct statistic_info {
+/* public: */
+	char *name;
+	char *x_unit;
+	char *y_unit;
+	int  flags;
+#define STATISTIC_FLAGS_NOINCR	0x01	/* no incremental data */
+#define STATISTIC_FLAGS_NOFLEX	0x02	/* type can't be altered by user */
+	char *defaults;
+};
+
+enum statistic_state {
+	STATISTIC_STATE_INVALID,
+	STATISTIC_STATE_UNCONFIGURED,
+	STATISTIC_STATE_RELEASED,
+	STATISTIC_STATE_OFF,
+	STATISTIC_STATE_ON
+};
+
+enum statistic_type {
+	STAT_CNTR_INC,
+	STAT_CNTR_PROD,
+	STAT_UTIL,
+	STAT_HGRAM_LIN,
+	STAT_HGRAM_LOG2,
+	STAT_SPARSE,
+	STAT_NONE
+};
+
+/**
+ * struct statistic - any data required for gathering data for a statistic
+ */
+struct statistic {
+/* private: */
+	enum statistic_state	 state;
+	enum statistic_type	 type;
+	void			*data;
+	void			(*add)(struct statistic *, s64, u64);
+	u64			 started;
+	u64			 stopped;
+	u64			 age;
+	union {
+		struct {
+			s64 range_min;
+			u32 last_index;
+			u32 base_interval;
+		} histogram;
+		struct {
+			u32 entries_max;
+		} sparse;
+	} u;
+};
+
+/**
+ * struct statistic_interface - collection of statistics for an entity
+ * @stat: a struct statistic array
+ * @info: a struct statistic_info array describing the struct statistic array
+ * @number: number of entries in both arrays
+ * @pull: an optional function called when user reads data from file
+ * @pull_private: optional data pointer passed to pull function
+ *
+ * Exploiters must setup a struct statistic_interface prior to calling
+ * statistic_create().
+ */
+struct statistic_interface {
+/* private: */
+	struct list_head	 list;
+	struct dentry		*debugfs_dir;
+	struct dentry		*data_file;
+	struct dentry		*def_file;
+/* public: */
+	struct statistic	*stat;
+	struct statistic_info	*info;
+	int			 number;
+	int			(*pull)(void*);
+	void			*pull_private;
+};
+
+#ifdef CONFIG_STATISTICS
+
+extern int statistic_create(struct statistic_interface *, const char *);
+extern int statistic_remove(struct statistic_interface *);
+
+extern void statistic_set(struct statistic *, int, s64, u64);
+
+extern void _statistic_add(struct statistic *, int, s64, u64);
+extern void statistic_add(struct statistic *, int, s64, u64);
+
+/*
+ * Clients are not supposed to call these directly.
+ * The declarations are needed to allow optimisation of _statistic_add_as()
+ * at compile time.
+ */
+extern void statistic_add_counter_inc(struct statistic *, s64, u64);
+extern void statistic_add_counter_prod(struct statistic *, s64, u64);
+extern void statistic_add_util(struct statistic *, s64, u64);
+extern void statistic_add_histogram_lin(struct statistic *, s64, u64);
+extern void statistic_add_histogram_log2(struct statistic *, s64, u64);
+extern void statistic_add_sparse(struct statistic *, s64, u64);
+
+/**
+ * _statistic_add_as - update statistic with incremental data in (X, Y) pair
+ * @type: data proessing mode to be used (must match statistic_info::defaults)
+ * @stat: struct statistic array
+ * @i: index of statistic to be updated
+ * @value: X
+ * @incr: Y
+ *
+ * The actual processing of the (X, Y) data pair is determined by the current
+ * definition applied to the statistic. See Documentation/statistics.txt.
+ *
+ * This function is faster than _statistic_add() because the data
+ * processing mode is already determined at compile time.
+ * Use this when you feel that the perfomance gain outweighs the loss
+ * of flexibility for your particular statistic.
+ *
+ * This variant leaves protecting per-cpu data to clients. It is preferred
+ * whenever clients update several statistics of the same entity in one go.
+ *
+ * You may want to use _statistic_inc_as() for (X, 1) data pairs.
+ */
+static inline void _statistic_add_as(int type, struct statistic *stat, int i,
+				     s64 value, u64 incr)
+{
+	if (stat[i].state == STATISTIC_STATE_ON) {
+		switch (type) {
+		case STAT_CNTR_INC:
+			statistic_add_counter_inc(&stat[i], value, incr);
+			break;
+		case STAT_CNTR_PROD:
+			statistic_add_counter_prod(&stat[i], value, incr);
+			break;
+		case STAT_UTIL:
+			statistic_add_util(&stat[i], value, incr);
+			break;
+		case STAT_HGRAM_LIN:
+			statistic_add_histogram_lin(&stat[i], value, incr);
+			break;
+		case STAT_HGRAM_LOG2:
+			statistic_add_histogram_log2(&stat[i], value, incr);
+			break;
+		case STAT_SPARSE:
+			statistic_add_sparse(&stat[i], value, incr);
+			break;
+		}
+	}
+}
+
+/**
+ * statistic_add_as - update statistic with incremental data in (X, Y) pair
+ * @type: data proessing mode to be used (must match statistic_info::defaults)
+ * @stat: struct statistic array
+ * @i: index of statistic to be updated
+ * @value: X
+ * @incr: Y
+ *
+ * The actual processing of the (X, Y) data pair is determined by the current
+ * the definition applied to the statistic. See Documentation/statistics.txt.
+ *
+ * This function is faster than statistic_add() because the data
+ * processing mode is already determined at compile time.
+ * Use this when you feel that the perfomance gain outweighs the loss
+ * of flexibility for your particular statistic.
+ *
+ * This variant takes care of protecting per-cpu data. It is preferred whenever
+ * clients don't update several statistics of the same entity in one go.
+ *
+ * You may want to use statistic_inc() for (X, 1) data pairs.
+ */
+static inline void statistic_add_as(int type, struct statistic *stat, int i,
+				    s64 value, u64 incr)
+{
+	unsigned long flags;
+	local_irq_save(flags);
+	_statistic_add_as(type, stat, i, value, incr);
+	local_irq_restore(flags);
+}
+
+#else /* !CONFIG_STATISTICS */
+/* These NOP functions unburden clients from handling !CONFIG_STATISTICS. */
+
+static inline int statistic_create(struct statistic_interface *interface,
+				   const char *name)
+{
+	return 0;
+}
+
+static inline int statistic_remove(struct statistic_interface *interface)
+{
+	return 0;
+}
+
+static inline void statistic_set(struct statistic *stat, int i,
+				 s64 value, u64 total)
+{
+}
+
+static inline void _statistic_add(struct statistic *stat, int i,
+				  s64 value, u64 incr)
+{
+}
+
+static inline void statistic_add(struct statistic *stat, int i,
+				 s64 value, u64 incr)
+{
+}
+
+static inline void _statistic_add_as(int type, struct statistic *stat, int i,
+				     s64 value, u64 incr)
+{
+}
+
+static inline void statistic_add_as(int type, struct statistic *stat, int i,
+				    s64 value, u64 incr)
+{
+}
+
+#endif /* CONFIG_STATISTICS */
+
+#define _statistic_inc(stat, i, value) \
+	_statistic_add(stat, i, value, 1)
+
+#define statistic_inc(stat, i, value) \
+	statistic_add(stat, i, value, 1)
+
+#define _statistic_inc_as(type, stat, i, value) \
+	_statistic_add_as(type, stat, i, value, 1)
+
+#define statistic_inc_as(type, stat, i, value) \
+	statistic_add_as(type, stat, i, value, 1)
+
+#endif /* STATISTIC_H */
diff -puN /dev/null lib/Kconfig.statistic
--- /dev/null
+++ a/lib/Kconfig.statistic
@@ -0,0 +1,11 @@
+config STATISTICS
+	bool "Statistics infrastructure"
+	depends on DEBUG_FS
+	help
+	  The statistics infrastructure provides a debugfs based user interface
+	  for statistics of kernel components. Statistics are available for
+	  components that have been instrumented to feed data into the
+	  statistics infrastructure.
+	  This feature is useful for performance measurements or performance
+	  debugging.
+	  If in doubt, say "N".
diff -puN lib/Makefile~statistics-infrastructure lib/Makefile
--- a/lib/Makefile~statistics-infrastructure
+++ a/lib/Makefile
@@ -60,6 +60,8 @@ obj-$(CONFIG_TEXTSEARCH_FSM) += ts_fsm.o
 obj-$(CONFIG_SMP) += percpu_counter.o
 obj-$(CONFIG_AUDIT_GENERIC) += audit.o
 
+obj-$(CONFIG_STATISTICS) += statistic.o
+
 obj-$(CONFIG_SWIOTLB) += swiotlb.o
 obj-$(CONFIG_FAULT_INJECTION) += fault-inject.o
 
diff -puN /dev/null lib/statistic.c
--- /dev/null
+++ a/lib/statistic.c
@@ -0,0 +1,1564 @@
+/*
+ *  lib/statistic.c
+ *    statistics facility
+ *
+ *    Copyright (C) 2005, 2006
+ *		IBM Deutschland Entwicklung GmbH,
+ *		IBM Corporation
+ *
+ *    Author(s): Martin Peschke (mpeschke@de.ibm.com),
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2, or (at your option)
+ * any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ *
+ *    another bunch of ideas being pondered:
+ *	- define a set of agreed names or a naming scheme for
+ *	  consistency and comparability across clients;
+ *	  this entails an agreement about granularities
+ *	  as well (e.g. separate statistic for read/write/no-data commands);
+ *	  a common set of unit strings would be nice then, too, of course
+ *	  (e.g. "seconds", "milliseconds", "microseconds", ...)
+ *	- perf. opt. of array: table lookup of values, binary search for values
+ *	- another statistic disclipline based on some sort of tree, but
+ *	  similar in semantics to list discipline (for high-perf. histograms of
+ *	  discrete values)
+ *	- allow for more than a single "view" on data at the same time by
+ *	  providing the capability to attach several (a list of) "definitions"
+ *	  to a struct statistic
+ *	  (e.g. show histogram of requests sizes and history of megabytes/sec.
+ *	  at the same time)
+ *	- multi-dimensional statistic (combination of two or more
+ *	  characteristics/discriminators); worth the effort??
+ *	  (e.g. a matrix of occurences for latencies of requests of
+ *	  particular sizes)
+ *
+ *	FIXME:
+ *	- statistics file access when statistics are being removed
+ */
+
+#include <linux/fs.h>
+#include <linux/debugfs.h>
+#include <linux/module.h>
+#include <linux/list.h>
+#include <linux/parser.h>
+#include <linux/time.h>
+#include <linux/sched.h>
+#include <linux/cpu.h>
+#include <linux/percpu.h>
+#include <linux/mutex.h>
+#include <linux/statistic.h>
+
+#include <asm/bug.h>
+#include <asm/uaccess.h>
+
+struct statistic_file_private {
+	struct list_head read_seg_lh;
+	struct list_head write_seg_lh;
+	size_t write_seg_total_size;
+};
+
+struct statistic_merge_private {
+	struct statistic *stat;
+	spinlock_t lock;
+	void *dst;
+};
+
+/**
+ * struct statistic_discipline - description of a data processing mode
+ * @parse: parses additional attributes specific to this mode (if any)
+ * @size: sizes a data area prior to allocation (mandatory)
+ * @reset: discards content of a data area (mandatory)
+ * @merge: merges content of a data area into another data area (mandatory)
+ * @fdata: prints content of a data area into buffer (mandatory)
+ * @fdef: prints additional attributes specific to this mode (if any)
+ * @add: updates a data area for a statistic fed incremental data (mandatory)
+ * @set: updates a data area for a statistic fed total numbers (mandatory)
+ * @name: pointer to name string (mandatory)
+ *
+ * Struct statistic_discipline describes a statistic infrastructure internal
+ * programming interface. Another data processing mode can be added by
+ * implementing these routines and appending an entry to the
+ * statistic_discs array.
+ *
+ * "Data area" in te above description usually means a chunk of memory,
+ * may it be allocated for data gathering per CPU, or be shared by all
+ * CPUs, or used for other purposes, like merging per-CPU data when
+ * users read data from files. Implementers of data processing modes
+ * don't need to worry about the designation of a particular chunk of memory.
+ * A data area of a data processing mode always has to look the same.
+ */
+struct statistic_discipline {
+	int (*parse)(struct statistic * stat, struct statistic_info *info,
+		     int type, char *def);
+	size_t (*size)(struct statistic * stat);
+	void (*reset)(struct statistic *stat, void *ptr);
+	void (*merge)(struct statistic *stat, void *dst, void *src);
+	int (*fdata)(struct statistic *stat, const char *name,
+		     struct statistic_file_private *fpriv, void *data);
+	int (*fdef)(struct statistic *stat, char *line);
+	void (*add)(struct statistic *stat, s64 value, u64 incr);
+	void (*set)(struct statistic *stat, s64 value, u64 total);
+	char *name;
+};
+
+static struct statistic_discipline statistic_discs[];
+
+static int statistic_initialise(struct statistic *stat)
+{
+	stat->type = STAT_NONE;
+	stat->state = STATISTIC_STATE_UNCONFIGURED;
+	return 0;
+}
+
+static int statistic_uninitialise(struct statistic *stat)
+{
+	stat->state = STATISTIC_STATE_INVALID;
+	return 0;
+}
+
+static int statistic_define(struct statistic *stat)
+{
+	if (stat->type == STAT_NONE)
+		return -EINVAL;
+	stat->state = STATISTIC_STATE_RELEASED;
+	return 0;
+}
+
+static int statistic_free(struct statistic *stat, struct statistic_info *info)
+{
+	struct statistic_discipline *disc = &statistic_discs[stat->type];
+	int cpu;
+
+	if (unlikely(info->flags & STATISTIC_FLAGS_NOINCR)) {
+		disc->reset(stat, stat->data);
+		kfree(stat->data);
+	} else {
+		for_each_online_cpu(cpu)
+			disc->reset(stat, percpu_ptr(stat->data, cpu));
+		percpu_free(stat->data);
+	}
+	stat->state = STATISTIC_STATE_RELEASED;
+	return 0;
+}
+
+static int statistic_alloc(struct statistic *stat,
+			   struct statistic_info *info)
+{
+	struct statistic_discipline *disc = &statistic_discs[stat->type];
+	size_t size = disc->size(stat);
+	int cpu;
+
+	if (unlikely(info->flags & STATISTIC_FLAGS_NOINCR)) {
+		stat->data = kzalloc(size, GFP_KERNEL);
+		if (unlikely(!stat->data))
+			return -ENOMEM;
+		disc->reset(stat, stat->data);
+	} else {
+		stat->data = percpu_alloc(size, GFP_KERNEL);
+		if (unlikely(!stat->data))
+			return -ENOMEM;
+		for_each_online_cpu(cpu)
+			disc->reset(stat, percpu_ptr(stat->data, cpu));
+	}
+	stat->age = timestamp_clock();
+	stat->state = STATISTIC_STATE_OFF;
+	return 0;
+}
+
+static int statistic_start(struct statistic *stat)
+{
+	stat->started = timestamp_clock();
+	stat->state = STATISTIC_STATE_ON;
+	return 0;
+}
+
+static void _statistic_barrier(void *unused)
+{
+}
+
+static int statistic_stop(struct statistic *stat)
+{
+	stat->stopped = timestamp_clock();
+	stat->state = STATISTIC_STATE_OFF;
+	/* ensures that all CPUs have ceased updating statistics */
+	smp_mb();
+	on_each_cpu(_statistic_barrier, NULL, 0, 1);
+	return 0;
+}
+
+static int statistic_transition(struct statistic *stat,
+				struct statistic_info *info,
+				enum statistic_state requested_state)
+{
+	int z = requested_state < stat->state ? 1 : 0;
+	int retval = 0;
+
+	while (!retval && stat->state != requested_state) {
+		switch (stat->state) {
+		case STATISTIC_STATE_INVALID:
+			retval = z ? -EINVAL : statistic_initialise(stat);
+			break;
+		case STATISTIC_STATE_UNCONFIGURED:
+			retval = z ? statistic_uninitialise(stat)
+				   : statistic_define(stat);
+			break;
+		case STATISTIC_STATE_RELEASED:
+			retval = z ? statistic_initialise(stat)
+				   : statistic_alloc(stat, info);
+			break;
+		case STATISTIC_STATE_OFF:
+			retval = z ? statistic_free(stat, info)
+				   : statistic_start(stat);
+			break;
+		case STATISTIC_STATE_ON:
+			retval = z ? statistic_stop(stat) : -EINVAL;
+			break;
+		}
+	}
+	return retval;
+}
+
+static int statistic_reset(struct statistic *stat, struct statistic_info *info)
+{
+	struct statistic_discipline *disc = &statistic_discs[stat->type];
+	enum statistic_state prev_state = stat->state;
+	int cpu;
+
+	if (unlikely(stat->state < STATISTIC_STATE_OFF))
+		return 0;
+	statistic_transition(stat, info, STATISTIC_STATE_OFF);
+	if (unlikely(info->flags & STATISTIC_FLAGS_NOINCR))
+		disc->reset(stat, stat->data);
+	else
+		for_each_online_cpu(cpu)
+			disc->reset(stat, percpu_ptr(stat->data, cpu));
+	stat->age = timestamp_clock();
+	statistic_transition(stat, info, prev_state);
+	return 0;
+}
+
+static void statistic_merge(void *__mpriv)
+{
+	struct statistic_merge_private *mpriv = __mpriv;
+	struct statistic *stat = mpriv->stat;
+	struct statistic_discipline *disc = &statistic_discs[stat->type];
+	void *src = percpu_ptr(stat->data, smp_processor_id());
+
+	spin_lock(&mpriv->lock);
+	disc->merge(stat, mpriv->dst, src);
+	spin_unlock(&mpriv->lock);
+}
+
+struct sgrb_seg {
+	struct list_head list;
+	char *address;
+	int offset;
+	int size;
+};
+
+static struct sgrb_seg *sgrb_seg_find(struct list_head *lh, int size)
+{
+	struct sgrb_seg *seg;
+
+	/* only the last buffer, if any, may have spare bytes */
+	list_for_each_entry_reverse(seg, lh, list) {
+		if (likely((PAGE_SIZE - seg->offset) >= size))
+			return seg;
+		break;
+	}
+	seg = kzalloc(sizeof(struct sgrb_seg), GFP_KERNEL);
+	if (unlikely(!seg))
+		return NULL;
+	seg->size = PAGE_SIZE;
+	seg->address = (void*)__get_free_page(GFP_KERNEL);
+	if (unlikely(!seg->address)) {
+		kfree(seg);
+		return NULL;
+	}
+	list_add_tail(&seg->list, lh);
+	return seg;
+}
+
+static void sgrb_seg_release_all(struct list_head *lh)
+{
+	struct sgrb_seg *seg, *tmp;
+
+	list_for_each_entry_safe(seg, tmp, lh, list) {
+		list_del(&seg->list);
+		free_page((unsigned long)seg->address);
+		kfree(seg);
+	}
+}
+
+static char *statistic_state_strings[] = {
+	"undefined(BUG)",
+	"unconfigured",
+	"released",
+	"off",
+	"on",
+};
+
+static int statistic_fdef(struct statistic_interface *interface, int i,
+			  struct statistic_file_private *private)
+{
+	struct statistic *stat = &interface->stat[i];
+	struct statistic_info *info = &interface->info[i];
+	struct statistic_discipline *disc = &statistic_discs[stat->type];
+	struct sgrb_seg *seg;
+	char t0[TIMESTAMP_SIZE], t1[TIMESTAMP_SIZE], t2[TIMESTAMP_SIZE];
+
+	seg = sgrb_seg_find(&private->read_seg_lh, 512);
+	if (unlikely(!seg))
+		return -ENOMEM;
+
+	seg->offset += sprintf(seg->address + seg->offset,
+			       "name=%s state=%s units=%s/%s",
+			       info->name, statistic_state_strings[stat->state],
+			       info->x_unit, info->y_unit);
+	if (stat->state == STATISTIC_STATE_UNCONFIGURED) {
+		seg->offset += sprintf(seg->address + seg->offset, "\n");
+		return 0;
+	}
+
+	seg->offset += sprintf(seg->address + seg->offset, " type=%s",
+			       disc->name);
+	if (info->flags & STATISTIC_FLAGS_NOFLEX)
+		seg->offset += sprintf(seg->address + seg->offset, "(fix)");
+
+	if (disc->fdef)
+		seg->offset += disc->fdef(stat, seg->address + seg->offset);
+	if (stat->state == STATISTIC_STATE_RELEASED) {
+		seg->offset += sprintf(seg->address + seg->offset, "\n");
+		return 0;
+	}
+
+	nsec_to_timestamp(t0, stat->age);
+	nsec_to_timestamp(t1, stat->started);
+	nsec_to_timestamp(t2, stat->stopped);
+	seg->offset += sprintf(seg->address + seg->offset,
+			       " data=%s started=%s stopped=%s\n", t0, t1, t2);
+	return 0;
+}
+
+static int statistic_fdata(struct statistic_interface *interface, int i,
+			   struct statistic_file_private *fpriv)
+{
+	struct statistic *stat = &interface->stat[i];
+	struct statistic_info *info = &interface->info[i];
+	struct statistic_discipline *disc = &statistic_discs[stat->type];
+	struct statistic_merge_private mpriv;
+	size_t size = disc->size(stat);
+	int retval;
+
+	if (unlikely(stat->state < STATISTIC_STATE_OFF))
+		return 0;
+	if (unlikely(info->flags & STATISTIC_FLAGS_NOINCR))
+		return disc->fdata(stat, info->name, fpriv, stat->data);
+	mpriv.dst = kzalloc(size, GFP_KERNEL);
+	if (unlikely(!mpriv.dst))
+		return -ENOMEM;
+	disc->reset(stat, mpriv.dst);
+	spin_lock_init(&mpriv.lock);
+	mpriv.stat = stat;
+	on_each_cpu(statistic_merge, &mpriv, 0, 1);
+	retval = disc->fdata(stat, info->name, fpriv, mpriv.dst);
+	kfree(mpriv.dst);
+	return retval;
+}
+
+/* cpu hotplug handling for per-cpu data */
+
+static int _statistic_hotcpu(struct statistic_interface *interface,
+			     int i, unsigned long action, int cpu)
+{
+	struct statistic *stat = &interface->stat[i];
+	struct statistic_info *info = &interface->info[i];
+	struct statistic_discipline *disc = &statistic_discs[stat->type];
+	void *src, *dst;
+	size_t size;
+	unsigned long flags;
+
+	if (unlikely(info->flags & STATISTIC_FLAGS_NOINCR))
+		return NOTIFY_OK;
+	if (stat->state < STATISTIC_STATE_OFF)
+		return NOTIFY_OK;
+	switch (action) {
+	case CPU_UP_PREPARE:
+		size = disc->size(stat);
+		dst = percpu_populate(stat->data, size, GFP_KERNEL, cpu);
+		if (!dst)
+			return NOTIFY_BAD;
+		disc->reset(stat, dst);
+		break;
+	case CPU_UP_CANCELED:
+	case CPU_DEAD:
+		local_irq_save(flags);
+		dst = percpu_ptr(stat->data, smp_processor_id());
+		src = percpu_ptr(stat->data, cpu);
+		disc->merge(stat, dst, src);
+		local_irq_restore(flags);
+		percpu_depopulate(stat->data, cpu);
+		break;
+	}
+	return NOTIFY_OK;
+}
+
+static struct list_head statistic_list;
+static struct mutex statistic_list_mutex;
+
+static int __cpuinit statistic_hotcpu(struct notifier_block *notifier,
+				      unsigned long action, void *__cpu)
+{
+	int cpu = (unsigned long)__cpu, i, retval = NOTIFY_OK;
+	struct statistic_interface *interface;
+
+	mutex_lock(&statistic_list_mutex);
+	list_for_each_entry(interface, &statistic_list, list)
+		for (i = 0; i < interface->number; i++) {
+			retval = _statistic_hotcpu(interface, i, action, cpu);
+			if (retval == NOTIFY_BAD)
+				goto unlock;
+		}
+unlock:
+	mutex_unlock(&statistic_list_mutex);
+	return retval;
+}
+
+static struct notifier_block statistic_hotcpu_notifier =
+{
+	.notifier_call = statistic_hotcpu,
+};
+
+/* module startup / removal */
+
+static struct dentry *statistic_root_dir;
+
+int __init statistic_init(void)
+{
+	statistic_root_dir = debugfs_create_dir("statistics", NULL);
+	if (unlikely(!statistic_root_dir))
+		return -ENOMEM;
+	INIT_LIST_HEAD(&statistic_list);
+	mutex_init(&statistic_list_mutex);
+	register_cpu_notifier(&statistic_hotcpu_notifier);
+	return 0;
+}
+
+void __exit statistic_exit(void)
+{
+	unregister_cpu_notifier(&statistic_hotcpu_notifier);
+	debugfs_remove(statistic_root_dir);
+}
+
+/* parser used for configuring statistics */
+
+static int statistic_parse_single(struct statistic *stat,
+				  struct statistic_info *info,
+				  char *def, int type)
+{
+	struct statistic_discipline *disc = &statistic_discs[type];
+	int prev_state = stat->state, retval = 0;
+	char *copy;
+
+	if (info->flags & STATISTIC_FLAGS_NOFLEX && stat->type != type &&
+	    def != info->defaults)
+		return -EINVAL;
+	if (disc->parse) {
+		copy = kstrdup(def, GFP_KERNEL);
+		if (unlikely(!copy))
+			return -ENOMEM;
+		retval = disc->parse(stat, info, type, copy);
+		kfree(copy);
+	} else if (type != stat->type)
+		statistic_transition(stat, info, STATISTIC_STATE_UNCONFIGURED);
+	if (!retval) {
+		stat->type = type;
+		stat->add = disc->add;
+	}
+	statistic_transition(stat, info,
+			     max(prev_state, STATISTIC_STATE_RELEASED));
+	return retval;
+}
+
+static match_table_t statistic_match_type = {
+	{1, "type=%s"},
+	{9, NULL}
+};
+
+static int statistic_parse_match(struct statistic *stat,
+				 struct statistic_info *info, char *def)
+{
+	int type, len;
+	char *p, *copy, *twisted;
+	substring_t args[MAX_OPT_ARGS];
+	struct statistic_discipline *disc;
+
+	if (!def)
+		def = info->defaults;
+	twisted = copy = kstrdup(def, GFP_KERNEL);
+	if (unlikely(!copy))
+		return -ENOMEM;
+	while ((p = strsep(&twisted, " ")) != NULL) {
+		if (!*p)
+			continue;
+		if (match_token(p, statistic_match_type, args) != 1)
+			continue;
+		len = (args[0].to - args[0].from) + 1;
+		for (type = 0; type < STAT_NONE; type++) {
+			disc = &statistic_discs[type];
+			if (unlikely(strncmp(disc->name, args[0].from, len)))
+				continue;
+			kfree(copy);
+			return statistic_parse_single(stat, info, def, type);
+		}
+	}
+	kfree(copy);
+	if (unlikely(stat->type == STAT_NONE))
+		return -EINVAL;
+	return statistic_parse_single(stat, info, def, stat->type);
+}
+
+static match_table_t statistic_match_common = {
+	{STATISTIC_STATE_UNCONFIGURED, "state=unconfigured"},
+	{STATISTIC_STATE_RELEASED, "state=released"},
+	{STATISTIC_STATE_OFF, "state=off"},
+	{STATISTIC_STATE_ON, "state=on"},
+	{1001, "name=%s"},
+	{1002, "data=reset"},
+	{1003, "defaults"},
+	{9999, NULL}
+};
+
+static void statistic_parse_line(struct statistic_interface *interface,
+				 char *def)
+{
+	char *p, *copy, *twisted, *name = NULL;
+	substring_t args[MAX_OPT_ARGS];
+	int token, reset = 0, defaults = 0, i;
+	int state = STATISTIC_STATE_INVALID;
+	struct statistic *stat = interface->stat;
+	struct statistic_info *info = interface->info;
+
+	if (unlikely(!def))
+		return;
+	twisted = copy = kstrdup(def, GFP_KERNEL);
+	if (unlikely(!copy))
+		return;
+
+	while ((p = strsep(&twisted, " ")) != NULL) {
+		if (!*p)
+			continue;
+		token = match_token(p, statistic_match_common, args);
+		switch (token) {
+		case STATISTIC_STATE_UNCONFIGURED:
+		case STATISTIC_STATE_RELEASED:
+		case STATISTIC_STATE_OFF:
+		case STATISTIC_STATE_ON:
+			state = token;
+			break;
+		case 1001:
+			if (likely(!name))
+				name = match_strdup(&args[0]);
+			break;
+		case 1002:
+			reset = 1;
+			break;
+		case 1003:
+			defaults = 1;
+			break;
+		}
+	}
+	for (i = 0; i < interface->number; i++, stat++, info++) {
+		if (!name || (name && !strcmp(name, info->name))) {
+			if (defaults)
+				statistic_parse_match(stat, info, NULL);
+			if (name)
+				statistic_parse_match(stat, info, def);
+			if (state != STATISTIC_STATE_INVALID)
+				statistic_transition(stat, info, state);
+			if (reset)
+				statistic_reset(stat, info);
+		}
+	}
+	kfree(copy);
+	kfree(name);
+}
+
+static void statistic_parse(struct statistic_interface *interface,
+			    struct list_head *line_lh, size_t line_size)
+{
+	struct sgrb_seg *seg, *tmp;
+	char *buf;
+	int offset = 0;
+
+	if (unlikely(!line_size))
+		return;
+	buf = kmalloc(line_size + 2, GFP_KERNEL);
+	if (unlikely(!buf))
+		return;
+	buf[line_size] = ' ';
+	buf[line_size + 1] = '\0';
+	list_for_each_entry_safe(seg, tmp, line_lh, list) {
+		memcpy(buf + offset, seg->address, seg->size);
+		offset += seg->size;
+		list_del(&seg->list);
+		kfree(seg);
+	}
+	statistic_parse_line(interface, buf);
+	kfree(buf);
+}
+
+/* sequential files comprising user interface */
+
+static int statistic_generic_open(struct inode *inode,
+		struct file *file, struct statistic_interface **interface,
+		struct statistic_file_private **private)
+{
+	*interface = inode->i_private;
+	BUG_ON(!interface);
+	*private = kzalloc(sizeof(struct statistic_file_private), GFP_KERNEL);
+	if (unlikely(!*private))
+		return -ENOMEM;
+	INIT_LIST_HEAD(&(*private)->read_seg_lh);
+	INIT_LIST_HEAD(&(*private)->write_seg_lh);
+	file->private_data = *private;
+	return 0;
+}
+
+static int statistic_generic_close(struct inode *inode, struct file *file)
+{
+	struct statistic_file_private *private = file->private_data;
+	BUG_ON(!private);
+	sgrb_seg_release_all(&private->read_seg_lh);
+	sgrb_seg_release_all(&private->write_seg_lh);
+	kfree(private);
+	return 0;
+}
+
+static ssize_t statistic_generic_read(struct file *file,
+				char __user *buf, size_t len, loff_t *offset)
+{
+	struct statistic_file_private *private = file->private_data;
+	struct sgrb_seg *seg;
+	size_t seg_offset, seg_residual, seg_transfer;
+	size_t transfered = 0;
+	loff_t pos = 0;
+
+	BUG_ON(!private);
+	list_for_each_entry(seg, &private->read_seg_lh, list) {
+		if (unlikely(!len))
+			break;
+		if (*offset >= pos && *offset <= (pos + seg->offset)) {
+			seg_offset = *offset - pos;
+			seg_residual = seg->offset - seg_offset;
+			seg_transfer = min(len, seg_residual);
+			if (unlikely(copy_to_user(buf + transfered,
+						  seg->address + seg_offset,
+						  seg_transfer)))
+				return -EFAULT;
+			transfered += seg_transfer;
+			*offset += seg_transfer;
+			pos += seg_transfer + seg_offset;
+			len -= seg_transfer;
+		} else
+			pos += seg->offset;
+	}
+	return transfered;
+}
+
+static ssize_t statistic_generic_write(struct file *file,
+			const char __user *buf, size_t len, loff_t *offset)
+{
+	struct statistic_file_private *private = file->private_data;
+	struct sgrb_seg *seg;
+	size_t seg_residual, seg_transfer;
+	size_t transfered = 0;
+
+	BUG_ON(!private);
+	if (unlikely(*offset != private->write_seg_total_size))
+		return -EPIPE;
+	while (len) {
+		seg = sgrb_seg_find(&private->write_seg_lh, 1);
+		if (unlikely(!seg))
+			return -ENOMEM;
+		seg_residual = seg->size - seg->offset;
+		seg_transfer = min(len, seg_residual);
+		if (unlikely(copy_from_user(seg->address + seg->offset,
+					    buf + transfered, seg_transfer)))
+			return -EFAULT;
+		private->write_seg_total_size += seg_transfer;
+		seg->offset += seg_transfer;
+		transfered += seg_transfer;
+		*offset += seg_transfer;
+		len -= seg_transfer;
+	}
+	return transfered;
+}
+
+static int statistic_def_close(struct inode *inode, struct file *file)
+{
+	struct statistic_interface *interface = inode->i_private;
+	struct statistic_file_private *private = file->private_data;
+	struct sgrb_seg *seg, *seg_nl;
+	int offset;
+	LIST_HEAD(line_lh);
+	char *nl;
+	size_t line_size = 0;
+
+	list_for_each_entry(seg, &private->write_seg_lh, list) {
+		for (offset = 0; offset < seg->offset; offset += seg_nl->size) {
+			seg_nl = kmalloc(sizeof(struct sgrb_seg), GFP_KERNEL);
+			if (unlikely(!seg_nl))
+				goto out;
+			seg_nl->address = seg->address + offset;
+			nl = strnchr(seg_nl->address,
+				     seg->offset - offset, '\n');
+			if (nl) {
+				seg_nl->offset = nl - seg_nl->address;
+				if (seg_nl->offset)
+					seg_nl->offset--;
+			} else
+				seg_nl->offset = seg->offset - offset;
+			seg_nl->size = seg_nl->offset + 1;
+			line_size += seg_nl->size;
+			list_add_tail(&seg_nl->list, &line_lh);
+			if (nl) {
+				statistic_parse(interface, &line_lh, line_size);
+				line_size = 0;
+			}
+		}
+	}
+out:
+	if (!list_empty(&line_lh))
+		statistic_parse(interface, &line_lh, line_size);
+	return statistic_generic_close(inode, file);
+}
+
+static int statistic_def_open(struct inode *inode, struct file *file)
+{
+	struct statistic_interface *interface;
+	struct statistic_file_private *private;
+	int retval = 0;
+	int i;
+
+	retval = statistic_generic_open(inode, file, &interface, &private);
+	if (unlikely(retval))
+		return retval;
+	for (i = 0; i < interface->number; i++) {
+		retval = statistic_fdef(interface, i, private);
+		if (unlikely(retval)) {
+			statistic_def_close(inode, file);
+			break;
+		}
+	}
+	return retval;
+}
+
+static int statistic_data_open(struct inode *inode, struct file *file)
+{
+	struct statistic_interface *interface;
+	struct statistic_file_private *private;
+	int retval = 0;
+	int i;
+
+	retval = statistic_generic_open(inode, file, &interface, &private);
+	if (unlikely(retval))
+		return retval;
+	if (interface->pull)
+		interface->pull(interface->pull_private);
+	for (i = 0; i < interface->number; i++) {
+		retval = statistic_fdata(interface, i, private);
+		if (unlikely(retval)) {
+			statistic_generic_close(inode, file);
+			break;
+		}
+	}
+	return retval;
+}
+
+static struct file_operations statistic_def_fops = {
+	.owner		= THIS_MODULE,
+	.read		= statistic_generic_read,
+	.write		= statistic_generic_write,
+	.open		= statistic_def_open,
+	.release	= statistic_def_close,
+};
+
+static struct file_operations statistic_data_fops = {
+	.owner		= THIS_MODULE,
+	.read		= statistic_generic_read,
+	.open		= statistic_data_open,
+	.release	= statistic_generic_close,
+};
+
+/* code concerned with single value statistics */
+
+size_t statistic_size_counter(struct statistic *stat)
+{
+	return sizeof(u64);
+}
+
+static void statistic_reset_counter(struct statistic *stat, void *ptr)
+{
+	*(u64*)ptr = 0;
+}
+
+void statistic_add_counter_inc(struct statistic *stat, s64 value, u64 incr)
+{
+	*(u64*)percpu_ptr(stat->data, smp_processor_id()) += incr;
+}
+EXPORT_SYMBOL_GPL(statistic_add_counter_inc);
+
+void statistic_add_counter_prod(struct statistic *stat, s64 value, u64 incr)
+{
+	if (unlikely(value < 0))
+		value = -value;
+	*(u64*)percpu_ptr(stat->data, smp_processor_id()) += value * incr;
+}
+EXPORT_SYMBOL_GPL(statistic_add_counter_prod);
+
+static void statistic_set_counter_inc(struct statistic *stat,
+				      s64 value, u64 total)
+{
+	*(u64*)stat->data = total;
+}
+
+static void statistic_set_counter_prod(struct statistic *stat,
+				       s64 value, u64 total)
+{
+	if (unlikely(value < 0))
+		value = -value;
+	*(u64*)stat->data = value * total;
+}
+
+static void statistic_merge_counter(struct statistic *stat,
+				    void *dst, void *src)
+{
+	*(u64*)dst += *(u64*)src;
+}
+
+static int statistic_fdata_counter(struct statistic *stat, const char *name,
+				   struct statistic_file_private *fpriv,
+				   void *data)
+{
+	struct sgrb_seg *seg;
+	seg = sgrb_seg_find(&fpriv->read_seg_lh, 128);
+	if (unlikely(!seg))
+		return -ENOMEM;
+	seg->offset += sprintf(seg->address + seg->offset, "%s %Lu\n",
+			       name, *(unsigned long long *)data);
+	return 0;
+}
+
+/* code concerned with utilisation indicator statistic */
+
+struct statistic_entry_util {
+	u32 res;
+	u32 num;	/* FIXME: better 64 bit; do_div can't deal with it) */
+	s64 acc;
+	s64 sqr;
+	s64 min;
+	s64 max;
+};
+
+size_t statistic_size_util(struct statistic *stat)
+{
+	return sizeof(struct statistic_entry_util);
+}
+
+static void statistic_reset_util(struct statistic *stat, void *ptr)
+{
+	struct statistic_entry_util *util = ptr;
+	util->num = 0;
+	util->acc = 0;
+	util->sqr = 0;
+	util->min = LLONG_MAX;
+	util->max = LLONG_MIN;
+}
+
+void statistic_add_util(struct statistic *stat, s64 value, u64 incr)
+{
+	struct statistic_entry_util *util;
+	util = percpu_ptr(stat->data, smp_processor_id());
+	util->num += incr;
+	util->acc += value * incr;
+	util->sqr += value * value * incr;
+	if (unlikely(value < util->min))
+		util->min = value;
+	if (unlikely(value > util->max))
+		util->max = value;
+}
+EXPORT_SYMBOL_GPL(statistic_add_util);
+
+static void statistic_set_util(struct statistic *stat, s64 value, u64 total)
+{
+	struct statistic_entry_util *util = stat->data;
+	util->num = total;
+	util->acc = value * total;
+	util->sqr = value * value * total;
+	if (unlikely(value < util->min))
+		util->min = value;
+	if (unlikely(value > util->max))
+		util->max = value;
+}
+
+static void statistic_merge_util(struct statistic *stat, void *_dst, void *_src)
+{
+	struct statistic_entry_util *dst = _dst, *src = _src;
+	dst->num += src->num;
+	dst->acc += src->acc;
+	dst->sqr += src->sqr;
+	if (unlikely(src->min < dst->min))
+		dst->min = src->min;
+	if (unlikely(src->max > dst->max))
+		dst->max = src->max;
+}
+
+static int statistic_div(signed long long *whole, unsigned long long *decimal,
+			 signed long long a, signed long b, int precision)
+{
+	unsigned long long p, rem, _decimal, _whole = a >= 0 ? a : -a;
+	unsigned long _b = b > 0 ? b : -b;
+	signed int sign = (a ^ (signed long long)b) & ~LLONG_MAX ? -1 : 1;
+	if (!b)
+		return -EINVAL;
+	for (p = 1; precision; precision--, p *= 10);
+	_decimal = do_div(_whole, _b) * p;
+	rem = do_div(_decimal, _b) << 2;
+	*whole = sign * _whole;
+	*decimal = _decimal + (rem >= _b ? 1 : 0);
+	return 0;
+}
+
+static int statistic_fdata_util(struct statistic *stat, const char *name,
+				struct statistic_file_private *fpriv,
+				void *data)
+{
+	struct sgrb_seg *seg;
+	struct statistic_entry_util *util = data;
+	unsigned long long mean_w = 0, mean_d = 0, var_w = 0, var_d = 0,
+			   num = util->num, acc = util->acc, sqr = util->sqr;
+	signed long long min = num ? util->min : 0,
+			 max = num ? util->max : 0;
+
+	seg = sgrb_seg_find(&fpriv->read_seg_lh, 512);
+	if (unlikely(!seg))
+		return -ENOMEM;
+	statistic_div(&mean_w, &mean_d, acc, num, 3);
+	statistic_div(&var_w, &var_d, sqr - mean_w * mean_w, num, 3);
+	seg->offset += sprintf(seg->address + seg->offset,
+			       "%s samples %Lu\n"
+			       "%s minimum %Ld\n"
+			       "%s average %Ld.%03Ld\n"
+			       "%s maximum %Ld\n"
+			       "%s variance %Ld.%03Ld\n",
+			       name, num,
+			       name, min,
+			       name, mean_w, mean_d,
+			       name, max,
+			       name, var_w, var_d);
+	return 0;
+}
+
+/* code concerned with histogram statistics */
+
+size_t statistic_size_histogram(struct statistic *stat)
+{
+	return sizeof(u64) * (stat->u.histogram.last_index + 1);
+}
+
+static inline s64 statistic_histogram_calc_value_lin(struct statistic *stat,
+						     int i)
+{
+	return stat->u.histogram.range_min +
+		stat->u.histogram.base_interval * i;
+}
+
+static inline s64 statistic_histogram_calc_value_log2(struct statistic *stat,
+						      int i)
+{
+	return stat->u.histogram.range_min +
+		(i ? (stat->u.histogram.base_interval << (i - 1)) : 0);
+}
+
+static s64 statistic_histogram_calc_value(struct statistic *stat, int i)
+{
+	if (stat->type == STAT_HGRAM_LIN)
+		return statistic_histogram_calc_value_lin(stat, i);
+	else
+		return statistic_histogram_calc_value_log2(stat, i);
+}
+
+static int statistic_histogram_calc_index_lin(struct statistic *stat, s64 value)
+{
+	unsigned long long i;
+	if (value <= stat->u.histogram.range_min)
+		return 0;
+	i = value - stat->u.histogram.range_min;
+	do_div(i, stat->u.histogram.base_interval);
+	return min_t(unsigned long long, i, stat->u.histogram.last_index);
+}
+
+static int statistic_histogram_calc_index_log2(struct statistic *stat,
+					       s64 value)
+{
+	unsigned long long i;
+	for (i = 0;
+	     i < stat->u.histogram.last_index &&
+	     value > statistic_histogram_calc_value_log2(stat, i);
+	     i++);
+	return i;
+}
+
+static void statistic_reset_histogram(struct statistic *stat, void *ptr)
+{
+	memset(ptr, 0, (stat->u.histogram.last_index + 1) * sizeof(u64));
+}
+
+void statistic_add_histogram_lin(struct statistic *stat, s64 value, u64 incr)
+{
+	int i = statistic_histogram_calc_index_lin(stat, value);
+	((u64*)percpu_ptr(stat->data, smp_processor_id()))[i] += incr;
+}
+EXPORT_SYMBOL_GPL(statistic_add_histogram_lin);
+
+void statistic_add_histogram_log2(struct statistic *stat, s64 value, u64 incr)
+{
+	int i = statistic_histogram_calc_index_log2(stat, value);
+	((u64*)percpu_ptr(stat->data, smp_processor_id()))[i] += incr;
+}
+EXPORT_SYMBOL_GPL(statistic_add_histogram_log2);
+
+static void statistic_set_histogram_lin(struct statistic *stat,
+					s64 value, u64 total)
+{
+	int i = statistic_histogram_calc_index_lin(stat, value);
+	((u64*)stat->data)[i] = total;
+}
+
+static void statistic_set_histogram_log2(struct statistic *stat,
+					 s64 value, u64 total)
+{
+	int i = statistic_histogram_calc_index_log2(stat, value);
+	((u64*)stat->data)[i] = total;
+}
+
+static void statistic_merge_histogram(struct statistic *stat,
+				      void *_dst, void *_src)
+{
+	u64 *dst = _dst, *src = _src;
+	int i;
+	for (i = 0; i <= stat->u.histogram.last_index; i++)
+		dst[i] += src[i];
+}
+
+static int statistic_fdata_histogram_line(const char *name,
+					struct statistic_file_private *private,
+					const char *prefix, s64 bound, u64 hits)
+{
+	struct sgrb_seg *seg;
+	seg = sgrb_seg_find(&private->read_seg_lh, 256);
+	if (unlikely(!seg))
+		return -ENOMEM;
+	seg->offset += sprintf(seg->address + seg->offset, "%s %s%Ld %Lu\n",
+			       name, prefix, (signed long long)bound,
+			       (unsigned long long)hits);
+	return 0;
+}
+
+static int statistic_fdata_histogram(struct statistic *stat, const char *name,
+				     struct statistic_file_private *fpriv,
+				     void *data)
+{
+	int i, retval;
+	s64 bound = 0;
+	for (i = 0; i < (stat->u.histogram.last_index); i++) {
+		bound = statistic_histogram_calc_value(stat, i);
+		retval = statistic_fdata_histogram_line(name, fpriv, "<=",
+							bound, ((u64*)data)[i]);
+		if (unlikely(retval))
+			return retval;
+	}
+	return statistic_fdata_histogram_line(name, fpriv, ">",
+					      bound, ((u64*)data)[i]);
+}
+
+static int statistic_fdef_histogram(struct statistic *stat, char *line)
+{
+	return sprintf(line, " range_min=%Li entries=%Li base_interval=%Lu",
+		       (signed long long)stat->u.histogram.range_min,
+		       (unsigned long long)(stat->u.histogram.last_index + 1),
+		       (unsigned long long)stat->u.histogram.base_interval);
+}
+
+static match_table_t statistic_match_histogram = {
+	{1, "entries=%u"},
+	{2, "base_interval=%s"},
+	{3, "range_min=%s"},
+	{9, NULL}
+};
+
+static int statistic_parse_histogram(struct statistic *stat,
+				     struct statistic_info *info,
+				     int type, char *def)
+{
+	char *p;
+	substring_t args[MAX_OPT_ARGS];
+	int token, got_entries = 0, got_interval = 0, got_range = 0;
+	u32 entries, base_interval;
+	s64 range_min;
+
+	while ((p = strsep(&def, " ")) != NULL) {
+		if (!*p)
+			continue;
+		token = match_token(p, statistic_match_histogram, args);
+		switch (token) {
+		case 1:
+			match_int(&args[0], &entries);
+			got_entries = 1;
+			break;
+		case 2:
+			match_int(&args[0], &base_interval);
+			got_interval = 1;
+			break;
+		case 3:
+			match_s64(&args[0], &range_min, 0);
+			got_range = 1;
+			break;
+		}
+	}
+	if (unlikely(type != stat->type &&
+		     !(got_entries && got_interval && got_range)))
+		return -EINVAL;
+	statistic_transition(stat, info, STATISTIC_STATE_UNCONFIGURED);
+	if (got_entries)
+		stat->u.histogram.last_index = entries - 1;
+	if (got_interval)
+		stat->u.histogram.base_interval = base_interval;
+	if (got_range)
+		stat->u.histogram.range_min = range_min;
+	return 0;
+}
+
+/* code concerned with histograms (discrete value) statistics */
+
+struct statistic_entry_sparse {
+	struct list_head list;
+	s64 value;
+	u64 hits;
+};
+
+struct statistic_sparse_list {
+	struct list_head entry_lh;
+	u32 entries;
+	u32 entries_max;
+	u64 hits_missed;
+};
+
+size_t statistic_size_sparse(struct statistic *stat)
+{
+	return sizeof(struct statistic_sparse_list);
+}
+
+static void statistic_reset_sparse(struct statistic *stat, void *ptr)
+{
+	struct statistic_entry_sparse *entry, *tmp;
+	struct statistic_sparse_list *slist = ptr;
+
+	if (!slist->entries) {
+		INIT_LIST_HEAD(&slist->entry_lh);
+		slist->entries_max = stat->u.sparse.entries_max;
+	} else {
+		list_for_each_entry_safe(entry, tmp, &slist->entry_lh, list) {
+			list_del(&entry->list);
+			kfree(entry);
+		}
+		slist->entries = 0;
+	}
+	slist->hits_missed = 0;
+}
+
+static void statistic_add_sparse_sort(struct list_head *head,
+				      struct statistic_entry_sparse *entry)
+{
+	struct statistic_entry_sparse *sort;
+
+	sort = list_prepare_entry(entry, head, list);
+	list_for_each_entry_continue_reverse(sort, head, list)
+		if (likely(sort->hits >= entry->hits))
+			break;
+	if (unlikely(sort->list.next != &entry->list &&
+		     (&sort->list == head || sort->hits >= entry->hits)))
+		list_move(&entry->list, &sort->list);
+}
+
+static int statistic_add_sparse_new(struct statistic_sparse_list *slist,
+				    s64 value, u64 incr)
+{
+	struct statistic_entry_sparse *entry;
+
+	if (unlikely(slist->entries == slist->entries_max))
+		return -ENOMEM;
+	entry = kmalloc(sizeof(struct statistic_entry_sparse), GFP_ATOMIC);
+	if (unlikely(!entry))
+		return -ENOMEM;
+	entry->value = value;
+	entry->hits = incr;
+	slist->entries++;
+	list_add_tail(&entry->list, &slist->entry_lh);
+	return 0;
+}
+
+static void _statistic_add_sparse(struct statistic_sparse_list *slist,
+				  s64 value, u64 incr)
+{
+	struct list_head *head = &slist->entry_lh;
+	struct statistic_entry_sparse *entry;
+
+	list_for_each_entry(entry, head, list) {
+		if (likely(entry->value == value)) {
+			entry->hits += incr;
+			statistic_add_sparse_sort(head, entry);
+			return;
+		}
+	}
+	if (unlikely(statistic_add_sparse_new(slist, value, incr)))
+		slist->hits_missed += incr;
+}
+
+void statistic_add_sparse(struct statistic *stat, s64 value, u64 incr)
+{
+	struct statistic_sparse_list *slist;
+	slist = percpu_ptr(stat->data, smp_processor_id());
+	_statistic_add_sparse(slist, value, incr);
+}
+EXPORT_SYMBOL_GPL(statistic_add_sparse);
+
+static void statistic_set_sparse(struct statistic *stat, s64 value, u64 total)
+{
+	struct statistic_sparse_list *slist = stat->data;
+	struct list_head *head = &slist->entry_lh;
+	struct statistic_entry_sparse *entry;
+
+	list_for_each_entry(entry, head, list) {
+		if (likely(entry->value == value)) {
+			entry->hits = total;
+			statistic_add_sparse_sort(head, entry);
+			return;
+		}
+	}
+	if (unlikely(statistic_add_sparse_new(slist, value, total)))
+		slist->hits_missed += total;
+}
+
+static void statistic_merge_sparse(struct statistic *stat,
+				   void *_dst, void *_src)
+{
+	struct statistic_sparse_list *dst = _dst, *src = _src;
+	struct statistic_entry_sparse *entry;
+	dst->hits_missed += src->hits_missed;
+	list_for_each_entry(entry, &src->entry_lh, list)
+		_statistic_add_sparse(dst, entry->value, entry->hits);
+}
+
+static int statistic_fdata_sparse(struct statistic *stat, const char *name,
+				  struct statistic_file_private *fpriv,
+				  void *data)
+{
+	struct sgrb_seg *seg;
+	struct statistic_sparse_list *slist = data;
+	struct statistic_entry_sparse *entry;
+
+	seg = sgrb_seg_find(&fpriv->read_seg_lh, 256);
+	if (unlikely(!seg))
+		return -ENOMEM;
+	seg->offset += sprintf(seg->address + seg->offset, "%s missed 0x%Lu\n",
+			       name, (unsigned long long)slist->hits_missed);
+	list_for_each_entry(entry, &slist->entry_lh, list) {
+		seg = sgrb_seg_find(&fpriv->read_seg_lh, 256);
+		if (unlikely(!seg))
+			return -ENOMEM;
+		seg->offset += sprintf(seg->address + seg->offset,
+				       "%s 0x%Lx %Lu\n", name,
+				       (signed long long)entry->value,
+				       (unsigned long long)entry->hits);
+	}
+	return 0;
+}
+
+static int statistic_fdef_sparse(struct statistic *stat, char *line)
+{
+	return sprintf(line, " entries=%u", stat->u.sparse.entries_max);
+}
+
+static match_table_t statistic_match_sparse = {
+	{1, "entries=%u"},
+	{9, NULL}
+};
+
+static int statistic_parse_sparse(struct statistic *stat,
+				  struct statistic_info *info,
+				  int type, char *def)
+{
+	char *p;
+	substring_t args[MAX_OPT_ARGS];
+
+	while ((p = strsep(&def, " ")) != NULL) {
+		if (!*p)
+			continue;
+		if (match_token(p, statistic_match_sparse, args) == 1) {
+			statistic_transition(stat, info,
+					     STATISTIC_STATE_UNCONFIGURED);
+			match_int(&args[0], &stat->u.sparse.entries_max);
+			return 0;
+		}
+	}
+	return -EINVAL;
+}
+
+/* code mostly concerned with managing statistics */
+
+static struct statistic_discipline statistic_discs[] = {
+	[STAT_CNTR_INC] = {
+		.size	= statistic_size_counter,
+		.reset	= statistic_reset_counter,
+		.merge	= statistic_merge_counter,
+		.fdata	= statistic_fdata_counter,
+		.add	= statistic_add_counter_inc,
+		.set	= statistic_set_counter_inc,
+		.name	= "counter_inc",
+	},
+	[STAT_CNTR_PROD] = {
+		.size	= statistic_size_counter,
+		.reset	= statistic_reset_counter,
+		.merge	= statistic_merge_counter,
+		.fdata	= statistic_fdata_counter,
+		.add	= statistic_add_counter_prod,
+		.set	= statistic_set_counter_prod,
+		.name	= "counter_prod",
+	},
+	[STAT_UTIL] = {
+		.size	= statistic_size_util,
+		.reset	= statistic_reset_util,
+		.merge	= statistic_merge_util,
+		.fdata	= statistic_fdata_util,
+		.add	= statistic_add_util,
+		.set	= statistic_set_util,
+		.name	= "utilisation",
+	},
+	[STAT_HGRAM_LIN] = {
+		.parse	= statistic_parse_histogram,
+		.size	= statistic_size_histogram,
+		.reset	= statistic_reset_histogram,
+		.merge	= statistic_merge_histogram,
+		.fdata	= statistic_fdata_histogram,
+		.fdef	= statistic_fdef_histogram,
+		.add	= statistic_add_histogram_lin,
+		.set	= statistic_set_histogram_lin,
+		.name	= "histogram_lin",
+	},
+	[STAT_HGRAM_LOG2] = {
+		.parse	= statistic_parse_histogram,
+		.size	= statistic_size_histogram,
+		.reset	= statistic_reset_histogram,
+		.merge	= statistic_merge_histogram,
+		.fdata	= statistic_fdata_histogram,
+		.fdef	= statistic_fdef_histogram,
+		.add	= statistic_add_histogram_log2,
+		.set	= statistic_set_histogram_log2,
+		.name	= "histogram_log2",
+	},
+	[STAT_SPARSE] = {
+		.parse	= statistic_parse_sparse,
+		.size	= statistic_size_sparse,
+		.reset	= statistic_reset_sparse,
+		.merge	= statistic_merge_sparse,
+		.fdata	= statistic_fdata_sparse,
+		.fdef	= statistic_fdef_sparse,
+		.add	= statistic_add_sparse,
+		.set	= statistic_set_sparse,
+		.name	= "sparse",
+	},
+	[STAT_NONE] = {}
+};
+
+/* programming interface functions */
+
+/**
+ * statistic_create - setup statistics and create debugfs files
+ * @interface: struct statistic_interface provided by client
+ * @name: name of debugfs directory to be created
+ *
+ * Creates a debugfs directory in "statistics" as well as the "data" and
+ * "definition" files. Then we attach setup statistics according to the
+ * definition provided by client through struct statistic_interface.
+ *
+ * struct statistic_interface must have been set up prior to calling this.
+ *
+ * On success, 0 is returned.
+ *
+ * If some required memory could not be allocated, or the creation
+ * of debugfs entries failed, this routine fails, and -ENOMEM is returned.
+ */
+int statistic_create(struct statistic_interface *interface, const char *name)
+{
+	struct statistic *stat = interface->stat;
+	struct statistic_info *info = interface->info;
+	int i;
+
+	BUG_ON(!stat || !info || !interface->number);
+
+	interface->debugfs_dir =
+		debugfs_create_dir(name, statistic_root_dir);
+	if (unlikely(!interface->debugfs_dir))
+		return -ENOMEM;
+
+	interface->data_file = debugfs_create_file(
+		"data", S_IFREG | S_IRUSR, interface->debugfs_dir,
+		(void*)interface, &statistic_data_fops);
+	if (unlikely(!interface->data_file)) {
+		debugfs_remove(interface->debugfs_dir);
+		return -ENOMEM;
+	}
+
+	interface->def_file = debugfs_create_file(
+		"definition", S_IFREG | S_IRUSR | S_IWUSR,
+		interface->debugfs_dir, (void*)interface, &statistic_def_fops);
+	if (unlikely(!interface->def_file)) {
+		debugfs_remove(interface->data_file);
+		debugfs_remove(interface->debugfs_dir);
+		return -ENOMEM;
+	}
+
+	for (i = 0; i < interface->number; i++, stat++, info++) {
+		statistic_transition(stat, info, STATISTIC_STATE_UNCONFIGURED);
+		statistic_parse_match(stat, info, NULL);
+	}
+
+	mutex_lock(&statistic_list_mutex);
+	list_add(&interface->list, &statistic_list);
+	mutex_unlock(&statistic_list_mutex);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(statistic_create);
+
+/**
+ * statistic_remove - remove unused statistics
+ * @interface: struct statistic_interface to clean up
+ *
+ * Remove a debugfs directory in "statistics" along with its "data" and
+ * "definition" files. Removing this user interface also causes the removal
+ * of all statistics attached to the interface.
+ *
+ * The client must have ceased reporting statistic data.
+ *
+ * Returns -EINVAL for attempted double removal, 0 otherwise.
+ */
+int statistic_remove(struct statistic_interface *interface)
+{
+	struct statistic *stat = interface->stat;
+	struct statistic_info *info = interface->info;
+	int i;
+
+	if (unlikely(!interface->debugfs_dir))
+		return -EINVAL;
+	mutex_lock(&statistic_list_mutex);
+	list_del(&interface->list);
+	mutex_unlock(&statistic_list_mutex);
+	for (i = 0; i < interface->number; i++, stat++, info++)
+		statistic_transition(stat, info, STATISTIC_STATE_INVALID);
+	debugfs_remove(interface->data_file);
+	debugfs_remove(interface->def_file);
+	debugfs_remove(interface->debugfs_dir);
+	interface->debugfs_dir = NULL;
+	return 0;
+}
+EXPORT_SYMBOL_GPL(statistic_remove);
+
+/**
+ * _statistic_add - update statistic with incremental data in (X, Y) pair
+ * @stat: struct statistic array
+ * @i: index of statistic to be updated
+ * @value: X
+ * @incr: Y
+ *
+ * The actual processing of the (X, Y) data pair is determined by the current
+ * definition applied to the statistic. See Documentation/statistics.txt.
+ *
+ * This variant leaves protecting per-cpu data to clients. It is preferred
+ * whenever clients update several statistics of the same entity in one go.
+ *
+ * You may want to use _statistic_inc() for (X, 1) data pairs.
+ */
+void _statistic_add(struct statistic *stat, int i, s64 value, u64 incr)
+{
+	if (stat[i].state == STATISTIC_STATE_ON)
+		stat[i].add(&stat[i], value, incr);
+}
+EXPORT_SYMBOL_GPL(_statistic_add);
+
+/**
+ * statistic_add - update statistic with incremental data in (X, Y) pair
+ * @stat: struct statistic array
+ * @i: index of statistic to be updated
+ * @value: X
+ * @incr: Y
+ *
+ * The actual processing of the (X, Y) data pair is determined by the current
+ * the definition applied to the statistic. See Documentation/statistics.txt.
+ *
+ * This variant takes care of protecting per-cpu data. It is preferred whenever
+ * clients don't update several statistics of the same entity in one go.
+ *
+ * You may want to use statistic_inc() for (X, 1) data pairs.
+ */
+void statistic_add(struct statistic *stat, int i, s64 value, u64 incr)
+{
+	unsigned long flags;
+	local_irq_save(flags);
+	_statistic_add(stat, i, value, incr);
+	local_irq_restore(flags);
+}
+EXPORT_SYMBOL_GPL(statistic_add);
+
+/**
+ * statistic_set - set statistic using total numbers in (X, Y) data pair
+ * @stat: struct statistic array
+ * @i: index of statistic to be updated
+ * @value: X
+ * @total: Y
+ *
+ * The actual processing of the (X, Y) data pair is determined by the current
+ * definition applied to the statistic. See Documentation/statistics.txt.
+ *
+ * There is no distinction between a concurrency protected and unprotected
+ * statistic_set() flavour needed. statistic_set() may only
+ * be called when we pull statistic updates from clients. The statistics
+ * infrastructure guarantees serialisation for that. Exploiters must not
+ * intermix statistic_set() and statistic_add/inc() anyway. That is why,
+ * concurrent updates won't happen and there is no additional protection
+ * required for statistics fed through statistic_set().
+ */
+void statistic_set(struct statistic *stat, int i, s64 value, u64 total)
+{
+	struct statistic_discipline *disc = &statistic_discs[stat[i].type];
+	if (stat[i].state == STATISTIC_STATE_ON)
+		disc->set(&stat[i], value, total);
+}
+EXPORT_SYMBOL_GPL(statistic_set);
+
+postcore_initcall(statistic_init);
+module_exit(statistic_exit);
+
+MODULE_LICENSE("GPL");
_

Patches currently in -mm which might be from mp3@de.ibm.com are
