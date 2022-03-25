Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59C22C433EF
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 22:41:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233896AbiCYWnO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 25 Mar 2022 18:43:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233899AbiCYWnJ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 25 Mar 2022 18:43:09 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C749B208C1C
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 15:41:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 777DFB82A34
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 22:41:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27895C340F0;
        Fri, 25 Mar 2022 22:41:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648248090;
        bh=T7XGy3OpCSmJLIAWH4hqUxGBSJlNN8gzbibnZHB7uSQ=;
        h=Date:To:From:Subject:From;
        b=vNOfRNuAbGPZm4iGGZ3+Ogb7wOKz14BzSXwsth5GeQL+w3MOWVZMpJmdb0MjZaw8v
         FB5jE6ThjYxVMIDFfINkIl6KJ6GFSmPzjcZJw69PMpqhHs1l4snifIEm45+X9OO3C0
         yzhRE/7Fwv7DeOGM4JDWzUfJTqdI9nGgwpZHBF08=
Date:   Fri, 25 Mar 2022 15:41:29 -0700
To:     mm-commits@vger.kernel.org, zhangshengju@cmss.chinamobile.com,
        weizhenliang@huawei.com, vbabka@suse.cz,
        tangbin@cmss.chinamobile.com, nixiaoming@huawei.com,
        lmark@codeaurora.org, georgi.djakov@linaro.org, corbet@lwn.net,
        hanshenghong2019@email.szu.edu.cn, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] documentation-vm-page_ownerrst-update-the-documentation.patch removed from -mm tree
Message-Id: <20220325224130.27895C340F0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: Documentation/vm/page_owner.rst: update the documentation
has been removed from the -mm tree.  Its filename was
     documentation-vm-page_ownerrst-update-the-documentation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Shenghong Han <hanshenghong2019@email.szu.edu.cn>
Subject: Documentation/vm/page_owner.rst: update the documentation

Update the documentation of ``page_owner``.

[akpm@linux-foundation.org: small grammatical tweaks]
Link: https://lkml.kernel.org/r/20211214134736.2569-1-hanshenghong2019@email.szu.edu.cn
Signed-off-by: Shenghong Han <hanshenghong2019@email.szu.edu.cn>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Georgi Djakov <georgi.djakov@linaro.org>
Cc: Liam Mark <lmark@codeaurora.org>
Cc: Tang Bin <tangbin@cmss.chinamobile.com>
Cc: Zhang Shengju <zhangshengju@cmss.chinamobile.com>
Cc: Zhenliang Wei <weizhenliang@huawei.com>
Cc: Xiaoming Ni <nixiaoming@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/vm/page_owner.rst |   23 +++++++++++++++++++++--
 1 file changed, 21 insertions(+), 2 deletions(-)

--- a/Documentation/vm/page_owner.rst~documentation-vm-page_ownerrst-update-the-documentation
+++ a/Documentation/vm/page_owner.rst
@@ -97,7 +97,7 @@ Usage
 
    The ``page_owner_sort`` tool ignores ``PFN`` rows, puts the remaining rows
    in buf, uses regexp to extract the page order value, counts the times
-   and pages of buf, and finally sorts them according to the times.
+   and pages of buf, and finally sorts them according to the parameter(s).
 
    See the result about who allocated each page
    in the ``sorted_page_owner.txt``. General output::
@@ -107,4 +107,23 @@ Usage
 	 // Detailed stack
 
    By default, ``page_owner_sort`` is sorted according to the times of buf.
-   If you want to sort by the pages nums of buf, use the ``-m`` parameter.
+   If you want to sort by the page nums of buf, use the ``-m`` parameter.
+   The detailed parameters are:
+
+   fundamental function:
+
+	Sort:
+		-a		Sort by memory allocation time.
+		-m		Sort by total memory.
+		-p		Sort by pid.
+		-r		Sort by memory release time.
+		-s		Sort by stack trace.
+		-t		Sort by times (default).
+
+   additional function:
+
+	Cull:
+		-c		Cull by comparing stacktrace instead of total block.
+
+	Filter:
+		-f		Filter out the information of blocks whose memory has not been released.
_

Patches currently in -mm which might be from hanshenghong2019@email.szu.edu.cn are


