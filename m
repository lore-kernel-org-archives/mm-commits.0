Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25CFAC5519F
	for <mm-commits@archiver.kernel.org>; Fri, 13 Nov 2020 01:35:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C302322243
	for <mm-commits@archiver.kernel.org>; Fri, 13 Nov 2020 01:35:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="JQbnqQPt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726146AbgKMBfH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 12 Nov 2020 20:35:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:43968 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726112AbgKMBfG (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 12 Nov 2020 20:35:06 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 93FCE21D7F;
        Fri, 13 Nov 2020 01:35:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605231305;
        bh=SYLuI0Tkw4u869R4PhGwMaE56fqE2NGfV/bm0mI8Bis=;
        h=Date:From:To:Subject:From;
        b=JQbnqQPtYGyXXGJEtffWn1u/zeu+LLt7y2D2ZB+N5VbGQsDmk4NLZYkF3NgnxSy0f
         dZos9ljBMKejeTpu4f+HC+WKFOfYHRPvccErS4wC51Z+6o+4EXYVn2E4R9S6GwtL2n
         Qt9CClr2Y4lBf4GfLTLp0gMIrg6eSXMHN5Nff/KA=
Date:   Thu, 12 Nov 2020 17:35:05 -0800
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, mm-commits@vger.kernel.org,
        rppt@linux.ibm.com
Subject:  + secretmem-add-memcg-accounting-fix.patch added to -mm
 tree
Message-ID: <20201113013505.VoHo-IQ-e%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: secretmem-add-memcg-accounting-fix
has been added to the -mm tree.  Its filename is
     secretmem-add-memcg-accounting-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/secretmem-add-memcg-accounting-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/secretmem-add-memcg-accounting-fix.patch

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
Subject: secretmem-add-memcg-accounting-fix

fix CONFIG_MEMCG=n build

Cc: Mike Rapoport <rppt@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/filemap.c~secretmem-add-memcg-accounting-fix
+++ a/mm/filemap.c
@@ -844,7 +844,7 @@ static noinline int __add_to_page_cache_
 	page->mapping = mapping;
 	page->index = offset;
 
-	if (!huge && !page->memcg_data) {
+	if (!huge && !page_memcg(page)) {
 		error = mem_cgroup_charge(page, current->mm, gfp);
 		if (error)
 			goto error;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

kthread_worker-document-cpu-hotplug-handling-fix.patch
mm.patch
mm-prevent-gup_fast-from-racing-with-cow-during-fork-checkpatch-fixes.patch
mm-swap_state-skip-meaningless-swap-cache-readahead-when-ra_infowin-==-0-fix.patch
mm-vmallocc-__vmalloc_area_node-avoid-32-bit-overflow.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix-2.patch
lib-test_bitmapc-add-for_each_set_clump-test-cases-checkpatch-fixes.patch
linux-next-rejects.patch
kasan-split-out-shadowc-from-commonc-fix.patch
kasan-mm-check-kasan_enabled-in-annotations-fix.patch
kasan-mm-rename-kasan_poison_kfree-temp-fix.patch
secretmem-add-memcg-accounting-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

