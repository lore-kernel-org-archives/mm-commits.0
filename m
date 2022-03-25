Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CFC7C433F5
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 01:09:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244500AbiCYBKh (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Mar 2022 21:10:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231880AbiCYBKc (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Mar 2022 21:10:32 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 715BD44774
        for <mm-commits@vger.kernel.org>; Thu, 24 Mar 2022 18:08:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 243CEB82708
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 01:08:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB019C340EC;
        Fri, 25 Mar 2022 01:08:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648170536;
        bh=Fq1WgJ7I2oittD73GD1Je7sD6NEjKS/Jlihe9Ym9qYo=;
        h=Date:To:From:In-Reply-To:Subject:From;
        b=FZzyr+W/ISn+xSC291hm7XZQnuyIIUAwCgL/ypFlqWsp7zCWGSqxUNtAf8NIjAQnr
         bSlDUlXc4CnYxaEvq8YDfAld15F/vb0JrbSRViA7goOmZRZrVfX20y9zqyA2EE0VZy
         ayRzI4rkNcc/HDwPZPV2VqBqzOJqfFNSp4D/xXPA=
Date:   Thu, 24 Mar 2022 18:08:56 -0700
To:     zhangshengju@cmss.chinamobile.com, weizhenliang@huawei.com,
        vbabka@suse.cz, tangbin@cmss.chinamobile.com,
        nixiaoming@huawei.com, lmark@codeaurora.org,
        georgi.djakov@linaro.org, corbet@lwn.net,
        hanshenghong2019@email.szu.edu.cn, akpm@linux-foundation.org,
        patches@lists.linux.dev, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220324180758.96b1ac7e17675d6bc474485e@linux-foundation.org>
Subject: [patch 007/114] Documentation/vm/page_owner.rst: update the documentation
Message-Id: <20220325010856.AB019C340EC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
