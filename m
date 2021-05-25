Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7429EC2B9F7
	for <mm-commits@archiver.kernel.org>; Tue, 25 May 2021 00:06:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4481F61413
	for <mm-commits@archiver.kernel.org>; Tue, 25 May 2021 00:06:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229539AbhEYAII (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 24 May 2021 20:08:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:49708 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229503AbhEYAIH (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 24 May 2021 20:08:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BB332613F5;
        Tue, 25 May 2021 00:06:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1621901198;
        bh=Q2cqxXR0Zs9l7u/ZvgK2pXqUX3Ti9j1AF13cZBK5tHk=;
        h=Date:From:To:Subject:From;
        b=bdbTBdG2bMiseQUOL8eNJlpvqCNS4eb4BOXsGvhteRA2uMzVsTBxihFmAN7DCbtx2
         HMiwvJoYgDynAWM8VWKcxymanLXNhmvlOAGyt32zfKysk6benIC5tFDcbank49fwGf
         xEskRiYIhorY6ZlagAaqOkHY6Egm7je/pk2pzj/E=
Date:   Mon, 24 May 2021 17:06:38 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, mm-commits@vger.kernel.org,
        yuehaibing@huawei.com
Subject:  + mm-compaction-use-device_attr_wo-macro.patch added to
 -mm tree
Message-ID: <20210525000638.da_QbzSrZ%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/compaction: use DEVICE_ATTR_WO macro
has been added to the -mm tree.  Its filename is
     mm-compaction-use-device_attr_wo-macro.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-compaction-use-device_attr_wo-macro.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-compaction-use-device_attr_wo-macro.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: YueHaibing <yuehaibing@huawei.com>
Subject: mm/compaction: use DEVICE_ATTR_WO macro

Use DEVICE_ATTR_WO helper instead of plain DEVICE_ATTR, which makes the
code a bit shorter and easier to read.

Link: https://lkml.kernel.org/r/20210523064521.32912-1-yuehaibing@huawei.com
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/mm/compaction.c~mm-compaction-use-device_attr_wo-macro
+++ a/mm/compaction.c
@@ -2722,9 +2722,9 @@ int sysctl_compaction_handler(struct ctl
 }
 
 #if defined(CONFIG_SYSFS) && defined(CONFIG_NUMA)
-static ssize_t sysfs_compact_node(struct device *dev,
-			struct device_attribute *attr,
-			const char *buf, size_t count)
+static ssize_t compact_store(struct device *dev,
+			     struct device_attribute *attr,
+			     const char *buf, size_t count)
 {
 	int nid = dev->id;
 
@@ -2737,7 +2737,7 @@ static ssize_t sysfs_compact_node(struct
 
 	return count;
 }
-static DEVICE_ATTR(compact, 0200, NULL, sysfs_compact_node);
+static DEVICE_ATTR_WO(compact);
 
 int compaction_register_node(struct node *node)
 {
_

Patches currently in -mm which might be from yuehaibing@huawei.com are

mm-dmapool-use-device_attr_ro-macro.patch
mm-compaction-use-device_attr_wo-macro.patch

