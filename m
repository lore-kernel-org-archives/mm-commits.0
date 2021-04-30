Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73769C433B4
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 05:59:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 56A8A6148E
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 05:59:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229482AbhD3GAP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 30 Apr 2021 02:00:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:53482 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229684AbhD3GAN (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 30 Apr 2021 02:00:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E98396148E;
        Fri, 30 Apr 2021 05:59:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1619762366;
        bh=UzXWGBQoLP8cGoFs6PpPtGuxsqPF8kJpSSOG0Ix85vY=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=GGihsjRKDOVp04wrmkDPxHfeXNOyo+I+hN5MemyrtG0NOwZdfVHlFWhwIp/pr21ET
         +r5qsKv8xPtEp55+8x94ZcqPQgzsGHZwIJ/JN7JjwK1J+WXajbiV1BwUdh2OpyUIFq
         EnLrv8DthvnH2MbeQIybgUipWEh93hLqGvjujg4I=
Date:   Thu, 29 Apr 2021 22:59:25 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, corbet@lwn.net, jhubbard@nvidia.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org, rppt@linux.ibm.com,
        torvalds@linux-foundation.org, willy@infradead.org
Subject:  [patch 121/178] mm/doc: fix fault_flag_allow_retry_first
 kerneldoc
Message-ID: <20210430055925.dIb_2a8B0%akpm@linux-foundation.org>
In-Reply-To: <20210429225251.02b6386d21b69255b4f6c163@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm/doc: fix fault_flag_allow_retry_first kerneldoc

make htmldocs reports:

./include/linux/mm.h:496: warning: Function parameter or member 'flags' not described in 'fault_flag_allow_retry_first'

Add a description.

Link: https://lkml.kernel.org/r/20210322195022.2143603-1-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Mike Rapoport <rppt@linux.ibm.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    1 +
 1 file changed, 1 insertion(+)

--- a/include/linux/mm.h~mm-doc-fix-fault_flag_allow_retry_first-kerneldoc
+++ a/include/linux/mm.h
@@ -485,6 +485,7 @@ extern pgprot_t protection_map[16];
 
 /**
  * fault_flag_allow_retry_first - check ALLOW_RETRY the first time
+ * @flags: Fault flags.
  *
  * This is mostly used for places where we want to try to avoid taking
  * the mmap_lock for too long a time when waiting for another condition
_
