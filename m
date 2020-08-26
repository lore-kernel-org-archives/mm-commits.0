Return-Path: <SRS0=fsxA=CE=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC9C8C433E1
	for <mm-commits@archiver.kernel.org>; Wed, 26 Aug 2020 00:34:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BD59620737
	for <mm-commits@archiver.kernel.org>; Wed, 26 Aug 2020 00:34:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1598402053;
	bh=lpxx8Pa/2S7S/3mA9PJVrKZmsz7uY65sqmuUWZHFy7U=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=VTeQ1EphgM+Qc7mi8Kt4hviGsGHBHDmTkR3AfraNtgfX7oNyim2VBa1TjJEXNzl+h
	 LPPJTpq/EwxhZ1t0U9Ch96AUaqtrMzjiVO45J5HbtOHm9XxQwOZPJbgogA9c83gORc
	 g4SWpc2NtGqGZ07dIPF2fq5sVeeMHkftU/vgzGxk=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726551AbgHZAeN (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 25 Aug 2020 20:34:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:47694 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726541AbgHZAeN (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 25 Aug 2020 20:34:13 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8801120707;
        Wed, 26 Aug 2020 00:34:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598402051;
        bh=lpxx8Pa/2S7S/3mA9PJVrKZmsz7uY65sqmuUWZHFy7U=;
        h=Date:From:To:Subject:From;
        b=H4KqPcHIs9NCC/VqQU8IId3PvsYgzxN2VaWkw3Ypo6lP1gJCqhXuHvv+Nw68GEFhW
         gTktGTZxZvdwNOUxvtn/10aeDqrz6i/IRKYXRHzDYCO4zO/H1ZEXqzstJ0yzDcyoN8
         nx1Wgg9abjh5WinvpFXSwfLZTEHMru/33fnAyBDo=
Date:   Tue, 25 Aug 2020 17:34:11 -0700
From:   akpm@linux-foundation.org
To:     jroedel@suse.de, mm-commits@vger.kernel.org, sfr@canb.auug.org.au
Subject:  +
 mm-track-page-table-modifications-in-__apply_to_page_range-fix.patch added
 to -mm tree
Message-ID: <20200826003411.RVYJjC_ep%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ARCH_PAGE_TABLE_SYNC_MASK needs vmalloc.h
has been added to the -mm tree.  Its filename is
     mm-track-page-table-modifications-in-__apply_to_page_range-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-track-page-table-modifications-in-__apply_to_page_range-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-track-page-table-modifications-in-__apply_to_page_range-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: ARCH_PAGE_TABLE_SYNC_MASK needs vmalloc.h

Link: https://lkml.kernel.org/r/20200825172508.16800a4f@canb.auug.org.au
Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/memory.c~mm-track-page-table-modifications-in-__apply_to_page_range-fix
+++ a/mm/memory.c
@@ -73,6 +73,7 @@
 #include <linux/numa.h>
 #include <linux/perf_event.h>
 #include <linux/ptrace.h>
+#include <linux/vmalloc.h>
 
 #include <trace/events/kmem.h>
 
_

Patches currently in -mm which might be from sfr@canb.auug.org.au are

mm-track-page-table-modifications-in-__apply_to_page_range-fix.patch

