Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C7F0C433FE
	for <mm-commits@archiver.kernel.org>; Tue, 22 Mar 2022 21:46:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236410AbiCVVsX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 22 Mar 2022 17:48:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236575AbiCVVsR (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 22 Mar 2022 17:48:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B528B5FF16;
        Tue, 22 Mar 2022 14:46:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5266561658;
        Tue, 22 Mar 2022 21:46:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB7A1C340EC;
        Tue, 22 Mar 2022 21:46:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1647985608;
        bh=aWVQSF/htNZy1jYL2zv40uPoiE5nLGqWuLDXHzyFsrk=;
        h=Date:To:From:In-Reply-To:Subject:From;
        b=hJbVq/TxDWydbfNA+HTiHuMcz+ngF/ZHQfx+kH1CgIR0T0QcgYHlv1w2dGpB+OTZ8
         GaecN07YbTHyMBD1UPtuxaE8NA63sDQd/4IEEQUdUhiIKpKRM4zIhZavVY3Dr4xIDz
         4dGyUWJQ2s0FlBCMlU0zq7/vv9WYjgCmWvLIzaSw=
Date:   Tue, 22 Mar 2022 14:46:48 -0700
To:     vbabka@suse.cz, surenb@google.com, stable@vger.kernel.org,
        sfr@canb.auug.org.au, rientjes@google.com, nadav.amit@gmail.com,
        minchan@kernel.org, mhocko@suse.com, quic_charante@quicinc.com,
        akpm@linux-foundation.org, patches@lists.linux.dev,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220322143803.04a5e59a07e48284f196a2f9@linux-foundation.org>
Subject: [patch 163/227] mm: madvise: skip unmapped vma holes passed to process_madvise
Message-Id: <20220322214648.AB7A1C340EC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Charan Teja Kalla <quic_charante@quicinc.com>
Subject: mm: madvise: skip unmapped vma holes passed to process_madvise

The process_madvise() system call is expected to skip holes in vma passed
through 'struct iovec' vector list.  But do_madvise, which
process_madvise() calls for each vma, returns ENOMEM in case of unmapped
holes, despite the VMA is processed.

Thus process_madvise() should treat ENOMEM as expected and consider the
VMA passed to as processed and continue processing other vma's in the
vector list.  Returning -ENOMEM to user, despite the VMA is processed,
will be unable to figure out where to start the next madvise.

Link: https://lkml.kernel.org/r/4f091776142f2ebf7b94018146de72318474e686.1647008754.git.quic_charante@quicinc.com
Fixes: ecb8ac8b1f14("mm/madvise: introduce process_madvise() syscall: an external memory hinting API")
Signed-off-by: Charan Teja Kalla <quic_charante@quicinc.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nadav Amit <nadav.amit@gmail.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/madvise.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/mm/madvise.c~mm-madvise-skip-unmapped-vma-holes-passed-to-process_madvise
+++ a/mm/madvise.c
@@ -1428,9 +1428,16 @@ SYSCALL_DEFINE5(process_madvise, int, pi
 
 	while (iov_iter_count(&iter)) {
 		iovec = iov_iter_iovec(&iter);
+		/*
+		 * do_madvise returns ENOMEM if unmapped holes are present
+		 * in the passed VMA. process_madvise() is expected to skip
+		 * unmapped holes passed to it in the 'struct iovec' list
+		 * and not fail because of them. Thus treat -ENOMEM return
+		 * from do_madvise as valid and continue processing.
+		 */
 		ret = do_madvise(mm, (unsigned long)iovec.iov_base,
 					iovec.iov_len, behavior);
-		if (ret < 0)
+		if (ret < 0 && ret != -ENOMEM)
 			break;
 		iov_iter_advance(&iter, iovec.iov_len);
 	}
_
