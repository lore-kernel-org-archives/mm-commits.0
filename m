Return-Path: <SRS0=2RlJ=CN=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C331CC54F52
	for <mm-commits@archiver.kernel.org>; Fri,  4 Sep 2020 18:10:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5F7DF2065E
	for <mm-commits@archiver.kernel.org>; Fri,  4 Sep 2020 18:10:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1599243040;
	bh=DizObQ1eIsj25Wgsm39gCqjtlm+Zfw6f3WN0565MRC8=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=CjEbTK1gRaKI1l/SFPnAZ0+yIxIp/DaoRP1pMFqNyKQTFZ36NNJxiZ6DDaL7GkumT
	 VrxPDlQ93ttQBRfzLqFRCuVP32fDo7J/zy3ug33fvPChjjrtGIIejzTSSua0MvTkxO
	 w0dky7Wif/3jTlWnOme6sSb8T/8OxoklBw7xvAPM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726621AbgIDSKj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 4 Sep 2020 14:10:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:48215 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726618AbgIDSKj (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 4 Sep 2020 14:10:39 -0400
Received: from X1 (unknown [162.218.216.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A954A21582;
        Fri,  4 Sep 2020 17:23:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599240231;
        bh=DizObQ1eIsj25Wgsm39gCqjtlm+Zfw6f3WN0565MRC8=;
        h=Date:From:To:Subject:From;
        b=uRctJq9ZHN5e03wvFUdXSe+8IFmtly78jfS98+fsQPe2J4oTTAuZBO6odLAqqt1Yh
         4mXkaEETuAR26RuN0URvAd20qNU3W9ML75j4MBio6+Lv14YN2alSGuxtJsMhiXlnHh
         2YsW3v262Rjd60rZdqsxivxdIF6+f28VGkjl5Rk4=
Date:   Fri, 04 Sep 2020 10:23:47 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        songliubraving@fb.com, kirill@shutemov.name, cai@lca.pw,
        akpm@linux-foundation.org
Subject:  + xarray-add-xa_get_order-fix.patch added to -mm tree
Message-ID: <20200904172347.fw0jD%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: xarray-add-xa_get_order-fix
has been added to the -mm tree.  Its filename is
     xarray-add-xa_get_order-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/xarray-add-xa_get_order-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/xarray-add-xa_get_order-fix.patch

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

