Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E21C9C433EF
	for <mm-commits@archiver.kernel.org>; Mon, 28 Feb 2022 19:48:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229581AbiB1TtM (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 28 Feb 2022 14:49:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229755AbiB1Ts7 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 28 Feb 2022 14:48:59 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EADB6FDFB1
        for <mm-commits@vger.kernel.org>; Mon, 28 Feb 2022 11:47:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6976D61386
        for <mm-commits@vger.kernel.org>; Mon, 28 Feb 2022 19:47:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD1DAC340F1;
        Mon, 28 Feb 2022 19:47:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1646077661;
        bh=eA/+9ylTBXsiVcBX6NC9CQPoK4+KIduLAS4aB2X6xLg=;
        h=Date:To:From:Subject:From;
        b=bmn+0Mgz7NIspC6wRy1jp5kDMsuwau1dcJBQ53+pFQlItkt6ykTO1pQ6eLUPriJAR
         rp1to3yMfFEFFi6pTAbBuzPmjUmctZB7Ch4nvRHxW3gv51QqPxyrfqFWpj7IQc/pgQ
         EqyV2f8zOWegJGEbN7r0Cod44iMsUokih3zqHd70=
Date:   Mon, 28 Feb 2022 11:47:41 -0800
To:     mm-commits@vger.kernel.org, xhao@linux.alibaba.com,
        skhan@linuxfoundation.org, rientjes@google.com,
        gregkh@linuxfoundation.org, corbet@lwn.net, sj@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-core-allow-non-exclusive-damon-start-stop.patch added to -mm tree
Message-Id: <20220228194741.BD1DAC340F1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon/core: allow non-exclusive DAMON start/stop
has been added to the -mm tree.  Its filename is
     mm-damon-core-allow-non-exclusive-damon-start-stop.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-damon-core-allow-non-exclusive-damon-start-stop.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-damon-core-allow-non-exclusive-damon-start-stop.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/core: allow non-exclusive DAMON start/stop

Patch series "Introduce DAMON sysfs interface", v3.

Introduction
============

DAMON's debugfs-based user interface (DAMON_DBGFS) served very well, so
far.  However, it unnecessarily depends on debugfs, while DAMON is not
aimed to be used for only debugging.  Also, the interface receives
multiple values via one file.  For example, schemes file receives 18
values.  As a result, it is inefficient, hard to be used, and difficult to
be extended.  Especially, keeping backward compatibility of user space
tools is getting only challenging.  It would be better to implement
another reliable and flexible interface and deprecate DAMON_DBGFS in long
term.

For the reason, this patchset introduces a sysfs-based new user interface
of DAMON.  The idea of the new interface is, using directory hierarchies
and having one dedicated file for each value.  For a short example, users
can do the virtual address monitoring via the interface as below:

    # cd /sys/kernel/mm/damon/admin/
    # echo 1 > kdamonds/nr_kdamonds
    # echo 1 > kdamonds/0/contexts/nr_contexts
    # echo vaddr > kdamonds/0/contexts/0/operations
    # echo 1 > kdamonds/0/contexts/0/targets/nr_targets
    # echo $(pidof <workload>) > kdamonds/0/contexts/0/targets/0/pid_target
    # echo on > kdamonds/0/state

A brief representation of the files hierarchy of DAMON sysfs interface is
as below.  Childs are represented with indentation, directories are having
'/' suffix, and files in each directory are separated by comma.

    /sys/kernel/mm/damon/admin
    │ kdamonds/nr_kdamonds
    │ │ 0/state,pid
    │ │ │ contexts/nr_contexts
    │ │ │ │ 0/operations
    │ │ │ │ │ monitoring_attrs/
    │ │ │ │ │ │ intervals/sample_us,aggr_us,update_us
    │ │ │ │ │ │ nr_regions/min,max
    │ │ │ │ │ targets/nr_targets
    │ │ │ │ │ │ 0/pid_target
    │ │ │ │ │ │ │ regions/nr_regions
    │ │ │ │ │ │ │ │ 0/start,end
    │ │ │ │ │ │ │ │ ...
    │ │ │ │ │ │ ...
    │ │ │ │ │ schemes/nr_schemes
    │ │ │ │ │ │ 0/action
    │ │ │ │ │ │ │ access_pattern/
    │ │ │ │ │ │ │ │ sz/min,max
    │ │ │ │ │ │ │ │ nr_accesses/min,max
    │ │ │ │ │ │ │ │ age/min,max
    │ │ │ │ │ │ │ quotas/ms,bytes,reset_interval_ms
    │ │ │ │ │ │ │ │ weights/sz_permil,nr_accesses_permil,age_permil
    │ │ │ │ │ │ │ watermarks/metric,interval_us,high,mid,low
    │ │ │ │ │ │ │ stats/nr_tried,sz_tried,nr_applied,sz_applied,qt_exceeds
    │ │ │ │ │ │ ...
    │ │ │ │ ...
    │ │ ...

Detailed usage of the files will be described in the final Documentation
patch of this patchset.

Main Difference Between DAMON_DBGFS and DAMON_SYSFS
---------------------------------------------------

At the moment, DAMON_DBGFS and DAMON_SYSFS provides same features.  One
important difference between them is their exclusiveness.  DAMON_DBGFS
works in an exclusive manner, so that no DAMON worker thread (kdamond) in
the system can run concurrently and interfere somehow.  For the reason,
DAMON_DBGFS asks users to construct all monitoring contexts and start them
at once.  It's not a big problem but makes the operation a little bit
complex and unflexible.

For more flexible usage, DAMON_SYSFS moves the responsibility of
preventing any possible interference to the admins and work in a
non-exclusive manner.  That is, users can configure and start contexts one
by one.  Note that DAMON respects both exclusive groups and non-exclusive
groups of contexts, in a manner similar to that of reader-writer locks. 
That is, if any exclusive monitoring contexts (e.g., contexts that started
via DAMON_DBGFS) are running, DAMON_SYSFS does not start new contexts, and
vice versa.

Future Plan of DAMON_DBGFS Deprecation
======================================

Once this patchset is merged, DAMON_DBGFS development will be frozen. 
That is, we will maintain it to work as is now so that no users will be
break.  But, it will not be extended to provide any new feature of DAMON. 
The support will be continued only until next LTS release.  After that, we
will drop DAMON_DBGFS.

User-space Tooling Compatibility
--------------------------------

As DAMON_SYSFS provides all features of DAMON_DBGFS, all user space
tooling can move to DAMON_SYSFS.  As we will continue supporting
DAMON_DBGFS until next LTS kernel release, user space tools would have
enough time to move to DAMON_SYSFS.

The official user space tool, damo[1], is already supporting both
DAMON_SYSFS and DAMON_DBGFS.  Both correctness tests[2] and performance
tests[3] of DAMON using DAMON_SYSFS also passed.

[1] https://github.com/awslabs/damo
[2] https://github.com/awslabs/damon-tests/tree/master/corr
[3] https://github.com/awslabs/damon-tests/tree/master/perf

Sequence of Patches
===================

First two patches (patches 1-2) make core changes for DAMON_SYSFS.  The
first one (patch 1) allows non-exclusive DAMON contexts so that
DAMON_SYSFS can work in non-exclusive mode, while the second one (patch 2)
adds size of DAMON enum types so that DAMON API users can safely iterate
the enums.

Third patch (patch 3) implements basic sysfs stub for virtual address
spaces monitoring.  Note that this implements only sysfs files and DAMON
is not linked.  Fourth patch (patch 4) links the DAMON_SYSFS to DAMON so
that users can control DAMON using the sysfs files.

Following six patches (patches 5-10) implements other DAMON features that
DAMON_DBGFS supports one by one (physical address space monitoring,
DAMON-based operation schemes, schemes quotas, schemes prioritization
weights, schemes watermarks, and schemes stats).

Following patch (patch 11) adds a simple selftest for DAMON_SYSFS, and the
final one (patch 12) documents DAMON_SYSFS.


This patch (of 13):

To avoid interference between DAMON contexts monitoring overlapping memory
regions, damon_start() works in an exclusive manner.  That is,
damon_start() does nothing bug fails if any context that started by
another instance of the function is still running.  This makes its usage a
little bit restrictive.  However, admins could aware each DAMON usage and
address such interferences on their own in some cases.

This commit hence implements non-exclusive mode of the function and allows
the callers to select the mode.  Note that the exclusive groups and
non-exclusive groups of contexts will respect each other in a manner
similar to that of reader-writer locks.  Therefore, this commit will not
cause any behavioral change to the exclusive groups.

Link: https://lkml.kernel.org/r/20220228081314.5770-1-sj@kernel.org
Link: https://lkml.kernel.org/r/20220228081314.5770-2-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Xin Hao <xhao@linux.alibaba.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/damon.h |    2 +-
 mm/damon/core.c       |   23 +++++++++++++++--------
 mm/damon/dbgfs.c      |    2 +-
 mm/damon/reclaim.c    |    2 +-
 4 files changed, 18 insertions(+), 11 deletions(-)

--- a/include/linux/damon.h~mm-damon-core-allow-non-exclusive-damon-start-stop
+++ a/include/linux/damon.h
@@ -508,7 +508,7 @@ int damon_nr_running_ctxs(void);
 int damon_register_ops(struct damon_operations *ops);
 int damon_select_ops(struct damon_ctx *ctx, enum damon_ops_id id);
 
-int damon_start(struct damon_ctx **ctxs, int nr_ctxs);
+int damon_start(struct damon_ctx **ctxs, int nr_ctxs, bool exclusive);
 int damon_stop(struct damon_ctx **ctxs, int nr_ctxs);
 
 #endif	/* CONFIG_DAMON */
--- a/mm/damon/core.c~mm-damon-core-allow-non-exclusive-damon-start-stop
+++ a/mm/damon/core.c
@@ -24,6 +24,7 @@
 
 static DEFINE_MUTEX(damon_lock);
 static int nr_running_ctxs;
+static bool running_exclusive_ctxs;
 
 static DEFINE_MUTEX(damon_ops_lock);
 static struct damon_operations damon_registered_ops[NR_DAMON_OPS];
@@ -434,22 +435,25 @@ static int __damon_start(struct damon_ct
  * damon_start() - Starts the monitorings for a given group of contexts.
  * @ctxs:	an array of the pointers for contexts to start monitoring
  * @nr_ctxs:	size of @ctxs
+ * @exclusive:	exclusiveness of this contexts group
  *
  * This function starts a group of monitoring threads for a group of monitoring
  * contexts.  One thread per each context is created and run in parallel.  The
- * caller should handle synchronization between the threads by itself.  If a
- * group of threads that created by other 'damon_start()' call is currently
- * running, this function does nothing but returns -EBUSY.
+ * caller should handle synchronization between the threads by itself.  If
+ * @exclusive is true and a group of threads that created by other
+ * 'damon_start()' call is currently running, this function does nothing but
+ * returns -EBUSY.
  *
  * Return: 0 on success, negative error code otherwise.
  */
-int damon_start(struct damon_ctx **ctxs, int nr_ctxs)
+int damon_start(struct damon_ctx **ctxs, int nr_ctxs, bool exclusive)
 {
 	int i;
 	int err = 0;
 
 	mutex_lock(&damon_lock);
-	if (nr_running_ctxs) {
+	if ((exclusive && nr_running_ctxs) ||
+			(!exclusive && running_exclusive_ctxs)) {
 		mutex_unlock(&damon_lock);
 		return -EBUSY;
 	}
@@ -460,13 +464,15 @@ int damon_start(struct damon_ctx **ctxs,
 			break;
 		nr_running_ctxs++;
 	}
+	if (exclusive && nr_running_ctxs)
+		running_exclusive_ctxs = true;
 	mutex_unlock(&damon_lock);
 
 	return err;
 }
 
 /*
- * __damon_stop() - Stops monitoring of given context.
+ * __damon_stop() - Stops monitoring of a given context.
  * @ctx:	monitoring context
  *
  * Return: 0 on success, negative error code otherwise.
@@ -504,9 +510,8 @@ int damon_stop(struct damon_ctx **ctxs,
 		/* nr_running_ctxs is decremented in kdamond_fn */
 		err = __damon_stop(ctxs[i]);
 		if (err)
-			return err;
+			break;
 	}
-
 	return err;
 }
 
@@ -1102,6 +1107,8 @@ static int kdamond_fn(void *data)
 
 	mutex_lock(&damon_lock);
 	nr_running_ctxs--;
+	if (!nr_running_ctxs && running_exclusive_ctxs)
+		running_exclusive_ctxs = false;
 	mutex_unlock(&damon_lock);
 
 	return 0;
--- a/mm/damon/dbgfs.c~mm-damon-core-allow-non-exclusive-damon-start-stop
+++ a/mm/damon/dbgfs.c
@@ -967,7 +967,7 @@ static ssize_t dbgfs_monitor_on_write(st
 				return -EINVAL;
 			}
 		}
