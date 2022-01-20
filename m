Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D68DBC433F5
	for <mm-commits@archiver.kernel.org>; Thu, 20 Jan 2022 02:09:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358187AbiATCJj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 19 Jan 2022 21:09:39 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:50992 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358191AbiATCJZ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 19 Jan 2022 21:09:25 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 19D1CB81B3B
        for <mm-commits@vger.kernel.org>; Thu, 20 Jan 2022 02:09:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AA1AC004E1;
        Thu, 20 Jan 2022 02:09:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642644562;
        bh=vI4ss0yCgevg3ztvIwwxzqDr7ZCp+AjGyA7wYbkjD7c=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=sOiBjTK3smDJmEa6OCdCwuOcGXwX7NSFYKRyNc5VxtfYqAjwDo0dHoi8at2Fly33X
         76aX+3YsuNG98OBGypG/BayRgQphAbu79ZYgaw/ZJJp5BGQATKMxFnubKLamImO5fj
         l4qKg6pLC/vL50uFO/Ik8YkJWYUEYsOq4oubZu+o=
Date:   Wed, 19 Jan 2022 18:09:22 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com,
        hch@lst.de, linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 31/55] uuid: discourage people from using UAPI
 header in new code
Message-ID: <20220120020922.oh9NDi0T7%akpm@linux-foundation.org>
In-Reply-To: <20220119180714.9e187ce100e4510de3cd9f7d@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: uuid: discourage people from using UAPI header in new code

Discourage people from using UAPI header in new code by adding a note.

Link: https://lkml.kernel.org/r/20211216113552.81199-1-andriy.shevchenko@linux.intel.com
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Acked-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/uapi/linux/uuid.h |    1 +
 1 file changed, 1 insertion(+)

--- a/include/uapi/linux/uuid.h~uuid-discourage-people-from-using-uapi-header-in-new-code
+++ a/include/uapi/linux/uuid.h
@@ -1,4 +1,5 @@
 /* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
+/* DO NOT USE in new code! This is solely for MEI due to legacy reasons */
 /*
  * UUID/GUID definition
  *
_
