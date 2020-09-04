Return-Path: <SRS0=2RlJ=CN=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76F84C47426
	for <mm-commits@archiver.kernel.org>; Fri,  4 Sep 2020 18:10:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1D475206B7
	for <mm-commits@archiver.kernel.org>; Fri,  4 Sep 2020 18:10:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1599243041;
	bh=xlFqgNKJQTODmGfQFSlVJvBZvepN6ixPIe8AC+BLSUU=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=rog/NVDc2xxwPpK6uIxm+rIZ/Uu0vTARUl3zd3/x9AnmTQvCcv3FICEqc10dQvuSN
	 j56NYZW5aPL7fBjywHhJGErnId/U7qgdwnCNgGxf+wmS+IIuPcv8UzNr+yXtnAs0ez
	 TZABa5dLGgfQ539PydqruYWqewMwNFmuUEp6AYbc=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726029AbgIDSKk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 4 Sep 2020 14:10:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:48208 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726434AbgIDSKk (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 4 Sep 2020 14:10:40 -0400
Received: from X1 (unknown [162.218.216.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B488C215A4;
        Fri,  4 Sep 2020 17:23:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599240237;
        bh=xlFqgNKJQTODmGfQFSlVJvBZvepN6ixPIe8AC+BLSUU=;
        h=Date:From:To:Subject:From;
        b=MUIQwfp6HrPCsj+oC9jZ07kxScGv+X4M6DUhuuHMISOuL1/OhxqNFlL1AktY6KCwd
         QIYRWe5djgJ5/frXOlHxAVbsxc/jX1kmiKVymX+XuwH4FBFfFaeYJnrSRaWelAqUgT
         1QVQhLLeTEAyD0ChI4zQu26jmte9cefSMTHTalkE=
Date:   Fri, 04 Sep 2020 10:23:53 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        songliubraving@fb.com, kirill@shutemov.name, cai@lca.pw,
        akpm@linux-foundation.org
Subject:  + xarray-add-xas_split-fix.patch added to -mm tree
Message-ID: <20200904172353.gfJQP%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: xarray-add-xas_split-fix
has been added to the -mm tree.  Its filename is
     xarray-add-xas_split-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/xarray-add-xas_split-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/xarray-add-xas_split-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-slub-re-initialize-randomized-freelist-sequence-in-calculate_sizes-fix.patch
mm.patch
mm-memory_hotplug-introduce-default-phys_to_target_node-implementation-fix.patch
device-dax-make-align-a-per-device-property-fix.patch
powerpc-mm-move-setting-pte-specific-flags-to-pfn_pte-fix.patch
mm-gup-dont-permit-users-to-call-get_user_pages-with-foll_longterm-fix.patch
memblock-make-memblock_debug-and-related-functionality-private-fix.patch
arch-drivers-replace-for_each_membock-with-for_each_mem_range-fix.patch
xarray-add-xa_get_order-fix.patch
xarray-add-xas_split-fix.patch
mmhwpoison-refactor-soft_offline_huge_page-and-__soft_offline_page-fix.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix-2.patch
fs-binfmt_elf-use-pt_load-p_align-values-for-suitable-start-address-fix.patch
linux-next-rejects.patch
kernel-forkc-export-kernel_thread-to-modules.patch

