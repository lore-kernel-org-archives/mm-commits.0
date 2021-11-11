Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9D6AC433EF
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:43:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B433561284
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:43:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234266AbhKKCqb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 10 Nov 2021 21:46:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:51674 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234240AbhKKCqa (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Nov 2021 21:46:30 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7873660F46;
        Thu, 11 Nov 2021 02:43:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636598622;
        bh=DgJAYXn8A2ftPspEZXvg12InTuXz8CYo2LdbAdex5Pw=;
        h=Date:From:To:Subject:From;
        b=CNHxxltJxOIZ7w3kTcn49jFKVO4mj8dUjOTKd1w8H1bS3PgiJJ/Xzi+Hul2Qt0Akd
         WXBqP/5JcIF7/z4mnvyPn23SP9k8JMUNFurV0yD3ojl0F5SPB8SFan6p+MOyV+kluy
         3LR3GR/aeAQYbD2uCYnzwlJSmo0ET2vKfeGx6RoI=
Date:   Wed, 10 Nov 2021 18:43:42 -0800
From:   akpm@linux-foundation.org
To:     deng.changcheng@zte.com.cn, mm-commits@vger.kernel.org,
        urezki@gmail.com, zealci@zte.com.cn
Subject:  [merged]
 lib-test_vmallocc-use-swap-to-make-code-cleaner.patch removed from -mm tree
Message-ID: <20211111024342.FjNOdU7hn%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib/test_vmalloc.c: use swap() to make code cleaner
has been removed from the -mm tree.  Its filename was
     lib-test_vmallocc-use-swap-to-make-code-cleaner.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


