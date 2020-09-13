Return-Path: <SRS0=3wUv=CW=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1290C43461
	for <mm-commits@archiver.kernel.org>; Sun, 13 Sep 2020 00:21:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9CA002087C
	for <mm-commits@archiver.kernel.org>; Sun, 13 Sep 2020 00:21:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1599956477;
	bh=OaOuTQnW8C7R+t4zjCAUTUxmzhPrLYRA0iWJomrn/H4=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=H2Kisxu1ZtZmG35Kw/MAGCLVtb585eVYz9oLYXFvq7p7uYLjhBGpEJpymfB56931c
	 mK9RQvnLHndb03al/0xoo69nppkxOThQCFLZuIQbEF94vFcT0fPXXNUgxkUI2abiAw
	 SXyUtt1Ypd/v7mMlr7YYFOirM4Vd8i/JGgkybOTQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725908AbgIMAVQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 12 Sep 2020 20:21:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:41730 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725907AbgIMAVP (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 12 Sep 2020 20:21:15 -0400
Received: from X1 (unknown [209.33.215.130])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E821B20796;
        Sun, 13 Sep 2020 00:21:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599956475;
        bh=OaOuTQnW8C7R+t4zjCAUTUxmzhPrLYRA0iWJomrn/H4=;
        h=Date:From:To:Subject:From;
        b=Hxsx60n56ladvydmlyqkokMZnrpj0lYYdt3PCQ7f6+5OjSVYaLlz7gkDixLjXPxPo
         4kB2sWlWZ7JdXC8BoGYEg6j5foI9G1Z2EOhyWXpzW2MGsLVjQKq8UU2w6jpePpgxZU
         lDx0NngRf9TNWyU82KLWXe8q736PeXhAotdUuEWo=
Date:   Sat, 12 Sep 2020 17:21:14 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, hulkci@huawei.com, yanaijie@huawei.com
Subject:  + device-dax-make-dev_dax_kmem_probe-static.patch added to
 -mm tree
Message-ID: <20200913002114.AFxQ7%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: device-dax: make dev_dax_kmem_probe() static
has been added to the -mm tree.  Its filename is
     device-dax-make-dev_dax_kmem_probe-static.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/device-dax-make-dev_dax_kmem_probe-static.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/device-dax-make-dev_dax_kmem_probe-static.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jason Yan <yanaijie@huawei.com>
Subject: device-dax: make dev_dax_kmem_probe() static

This eliminates the following sparse warning:

drivers/dax/kmem.c:38:5: warning: symbol 'dev_dax_kmem_probe' was not
declared. Should it be static?

Link: https://lkml.kernel.org/r/20200912033901.143382-1-yanaijie@huawei.com
Signed-off-by: Jason Yan <yanaijie@huawei.com>
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/dax/kmem.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/dax/kmem.c~device-dax-make-dev_dax_kmem_probe-static
+++ a/drivers/dax/kmem.c
@@ -35,7 +35,7 @@ static int dax_kmem_range(struct dev_dax
 	return 0;
 }
 
-int dev_dax_kmem_probe(struct dev_dax *dev_dax)
+static int dev_dax_kmem_probe(struct dev_dax *dev_dax)
 {
 	int numa_node = dev_dax->target_node;
 	struct device *dev = &dev_dax->dev;
_

Patches currently in -mm which might be from yanaijie@huawei.com are

device-dax-make-dev_dax_kmem_probe-static.patch

