Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34F78C6FA86
	for <mm-commits@archiver.kernel.org>; Tue, 27 Sep 2022 02:56:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230389AbiI0C4P (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 26 Sep 2022 22:56:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230477AbiI0Cz3 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 26 Sep 2022 22:55:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D6331261A
        for <mm-commits@vger.kernel.org>; Mon, 26 Sep 2022 19:50:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E015AB81923
        for <mm-commits@vger.kernel.org>; Tue, 27 Sep 2022 02:50:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84B86C433D6;
        Tue, 27 Sep 2022 02:50:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664247020;
        bh=FKFSRuS0hfXv1ND84dAA6FKf3HKj/gT6Ps7Xu5yIMZE=;
        h=Date:To:From:Subject:From;
        b=Nl3E5QgkJaAgDFy2SDXF1+ZIKhAbuTosyR41HVBY+sPLTuwCDDFVxEvHnwm9iNjAZ
         Uy2gPL4eVbt5acGpURrm8AH5dE05v1hg9nG3TG7L2w2oGbFejSkp37I3AAanrU1z91
         ibOUPpiCh8zUkjMNiemGMMzfkrXepnoQ8On6gGpw=
Date:   Mon, 26 Sep 2022 19:50:19 -0700
To:     mm-commits@vger.kernel.org, yang.yang29@zte.com.cn,
        xu.xin16@zte.com.cn, willy@infradead.org, ran.xiaokai@zte.com.cn,
        izik.eidus@ravellosystems.com, hughd@google.com,
        bagasdotme@gmail.com, adobriyan@gmail.com, cgel.zte@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] ksm-add-profit-monitoring-documentation.patch removed from -mm tree
Message-Id: <20220927025020.84B86C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: ksm: add profit monitoring documentation
has been removed from the -mm tree.  Its filename was
     ksm-add-profit-monitoring-documentation.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


