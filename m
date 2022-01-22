Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26AA7C433F5
	for <mm-commits@archiver.kernel.org>; Sat, 22 Jan 2022 01:28:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231674AbiAVB2G (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 21 Jan 2022 20:28:06 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:38440 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230416AbiAVB2G (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 21 Jan 2022 20:28:06 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D2242B820D4
        for <mm-commits@vger.kernel.org>; Sat, 22 Jan 2022 01:28:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1885AC340E1;
        Sat, 22 Jan 2022 01:28:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642814883;
        bh=MYMXtdREdohctVFqfUkiCNUIoLFTz8y3CwZnv4q6Qwg=;
        h=Date:From:To:Subject:From;
        b=CkSqYjzKoQDar8knFykOLmo/7wHd4zsuGqeMlvNjY2iXrW/1t3+GGavJuNedqT2CC
         084WWsPxt4pV8qmS1KQ8huJ+vuKAKrzTrYcmJQKLMK+GnYctBpwQVa1SngQpw1QK17
         U7E4CveikV63W04CxFtmuGZ9MteHztrrsiN6GB/o=
Date:   Fri, 21 Jan 2022 17:28:02 -0800
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, ddstreet@ieee.org, geert@linux-m68k.org,
        hch@lst.de, hughd@google.com, jgross@suse.com,
        Konrad.wilk@oracle.com, mm-commits@vger.kernel.org,
        sjenning@redhat.com, vitaly.wool@konsulko.com, willy@infradead.org
Subject:  [folded-merged] mm-remove-cleancache-fix.patch removed
 from -mm tree
Message-ID: <20220122012802.5gB-4LPAF%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-remove-cleancache-fix
has been removed from the -mm tree.  Its filename was
     mm-remove-cleancache-fix.patch

This patch was dropped because it was folded into mm-remove-cleancache.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-remove-cleancache-fix

remove now-unreachable code

Cc: Christoph Hellwig <hch@lst.de>
Cc: Dan Streetman <ddstreet@ieee.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Juergen Gross <jgross@suse.com>
Cc: Konrad Rzeszutek Wilk <Konrad.wilk@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Seth Jennings <sjenning@redhat.com>
Cc: Vitaly Wool <vitaly.wool@konsulko.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/f2fs/data.c |    6 ------
 1 file changed, 6 deletions(-)

--- a/fs/f2fs/data.c~mm-remove-cleancache-fix
+++ a/fs/f2fs/data.c
@@ -2089,12 +2089,6 @@ submit_and_realloc:
 	ClearPageError(page);
 	*last_block_in_bio = block_nr;
 	goto out;
-confused:
-	if (bio) {
-		__submit_bio(F2FS_I_SB(inode), bio, DATA);
-		bio = NULL;
-	}
-	unlock_page(page);
 out:
 	*bio_ret = bio;
 	return ret;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-remove-cleancache.patch
mm-simplify-try_to_unuse-fix.patch
mm.patch
documentation-vm-page_ownerrst-update-the-documentation-fix.patch
mm-mempolicy-convert-from-atomic_t-to-refcount_t-on-mempolicy-refcnt-fix.patch
arch-x86-include-asm-pgtableh-needs-spinlockh.patch
mutex-subsystem-synchro-test-module-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

