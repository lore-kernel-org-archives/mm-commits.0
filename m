Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D347BC433E9
	for <mm-commits@archiver.kernel.org>; Thu, 21 Jan 2021 22:33:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 874E823A5F
	for <mm-commits@archiver.kernel.org>; Thu, 21 Jan 2021 22:33:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726468AbhAUWcx (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 21 Jan 2021 17:32:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:45556 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726314AbhAUWcn (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 21 Jan 2021 17:32:43 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DF64223A56;
        Thu, 21 Jan 2021 22:31:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1611268311;
        bh=Va5VFmMziAdgfzbEVzYaO7/0ftSoKPp7zfd06dMJGd0=;
        h=Date:From:To:Subject:From;
        b=Sm0soQtg+YaL1C5stio2nYvLHYKYZ43zWgiTFMD+SJaaLeIK3AA9XqXj90pJ3cPGB
         vOL6mKMS5+DEG0/oF4L8+EPfElujJgA0HXcfvxRnnr9G43MpRIfWBi2p2tCUIP1WwJ
         LG3AaU89zklw0/AH7/zeBEuBQRxn/olvoeQdUudM=
Date:   Thu, 21 Jan 2021 14:31:50 -0800
From:   akpm@linux-foundation.org
To:     abaci-bugfix@linux.alibaba.com, abaci@linux.alibaba.com,
        adobriyan@gmail.com, bhe@redhat.com, dyoung@redhat.com,
        mm-commits@vger.kernel.org, urezki@gmail.com, vgoyal@redhat.com
Subject:  + vmalloc-remove-redundant-null-check.patch added to -mm
 tree
Message-ID: <20210121223150.ZWz8Ftt-f%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: vmalloc: remove redundant NULL check
has been added to the -mm tree.  Its filename is
     vmalloc-remove-redundant-null-check.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/vmalloc-remove-redundant-null-check.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/vmalloc-remove-redundant-null-check.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Yang Li <abaci-bugfix@linux.alibaba.com>
Subject: vmalloc: remove redundant NULL check

Fix below warnings reported by coccicheck:
./fs/proc/vmcore.c:1503:2-7: WARNING: NULL check before some freeing
functions is not needed.

Link: https://lkml.kernel.org/r/1611216753-44598-1-git-send-email-abaci-bugfix@linux.alibaba.com
Signed-off-by: Yang Li <abaci-bugfix@linux.alibaba.com>
Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Acked-by: Baoquan He <bhe@redhat.com>
Cc: Dave Young <dyoung@redhat.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/vmcore.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

--- a/fs/proc/vmcore.c~vmalloc-remove-redundant-null-check
+++ a/fs/proc/vmcore.c
@@ -1503,11 +1503,8 @@ int vmcore_add_device_dump(struct vmcore
 	return 0;
 
 out_err:
-	if (buf)
-		vfree(buf);
-
-	if (dump)
-		vfree(dump);
+	vfree(buf);
+	vfree(dump);
 
 	return ret;
 }
_

Patches currently in -mm which might be from abaci-bugfix@linux.alibaba.com are

vmalloc-remove-redundant-null-check.patch

