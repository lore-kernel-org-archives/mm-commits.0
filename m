Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A713AC433DF
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 02:14:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 46EF3206ED
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 02:14:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602814450;
	bh=3lyyRGMkNN15colv9HK6pUVHtiOugaxxkzGg9sJ24I0=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=rzU0sZ9P3Yde1y4EDF7WMMIQ4odVZBBqlp2EsUJ17n/Uigu4WY1npiaVT0V/ympxW
	 hJVJHWM0DKzmMwJzufZH0jj7wXTZDdD2IQMlY9VevPDM9X3oWZd7jnWZqFHY21JTSL
	 lo1l3+a1zmxnnMKAX/DpxEayPQy3ZVX1pMN15ByE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404124AbgJPCOJ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 15 Oct 2020 22:14:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:48550 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404094AbgJPCOF (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 15 Oct 2020 22:14:05 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5D43B206ED;
        Fri, 16 Oct 2020 02:14:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602814442;
        bh=3lyyRGMkNN15colv9HK6pUVHtiOugaxxkzGg9sJ24I0=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=xfB/7uEXs+NVTPVDeevEqhUt7+NCsoNk/7AD8YcrZucrk9ZO+1naYmbjhVpODgL4G
         Aft+LDHzhxfsn5hOSaWGNkWB6UWhGg/xWSHd8Karg/BWkhxpXqZSaVZioqNaITIclm
         wVSndQQnLYJ/EMsyKdRua+ah5k2rsVwbx2uM/ulQ=
Date:   Thu, 15 Oct 2020 19:14:01 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, cai@lca.pw, kirill@shutemov.name,
        mm-commits@vger.kernel.org, songliubraving@fb.com,
        willy@infradead.org
Subject:  [folded-merged] xarray-add-xa_get_order-fix.patch removed
 from -mm tree
Message-ID: <20201016021401.101ezAAMA%akpm@linux-foundation.org>
In-Reply-To: <20201010231559.e148a66f744d0b4870301450@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: xarray-add-xa_get_order-fix
has been removed from the -mm tree.  Its filename was
     xarray-add-xa_get_order-fix.patch

This patch was dropped because it was folded into xarray-add-xa_get_order.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: xarray-add-xa_get_order-fix

export xa_get_order to modules

ERROR: modpost: "xa_get_order" [lib/test_xarray.ko] undefined!

Cc: "Kirill A . Shutemov" <kirill@shutemov.name>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Qian Cai <cai@lca.pw>
Cc: Song Liu <songliubraving@fb.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/xarray.c |    1 +
 1 file changed, 1 insertion(+)

--- a/lib/xarray.c~xarray-add-xa_get_order-fix
+++ a/lib/xarray.c
@@ -1631,6 +1631,7 @@ unlock:
 
 	return order;
 }
+EXPORT_SYMBOL(xa_get_order);
 #endif /* CONFIG_XARRAY_MULTI */
 
 /**
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

xarray-add-xa_get_order.patch
xarray-add-xas_split-fix.patch
mm-memory_hotplug-simplify-page-offlining-fix.patch
checkpatch-warn-on-self-assignments-checkpatch-fixes.patch
checkpatch-emit-a-warning-on-embedded-filenames-fix.patch
fs-binfmt_elf-use-pt_load-p_align-values-for-suitable-start-address-fix.patch
mm.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix-2.patch
linux-next-rejects.patch
mm-madvise-introduce-process_madvise-syscall-an-external-memory-hinting-api-fix-fix.patch
mm-madvise-introduce-process_madvise-syscall-an-external-memory-hinting-api-fix-fix-fix-fix-fix-fix-fix-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

