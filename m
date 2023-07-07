Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DAAACEB64D9
	for <mm-commits@archiver.kernel.org>; Fri,  7 Jul 2023 18:56:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229663AbjGGS4o (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 7 Jul 2023 14:56:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229542AbjGGS4n (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 7 Jul 2023 14:56:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74141AC
        for <mm-commits@vger.kernel.org>; Fri,  7 Jul 2023 11:56:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 06BD361A1D
        for <mm-commits@vger.kernel.org>; Fri,  7 Jul 2023 18:56:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5196AC433C7;
        Fri,  7 Jul 2023 18:56:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1688756201;
        bh=m6R1yHj+2zFsWk7JlzqyA61T5djoxZ4SxlUZKqAMsuc=;
        h=Date:To:From:Subject:From;
        b=mG+kaUrYftVl7AmtHOSOpHR8f2delWBz6SV+mT243sfzLChUEXbXcClXO/pwGAEJD
         4W7SkRWzcZwYQCDLx3COijSrRmF+bhZ2sV52txUjaFkI9knD15VR7cqzFzwDYDvz4V
         3BF0SUPuAojc9DytP4wl7+RBM/xfkc9CQ+L7U9LU=
Date:   Fri, 07 Jul 2023 11:56:40 -0700
To:     mm-commits@vger.kernel.org, xiubli@redhat.com, willy@infradead.org,
        tytso@mit.edu, torvalds@linux-foundation.org, sfrench@samba.org,
        rohiths.msft@gmail.com, nspmangalore@gmail.com,
        jefflexu@linux.alibaba.com, idryomov@gmail.com,
        dhowells@redhat.com, daire.byrne@gmail.com, asmadeus@codewreck.org,
        adilger.kernel@dilger.ca, dwysocha@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-netfs-fscache-stop-read-optimisation-when-folio-removed-from-pagecache-fix.patch added to mm-nonmm-unstable branch
Message-Id: <20230707185641.5196AC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: call folio_mapping() inside folio_needs_release()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     mm-netfs-fscache-stop-read-optimisation-when-folio-removed-from-pagecache-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-netfs-fscache-stop-read-optimisation-when-folio-removed-from-pagecache-fix.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: Dave Wysochanski <dwysocha@redhat.com>
Subject: mm: call folio_mapping() inside folio_needs_release()
Date: Fri Jul  7 11:54:53 AM PDT 2023

We must call folio_mapping() inside folio_needs_release() or we will end
up oopsing on an anon page as follows:

 RIP: 0010:filemap_release_folio+0x69/0x80
 Code: 75 95 00 5d e9 58 7c 95 00 48 85 d2 74 f5 48 8b 8a 98 00 00 00 84 c9 79 ea 48 8b 0f 31 c0 80 e5 80 75 e0 48 8b 82 90 00 00 00 <48> 8b 40 48 48 85 c0 75 cb e8 19 69 15  00 5d e9 23 7c 95 00 0f 0b
 RSP: 0018:ffffa89c4057b980 EFLAGS: 00010246
 RAX: 0500000001251880 RBX: ffffa89c4057baa8 RCX: 0017ffffc0080005
 RDX: ffff90c709bd3f71 RSI: 0000000000000cc0 RDI: ffffebcf45a6e800
 RBP: ffffa89c4057b980 R08: ffff90c707f800c0 R09: ffffebcf45a6e808
 R10: 0000000000000000 R11: 000000000000000c R12: ffffebcf45a6e800
 R13: ffffa89c4057ba08 R14: ffffebcf45a6e808 R15: ffffa89c4057bdb0
 FS:  0000000000000000(0000) GS:ffff91443fdc0000(0000) knlGS:0000000000000000
 CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
 CR2: 00007f4472634000 CR3: 0000000103d8a000 CR4: 0000000000350ee0
 Call Trace:
  <TASK>
  shrink_folio_list+0x746/0xc80
  evict_folios+0x272/0x5f0
  try_to_shrink_lruvec+0x1f1/0x2d0
  shrink_one+0x13b/0x1b0
  lru_gen_shrink_node+0x1ee/0x3e0
  shrink_node+0x68d/0x730
  balance_pgdat+0x41e/0x8c0
  kswapd+0x1f4/0x3b0
  kthread+0xf9/0x130
  ret_from_fork+0x2c/0x50
  </TASK>

Link: https://github.com/DaveWysochanskiRH/kernel/commit/902c990e311120179fa5de99d68364b2947b79ec
Signed-off-by: Dave Wysochanski <dwysocha@redhat.com>
Reported-by: Daire Byrne <daire.byrne@gmail.com>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>
Cc: Dave Wysochanski <dwysocha@redhat.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Dominique Martinet <asmadeus@codewreck.org>
Cc: Ilya Dryomov <idryomov@gmail.com>
Cc: Jingbo Xu <jefflexu@linux.alibaba.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Rohith Surabattula <rohiths.msft@gmail.com>
Cc: Shyam Prasad N <nspmangalore@gmail.com>
Cc: Steve French <sfrench@samba.org>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: Xiubo Li <xiubli@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/internal.h~mm-netfs-fscache-stop-read-optimisation-when-folio-removed-from-pagecache-fix
+++ a/mm/internal.h
@@ -181,7 +181,7 @@ static inline void set_page_refcounted(s
  */
 static inline bool folio_needs_release(struct folio *folio)
 {
-	struct address_space *mapping = folio->mapping;
+	struct address_space *mapping = folio_mapping(folio);
 
 	return folio_has_private(folio) ||
 		(mapping && mapping_release_always(mapping));
_

Patches currently in -mm which might be from dwysocha@redhat.com are

mm-netfs-fscache-stop-read-optimisation-when-folio-removed-from-pagecache-fix.patch

