Return-Path: <SRS0=Fe7N=DY=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75952C433E7
	for <mm-commits@archiver.kernel.org>; Sat, 17 Oct 2020 23:04:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3FD2720897
	for <mm-commits@archiver.kernel.org>; Sat, 17 Oct 2020 23:04:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602975850;
	bh=hyVqBaTqnTjcFLHpZLxW+GzLXZonULdljYEo/XEuFg4=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=Lp7rUSUT3NVCPru8GOSidjTP3HTKt72Shi/szGVCmKNCSzwJbdJAFcELO5HXFGIlO
	 +46RfwA8yW8mNhUHBA98OSpoFPhUxtub5GEcJv3U1l6aPlaFphnY2QJx373Lgc0hVQ
	 KS9v+78szKHo5GANJmK5y0MnZlpIP0ue9KqOsPks=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439835AbgJQXEK (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 17 Oct 2020 19:04:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:45546 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2438235AbgJQXEJ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 17 Oct 2020 19:04:09 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B710520897;
        Sat, 17 Oct 2020 23:04:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602975847;
        bh=hyVqBaTqnTjcFLHpZLxW+GzLXZonULdljYEo/XEuFg4=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=dDraepmKlpoPv03FzN38el6N5z6fURa3jY/mUKbc+74E48VBNIevFTzWChUad2F6I
         JF3xZM0URsXOEDigcTmb7ZD/B3gQjGE8xPYYtTnVze0ewFgT5A1Ke+hBLqTAu/mRAv
         WWVQK0yvUDxYJ3FzonyxwXoDW4FQ55N5qPUmHjbs=
Date:   Sat, 17 Oct 2020 16:04:07 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, fw@deneb.enyo.de, minchan@kernel.org,
        mm-commits@vger.kernel.org
Subject:  [folded-merged]
 =?US-ASCII?Q?mm-madvise-introduce-process=5Fmadvise-syscall-an-external-?=
 =?US-ASCII?Q?memory-hinting-api-fix-fix.patch?= removed from -mm tree
Message-ID: <20201017230407.sZVLAUtn1%akpm@linux-foundation.org>
In-Reply-To: <20201015194043.84cda0c1d6ca2a6847f2384a@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-madvise-introduce-process_madvise-syscall-an-external-memory-hinting-api-fix-fix
has been removed from the -mm tree.  Its filename was
     mm-madvise-introduce-process_madvise-syscall-an-external-memory-hinting-api-fix-fix.patch

This patch was dropped because it was folded into mm-madvise-introduce-process_madvise-syscall-an-external-memory-hinting-api.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-madvise-introduce-process_madvise-syscall-an-external-memory-hinting-api-fix-fix

fix i386 build

mm/madvise.c: In function process_madvise_vec:
mm/madvise.c:1168:15: error: storage size of iovec isnt known
  struct iovec iovec;

Cc: Florian Weimer <fw@deneb.enyo.de>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/madvise.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/madvise.c~mm-madvise-introduce-process_madvise-syscall-an-external-memory-hinting-api-fix-fix
+++ a/mm/madvise.c
@@ -18,6 +18,7 @@
 #include <linux/fadvise.h>
 #include <linux/sched.h>
 #include <linux/sched/mm.h>
+#include <linux/uio.h>
 #include <linux/ksm.h>
 #include <linux/fs.h>
 #include <linux/file.h>
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-madvise-introduce-process_madvise-syscall-an-external-memory-hinting-api.patch
mm-madvise-introduce-process_madvise-syscall-an-external-memory-hinting-api-fix-fix-fix-fix-fix-fix-fix-fix.patch
mm.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix-2.patch
kernel-forkc-export-kernel_thread-to-modules.patch

