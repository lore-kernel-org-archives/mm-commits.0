Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A563AC677F1
	for <mm-commits@archiver.kernel.org>; Mon, 16 Jan 2023 20:19:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232058AbjAPUTl (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 16 Jan 2023 15:19:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233233AbjAPUTk (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 16 Jan 2023 15:19:40 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7163A83C5
        for <mm-commits@vger.kernel.org>; Mon, 16 Jan 2023 12:19:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0D2A36112F
        for <mm-commits@vger.kernel.org>; Mon, 16 Jan 2023 20:19:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62725C433EF;
        Mon, 16 Jan 2023 20:19:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1673900378;
        bh=YwtXv8+JUARAzuTmNR8PK0jIEtLXRsAkwIbH9JbzBRs=;
        h=Date:To:From:Subject:From;
        b=pc5J4qAHP+tTFSPRKvjESITlB9GrurehNxv3H2v5LDTpNt5h2Nao7IFUB4MKGtNF4
         1NhmpoRKoKhYZaqac6hR/YGTKlVTNHqcoafprddX74t27kYciJszBctC1rYSZ1hwNE
         8kjxyYdI6MMD8B2mCWowOSi8yVAuv24j26moIJJQ=
Date:   Mon, 16 Jan 2023 12:19:37 -0800
To:     mm-commits@vger.kernel.org, wangkefeng.wang@huawei.com,
        tony.luck@intel.com, shy828301@gmail.com, rientjes@google.com,
        naoya.horiguchi@nec.com, jiaqiyan@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory-failure-bump-memory-failure-stats-to-pglist_data.patch added to mm-unstable branch
Message-Id: <20230116201938.62725C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memory-failure: bump memory failure stats to pglist_data
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memory-failure-bump-memory-failure-stats-to-pglist_data.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memory-failure-bump-memory-failure-stats-to-pglist_data.patch

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
From: Jiaqi Yan <jiaqiyan@google.com>
Subject: mm: memory-failure: bump memory failure stats to pglist_data
Date: Mon, 16 Jan 2023 19:39:01 +0000

Right before memory_failure finishes its handling, accumulate poisoned
page's resolution counters to pglist_data's memory_failure_stats, so as to
update the corresponding sysfs entries.

Tested:
1) Start an application to allocate memory buffer chunks
2) Convert random memory buffer addresses to physical addresses
3) Inject memory errors using EINJ at chosen physical addresses
4) Access poisoned memory buffer and recover from SIGBUS
5) Check counter values under
   /sys/devices/system/node/node*/memory_failure/pages_*

Link: https://lkml.kernel.org/r/20230116193902.1315236-3-jiaqiyan@google.com
Signed-off-by: Jiaqi Yan <jiaqiyan@google.com>
Acked-by: David Rientjes <rientjes@google.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Yang Shi <shy828301@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/memory-failure.c~mm-memory-failure-bump-memory-failure-stats-to-pglist_data
+++ a/mm/memory-failure.c
@@ -1227,6 +1227,39 @@ static struct page_state error_states[]
 #undef slab
 #undef reserved
 
+static void update_per_node_mf_stats(unsigned long pfn,
+				     enum mf_result result)
+{
+	int nid = MAX_NUMNODES;
+	struct memory_failure_stats *mf_stats = NULL;
+
+	nid = pfn_to_nid(pfn);
+	if (unlikely(nid < 0 || nid >= MAX_NUMNODES)) {
+		WARN_ONCE(1, "Memory failure: pfn=%#lx, invalid nid=%d", pfn, nid);
+		return;
+	}
+
+	mf_stats = &NODE_DATA(nid)->mf_stats;
+	switch (result) {
+	case MF_IGNORED:
+		++mf_stats->pages_ignored;
+		break;
+	case MF_FAILED:
+		++mf_stats->pages_failed;
+		break;
+	case MF_DELAYED:
+		++mf_stats->pages_delayed;
+		break;
+	case MF_RECOVERED:
+		++mf_stats->pages_recovered;
+		break;
+	default:
+		WARN_ONCE(1, "Memory failure: mf_result=%d is not properly handled", result);
+		break;
+	}
+	++mf_stats->pages_poisoned;
+}
+
 /*
  * "Dirty/Clean" indication is not 100% accurate due to the possibility of
  * setting PG_dirty outside page lock. See also comment above set_page_dirty().
@@ -1237,6 +1270,9 @@ static int action_result(unsigned long p
 	trace_memory_failure_event(pfn, type, result);
 
 	num_poisoned_pages_inc(pfn);
+
+	update_per_node_mf_stats(pfn, result);
+
 	pr_err("%#lx: recovery action for %s: %s\n",
 		pfn, action_page_types[type], action_name[result]);
 
_

Patches currently in -mm which might be from jiaqiyan@google.com are

mm-khugepaged-recover-from-poisoned-anonymous-memory.patch
mm-khugepaged-recover-from-poisoned-file-backed-memory.patch
mm-memory-failure-add-memory-failure-stats-to-sysfs.patch
mm-memory-failure-bump-memory-failure-stats-to-pglist_data.patch
mm-memory-failure-document-memory-failure-stats.patch

