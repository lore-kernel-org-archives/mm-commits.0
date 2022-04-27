Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A492C4332F
	for <mm-commits@archiver.kernel.org>; Wed, 27 Apr 2022 23:02:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232778AbiD0XFz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 27 Apr 2022 19:05:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239745AbiD0XDb (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 27 Apr 2022 19:03:31 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BC8E8F1A1
        for <mm-commits@vger.kernel.org>; Wed, 27 Apr 2022 15:56:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EE229B82ABE
        for <mm-commits@vger.kernel.org>; Wed, 27 Apr 2022 22:56:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5C98C385A7;
        Wed, 27 Apr 2022 22:56:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1651100216;
        bh=GpvF+Zb0cwLMjGKV+wGGJugYTJzvln03b/oQjCL0xVY=;
        h=Date:To:From:Subject:From;
        b=NT3yTr0iWJNHRdw86UAx77+lL8jSeAwbGfR5N+/PLoldQQ3uMhRcZq1HYUoV5a43h
         7g6ju69R2KiSAJhUGZHYAvr7o8vuPb7HIcPB3EBqrbeIyvclbwc1kvNyf4rxTj/BIW
         vq0kWxdp3EFXW71IPIPIzevkGd+vPTPIcU5r1rKc=
Date:   Wed, 27 Apr 2022 15:56:55 -0700
To:     mm-commits@vger.kernel.org, sfr@canb.auug.org.au,
        quic_qiancai@quicinc.com, Liam.Howlett@oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-start-tracking-vmas-with-maple-tree-fix.patch added to -mm tree
Message-Id: <20220427225656.A5C98C385A7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mmap: fix __vma_adjust() memory leak
has been added to the -mm tree.  Its filename is
     mm-start-tracking-vmas-with-maple-tree-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-start-tracking-vmas-with-maple-tree-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-start-tracking-vmas-with-maple-tree-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: mm/mmap: fix __vma_adjust() memory leak

When shifting the arg pages, the maple state may be left with allocated
memory.  Free the memory by calling mas_destroy() unconditionally at the
end of the function.

Link: https://lkml.kernel.org/r/20220427224134.yurrplclbhmnrloj@revolver
Fixes: bd6a1fd58daf (mm: start tracking VMAs with maple tree)
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Reported-by: Qian Cai <quic_qiancai@quicinc.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/mmap.c~mm-start-tracking-vmas-with-maple-tree-fix
+++ a/mm/mmap.c
@@ -864,6 +864,7 @@ int __vma_adjust(struct vm_area_struct *
 	MA_STATE(mas, &mm->mm_mt, 0, 0);
 	struct vm_area_struct *exporter = NULL, *importer = NULL;
 
+	mas_destroy(&mas);
 	validate_mm(mm);
 	validate_mm_mt(mm);
 
_

Patches currently in -mm which might be from Liam.Howlett@oracle.com are

mm-start-tracking-vmas-with-maple-tree-fix.patch

