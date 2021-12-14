Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99777C433EF
	for <mm-commits@archiver.kernel.org>; Tue, 14 Dec 2021 20:41:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237681AbhLNUln (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 14 Dec 2021 15:41:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231263AbhLNUlm (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 14 Dec 2021 15:41:42 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B94F9C061574
        for <mm-commits@vger.kernel.org>; Tue, 14 Dec 2021 12:41:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 22CC3616D4
        for <mm-commits@vger.kernel.org>; Tue, 14 Dec 2021 20:41:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E079C34600;
        Tue, 14 Dec 2021 20:41:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1639514501;
        bh=lSoTFmHPMpwoo2CPm0PHRd+kH+BwjiuIvP1RcxPIFRU=;
        h=Date:From:To:Subject:From;
        b=KdUBx4xCpT6ItMEzEiViTbNkmVcvOEMf9Vfexll3y+TZOB2jLq8gy/7BcUHdP4895
         UpcTwq6ivyXdygt9zNekcrZ0E9Mvv1baOLPA+tt6Orvgp5sf9aFL9nNVs6yQ1q8uXM
         VAylWaSAsRKwvvsJD1TNUbcKB1H8rAviDKtzXoMs=
Date:   Tue, 14 Dec 2021 12:41:40 -0800
From:   akpm@linux-foundation.org
To:     corbet@lwn.net, georgi.djakov@linaro.org,
        hanshenghong2019@email.szu.edu.cn, lmark@codeaurora.org,
        mm-commits@vger.kernel.org, nixiaoming@huawei.com,
        tangbin@cmss.chinamobile.com, vbabka@suse.cz,
        weizhenliang@huawei.com, zhangshengju@cmss.chinamobile.com
Subject:  +
 documentation-vm-page_ownerrst-update-the-documentation.patch added to -mm
 tree
Message-ID: <20211214204140.whK8ZuMra%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: Documentation/vm/page_owner.rst: update the documentation
has been added to the -mm tree.  Its filename is
     documentation-vm-page_ownerrst-update-the-documentation.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/documentation-vm-page_ownerrst-update-the-documentation.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/documentation-vm-page_ownerrst-update-the-documentation.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Shenghong Han <hanshenghong2019@email.szu.edu.cn>
Subject: Documentation/vm/page_owner.rst: update the documentation

Update the documentation of ``page_owner``.

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

 Documentation/vm/page_owner.rst |   21 ++++++++++++++++++++-
 1 file changed, 20 insertions(+), 1 deletion(-)

--- a/Documentation/vm/page_owner.rst~documentation-vm-page_ownerrst-update-the-documentation
+++ a/Documentation/vm/page_owner.rst
@@ -97,7 +97,7 @@ Usage
 
    The ``page_owner_sort`` tool ignores ``PFN`` rows, puts the remaining rows
    in buf, uses regexp to extract the page order value, counts the times
-   and pages of buf, and finally sorts them according to the times.
+   and pages of buf, and finally sorts them according to the parameter(s).
 
    See the result about who allocated each page
    in the ``sorted_page_owner.txt``. General output:
@@ -108,3 +108,22 @@ Usage
 
    By default, ``page_owner_sort`` is sorted according to the times of buf.
    If you want to sort by the pages nums of buf, use the ``-m`` parameter.
+   The detail parameters are shown as follows:
+
+   fundamental function:
+
+	Sort:
+		-a		Sort by memory allocate time.
+		-m		Sort by total memory.
+		-p		Sort by pid.
+		-r		Sort by memory release time.
+		-s		Sort by the stack trace.
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

tools-vm-page_owner_sortc-two-trivial-fixes.patch
documentation-vm-page_ownerrst-update-the-documentation.patch

