From: akpm@linux-foundation.org
Subject: + add-a-document-describing-the-resource-counter-abstraction-v2.patch added to -mm tree
Date: Thu, 13 Mar 2008 14:39:09 -0700
Message-ID: <200803132139.m2DLd9rA001685@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55451 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754706AbYCMVj5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Mar 2008 17:39:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: xemul@openvz.org, balbir@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, randy.dunlap@oracle.com


The patch titled
     memcgroups: add a document describing the resource counter abstraction
has been added to the -mm tree.  Its filename is
     add-a-document-describing-the-resource-counter-abstraction-v2.patch

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
Subject: memcgroups: add a document describing the resource counter abstraction
From: Pavel Emelyanov <xemul@openvz.org>

The resource counter is supposed to facilitate the resource accounting of
arbitrary resource (and it already does this for memory controller).

However, it is about to be used in other resources controllers (swap, kernel
memory, networking, etc), so provide a doc describing how to work with it. 
This will eliminate all the possible future duplications in the appropriate
controllers' docs.

Fixed errors pointed out by Randy.

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/controllers/resource_counter.txt |  181 +++++++++++++++
 include/linux/res_counter.h                    |    2 
 2 files changed, 183 insertions(+)

diff -puN /dev/null Documentation/controllers/resource_counter.txt
--- /dev/null
+++ a/Documentation/controllers/resource_counter.txt
@@ -0,0 +1,181 @@
+
+		The Resource Counter
+
+The resource counter, declared at include/linux/res_counter.h,
+is supposed to facilitate the resource management by controllers
+by providing common stuff for accounting.
+
+This "stuff" includes the res_counter structure and routines
+to work with it.
+
+
+
+1. Crucial parts of the res_counter structure
+
+ a. unsigned long long usage
+
+ 	The usage value shows the amount of a resource that is consumed
+	by a group at a given time. The units of measurement should be
+	determined by the controller that uses this counter. E.g. it can
+	be bytes, items or any other unit the controller operates on.
+
+ b. unsigned long long max_usage
+
+ 	The maximal value of the usage over time.
+
+ 	This value is useful when gathering statistical information about
+	the particular group, as it shows the actual resource requirements
+	for a particular group, not just some usage snapshot.
+
+ c. unsigned long long limit
+
+ 	The maximal allowed amount of resource to consume by the group. In
+	case the group requests for more resources, so that the usage value
+	would exceed the limit, the resource allocation is rejected (see
+	the next section).
+
+ d. unsigned long long failcnt
+
+ 	The failcnt stands for "failures counter". This is the number of
+	resource allocation attempts that failed.
+
+ c. spinlock_t lock
+
+ 	Protects changes of the above values.
+
+
+
+2. Basic accounting routines
+
+ a. void res_counter_init(struct res_counter *rc)
+
+ 	Initializes the resource counter. As usual, should be the first
+	routine called for a new counter.
+
+ b. int res_counter_charge[_locked]
+			(struct res_counter *rc, unsigned long val)
+
+	When a resource is about to be allocated it has to be accounted
+	with the appropriate resource counter (controller should determine
+	which one to use on its own). This operation is called "charging".
+
+	This is not very important which operation - resource allocation
+	or charging - is performed first, but
+	  * if the allocation is performed first, this may create a
+	    temporary resource over-usage by the time resource counter is
+	    charged;
+	  * if the charging is performed first, then it should be uncharged
+	    on error path (if the one is called).
+
+ c. void res_counter_uncharge[_locked]
+			(struct res_counter *rc, unsigned long val)
+
+	When a resource is released (freed) is should be de-accounted
+	from the resource counter it was accounted to.  This is called
+	"uncharging".
+
+    The _locked routines imply that the res_counter->lock is taken.
+
+
+ 2.1 Other accounting routines
+
+    There are more routines that may help you with common needs, like
+    checking whether the limit is reached or resetting the max_usage
+    value. They are all declared in include/linux/res_counter.h.
+
+
+
+3. Analyzing the resource counter registrations
+
+ a. If the failcnt value constantly grows, this means that the counter's
+    limit is too tight. Either the group is misbehaving and consumes too
+    many resources, or the configuration is not suitable for the group
+    and the limit should be increased.
+
+ b. The max_usage value can be used to quickly tune the group. One may
+    set the limits to maximal values and either load the container with
+    a common pattern or leave one for a while. After this the max_usage
+    value shows the amount of memory the container would require during
+    its common activity.
+
+    Setting the limit a bit above this value gives a pretty good
+    configuration that works in most of the cases.
+
+ c. If the max_usage is much less than the limit, but the failcnt value
+    is growing, then the group tries to allocate a big chunk of resource
+    at once.
+
+ d. If the max_usage is much less than the limit, but the failcnt value
+    is 0, then this group is given too high limit, that it does not
+    require. It is better to lower the limit a bit leaving more resource
+    for other groups.
+
+
+
+4. Communication with the control groups subsystem (cgroups)
+
+All the resource controllers that are using cgroups and resource counters
+should provide files (in the cgroup filesystem) to work with the resource
+counter fields. They are recommended to adhere to the following rules:
+
+ a. File names
+
+ 	Field name	File name
+	---------------------------------------------------
+	usage		usage_in_<unit_of_measurement>
+	max_usage	max_usage_in_<unit_of_measurement>
+	limit		limit_in_<unit_of_measurement>
+	failcnt		failcnt
+	lock		no file :)
+
+ b. Reading from file should show the corresponding field value in the
+    appropriate format.
+
+ c. Writing to file
+
+ 	Field		Expected behavior
+	----------------------------------
+	usage		prohibited
+	max_usage	reset to usage
+	limit		set the limit
+	failcnt		reset to zero
+
+
+
+5. Usage example
+
+ a. Declare a task group (take a look at cgroups subsystem for this) and
+    fold a res_counter into it
+
+	struct my_group {
+		struct res_counter res;
+
+		<other fields>
+	}
+
+ b. Put hooks in resource allocation/release paths
+
+ 	int alloc_something(...)
+	{
+		if (res_counter_charge(res_counter_ptr, amount) < 0)
+			return -ENOMEM;
+
+		<allocate the resource and return to the caller>
+	}
+
+	void release_something(...)
+	{
+		res_counter_uncharge(res_counter_ptr, amount);
+
+		<release the resource>
+	}
+
+    In order to keep the usage value self-consistent, both the
+    "res_counter_ptr" and the "amount" in release_something() should be
+    the same as they were in the alloc_something() when the releasing
+    resource was allocated.
+
+ c. Provide the way to read res_counter values and set them (the cgroups
+    still can help with it).
+
+ c. Compile and run :)
diff -puN include/linux/res_counter.h~add-a-document-describing-the-resource-counter-abstraction-v2 include/linux/res_counter.h
--- a/include/linux/res_counter.h~add-a-document-describing-the-resource-counter-abstraction-v2
+++ a/include/linux/res_counter.h
@@ -9,6 +9,8 @@
  *
  * Author: Pavel Emelianov <xemul@openvz.org>
  *
