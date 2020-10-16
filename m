Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52494C433E7
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 02:14:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EC99820878
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 02:14:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602814476;
	bh=BhPL5GHBOeg39U7ujGTOJTRhh1o5SlNq9i2mSH00iSg=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=Fh6bP/T6U9iUYOy5aN74nNC7T2j2dEsST7RUr3KiV8r1K7KO252vkwFe1prCDGFPY
	 HM0b9KTKzksJA8UuSkDjewv1dsll98b3GCo3MFjKcxvYa4VfK9JDdgNBLpii4QS3Eq
	 uDd1VzfPHcHmazz6VeR3RYjq+pYouuXnEitiMssg=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404129AbgJPCOf (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 15 Oct 2020 22:14:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:48766 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404094AbgJPCOf (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 15 Oct 2020 22:14:35 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7DF9020725;
        Fri, 16 Oct 2020 02:14:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602814474;
        bh=BhPL5GHBOeg39U7ujGTOJTRhh1o5SlNq9i2mSH00iSg=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=u9/61611vXb67NY3li5+posSkuqrcT+kXt38A8YXkhfb9mC4curbU/evC/yDH78Vh
         cHZXDOytva3frzdhPonuI9ax62q88mFWIjW9WVH5aI0zZ/eJKOtPNMUjLgn6wIVgmt
         gMMuTJYbkpzH+El7RHkzws8hhvOiAxFHtp4sbp1k=
Date:   Thu, 15 Oct 2020 19:14:34 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, cai@lca.pw, kirill@shutemov.name,
        mm-commits@vger.kernel.org, songliubraving@fb.com,
        willy@infradead.org
Subject:  [folded-merged] xarray-add-xas_split-fix.patch removed
 from -mm tree
Message-ID: <20201016021434.I0s1NXpoV%akpm@linux-foundation.org>
In-Reply-To: <20201010231559.e148a66f744d0b4870301450@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: xarray-add-xas_split-fix
has been removed from the -mm tree.  Its filename was
     xarray-add-xas_split-fix.patch

This patch was dropped because it was folded into xarray-add-xas_split.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: xarray-add-xas_split-fix

export xas_split_alloc() to modules

ERROR: modpost: "xas_split_alloc" [lib/test_xarray.ko] undefined!

Cc: "Kirill A . Shutemov" <kirill@shutemov.name>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Qian Cai <cai@lca.pw>
Cc: Song Liu <songliubraving@fb.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/xarray.c |    1 +
 1 file changed, 1 insertion(+)

--- a/lib/xarray.c~xarray-add-xas_split-fix
+++ a/lib/xarray.c
@@ -1025,6 +1025,7 @@ nomem:
 	xas_destroy(xas);
 	xas_set_err(xas, -ENOMEM);
 }
+EXPORT_SYMBOL_GPL(xas_split_alloc);
 
 /**
  * xas_split() - Split a multi-index entry into smaller entries.
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

xarray-add-xas_split.patch
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

