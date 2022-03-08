Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA3D3C433F5
	for <mm-commits@archiver.kernel.org>; Tue,  8 Mar 2022 17:54:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349320AbiCHRy7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 8 Mar 2022 12:54:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349307AbiCHRy6 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 8 Mar 2022 12:54:58 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 773D9522CC
        for <mm-commits@vger.kernel.org>; Tue,  8 Mar 2022 09:54:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 20FFAB81B0B
        for <mm-commits@vger.kernel.org>; Tue,  8 Mar 2022 17:54:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A632BC340F4;
        Tue,  8 Mar 2022 17:53:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1646762038;
        bh=QmRv10CHDlsUKZJVAfKfcAlZjUQGKYe1/x0GAF5WQfA=;
        h=Date:To:From:Subject:From;
        b=yYPR4+DU7GCi2DyP27DCFF1K7IAvCpE21Wqd6zcGBN0Y9XkjE8sBZdBFxhEpWZirA
         E91+gfrcK5XNWr/rwQojNtwyMrb/atUvYb0n/Gv+Cquo+hRnkfhLeMQrPm77TD+XFK
         QLB1DKOs6shSz+DxrWdJpraGy4+j624edjn9jxek=
Date:   Tue, 08 Mar 2022 09:53:57 -0800
To:     mm-commits@vger.kernel.org, weizhenliang@huawei.com,
        skhan@linuxfoundation.org, rdunlap@infradead.org,
        georgi.djakov@linaro.org, corbet@lwn.net,
        caoyixuan2019@email.szu.edu.cn, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] documentation-vm-page_ownerrst-fix-commends.patch removed from -mm tree
Message-Id: <20220308175358.A632BC340F4@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: Documentation/vm/page_owner.rst: fix comments
has been removed from the -mm tree.  Its filename was
     documentation-vm-page_ownerrst-fix-commends.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Yixuan Cao <caoyixuan2019@email.szu.edu.cn>
Subject: Documentation/vm/page_owner.rst: fix comments

There are some comments that need to be fixed.

Thanks for Shuah Khan's constructive suggestions.  The comments have been
fixed as follows.

a. So, if you'd like to use it, you need
to add "page_owner=on" into your boot cmdline.

Here, "into" has been replaced with "to".

b. ...page owner is disabled in runtime due to no
enabling, boot option, runtime overhead is marginal.

Here, "no" has been replaced with "not".

Link: https://lkml.kernel.org/r/20220223134104.2663-1-caoyixuan2019@email.szu.edu.cn
Signed-off-by: Yixuan Cao <caoyixuan2019@email.szu.edu.cn>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Zhenliang Wei <weizhenliang@huawei.com>
Cc: Georgi Djakov <georgi.djakov@linaro.org>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Cc: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/vm/page_owner.rst |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/Documentation/vm/page_owner.rst~documentation-vm-page_ownerrst-fix-commends
+++ a/Documentation/vm/page_owner.rst
@@ -26,9 +26,9 @@ fragmentation statistics can be obtained
 each page. It is already implemented and activated if page owner is
 enabled. Other usages are more than welcome.
 
-page owner is disabled in default. So, if you'd like to use it, you need
-to add "page_owner=on" into your boot cmdline. If the kernel is built
-with page owner and page owner is disabled in runtime due to no enabling
+page owner is disabled by default. So, if you'd like to use it, you need
+to add "page_owner=on" to your boot cmdline. If the kernel is built
+with page owner and page owner is disabled in runtime due to not enabling
 boot option, runtime overhead is marginal. If disabled in runtime, it
 doesn't require memory to store owner information, so there is no runtime
 memory overhead. And, page owner inserts just two unlikely branches into
_

Patches currently in -mm which might be from caoyixuan2019@email.szu.edu.cn are

tools-vm-page_owner_sortc-delete-invalid-duplicate-code.patch
mm-page_ownerc-record-tgid.patch
tools-vm-page_owner_sortc-fix-the-instructions-for-use.patch

