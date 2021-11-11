Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F29B5C433EF
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:40:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D9F1B610F7
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:40:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233872AbhKKCm4 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 10 Nov 2021 21:42:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:48538 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233571AbhKKCmz (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Nov 2021 21:42:55 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8640261354;
        Thu, 11 Nov 2021 02:40:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636598407;
        bh=F3r50GZOtznGmHGes7RgpxTuo9wfRAfdj+Lmo/n4rBU=;
        h=Date:From:To:Subject:From;
        b=cmZ18K1xLXMqD5pv8cLjdh9zz6IU5SeasfgD88rMMETjHTNj0c/CpilzplDsj2v5j
         thHQjD4S1FaujtdSvREVZMeshpdcYupEWxmxadVzMZxER4aHST1A5AWtU/clpWGVdk
         cP4sQMAUpUvdRfaZZo3vjLWSvBUP5tB4pNUxKwTQ=
Date:   Wed, 10 Nov 2021 18:40:07 -0800
From:   akpm@linux-foundation.org
To:     dan.j.williams@intel.com, hch@lst.de, mm-commits@vger.kernel.org,
        naoya.horiguchi@nec.com
Subject:  [merged]
 mm-dont-include-linux-daxh-in-linux-mempolicyh.patch removed from -mm tree
Message-ID: <20211111024007.ytJBTpf9T%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: don't include <linux/dax.h> in <linux/mempolicy.h>
has been removed from the -mm tree.  Its filename was
     mm-dont-include-linux-daxh-in-linux-mempolicyh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Christoph Hellwig <hch@lst.de>
Subject: mm: don't include <linux/dax.h> in <linux/mempolicy.h>

Not required at all, and having this causes a huge kernel rebuild as soon
as something in dax.h changes.

Link: https://lkml.kernel.org/r/20210921082253.1859794-1-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mempolicy.h |    1 -
 mm/memory-failure.c       |    1 +
 2 files changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/mempolicy.h~mm-dont-include-linux-daxh-in-linux-mempolicyh
+++ a/include/linux/mempolicy.h
@@ -8,7 +8,6 @@
 
 #include <linux/sched.h>
 #include <linux/mmzone.h>
-#include <linux/dax.h>
 #include <linux/slab.h>
 #include <linux/rbtree.h>
 #include <linux/spinlock.h>
--- a/mm/memory-failure.c~mm-dont-include-linux-daxh-in-linux-mempolicyh
+++ a/mm/memory-failure.c
@@ -39,6 +39,7 @@
 #include <linux/kernel-page-flags.h>
 #include <linux/sched/signal.h>
 #include <linux/sched/task.h>
+#include <linux/dax.h>
 #include <linux/ksm.h>
 #include <linux/rmap.h>
 #include <linux/export.h>
_

Patches currently in -mm which might be from hch@lst.de are

mm-unexport-folio_memcg_unlock.patch
mm-unexport-unlock_page_memcg.patch

