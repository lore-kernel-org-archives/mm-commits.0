Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDD37C433F5
	for <mm-commits@archiver.kernel.org>; Tue, 22 Mar 2022 21:50:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236934AbiCVVvw (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 22 Mar 2022 17:51:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236978AbiCVVvj (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 22 Mar 2022 17:51:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2E596579F
        for <mm-commits@vger.kernel.org>; Tue, 22 Mar 2022 14:49:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 42ED861662
        for <mm-commits@vger.kernel.org>; Tue, 22 Mar 2022 21:49:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99224C340EE;
        Tue, 22 Mar 2022 21:49:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1647985798;
        bh=bQqOYlZD+42SAaMW44eQLy21UU5942AlHX38ItcKB3U=;
        h=Date:To:From:In-Reply-To:Subject:From;
        b=WvznL9GjmdwXwaf3YvL4Bqo1eNUn7RY2smZazRtDSFmD0yAcb32O7YQtjAyDUQmV9
         eyHyYoTdYwR8EXTAugCDyI+3pFvXaRJlwa8GM0l/6oP7D72ly0BIicEOieu8u4ugLT
         8E2MuFgEAJYga704aSVe5JrjGsby90sDvvX/YGFQ=
Date:   Tue, 22 Mar 2022 14:49:58 -0700
To:     xhao@linux.alibaba.com, skhan@linuxfoundation.org,
        rientjes@google.com, gregkh@linuxfoundation.org, corbet@lwn.net,
        sj@kernel.org, akpm@linux-foundation.org, patches@lists.linux.dev,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220322143803.04a5e59a07e48284f196a2f9@linux-foundation.org>
Subject: [patch 226/227] Docs/ABI/testing: add DAMON sysfs interface ABI document
Message-Id: <20220322214958.99224C340EE@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: SeongJae Park <sj@kernel.org>
Subject: Docs/ABI/testing: add DAMON sysfs interface ABI document

This commit adds DAMON sysfs interface ABI document under
Documentation/ABI/testing.

Link: https://lkml.kernel.org/r/20220228081314.5770-14-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Cc: Xin Hao <xhao@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/ABI/testing/sysfs-kernel-mm-damon |  274 ++++++++++++++
 MAINTAINERS                                     |    1 
 2 files changed, 275 insertions(+)

--- /dev/null
+++ a/Documentation/ABI/testing/sysfs-kernel-mm-damon
@@ -0,0 +1,274 @@
+what:		/sys/kernel/mm/damon/
+Date:		Mar 2022
+Contact:	SeongJae Park <sj@kernel.org>
+Description:	Interface for Data Access MONitoring (DAMON).  Contains files
+		for controlling DAMON.  For more details on DAMON itself,
+		please refer to Documentation/admin-guide/mm/damon/index.rst.
+
+What:		/sys/kernel/mm/damon/admin/
+Date:		Mar 2022
+Contact:	SeongJae Park <sj@kernel.org>
+Description:	Interface for privileged users of DAMON.  Contains files for
+		controlling DAMON that aimed to be used by privileged users.
+
+What:		/sys/kernel/mm/damon/admin/kdamonds/nr_kdamonds
+Date:		Mar 2022
+Contact:	SeongJae Park <sj@kernel.org>
+Description:	Writing a number 'N' to this file creates the number of
+		directories for controlling each DAMON worker thread (kdamond)
+		named '0' to 'N-1' under the kdamonds/ directory.
+
+What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/state
+Date:		Mar 2022
+Contact:	SeongJae Park <sj@kernel.org>
+Description:	Writing 'on' or 'off' to this file makes the kdamond starts or
+		stops, respectively.  Reading the file returns the keywords
+		based on the current status.  Writing 'update_schemes_stats' to
+		the file updates contents of schemes stats files of the
+		kdamond.
+
+What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/pid
+Date:		Mar 2022
+Contact:	SeongJae Park <sj@kernel.org>
+Description:	Reading this file returns the pid of the kdamond if it is
+		running.
+
+What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/nr_contexts
+Date:		Mar 2022
+Contact:	SeongJae Park <sj@kernel.org>
+Description:	Writing a number 'N' to this file creates the number of
+		directories for controlling each DAMON context named '0' to
+		'N-1' under the contexts/ directory.
+
+What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/operations
+Date:		Mar 2022
+Contact:	SeongJae Park <sj@kernel.org>
+Description:	Writing a keyword for a monitoring operations set ('vaddr' for
+		virtual address spaces monitoring, and 'paddr' for the physical
+		address space monitoring) to this file makes the context to use
+		the operations set.  Reading the file returns the keyword for
+		the operations set the context is set to use.
+
+What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/monitoring_attrs/intervals/sample_us
+Date:		Mar 2022
+Contact:	SeongJae Park <sj@kernel.org>
+Description:	Writing a value to this file sets the sampling interval of the
+		DAMON context in microseconds as the value.  Reading this file
+		returns the value.
+
+What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/monitoring_attrs/intervals/aggr_us
+Date:		Mar 2022
+Contact:	SeongJae Park <sj@kernel.org>
+Description:	Writing a value to this file sets the aggregation interval of
+		the DAMON context in microseconds as the value.  Reading this
+		file returns the value.
+
+What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/monitoring_attrs/intervals/update_us
+Date:		Mar 2022
+Contact:	SeongJae Park <sj@kernel.org>
+Description:	Writing a value to this file sets the update interval of the
+		DAMON context in microseconds as the value.  Reading this file
+		returns the value.
+
+What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/monitoring_attrs/nr_regions/min
+
+WDate:		Mar 2022
+Contact:	SeongJae Park <sj@kernel.org>
+Description:	Writing a value to this file sets the minimum number of
+		monitoring regions of the DAMON context as the value.  Reading
+		this file returns the value.
+
+What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/monitoring_attrs/nr_regions/max
+Date:		Mar 2022
+Contact:	SeongJae Park <sj@kernel.org>
+Description:	Writing a value to this file sets the maximum number of
+		monitoring regions of the DAMON context as the value.  Reading
+		this file returns the value.
+
+What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/targets/nr_targets
+Date:		Mar 2022
+Contact:	SeongJae Park <sj@kernel.org>
+Description:	Writing a number 'N' to this file creates the number of
+		directories for controlling each DAMON target of the context
+		named '0' to 'N-1' under the contexts/ directory.
+
+What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/targets/<T>/pid_target
+Date:		Mar 2022
+Contact:	SeongJae Park <sj@kernel.org>
+Description:	Writing to and reading from this file sets and gets the pid of
+		the target process if the context is for virtual address spaces
+		monitoring, respectively.
+
+What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/targets/<T>/regions/nr_regions
+Date:		Mar 2022
+Contact:	SeongJae Park <sj@kernel.org>
+Description:	Writing a number 'N' to this file creates the number of
+		directories for setting each DAMON target memory region of the
+		context named '0' to 'N-1' under the regions/ directory.  In
+		case of the virtual address space monitoring, DAMON
+		automatically sets the target memory region based on the target
+		processes' mappings.
+
+What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/targets/<T>/regions/<R>/start
+Date:		Mar 2022
+Contact:	SeongJae Park <sj@kernel.org>
+Description:	Writing to and reading from this file sets and gets the start
+		address of the monitoring region.
+
+What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/targets/<T>/regions/<R>/end
+Date:		Mar 2022
+Contact:	SeongJae Park <sj@kernel.org>
+Description:	Writing to and reading from this file sets and gets the end
+		address of the monitoring region.
+
+What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/nr_schemes
+Date:		Mar 2022
+Contact:	SeongJae Park <sj@kernel.org>
+Description:	Writing a number 'N' to this file creates the number of
+		directories for controlling each DAMON-based operation scheme
+		of the context named '0' to 'N-1' under the schemes/ directory.
+
+What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/action
+Date:		Mar 2022
+Contact:	SeongJae Park <sj@kernel.org>
+Description:	Writing to and reading from this file sets and gets the action
+		of the scheme.
+
+What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/access_pattern/sz/min
+Date:		Mar 2022
+Contact:	SeongJae Park <sj@kernel.org>
+Description:	Writing to and reading from this file sets and gets the mimimum
+		size of the scheme's target regions in bytes.
+
+What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/access_pattern/sz/max
+Date:		Mar 2022
+Contact:	SeongJae Park <sj@kernel.org>
+Description:	Writing to and reading from this file sets and gets the maximum
+		size of the scheme's target regions in bytes.
+
+What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/access_pattern/nr_accesses/min
+Date:		Mar 2022
+Contact:	SeongJae Park <sj@kernel.org>
+Description:	Writing to and reading from this file sets and gets the manimum
+		'nr_accesses' of the scheme's target regions.
+
+What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/access_pattern/nr_accesses/max
+Date:		Mar 2022
+Contact:	SeongJae Park <sj@kernel.org>
+Description:	Writing to and reading from this file sets and gets the maximum
+		'nr_accesses' of the scheme's target regions.
+
+What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/access_pattern/age/min
+Date:		Mar 2022
+Contact:	SeongJae Park <sj@kernel.org>
+Description:	Writing to and reading from this file sets and gets the minimum
+		'age' of the scheme's target regions.
+
+What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/access_pattern/age/max
+Date:		Mar 2022
+Contact:	SeongJae Park <sj@kernel.org>
+Description:	Writing to and reading from this file sets and gets the maximum
+		'age' of the scheme's target regions.
+
+What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/quotas/ms
+Date:		Mar 2022
+Contact:	SeongJae Park <sj@kernel.org>
+Description:	Writing to and reading from this file sets and gets the time
+		quota of the scheme in milliseconds.
+
+What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/quotas/bytes
+Date:		Mar 2022
+Contact:	SeongJae Park <sj@kernel.org>
+Description:	Writing to and reading from this file sets and gets the size
+		quota of the scheme in bytes.
+
+What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/quotas/reset_interval_ms
+Date:		Mar 2022
+Contact:	SeongJae Park <sj@kernel.org>
+Description:	Writing to and reading from this file sets and gets the quotas
+		charge reset interval of the scheme in milliseconds.
+
+What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/quotas/weights/sz_permil
+Date:		Mar 2022
+Contact:	SeongJae Park <sj@kernel.org>
+Description:	Writing to and reading from this file sets and gets the
+		under-quota limit regions prioritization weight for 'size' in
+		permil.
+
+What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/quotas/weights/nr_accesses_permil
+Date:		Mar 2022
+Contact:	SeongJae Park <sj@kernel.org>
+Description:	Writing to and reading from this file sets and gets the
+		under-quota limit regions prioritization weight for
+		'nr_accesses' in permil.
+
+What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/quotas/weights/age_permil
+Date:		Mar 2022
+Contact:	SeongJae Park <sj@kernel.org>
+Description:	Writing to and reading from this file sets and gets the
+		under-quota limit regions prioritization weight for 'age' in
+		permil.
+
+What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/watermarks/metric
+Date:		Mar 2022
+Contact:	SeongJae Park <sj@kernel.org>
+Description:	Writing to and reading from this file sets and gets the metric
+		of the watermarks for the scheme.  The writable/readable
+		keywords for this file are 'none' for disabling the watermarks
+		feature, or 'free_mem_rate' for the system's global free memory
+		rate in permil.
+
+What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/watermarks/interval_us
+Date:		Mar 2022
+Contact:	SeongJae Park <sj@kernel.org>
+Description:	Writing to and reading from this file sets and gets the metric
+		check interval of the watermarks for the scheme in
+		microseconds.
+
+What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/watermarks/high
+Date:		Mar 2022
+Contact:	SeongJae Park <sj@kernel.org>
+Description:	Writing to and reading from this file sets and gets the high
+		watermark of the scheme in permil.
+
+What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/watermarks/mid
+Date:		Mar 2022
+Contact:	SeongJae Park <sj@kernel.org>
+Description:	Writing to and reading from this file sets and gets the mid
+		watermark of the scheme in permil.
+
+What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/watermarks/low
+Date:		Mar 2022
+Contact:	SeongJae Park <sj@kernel.org>
+Description:	Writing to and reading from this file sets and gets the low
+		watermark of the scheme in permil.
+
+What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/stats/nr_tried
+Date:		Mar 2022
+Contact:	SeongJae Park <sj@kernel.org>
+Description:	Reading this file returns the number of regions that the action
+		of the scheme has tried to be applied.
+
+What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/stats/sz_tried
+Date:		Mar 2022
+Contact:	SeongJae Park <sj@kernel.org>
+Description:	Reading this file returns the total size of regions that the
+		action of the scheme has tried to be applied in bytes.
+
+What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/stats/nr_applied
+Date:		Mar 2022
+Contact:	SeongJae Park <sj@kernel.org>
+Description:	Reading this file returns the number of regions that the action
+		of the scheme has successfully applied.
+
+What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/stats/sz_applied
+Date:		Mar 2022
+Contact:	SeongJae Park <sj@kernel.org>
+Description:	Reading this file returns the total size of regions that the
+		action of the scheme has successfully applied in bytes.
+
+What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/stats/qt_exceeds
+Date:		Mar 2022
+Contact:	SeongJae Park <sj@kernel.org>
+Description:	Reading this file returns the number of the exceed events of
+		the scheme's quotas.
--- a/MAINTAINERS~docs-abi-testing-add-damon-sysfs-interface-abi-document
+++ a/MAINTAINERS
@@ -5317,6 +5317,7 @@ DATA ACCESS MONITOR
 M:	SeongJae Park <sj@kernel.org>
 L:	linux-mm@kvack.org
 S:	Maintained
+F:	Documentation/ABI/testing/sysfs-kernel-mm-damon
 F:	Documentation/admin-guide/mm/damon/
 F:	Documentation/vm/damon/
 F:	include/linux/damon.h
_
