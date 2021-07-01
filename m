Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5CA01C11F6B
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 01:50:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 467756146D
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 01:50:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238439AbhGABwi (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Jun 2021 21:52:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:41886 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238384AbhGABwa (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 30 Jun 2021 21:52:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8633C6105A;
        Thu,  1 Jul 2021 01:50:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625104200;
        bh=DN83jSjQlIGmXuJ3pDrx5I5PaeOcOqI2mGZ1P2n1rKs=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=jtua0N9PEjI/q4NDC0xozoZJJBNdhhRnavlf2tjom5XSOc3w2ryEa8weYWUqUAFq7
         XODQnDsMF1iDu/4dzwTWCW9s2xN+DXAVLkyRpxmOv6jbWqJDNmteF+erAZj+zezG8R
         Qz2CcoKtYWhWHL2gBEmJqJ8dF280SxydyGVwKnOY=
Date:   Wed, 30 Jun 2021 18:50:00 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     adobriyan@gmail.com, akpm@linux-foundation.org, corbet@lwn.net,
        eric.dumazet@gmail.com, linux-mm@kvack.org, mhocko@suse.com,
        mm-commits@vger.kernel.org, rppt@linux.ibm.com,
        torvalds@linux-foundation.org, vbabka@suse.cz, willy@infradead.org
Subject:  [patch 053/192] docs: proc.rst: meminfo: briefly describe
 gaps in memory accounting
Message-ID: <20210701015000.a7W7wztCi%akpm@linux-foundation.org>
In-Reply-To: <20210630184624.9ca1937310b0dd5ce66b30e7@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Mike Rapoport <rppt@linux.ibm.com>
Subject: docs: proc.rst: meminfo: briefly describe gaps in memory accounting

Add a paragraph that explains that it may happen that the counters in
/proc/meminfo do not add up to the overall memory usage.

Link: https://lkml.kernel.org/r/20210421061127.1182723-1-rppt@kernel.org
Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/proc.rst |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

--- a/Documentation/filesystems/proc.rst~docs-procrst-meminfo-briefly-describe-gaps-in-memory-accounting
+++ a/Documentation/filesystems/proc.rst
@@ -933,8 +933,15 @@ meminfo
 ~~~~~~~
 
 Provides information about distribution and utilization of memory.  This
-varies by architecture and compile options.  The following is from a
-16GB PIII, which has highmem enabled.  You may not have all of these fields.
+varies by architecture and compile options.  Some of the counters reported
+here overlap.  The memory reported by the non overlapping counters may not
+add up to the overall memory usage and the difference for some workloads
+can be substantial.  In many cases there are other means to find out
+additional memory using subsystem specific interfaces, for instance
+/proc/net/sockstat for TCP memory allocations.
+
+The following is from a 16GB PIII, which has highmem enabled.
+You may not have all of these fields.
 
 ::
 
_