-		ret = damon_start(dbgfs_ctxs, dbgfs_nr_ctxs);
+		ret = damon_start(dbgfs_ctxs, dbgfs_nr_ctxs, true);
 	} else if (!strncmp(kbuf, "off", count)) {
 		ret = damon_stop(dbgfs_ctxs, dbgfs_nr_ctxs);
 	} else {
--- a/mm/damon/reclaim.c~mm-damon-core-allow-non-exclusive-damon-start-stop
+++ a/mm/damon/reclaim.c
@@ -330,7 +330,7 @@ static int damon_reclaim_turn(bool on)
 	if (err)
 		goto free_scheme_out;
 
-	err = damon_start(&ctx, 1);
+	err = damon_start(&ctx, 1, true);
 	if (!err) {
 		kdamond_pid = ctx->kdamond->pid;
 		return 0;
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-dbgfs-init_regions-use-target-index-instead-of-target-id.patch
docs-admin-guide-mm-damon-usage-update-for-changed-initail_regions-file-input.patch
mm-damon-core-move-damon_set_targets-into-dbgfs.patch
mm-damon-remove-the-target-id-concept.patch
mm-damon-rename-damon_primitives-to-damon_operations.patch
mm-damon-let-monitoring-operations-can-be-registered-and-selected.patch
mm-damon-paddrvaddr-register-themselves-to-damon-in-subsys_initcall.patch
mm-damon-reclaim-use-damon_select_ops-instead-of-damon_vpa_set_operations.patch
mm-damon-dbgfs-use-damon_select_ops-instead-of-damon_vpa_set_operations.patch
mm-damon-dbgfs-use-operations-id-for-knowing-if-the-target-has-pid.patch
mm-damon-dbgfs-test-fix-is_target_id-change.patch
mm-damon-paddrvaddr-remove-damon_pva_target_validset_operations.patch
docs-vm-damon-call-low-level-monitoring-primitives-the-operations.patch
docs-vm-damon-design-update-damon-idle-page-tracking-interference-handling.patch
docs-damon-update-outdated-term-regions-update-interval.patch
mm-damon-core-allow-non-exclusive-damon-start-stop.patch
mm-damon-core-add-number-of-each-enum-type-values.patch
mm-damon-implement-a-minimal-stub-for-sysfs-based-damon-interface.patch
mm-damon-sysfs-link-damon-for-virtual-address-spaces-monitoring.patch
mm-damon-sysfs-support-the-physical-address-space-monitoring.patch
mm-damon-sysfs-support-damon-based-operation-schemes.patch
mm-damon-sysfs-support-damos-quotas.patch
mm-damon-sysfs-support-schemes-prioritization.patch
mm-damon-sysfs-support-damos-watermarks.patch
mm-damon-sysfs-support-damos-stats.patch
selftests-damon-add-a-test-for-damon-sysfs-interface.patch
docs-admin-guide-mm-damon-usage-document-damon-sysfs-interface.patch
docs-abi-testing-add-damon-sysfs-interface-abi-document.patch

