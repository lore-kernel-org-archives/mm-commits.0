Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A7C5C433EF
	for <mm-commits@archiver.kernel.org>; Thu, 28 Oct 2021 19:35:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4014261107
	for <mm-commits@archiver.kernel.org>; Thu, 28 Oct 2021 19:35:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230412AbhJ1Th5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 28 Oct 2021 15:37:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:43414 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230104AbhJ1Thz (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 28 Oct 2021 15:37:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A9048610FF;
        Thu, 28 Oct 2021 19:35:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1635449727;
        bh=qvaSQoEbZZ9r3JIjsWxaTzc5O7OWCvasI5D+lCbEvRw=;
        h=Date:From:To:Subject:From;
        b=CI9gdYGtiLacW4GHRF10IhPioQ4U+527EKh06f3CjypWfME1jNCE/wuGtbDLUlFhW
         amgVBIRwCFJrZjlQNMd0QWoqvCiW9gIi3NZgOZWksC/ApkEWSbzrrrN24PcDTWY4lX
         1uifn6GG2USe1KWj1eMAJKJl1JcJdwkZiqy+uu6E=
Date:   Thu, 28 Oct 2021 12:35:27 -0700
From:   akpm@linux-foundation.org
To:     deng.changcheng@zte.com.cn, mm-commits@vger.kernel.org,
        urezki@gmail.com, zealci@zte.com.cn
Subject:  + lib-test_vmallocc-use-swap-to-make-code-cleaner.patch
 added to -mm tree
Message-ID: <20211028193527.NAmqSqk0s%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib/test_vmalloc.c: use swap() to make code cleaner
has been added to the -mm tree.  Its filename is
     lib-test_vmallocc-use-swap-to-make-code-cleaner.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/lib-test_vmallocc-use-swap-to-make-code-cleaner.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/lib-test_vmallocc-use-swap-to-make-code-cleaner.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Changcheng Deng <deng.changcheng@zte.com.cn>
Subject: lib/test_vmalloc.c: use swap() to make code cleaner

Use swap() in order to make code cleaner. Issue found by coccinelle.

Link: https://lkml.kernel.org/r/20211028111443.15744-1-deng.changcheng@zte.com.cn
Signed-off-by: Changcheng Deng <deng.changcheng@zte.com.cn>
Reported-by: Zeal Robot <zealci@zte.com.cn>
Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_vmalloc.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/lib/test_vmalloc.c~lib-test_vmallocc-use-swap-to-make-code-cleaner
+++ a/lib/test_vmalloc.c
@@ -393,7 +393,7 @@ static struct test_driver {
 static void shuffle_array(int *arr, int n)
 {
 	unsigned int rnd;
-	int i, j, x;
+	int i, j;
 
 	for (i = n - 1; i > 0; i--)  {
 		get_random_bytes(&rnd, sizeof(rnd));
@@ -402,9 +402,7 @@ static void shuffle_array(int *arr, int
 		j = rnd % i;
 
 		/* Swap indexes. */
-		x = arr[i];
-		arr[i] = arr[j];
-		arr[j] = x;
+		swap(arr[i], arr[j]);
 	}
 }
 
_

Patches currently in -mm which might be from deng.changcheng@zte.com.cn are

lib-test_vmallocc-use-swap-to-make-code-cleaner.patch

