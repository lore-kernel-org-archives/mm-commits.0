Return-Path: <SRS0=Fe7N=DY=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7AA7C43457
	for <mm-commits@archiver.kernel.org>; Sat, 17 Oct 2020 23:04:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 676C220E65
	for <mm-commits@archiver.kernel.org>; Sat, 17 Oct 2020 23:04:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602975854;
	bh=IMypXh8Uh7zKju+2VsoW3ts8WS03BmiW0e6m6kjw5gM=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=dFPqY1oiQhPTq1pvEMcTLO6aejj39zqU0iehDgwfKHwUxcBnGygHWRoJqC9w6Zb6K
	 dcdt+N3b5pA4KqFw3EAMNjKejEcqxIxyEuBkyiaiCD4vfwWP2bhsUrIyXwjymrGQZN
	 fDfHEDSSThU3NRYlOOJr7oP3XOs1efijkhiR48ao=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439837AbgJQXEO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 17 Oct 2020 19:04:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:45594 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2438235AbgJQXEO (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 17 Oct 2020 19:04:14 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 899A920897;
        Sat, 17 Oct 2020 23:04:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602975853;
        bh=IMypXh8Uh7zKju+2VsoW3ts8WS03BmiW0e6m6kjw5gM=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=iJQWgO810ZfmGmxTu79ypJorz1dtnvekcQIHArLm0y1FrQHZRCS8/WxGSFxgR2fKg
         zop4SUjSbW79kdKaWzpqEo7h2YP27kTVxaQ/bzI7dWiEVdjmHsEUBMK1JiBtb/GY32
         KI6qlUfkmxkYv4a7UDAojj0tbPRO+QlShdx9zF5w=
Date:   Sat, 17 Oct 2020 16:04:13 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     minchan@kernel.org, mm-commits@vger.kernel.org,
        sfr@canb.auug.org.au
Subject:  [folded-merged]
 =?US-ASCII?Q?mm-madvise-introduce-process=5Fmadvise-syscall-an-external-?=
 =?US-ASCII?Q?memory-hinting-api-fix-fix-fix-fix.patch?= removed from -mm
 tree
Message-ID: <20201017230413.Xz4KoB8QT%akpm@linux-foundation.org>
In-Reply-To: <20201015194043.84cda0c1d6ca2a6847f2384a@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fix for "mm/madvise: introduce process_madvise() syscall: an external memory hinting API"
has been removed from the -mm tree.  Its filename was
     mm-madvise-introduce-process_madvise-syscall-an-external-memory-hinting-api-fix-fix-fix-fix.patch

This patch was dropped because it was folded into mm-madvise-introduce-process_madvise-syscall-an-external-memory-hinting-api.patch

------------------------------------------------------
From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: fix for "mm/madvise: introduce process_madvise() syscall: an external memory hinting API"

Link: https://lkml.kernel.org/r/20200908204547.285646b4@canb.auug.org.au
Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/madvise.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/madvise.c~mm-madvise-introduce-process_madvise-syscall-an-external-memory-hinting-api-fix-fix-fix-fix
+++ a/mm/madvise.c
@@ -7,6 +7,7 @@
  */
 
 #include <linux/mman.h>
+#include <linux/compat.h>
 #include <linux/pagemap.h>
 #include <linux/syscalls.h>
 #include <linux/mempolicy.h>
_

Patches currently in -mm which might be from sfr@canb.auug.org.au are

mm-madvise-introduce-process_madvise-syscall-an-external-memory-hinting-api.patch
mm-madvise-introduce-process_madvise-syscall-an-external-memory-hinting-api-fix-fix-fix-fix-fix-fix-fix-fix-fix.patch

