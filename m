Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0D62C433EF
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:50:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 81B116135E
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:50:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234496AbhKKCxK (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 10 Nov 2021 21:53:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:57146 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234469AbhKKCxK (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Nov 2021 21:53:10 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B7099610A2;
        Thu, 11 Nov 2021 02:50:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636599022;
        bh=mhX2h45Vpy2/x94MDEjHSjafucyYp+J38fEkk4unoWA=;
        h=Date:From:To:Subject:From;
        b=DzN78PO69DT8fxskh+fVroKYR9OCuu2CAZhBnErdK4Kg/1Yd7LtZQo7MR8Z+RwVQo
         jKmofZ4fPgByH7tO+StI3rdAwt8ai70CaAX3yjPeUTfU+g1QZb/DPaHQ2lB6yXUvgW
         yNaUH3BxwflnfT0NjVJigyY5APh8WSTxNqVF6B+g=
Date:   Wed, 10 Nov 2021 18:50:21 -0800
From:   akpm@linux-foundation.org
To:     amit@kernel.org, benh@kernel.crashing.org, corbet@lwn.net,
        david@redhat.com, dwmw@amazon.com, elver@google.com,
        foersleo@amazon.de, gthelen@google.com,
        Jonathan.Cameron@huawei.com, markubo@amazon.de,
        mm-commits@vger.kernel.org, rientjes@google.com,
        shakeelb@google.com, shuah@kernel.org, sj@kernel.org
Subject:  [merged]
 documentation-admin-guide-mm-damon-add-a-document-for-damon_reclaim.patch
 removed from -mm tree
Message-ID: <20211111025021.DRGPc28L_%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: Documentation/admin-guide/mm/damon: add a document for DAMON_RECLAIM
has been removed from the -mm tree.  Its filename was
     documentation-admin-guide-mm-damon-add-a-document-for-damon_reclaim.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: Documentation/admin-guide/mm/damon: add a document for DAMON_RECLAIM

This commit adds an admin-guide document for DAMON-based Reclamation.

Link: https://lkml.kernel.org/r/20211019150731.16699-16-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Amit Shah <amit@kernel.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Cc: David Woodhouse <dwmw@amazon.com>
Cc: Greg Thelen <gthelen@google.com>
Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Leonard Foerster <foersleo@amazon.de>
Cc: Marco Elver <elver@google.com>
Cc: Markus Boehme <markubo@amazon.de>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/damon/index.rst   |    1 
 Documentation/admin-guide/mm/damon/reclaim.rst |  235 +++++++++++++++
 2 files changed, 236 insertions(+)

--- a/Documentation/admin-guide/mm/damon/index.rst~documentation-admin-guide-mm-damon-add-a-document-for-damon_reclaim
+++ a/Documentation/admin-guide/mm/damon/index.rst
@@ -13,3 +13,4 @@ optimize those.
 
    start
    usage
+   reclaim
--- /dev/null
+++ a/Documentation/admin-guide/mm/damon/reclaim.rst
@@ -0,0 +1,235 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+=======================
+DAMON-based Reclamation
+=======================
+
+DAMON-based Reclamation (DAMON_RECLAIM) is a static kernel module that aimed to
+be used for proactive and lightweight reclamation under light memory pressure.
+It doesn't aim to replace the LRU-list based page_granularity reclamation, but
+to be selectively used for different level of memory pressure and requirements.
+
+Where Proactive Reclamation is Required?
+========================================
+
+On general memory over-committed systems, proactively reclaiming cold pages
+helps saving memory and reducing latency spikes that incurred by the direct
+reclaim of the process or CPU consumption of kswapd, while incurring only
+minimal performance degradation [1]_ [2]_ .
+
+Free Pages Reporting [3]_ based memory over-commit virtualization systems are
+good example of the cases.  In such systems, the guest VMs reports their free
+memory to host, and the host reallocates the reported memory to other guests.
+As a result, the memory of the systems are fully utilized.  However, the
+guests could be not so memory-frugal, mainly because some kernel subsystems and
+user-space applications are designed to use as much memory as available.  Then,
+guests could report only small amount of memory as free to host, results in
+memory utilization drop of the systems.  Running the proactive reclamation in
+guests could mitigate this problem.
+
+How It Works?
+=============
+
+DAMON_RECLAIM finds memory regions that didn't accessed for specific time
+duration and page out.  To avoid it consuming too much CPU for the paging out
+operation, a speed limit can be configured.  Under the speed limit, it pages
+out memory regions that didn't accessed longer time first.  System
+administrators can also configure under what situation this scheme should
+automatically activated and deactivated with three memory pressure watermarks.
+
+Interface: Module Parameters
+============================
+
+To use this feature, you should first ensure your system is running on a kernel
+that is built with ``CONFIG_DAMON_RECLAIM=y``.
+
+To let sysadmins enable or disable it and tune for the given system,
+DAMON_RECLAIM utilizes module parameters.  That is, you can put
+``damon_reclaim.<parameter>=<value>`` on the kernel boot command line or write
+proper values to ``/sys/modules/damon_reclaim/parameters/<parameter>`` files.
+
+Note that the parameter values except ``enabled`` are applied only when
+DAMON_RECLAIM starts.  Therefore, if you want to apply new parameter values in
+runtime and DAMON_RECLAIM is already enabled, you should disable and re-enable
+it via ``enabled`` parameter file.  Writing of the new values to proper
+parameter values should be done before the re-enablement.
+
+Below are the description of each parameter.
+
+enabled
+-------
+
+Enable or disable DAMON_RECLAIM.
+
+You can enable DAMON_RCLAIM by setting the value of this parameter as ``Y``.
+Setting it as ``N`` disables DAMON_RECLAIM.  Note that DAMON_RECLAIM could do
+no real monitoring and reclamation due to the watermarks-based activation
+condition.  Refer to below descriptions for the watermarks parameter for this.
+
+min_age
+-------
+
+Time threshold for cold memory regions identification in microseconds.
+
+If a memory region is not accessed for this or longer time, DAMON_RECLAIM
+identifies the region as cold, and reclaims it.
+
+120 seconds by default.
+
+quota_ms
+--------
+
+Limit of time for the reclamation in milliseconds.
+
+DAMON_RECLAIM tries to use only up to this time within a time window
+(quota_reset_interval_ms) for trying reclamation of cold pages.  This can be
+used for limiting CPU consumption of DAMON_RECLAIM.  If the value is zero, the
+limit is disabled.
+
+10 ms by default.
+
+quota_sz
+--------
+
+Limit of size of memory for the reclamation in bytes.
+
+DAMON_RECLAIM charges amount of memory which it tried to reclaim within a time
+window (quota_reset_interval_ms) and makes no more than this limit is tried.
+This can be used for limiting consumption of CPU and IO.  If this value is
+zero, the limit is disabled.
+
+128 MiB by default.
+
+quota_reset_interval_ms
+-----------------------
+
+The time/size quota charge reset interval in milliseconds.
+
+The charget reset interval for the quota of time (quota_ms) and size
+(quota_sz).  That is, DAMON_RECLAIM does not try reclamation for more than
+quota_ms milliseconds or quota_sz bytes within quota_reset_interval_ms
+milliseconds.
+
+1 second by default.
+
+wmarks_interval
+---------------
+
+Minimal time to wait before checking the watermarks, when DAMON_RECLAIM is
+enabled but inactive due to its watermarks rule.
+
+wmarks_high
+-----------
+
+Free memory rate (per thousand) for the high watermark.
+
+If free memory of the system in bytes per thousand bytes is higher than this,
+DAMON_RECLAIM becomes inactive, so it does nothing but only periodically checks
+the watermarks.
+
+wmarks_mid
+----------
+
+Free memory rate (per thousand) for the middle watermark.
+
+If free memory of the system in bytes per thousand bytes is between this and
+the low watermark, DAMON_RECLAIM becomes active, so starts the monitoring and
+the reclaiming.
+
+wmarks_low
+----------
+
+Free memory rate (per thousand) for the low watermark.
+
+If free memory of the system in bytes per thousand bytes is lower than this,
+DAMON_RECLAIM becomes inactive, so it does nothing but periodically checks the
+watermarks.  In the case, the system falls back to the LRU-list based page
+granularity reclamation logic.
+
+sample_interval
+---------------
+
+Sampling interval for the monitoring in microseconds.
+
+The sampling interval of DAMON for the cold memory monitoring.  Please refer to
+the DAMON documentation (:doc:`usage`) for more detail.
+
+aggr_interval
+-------------
+
+Aggregation interval for the monitoring in microseconds.
+
+The aggregation interval of DAMON for the cold memory monitoring.  Please
+refer to the DAMON documentation (:doc:`usage`) for more detail.
+
+min_nr_regions
+--------------
+
+Minimum number of monitoring regions.
+
+The minimal number of monitoring regions of DAMON for the cold memory
+monitoring.  This can be used to set lower-bound of the monitoring quality.
+But, setting this too high could result in increased monitoring overhead.
+Please refer to the DAMON documentation (:doc:`usage`) for more detail.
+
+max_nr_regions
+--------------
+
+Maximum number of monitoring regions.
+
+The maximum number of monitoring regions of DAMON for the cold memory
+monitoring.  This can be used to set upper-bound of the monitoring overhead.
+However, setting this too low could result in bad monitoring quality.  Please
+refer to the DAMON documentation (:doc:`usage`) for more detail.
+
+monitor_region_start
+--------------------
+
+Start of target memory region in physical address.
+
+The start physical address of memory region that DAMON_RECLAIM will do work
+against.  That is, DAMON_RECLAIM will find cold memory regions in this region
+and reclaims.  By default, biggest System RAM is used as the region.
+
+monitor_region_end
+------------------
+
+End of target memory region in physical address.
+
+The end physical address of memory region that DAMON_RECLAIM will do work
+against.  That is, DAMON_RECLAIM will find cold memory regions in this region
+and reclaims.  By default, biggest System RAM is used as the region.
+
+kdamond_pid
+-----------
+
+PID of the DAMON thread.
+
+If DAMON_RECLAIM is enabled, this becomes the PID of the worker thread.  Else,
+-1.
+
+Example
+=======
+
+Below runtime example commands make DAMON_RECLAIM to find memory regions that
+not accessed for 30 seconds or more and pages out.  The reclamation is limited
+to be done only up to 1 GiB per second to avoid DAMON_RECLAIM consuming too
+much CPU time for the paging out operation.  It also asks DAMON_RECLAIM to do
+nothing if the system's free memory rate is more than 50%, but start the real
+works if it becomes lower than 40%.  If DAMON_RECLAIM doesn't make progress and
+therefore the free memory rate becomes lower than 20%, it asks DAMON_RECLAIM to
+do nothing again, so that we can fall back to the LRU-list based page
+granularity reclamation. ::
+
+    # cd /sys/modules/damon_reclaim/parameters
+    # echo 30000000 > min_age
+    # echo $((1 * 1024 * 1024 * 1024)) > quota_sz
+    # echo 1000 > quota_reset_interval_ms
+    # echo 500 > wmarks_high
+    # echo 400 > wmarks_mid
+    # echo 200 > wmarks_low
+    # echo Y > enabled
+
+.. [1] https://research.google/pubs/pub48551/
+.. [2] https://lwn.net/Articles/787611/
+.. [3] https://www.kernel.org/doc/html/latest/vm/free_page_reporting.html
_

Patches currently in -mm which might be from sj@kernel.org are


