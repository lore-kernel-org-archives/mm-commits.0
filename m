Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3927C07E9E
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:22:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D1FE861C9D
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:22:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229956AbhGFTZK (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 6 Jul 2021 15:25:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:58440 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230098AbhGFTZI (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 6 Jul 2021 15:25:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6B8F461C9E;
        Tue,  6 Jul 2021 19:22:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625599349;
        bh=lJC9qAF2AByMdNZWcBIOMkmb5bd29Eo8h5DJYffuDBM=;
        h=Date:From:To:Subject:From;
        b=qMDvPR119vlyNN89YNhC8exNMK1rHAbM3LbONFfLRKD3FUp+q3dtBOxYX4JqZlHoV
         nFomhqHko9tqBhF3GMi8oHAUsvoBwQf+OnjbmMJ/4JopNe/Ms9RbS+LUQA9p4Zusoe
         EncJdyxLwWddnyahuNXSDpLrBbwc9mFAZAmQprvs=
Date:   Tue, 06 Jul 2021 12:22:29 -0700
From:   akpm@linux-foundation.org
To:     andriy.shevchenko@linux.intel.com, bfields@fieldses.org,
        chuck.lever@oracle.com, mm-commits@vger.kernel.org,
        viro@zeniv.linux.org.uk
Subject:  [merged]
 nfsd-avoid-non-flexible-api-in-seq_quote_mem.patch removed from -mm tree
Message-ID: <20210706192229.uQ7U0bSgO%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: nfsd: avoid non-flexible API in seq_quote_mem()
has been removed from the -mm tree.  Its filename was
     nfsd-avoid-non-flexible-api-in-seq_quote_mem.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: nfsd: avoid non-flexible API in seq_quote_mem()

The seq_escape_mem_ascii() is completely non-flexible and shouldn't be
used.  Replace it with properly called seq_escape_mem().

Link: https://lkml.kernel.org/r/20210504180819.73127-15-andriy.shevchenko@linux.intel.com
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Chuck Lever <chuck.lever@oracle.com>
Cc: "J. Bruce Fields" <bfields@fieldses.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nfsd/nfs4state.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/nfsd/nfs4state.c~nfsd-avoid-non-flexible-api-in-seq_quote_mem
+++ a/fs/nfsd/nfs4state.c
@@ -2351,7 +2351,7 @@ static struct nfs4_client *get_nfsdfs_cl
 static void seq_quote_mem(struct seq_file *m, char *data, int len)
 {
 	seq_printf(m, "\"");
-	seq_escape_mem_ascii(m, data, len);
+	seq_escape_mem(m, data, len, ESCAPE_HEX | ESCAPE_NAP | ESCAPE_APPEND, "\"\\");
 	seq_printf(m, "\"");
 }
 
_

Patches currently in -mm which might be from andriy.shevchenko@linux.intel.com are


