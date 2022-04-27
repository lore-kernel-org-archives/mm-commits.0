Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CAAF7C433F5
	for <mm-commits@archiver.kernel.org>; Wed, 27 Apr 2022 04:04:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236301AbiD0EHl (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 27 Apr 2022 00:07:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357618AbiD0EHk (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 27 Apr 2022 00:07:40 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EC4FD083C
        for <mm-commits@vger.kernel.org>; Tue, 26 Apr 2022 21:04:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 66395B824AC
        for <mm-commits@vger.kernel.org>; Wed, 27 Apr 2022 04:04:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB6FAC385A7;
        Wed, 27 Apr 2022 04:04:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1651032262;
        bh=iQj6+ttPsGOZyqk7cmIYzlusPytGAGxcap6Bp7kTPQc=;
        h=Date:To:From:Subject:From;
        b=zZxnM/90Dj7UCWWafhHwGmWjUAfDUAseuh37vlguB/XdVeZNoUuS1Kvnff46fzbIx
         1l64BI56lRSutQOBRZOMBWPgwQhrCOyQoQkwZTZUUJDNqO+K//DS/MH9MbVq5GakLU
         3/e8lgu+eDV8tSja7vnSXtGwH5cqydibIwWzHg9c=
Date:   Tue, 26 Apr 2022 21:04:21 -0700
To:     mm-commits@vger.kernel.org, ryabinin.a.a@gmail.com,
        qiang1.zhang@intel.com, glider@google.com, dvyukov@google.com,
        andreyknvl@gmail.com, akpm@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] kasan-prevent-cpu_quarantine-corruption-when-cpu-offline-and-cache-shrink-occur-at-same-time-fix.patch removed from -mm tree
Message-Id: <20220427040421.EB6FAC385A7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan-prevent-cpu_quarantine-corruption-when-cpu-offline-and-cache-shrink-occur-at-same-time-fix
has been removed from the -mm tree.  Its filename was
     kasan-prevent-cpu_quarantine-corruption-when-cpu-offline-and-cache-shrink-occur-at-same-time-fix.patch

This patch was dropped because it was folded into kasan-prevent-cpu_quarantine-corruption-when-cpu-offline-and-cache-shrink-occur-at-same-time.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: kasan-prevent-cpu_quarantine-corruption-when-cpu-offline-and-cache-shrink-occur-at-same-time-fix

add comment, per Zqiang

Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Zqiang <qiang1.zhang@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/quarantine.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/mm/kasan/quarantine.c~kasan-prevent-cpu_quarantine-corruption-when-cpu-offline-and-cache-shrink-occur-at-same-time-fix
+++ a/mm/kasan/quarantine.c
@@ -315,6 +315,11 @@ static void per_cpu_remove_cache(void *a
 	struct qlist_head *q;
 
 	q = this_cpu_ptr(&cpu_quarantine);
+	/*
+	 * Ensure the ordering between the writing to q->offline and
+	 * per_cpu_remove_cache.  Prevent cpu_quarantine from being corrupted
+	 * by interrupt.
+	 */
 	if (READ_ONCE(q->offline))
 		return;
 	qlist_move_cache(q, &to_free, cache);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

kasan-prevent-cpu_quarantine-corruption-when-cpu-offline-and-cache-shrink-occur-at-same-time.patch
mm.patch
mm-create-new-mm-swaph-header-file-fix.patch
mm-check-against-orig_pte-for-finish_fault-fix-checkpatch-fixes.patch
mm-hugetlb-only-drop-uffd-wp-special-pte-if-required-fix-fix.patch
ksm-count-ksm-merging-pages-for-each-process-fix.patch
mm-memory_hotplug-refactor-hotadd_init_pgdat-and-try_online_node-checkpatch-fixes.patch
kfence-enable-check-kfence-canary-on-panic-via-boot-param-fix.patch
lib-kstrtoxc-add-false-true-support-to-kstrtobool-fix.patch
mapletree-vs-khugepaged.patch
mm-vmscan-not-necessary-to-re-init-the-list-for-each-iteration-fix.patch
proc-fix-dentry-inode-overinstantiating-under-proc-pid-net-checkpatch-fixes.patch
fs-proc-kcorec-remove-check-of-list-iterator-against-head-past-the-loop-body-fix.patch
add-fat-messages-to-printk-index-checkpatch-fixes.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
mm-oom_killc-fix-vm_oom_kill_table-ifdeffery.patch

