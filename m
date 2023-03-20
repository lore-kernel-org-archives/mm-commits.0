Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 822FCC6FD1D
	for <mm-commits@archiver.kernel.org>; Mon, 20 Mar 2023 21:21:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229810AbjCTVVF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 20 Mar 2023 17:21:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229524AbjCTVVF (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 20 Mar 2023 17:21:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68C7A2916F
        for <mm-commits@vger.kernel.org>; Mon, 20 Mar 2023 14:21:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 036A961840
        for <mm-commits@vger.kernel.org>; Mon, 20 Mar 2023 21:21:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BE0DC433D2;
        Mon, 20 Mar 2023 21:21:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1679347262;
        bh=nOM2+JQt0v5iJsRZzx1eGqwRcqNSKVz5FIyyK+Cz4PE=;
        h=Date:To:From:Subject:From;
        b=i8NZeZfYcb66xNk64qiVf25Vfnq+/fS/TLABTqgrv7Lvk7ilAKAmbzaJ+A5njwXwO
         oT8GyF/jJnbxUhvmF/uNik5dhXieCxI7PDmS3OZq0qp5FfkLNtdpQoM+66ET0fCfE0
         cM9Dc96azYq1e1lrFN6M8IWO9YeAMrbUkVxY8ePs=
Date:   Mon, 20 Mar 2023 14:21:01 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        konishi.ryusuke@gmail.com, hch@lst.de, agruenba@redhat.com,
        hughd@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + shmem-open-code-the-page-cache-lookup-in-shmem_get_folio_gfp-fix.patch added to mm-unstable branch
Message-Id: <20230320212102.5BE0DC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: shmem-open-code-the-page-cache-lookup-in-shmem_get_folio_gfp-fix
has been added to the -mm mm-unstable branch.  Its filename is
     shmem-open-code-the-page-cache-lookup-in-shmem_get_folio_gfp-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/shmem-open-code-the-page-cache-lookup-in-shmem_get_folio_gfp-fix.patch

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
From: Hugh Dickins <hughd@google.com>
Subject: shmem-open-code-the-page-cache-lookup-in-shmem_get_folio_gfp-fix
Date: Sun, 19 Mar 2023 22:23:36 -0700 (PDT)

Adjust the new comment line: shmem folio may have been swapped out.

Link: https://lkml.kernel.org/r/af178ebb-1076-a38c-1dc1-2a37ccce4a3@google.com
Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: Andreas Gruenbacher <agruenba@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/shmem.c~shmem-open-code-the-page-cache-lookup-in-shmem_get_folio_gfp-fix
+++ a/mm/shmem.c
@@ -1880,7 +1880,7 @@ repeat:
 	if (folio) {
 		folio_lock(folio);
 
-		/* Has the page been truncated? */
+		/* Has the folio been truncated or swapped out? */
 		if (unlikely(folio->mapping != mapping)) {
 			folio_unlock(folio);
 			folio_put(folio);
_

Patches currently in -mm which might be from hughd@google.com are

shmem-open-code-the-page-cache-lookup-in-shmem_get_folio_gfp-fix.patch