+ * See Documentation/controllers/resource_counter.txt for more
+ * info about what this counter is.
  */
 
 #include <linux/cgroup.h>
_

Patches currently in -mm which might be from xemul@openvz.org are

origin.patch
git-kgdb-light.patch
use-find_task_by_vpid-in-audit-code.patch
ia64-fix-getpid-and-set_tid_address-fast-system-calls-for-pid-namespaces.patch
git-udf.patch
mm-have-zonelist-contains-structs-with-both-a-zone-pointer-and-zone_idx-fix-memcg-ooms.patch
mm-have-zonelist-contains-structs-with-both-a-zone-pointer-and-zone_idx-just-return-do_try_to_free_pages.patch
mm-have-zonelist-contains-structs-with-both-a-zone-pointer-and-zone_idx-just-return-do_try_to_free_pages-do_try_to_free_pages-gfp_mask-redundant.patch
cgroup-api-files-rename-read-write_uint-methods-to-read_write_u64.patch
cgroup-api-files-add-res_counter_read_u64.patch
cgroup-api-files-use-read_u64-in-memory-controller.patch
cgroup-api-files-strip-all-trailing-whitespace-in-cgroup_write_u64.patch
cgroup-api-files-update-cpusets-to-use-cgroup-structured-file-api.patch
cgroup-api-files-update-cpusets-to-use-cgroup-structured-file-api-fix.patch
cgroup-api-files-add-cgroup-map-data-type.patch
cgroup-api-files-use-cgroup-map-for-memcontrol-stats-file.patch
cgroup-api-files-drop-mem_cgroup_force_empty.patch
cgroup-api-files-move-releasable-to-cgroup_debug-subsystem.patch
cgroup-api-files-make-cgroup_debug-default-to-off.patch
cgroups-add-cgroup-support-for-enabling-controllers-at-boot-time.patch
memory-controller-make-memory-resource-control-aware-of-boot-options.patch
memcgroup-add-the-max_usage-member-on-the-res_counter.patch
add-a-document-describing-the-resource-counter-abstraction-v2.patch
remove-unused-variable-from-send_signal.patch
turn-legacy_queue-macro-into-static-inline-function.patch
consolidate-checking-for-ignored-legacy-signals.patch
consolidate-checking-for-ignored-legacy-signals-simplify.patch
signals-consolidate-checks-for-whether-or-not-to-ignore-a-signal.patch
signals-clean-dequeue_signal-from-excess-checks-and-assignments.patch
signals-consolidate-send_sigqueue-and-send_group_sigqueue.patch
signals-cleanup-security_task_kill-usage-implementation.patch
signals-use-__group_complete_signal-for-the-specific-signals-too.patch
signals-fold-complete_signal-into-send_signal-do_send_sigqueue.patch
signals-unify-send_sigqueue-send_group_sigqueue-completely.patch
sysctl-merge-equal-proc_sys_read-and-proc_sys_write.patch
sysctl-clean-from-unneeded-extern-and-forward-declarations.patch
sysctl-add-the-permissions-callback-on-the-ctl_table_root.patch
free_pidmap-turn-it-into-free_pidmapstruct-upid.patch
use-find_task_by_vpid-in-taskstats.patch
deprecate-find_task_by_pid.patch
deprecate-find_task_by_pid-warning-fix.patch
pidns-make-pid-level-and-pid_ns-level-unsigned.patch
reiser4.patch
put_pid-make-sure-we-dont-free-the-live-pid.patch

