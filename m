Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2770ECAAA1
	for <mm-commits@archiver.kernel.org>; Mon, 12 Sep 2022 04:58:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229584AbiILE6k (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 12 Sep 2022 00:58:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229703AbiILE5G (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 12 Sep 2022 00:57:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C5CC2872A
        for <mm-commits@vger.kernel.org>; Sun, 11 Sep 2022 21:57:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 97B1960EFD
        for <mm-commits@vger.kernel.org>; Mon, 12 Sep 2022 04:57:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0EEDC433C1;
        Mon, 12 Sep 2022 04:57:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662958624;
        bh=NZCbDZklLQcYWpU07eh2BEFq2lbBGYLjUN3bF6ljWMI=;
        h=Date:To:From:Subject:From;
        b=cgbHA6W5HiLxLMjcRWfO354Y2kNG3lK7jJrcXGl4PDnxHi3TniTGswvEGQA11u/Up
         fG0xkzSVv7gW/fI5HPC13Zs2yEGT42A8JqELZwdhGtD6ouK8uX3nGQ3UTinHMBplKA
         3QcvBdR6HT3nOhEzlW3x8w7/8S0G55XiNyL5jh0Y=
Date:   Sun, 11 Sep 2022 21:57:03 -0700
To:     mm-commits@vger.kernel.org, kbusch@kernel.org, arnd@arndb.de,
        andriy.shevchenko@linux.intel.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] asm-generic-make-parameter-types-consisten-in-_unaligned_be48.patch removed from -mm tree
Message-Id: <20220912045703.F0EEDC433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: asm-generic: make parameter types consistent in _unaligned_be48()
has been removed from the -mm tree.  Its filename was
     asm-generic-make-parameter-types-consisten-in-_unaligned_be48.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: asm-generic: make parameter types consistent in _unaligned_be48()
Date: Tue, 30 Aug 2022 20:27:13 +0300

There is a convention to use internal kernel types, so replace __u8 by u8.

Link: https://lkml.kernel.org/r/20220830172713.43686-1-andriy.shevchenko@linux.intel.com
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: Keith Busch <kbusch@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/unaligned.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/asm-generic/unaligned.h~asm-generic-make-parameter-types-consisten-in-_unaligned_be48
+++ a/include/asm-generic/unaligned.h
@@ -126,7 +126,7 @@ static inline void put_unaligned_le24(co
 	__put_unaligned_le24(val, p);
 }
 
-static inline void __put_unaligned_be48(const u64 val, __u8 *p)
+static inline void __put_unaligned_be48(const u64 val, u8 *p)
 {
 	*p++ = val >> 40;
 	*p++ = val >> 32;
_

Patches currently in -mm which might be from andriy.shevchenko@linux.intel.com are


