Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D04D4CCA481
	for <mm-commits@archiver.kernel.org>; Mon, 13 Jun 2022 20:42:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235344AbiFMUlz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 13 Jun 2022 16:41:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343658AbiFMUlG (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 13 Jun 2022 16:41:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2D75DEDD
        for <mm-commits@vger.kernel.org>; Mon, 13 Jun 2022 12:40:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 32CDB61544
        for <mm-commits@vger.kernel.org>; Mon, 13 Jun 2022 19:40:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 844DDC34114;
        Mon, 13 Jun 2022 19:40:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1655149254;
        bh=oh3friUXqmvjMMG6Iaa1/4GjjxNUxAxHXYmpRamWS1I=;
        h=Date:To:From:Subject:From;
        b=kk/qlgCJ1mvPHwt49Vk66mE2Ge9A/dwjTZ5xZL44PbwVF8pg7nnAR42rcr+qIiX26
         CkaQK5e567qboF9gs1IwFJQzw26dPJjb/76BvX5fquTRQVPTmUApbSWmGqxLRRCShR
         s6nxVqdCTPVt5Xg3QVSGoXgn0OGElFcWZb6ytTDw=
Date:   Mon, 13 Jun 2022 12:40:53 -0700
To:     mm-commits@vger.kernel.org, corbet@lwn.net, sj@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + docs-admin-guide-damon-add-a-document-for-damon_lru_sort.patch added to mm-unstable branch
Message-Id: <20220613194054.844DDC34114@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: Docs/admin-guide/damon: add a document for DAMON_LRU_SORT
has been added to the -mm mm-unstable branch.  Its filename is
     docs-admin-guide-damon-add-a-document-for-damon_lru_sort.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-admin-guide-damon-add-a-document-for-damon_lru_sort.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: Docs/admin-guide/damon: add a document for DAMON_LRU_SORT
Date: Mon, 13 Jun 2022 19:23:01 +0000

This commit documents the usage of DAMON_LRU_SORT for admins.

Link: https://lkml.kernel.org/r/20220613192301.8817-10-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/damon/index.rst    |    1 
 Documentation/admin-guide/mm/damon/lru_sort.rst |  294 ++++++++++++++
 2 files changed, 295 insertions(+)

--- a/Documentation/admin-guide/mm/damon/index.rst~docs-admin-guide-damon-add-a-document-for-damon_lru_sort
+++ a/Documentation/admin-guide/mm/damon/index.rst
@@ -14,3 +14,4 @@ optimize those.
    start
    usage
    reclaim
+   lru_sort
--- /dev/null
+++ a/Documentation/admin-guide/mm/damon/lru_sort.rst
@@ -0,0 +1,294 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+=============================
+DAMON-based LRU-lists Sorting
+=============================
+
+DAMON-based LRU-lists Sorting (DAMON_LRU_SORT) is a static kernel module that
+aimed to be used for proactive and lightweight data access pattern based
+(de)prioritization of pages on their LRU-lists for making LRU-lists a more
+trusworthy data access pattern source.
+
+Where Proactive LRU-lists Sorting is Required?
+==============================================
+
+As page-granularity access checking overhead could be significant on huge
+systems, LRU lists are normally not proactively sorted but partially and
+reactively sorted for special events including specific user requests, system
+calls and memory pressure.  As a result, LRU lists are sometimes not so
+perfectly prepared to be used as a trustworthy access pattern source for some
+situations including reclamation target pages selection under sudden memory
+pressure.
+
+Because DAMON can identify access patterns of best-effort accuracy while
+inducing only user-specified range of overhead, proactively running
+DAMON_LRU_SORT could be helpful for making LRU lists more trustworthy access
+pattern source with low and controlled overhead.
+
+How It Works?
+=============
+
+DAMON_LRU_SORT finds hot pages (pages of memory regions that showing access
+rates that higher than a user-specified threshold) and cold pages (pages of
+memory regions that showing no access for a time that longer than a
+user-specified threshold) using DAMON, and prioritizes hot pages while
+deprioritizing cold pages on their LRU-lists.  To avoid it consuming too much
+CPU for the prioritizations, a CPU time usage limit can be configured.  Under
+the limit, it prioritizes and deprioritizes more hot and cold pages first,
+respectively.  System administrators can also configure under what situation
+this scheme should automatically activated and deactivated with three memory
+pressure watermarks.
+
+Its default parameters for hotness/coldness thresholds and CPU quota limit are
+conservatively chosen.  That is, the module under its default parameters could
+be widely used without harm for common situations while providing a level of
+benefits for systems having clear hot/cold access patterns under memory
+pressure while consuming only a limited small portion of CPU time.
+
+Interface: Module Parameters
+============================
+
+To use this feature, you should first ensure your system is running on a kernel
+that is built with ``CONFIG_DAMON_LRU_SORT=y``.
+
+To let sysadmins enable or disable it and tune for the given system,
+DAMON_LRU_SORT utilizes module parameters.  That is, you can put
+``damon_lru_sort.<parameter>=<value>`` on the kernel boot command line or write
+proper values to ``/sys/modules/damon_lru_sort/parameters/<parameter>`` files.
+
+Below are the description of each parameter.
+
+enabled
+-------
+
+Enable or disable DAMON_LRU_SORT.
+
+You can enable DAMON_LRU_SORT by setting the value of this parameter as ``Y``.
+Setting it as ``N`` disables DAMON_LRU_SORT.  Note that DAMON_LRU_SORT could do
+no real monitoring and LRU-lists sorting due to the watermarks-based activation
+condition.  Refer to below descriptions for the watermarks parameter for this.
+
+commit_inputs
+-------------
+
+Make DAMON_LRU_SORT reads the input parameters again, except ``enabled``.
+
+Input parameters that updated while DAMON_LRU_SORT is running are not applied
+by default.  Once this parameter is set as ``Y``, DAMON_LRU_SORT reads values
+of parametrs except ``enabled`` again.  Once the re-reading is done, this
+parameter is set as ``N``.  If invalid parameters are found while the
+re-reading, DAMON_LRU_SORT will be disabled.
+
+hot_thres_access_freq
+---------------------
+
+Access frequency threshold for hot memory regions identification in permil.
+
+If a memory region is accessed in frequency of this or higher, DAMON_LRU_SORT
+identifies the region as hot, and mark it as accessed on the LRU list, so that
+it could not be reclaimed under memory pressure.  50% by default.
+
+cold_min_age
+------------
+
+Time threshold for cold memory regions identification in microseconds.
+
+If a memory region is not accessed for this or longer time, DAMON_LRU_SORT
+identifies the region as cold, and mark it as unaccessed on the LRU list, so
+that it could be reclaimed first under memory pressure.  120 seconds by
+default.
+
+quota_ms
+--------
+
+Limit of time for trying the LRU lists sorting in milliseconds.
+
+DAMON_LRU_SORT tries to use only up to this time within a time window
+(quota_reset_interval_ms) for trying LRU lists sorting.  This can be used
+for limiting CPU consumption of DAMON_LRU_SORT.  If the value is zero, the
+limit is disabled.
+
+10 ms by default.
+
+quota_reset_interval_ms
+-----------------------
+
+The time quota charge reset interval in milliseconds.
+
+The charge reset interval for the quota of time (quota_ms).  That is,
+DAMON_LRU_SORT does not try LRU-lists sorting for more than quota_ms
+milliseconds or quota_sz bytes within quota_reset_interval_ms milliseconds.
+
+1 second by default.
+
+wmarks_interval
+---------------
+
+The watermarks check time interval in microseconds.
+
+Minimal time to wait before checking the watermarks, when DAMON_LRU_SORT is
+enabled but inactive due to its watermarks rule.  5 seconds by default.
+
+wmarks_high
+-----------
+
+Free memory rate (per thousand) for the high watermark.
+
+If free memory of the system in bytes per thousand bytes is higher than this,
+DAMON_LRU_SORT becomes inactive, so it does nothing but periodically checks the
+watermarks.  200 (20%) by default.
+
+wmarks_mid
+----------
+
+Free memory rate (per thousand) for the middle watermark.
+
+If free memory of the system in bytes per thousand bytes is between this and
+the low watermark, DAMON_LRU_SORT becomes active, so starts the monitoring and
+the LRU-lists sorting.  150 (15%) by default.
+
+wmarks_low
+----------
+
+Free memory rate (per thousand) for the low watermark.
+
+If free memory of the system in bytes per thousand bytes is lower than this,
+DAMON_LRU_SORT becomes inactive, so it does nothing but periodically checks the
+watermarks.  50 (5%) by default.
+
+sample_interval
+---------------
+
+Sampling interval for the monitoring in microseconds.
+
+The sampling interval of DAMON for the cold memory monitoring.  Please refer to
+the DAMON documentation (:doc:`usage`) for more detail.  5ms by default.
+
+aggr_interval
+-------------
+
+Aggregation interval for the monitoring in microseconds.
+
+The aggregation interval of DAMON for the cold memory monitoring.  Please
+refer to the DAMON documentation (:doc:`usage`) for more detail.  100ms by
+default.
+
+min_nr_regions
+--------------
+
+Minimum number of monitoring regions.
+
+The minimal number of monitoring regions of DAMON for the cold memory
+monitoring.  This can be used to set lower-bound of the monitoring quality.
+But, setting this too high could result in increased monitoring overhead.
+Please refer to the DAMON documentation (:doc:`usage`) for more detail.  10 by
+default.
+
+max_nr_regions
+--------------
+
+Maximum number of monitoring regions.
+
+The maximum number of monitoring regions of DAMON for the cold memory
+monitoring.  This can be used to set upper-bound of the monitoring overhead.
+However, setting this too low could result in bad monitoring quality.  Please
+refer to the DAMON documentation (:doc:`usage`) for more detail.  1000 by
+defaults.
+
+monitor_region_start
+--------------------
+
+Start of target memory region in physical address.
+
+The start physical address of memory region that DAMON_LRU_SORT will do work
+against.  By default, biggest System RAM is used as the region.
+
+monitor_region_end
+------------------
+
+End of target memory region in physical address.
+
+The end physical address of memory region that DAMON_LRU_SORT will do work
+against.  By default, biggest System RAM is used as the region.
+
+kdamond_pid
+-----------
+
+PID of the DAMON thread.
+
+If DAMON_LRU_SORT is enabled, this becomes the PID of the worker thread.  Else,
+-1.
+
+nr_lru_sort_tried_hot_regions
+-----------------------------
+
+Number of hot memory regions that tried to be LRU-sorted.
+
+bytes_lru_sort_tried_hot_regions
+--------------------------------
+
+Total bytes of hot memory regions that tried to be LRU-sorted.
+
+nr_lru_sorted_hot_regions
+-------------------------
+
+Number of hot memory regions that successfully be LRU-sorted.
+
+bytes_lru_sorted_hot_regions
+----------------------------
+
+Total bytes of hot memory regions that successfully be LRU-sorted.
+
+nr_hot_quota_exceeds
+--------------------
+
+Number of times that the time quota limit for hot regions have exceeded.
+
+nr_lru_sort_tried_cold_regions
+------------------------------
+
+Number of cold memory regions that tried to be LRU-sorted.
+
+bytes_lru_sort_tried_cold_regions
+---------------------------------
+
+Total bytes of cold memory regions that tried to be LRU-sorted.
+
+nr_lru_sorted_cold_regions
+--------------------------
+
+Number of cold memory regions that successfully be LRU-sorted.
+
+bytes_lru_sorted_cold_regions
+-----------------------------
+
+Total bytes of cold memory regions that successfully be LRU-sorted.
+
+nr_cold_quota_exceeds
+---------------------
+
+Number of times that the time quota limit for cold regions have exceeded.
+
+Example
+=======
+
+Below runtime example commands make DAMON_LRU_SORT to find memory regions
+having >=50% access frequency and LRU-prioritize while LRU-deprioritizing
+memory regions that not accessed for 120 seconds.  The prioritization and
+deprioritization is limited to be done using only up to 1% CPU time to avoid
+DAMON_LRU_SORT consuming too much CPU time for the (de)prioritization.  It also
+asks DAMON_LRU_SORT to do nothing if the system's free memory rate is more than
+50%, but start the real works if it becomes lower than 40%.  If DAMON_RECLAIM
+doesn't make progress and therefore the free memory rate becomes lower than
+20%, it asks DAMON_LRU_SORT to do nothing again, so that we can fall back to
+the LRU-list based page granularity reclamation. ::
+
+    # cd /sys/modules/damon_lru_sort/parameters
+    # echo 500 > hot_thres_access_freq
+    # echo 120000000 > cold_min_age
+    # echo 10 > quota_ms
+    # echo 1000 > quota_reset_interval_ms
+    # echo 500 > wmarks_high
+    # echo 400 > wmarks_mid
+    # echo 200 > wmarks_low
+    # echo Y > enabled
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-reclaim-schedule-damon_reclaim_timer-only-after-system_wq-is-initialized.patch
docs-admin-guide-damon-reclaim-remove-a-paragraph-that-been-obsolete-due-to-online-tuning-support.patch
mm-damon-dbgfssysfs-move-target_has_pid-from-dbgfs-to-damonh.patch
mm-damon-reclaim-deduplicate-commit_inputs-handling.patch
mm-damon-sysfs-deduplicate-inputs-applying.patch
mm-damon-reclaim-make-enabled-checking-timer-simpler.patch
mm-damon-reclaim-add-damon_reclaim_-prefix-to-enabled_store.patch
mm-damon-dbgfs-add-and-use-mappings-between-schemes-action-inputs-and-damos_action-values.patch
mm-damon-paddr-use-a-separate-function-for-damos_pageout-handling.patch
mm-damon-schemes-add-lru_prio-damos-action.patch
docs-admin-guide-damon-sysfs-document-lru_prio-scheme-action.patch
mm-damon-schemes-add-lru_deprio-action.patch
docs-admin-guide-damon-sysfs-document-lru_deprio-scheme-action.patch
mm-damon-introduce-damon-based-lru-lists-sorting.patch
docs-admin-guide-damon-add-a-document-for-damon_lru_sort.patch

