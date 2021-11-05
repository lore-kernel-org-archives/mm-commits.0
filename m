Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29D00C433EF
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:35:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 157ED61262
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:35:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232416AbhKEUiQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 5 Nov 2021 16:38:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:32956 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232395AbhKEUiK (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Nov 2021 16:38:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8C90E6125F;
        Fri,  5 Nov 2021 20:35:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636144530;
        bh=A2CJN584gHMdu1tguBc0hQwk713kctjwbfDr8H1GB68=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=BXrM17EjaEgi1vR3sdL2nyJ/yvo4K5S7JTsM6WCaOcJgm8N/agyRJTKE6QsVuqmNF
         mgfKHKxs4Piqt5FIaOkx2+ziVRwYIsTL1G+PKyblK9ZlUD41rTUJtLlMTp56lbPVUZ
         avM+NLwQZop33L1MaGQoMmvX87PPkm1XHZdvruYQ=
Date:   Fri, 05 Nov 2021 13:35:30 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, dan.j.williams@intel.com, hch@lst.de,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        naoya.horiguchi@nec.com, torvalds@linux-foundation.org
Subject:  [patch 018/262] mm: don't include <linux/dax.h> in
 <linux/mempolicy.h>
Message-ID: <20211105203530.rAInkI_6I%akpm@linux-foundation.org>
In-Reply-To: <20211105133408.cccbb98b71a77d5e8430aba1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
