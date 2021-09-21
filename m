Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86C16C433EF
	for <mm-commits@archiver.kernel.org>; Tue, 21 Sep 2021 18:34:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4847F61186
	for <mm-commits@archiver.kernel.org>; Tue, 21 Sep 2021 18:34:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233114AbhIUSgC (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 21 Sep 2021 14:36:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:49254 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232890AbhIUSgB (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 21 Sep 2021 14:36:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A588561100;
        Tue, 21 Sep 2021 18:34:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1632249272;
        bh=Zb7TKrfXranpVS+tUtjgIBDI5d/6oOe7JXAqX6Z2a6I=;
        h=Date:From:To:Subject:From;
        b=OVjSoQMhUEI/Lp3zwziaWhdNautA3aVgxBJrcyp3ChmgXRYz88tdWXMT5dqlImpbx
         LLeGSuANIsaeH7dR/C/5L67CqTbVaetG/OT+IqNqq5FkKoSTAYh6xI5m2j/EyLYD49
         z3auVVXs6iKPkVWR96KAjsTkLdoO/StJvR3x6vCg=
Date:   Tue, 21 Sep 2021 11:34:32 -0700
From:   akpm@linux-foundation.org
To:     hch@lst.de, mm-commits@vger.kernel.org, naoya.horiguchi@nec.com
Subject:  + mm-dont-include-linux-daxh-in-linux-mempolicyh.patch
 added to -mm tree
Message-ID: <20210921183432._7I3mJ1Wh%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: don't include <linux/dax.h> in <linux/mempolicy.h>
has been added to the -mm tree.  Its filename is
     mm-dont-include-linux-daxh-in-linux-mempolicyh.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-dont-include-linux-daxh-in-linux-mempolicyh.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-dont-include-linux-daxh-in-linux-mempolicyh.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Christoph Hellwig <hch@lst.de>
Subject: mm: don't include <linux/dax.h> in <linux/mempolicy.h>

Not required at all, and having this causes a huge kernel rebuild as soon
as something in dax.h changes.

Link: https://lkml.kernel.org/r/20210921082253.1859794-1-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
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

mm-dont-include-linux-daxh-in-linux-mempolicyh.patch
mm-unexport-folio_memcg_unlock.patch
mm-unexport-unlock_page_memcg.patch

