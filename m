Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC105C4708E
	for <mm-commits@archiver.kernel.org>; Fri,  6 Jan 2023 00:51:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235888AbjAFAvN (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 5 Jan 2023 19:51:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235969AbjAFAvM (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jan 2023 19:51:12 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B94A193
        for <mm-commits@vger.kernel.org>; Thu,  5 Jan 2023 16:51:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5447B61C01
        for <mm-commits@vger.kernel.org>; Fri,  6 Jan 2023 00:51:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A94F8C433D2;
        Fri,  6 Jan 2023 00:51:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1672966270;
        bh=mD/HAcp0IVnRBXZhHaXq2w2hJWsp1Bv2gKbgyWk+Bos=;
        h=Date:To:From:Subject:From;
        b=qNkrdXSMHox2n90WQO25J2xX/tF2mafVtzvPFAOj1Im46CKI4KI0b8Qg58lM3sJ1q
         XBWjNNUKZpmlweaSbWIB+7vtzAB0Rn2jgoAF0MdOGfVuaLNiUUySVAHFtKqwj5jOHU
         RrPZY7zMUrEyp/y9K27Q7mGBo/q0iisVQTh0jxjk=
Date:   Thu, 05 Jan 2023 16:51:09 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        ira.weiny@intel.com, fmdefrancesco@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-remove-an-ambiguous-sentence-from-kmap_local_folio-kdocs.patch added to mm-unstable branch
Message-Id: <20230106005110.A94F8C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: remove an ambiguous sentence from kmap_local_folio() kdocs
has been added to the -mm mm-unstable branch.  Its filename is
     mm-remove-an-ambiguous-sentence-from-kmap_local_folio-kdocs.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-remove-an-ambiguous-sentence-from-kmap_local_folio-kdocs.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: "Fabio M. De Francesco" <fmdefrancesco@gmail.com>
Subject: mm: remove an ambiguous sentence from kmap_local_folio() kdocs
Date: Thu, 5 Jan 2023 13:04:24 +0100

In the kdocs of kmap_local_folio() there is a an ambiguous sentence which
suggests to use this API "only when really necessary".

On the contrary, since kmap() and kmap_atomic() are deprecated, both
kmap_local_folio(), as well as kmap_local_page(), must be preferred to the
previous ones.

Therefore, remove the above-mentioned sentence exactly how it has
previously been done for the kmap_local_page() kdocs in commit
72f1c55adf70 ("highmem: delete a sentence from kmap_local_page() kdocs").

Link: https://lkml.kernel.org/r/20230105120424.30055-1-fmdefrancesco@gmail.com
Signed-off-by: Fabio M. De Francesco <fmdefrancesco@gmail.com>
Reviewed-by: Ira Weiny <ira.weiny@intel.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/highmem.h |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/include/linux/highmem.h~mm-remove-an-ambiguous-sentence-from-kmap_local_folio-kdocs
+++ a/include/linux/highmem.h
@@ -120,8 +120,7 @@ static inline void *kmap_local_page(stru
  * temporarily mapped.
  *
  * While it is significantly faster than kmap() for the higmem case it
- * comes with restrictions about the pointer validity. Only use when really
- * necessary.
+ * comes with restrictions about the pointer validity.
  *
  * On HIGHMEM enabled systems mapping a highmem page has the side effect of
  * disabling migration in order to keep the virtual address stable across
_

Patches currently in -mm which might be from fmdefrancesco@gmail.com are

mm-highmem-add-notes-about-conversions-from-kmap_atomic.patch
mm-remove-an-ambiguous-sentence-from-kmap_local_folio-kdocs.patch
mm-fix-two-spelling-mistakes-in-highmemh.patch

