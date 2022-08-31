Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDD8BECAAD5
	for <mm-commits@archiver.kernel.org>; Wed, 31 Aug 2022 00:43:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231590AbiHaAna (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 30 Aug 2022 20:43:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232257AbiHaAnN (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 30 Aug 2022 20:43:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE37F20BEB
        for <mm-commits@vger.kernel.org>; Tue, 30 Aug 2022 17:41:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 13746617EC
        for <mm-commits@vger.kernel.org>; Wed, 31 Aug 2022 00:40:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F27CC433D6;
        Wed, 31 Aug 2022 00:40:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1661906450;
        bh=LV8pGr8lqVey0vHNHOetJVbW0bP46ZwZtAX2Sm3cd8E=;
        h=Date:To:From:Subject:From;
        b=fRl+qtI+eU1UmD5ELB+Blps0fJVxLX5Ys5LuJGGZ1gSpwdHKdwufZ4JK5sHyYhcU6
         Ro/JnDfyWDsu0JxXn39vSimsQMgXuDE7ktDaRH7v4DnYQSgnuurbchCzHg3agzgMYA
         lZXJ4FR3jb6NTGiHFvmWl8PiYwJv2IrloHavMdPM=
Date:   Tue, 30 Aug 2022 17:40:49 -0700
To:     mm-commits@vger.kernel.org, yang.yang29@zte.com.cn,
        xu.xin16@zte.com.cn, willy@infradead.org, ran.xiaokai@zte.com.cn,
        izik.eidus@ravellosystems.com, hughd@google.com,
        bagasdotme@gmail.com, adobriyan@gmail.com, cgel.zte@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + ksm-add-profit-monitoring-documentation.patch added to mm-unstable branch
Message-Id: <20220831004050.6F27CC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ksm: add profit monitoring documentation
has been added to the -mm mm-unstable branch.  Its filename is
     ksm-add-profit-monitoring-documentation.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ksm-add-profit-monitoring-documentation.patch

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
From: xu xin <cgel.zte@gmail.com>
Subject: ksm: add profit monitoring documentation
Date: Tue, 30 Aug 2022 14:40:03 +0000

Add the description of KSM profit and how to determine it separately in
system-wide range and inner a single process.

Link: https://lkml.kernel.org/r/20220830144003.299870-1-xu.xin16@zte.com.cn
Signed-off-by: xu xin <xu.xin16@zte.com.cn>
Reviewed-by: Xiaokai Ran <ran.xiaokai@zte.com.cn>
Reviewed-by: Yang Yang <yang.yang29@zte.com.cn>
Reviewed-by: Bagas Sanjaya <bagasdotme@gmail.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Izik Eidus <izik.eidus@ravellosystems.com>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/ksm.rst |   36 +++++++++++++++++++++++++
 1 file changed, 36 insertions(+)

--- a/Documentation/admin-guide/mm/ksm.rst~ksm-add-profit-monitoring-documentation
+++ a/Documentation/admin-guide/mm/ksm.rst
@@ -184,6 +184,42 @@ The maximum possible ``pages_sharing/pag
 ``max_page_sharing`` tunable. To increase the ratio ``max_page_sharing`` must
 be increased accordingly.
 
+Monitoring KSM profit
+=====================
+
+KSM can save memory by merging identical pages, but also can consume
+additional memory, because it needs to generate a number of rmap_items to
+save each scanned page's brief rmap information. Some of these pages may
+be merged, but some may not be abled to be merged after being checked
+several times, which are unprofitable memory consumed.
+
+1) How to determine whether KSM save memory or consume memory in system-wide
+   range? Here is a simple approximate calculation for reference::
+
+	general_profit =~ pages_sharing * sizeof(page) - (all_rmap_items) *
+			  sizeof(rmap_item);
+
+   where all_rmap_items can be easily obtained by summing ``pages_sharing``,
+   ``pages_shared``, ``pages_unshared`` and ``pages_volatile``.
+
+2) The KSM profit inner a single process can be similarly obtained by the
+   following approximate calculation::
+
+	process_profit =~ ksm_merging_pages * sizeof(page) -
+			  ksm_rmap_items * sizeof(rmap_item).
+
+   where ksm_merging_pages is shown under the directory ``/proc/<pid>/``,
+   and ksm_rmap_items is shown in ``/proc/<pid>/ksm_stat``.
+
+From the perspective of application, a high ratio of ``ksm_rmap_items`` to
+``ksm_merging_pages`` means a bad madvise-applied policy, so developers or
+administrators have to rethink how to change madvise policy. Giving an example
+for reference, a page's size is usually 4K, and the rmap_item's size is
+separately 32B on 32-bit CPU architecture and 64B on 64-bit CPU architecture.
+so if the ``ksm_rmap_items/ksm_merging_pages`` ratio exceeds 64 on 64-bit CPU
+or exceeds 128 on 32-bit CPU, then the app's madvise policy should be dropped,
+because the ksm profit is approximately zero or negative.
+
 Monitoring KSM events
 =====================
 
_

Patches currently in -mm which might be from cgel.zte@gmail.com are

ksm-count-allocated-ksm-rmap_items-for-each-process.patch
ksm-add-profit-monitoring-documentation.patch

