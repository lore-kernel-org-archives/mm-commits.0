Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3409C433B4
	for <mm-commits@archiver.kernel.org>; Sun,  9 May 2021 03:48:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BA94461430
	for <mm-commits@archiver.kernel.org>; Sun,  9 May 2021 03:48:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229615AbhEIDuA (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 May 2021 23:50:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:48578 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229591AbhEIDuA (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 8 May 2021 23:50:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A012961421;
        Sun,  9 May 2021 03:48:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620532137;
        bh=OnMFvsgZvFQAmRejhRr87VKiBtN0QW+VugzmLuvQCFo=;
        h=Date:From:To:Subject:From;
        b=rdYLFEdY7LqtejuD3JPk2go5Zrz9J1I2vQSfMlsUpDJMqWDysR2GZMZnwy3l2yomr
         BFO5G04W7BMvKfbw+A9ntMG9ujLnaKG77moYf51jkJkD9KZESpXAb0Oi6dNQKD0s6u
         ys5fsqeBFYiFUZ98hDHkQG+40mnYzFgkTQuqpxRA=
Date:   Sat, 08 May 2021 20:48:57 -0700
From:   akpm@linux-foundation.org
To:     andriy.shevchenko@linux.intel.com, bfields@fieldses.org,
        chuck.lever@oracle.com, mm-commits@vger.kernel.org,
        viro@zeniv.linux.org.uk
Subject:  + nfsd-avoid-non-flexible-api-in-seq_quote_mem.patch
 added to -mm tree
Message-ID: <20210509034857.aU9orZylE%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: nfsd: avoid non-flexible API in seq_quote_mem()
has been added to the -mm tree.  Its filename is
     nfsd-avoid-non-flexible-api-in-seq_quote_mem.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/nfsd-avoid-non-flexible-api-in-seq_quote_mem.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/nfsd-avoid-non-flexible-api-in-seq_quote_mem.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

lib-string_helpers-switch-to-use-bit-macro.patch
lib-string_helpers-move-escape_np-check-inside-else-branch-in-a-loop.patch
lib-string_helpers-drop-indentation-level-in-string_escape_mem.patch
lib-string_helpers-introduce-escape_na-for-escaping-non-ascii.patch
lib-string_helpers-introduce-escape_nap-to-escape-non-ascii-and-non-printable.patch
lib-string_helpers-allow-to-append-additional-characters-to-be-escaped.patch
lib-test-string_helpers-print-flags-in-hexadecimal-format.patch
lib-test-string_helpers-get-rid-of-trailing-comma-in-terminators.patch
lib-test-string_helpers-add-test-cases-for-new-features.patch
maintainers-add-myself-as-designated-reviewer-for-generic-string-library.patch
seq_file-introduce-seq_escape_mem.patch
seq_file-add-seq_escape_str-as-replica-of-string_escape_str.patch
seq_file-convert-seq_escape-to-use-seq_escape_str.patch
nfsd-avoid-non-flexible-api-in-seq_quote_mem.patch
seq_file-drop-unused-_escape_mem_ascii.patch

