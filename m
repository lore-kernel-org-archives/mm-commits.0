Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 018C7C433F5
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:39:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DDF7961262
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:39:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232269AbhKEUmi (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 5 Nov 2021 16:42:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:37332 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233489AbhKEUmh (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Nov 2021 16:42:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2E145611C0;
        Fri,  5 Nov 2021 20:39:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636144797;
        bh=qp1GkC5rhtav/0WU3qrAq2fB/epoumgn+EcvJW6QSz0=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=YxnMr26d7GE2uJ2wBmpatyUv6NoqV5pUjsh9mNl6o1oqkfBVFtkV1TjwOeMRCD7/S
         Wq8d5fqoHOiJMoxWpUgFHNhexMMEYshNeT/7k9p7zBOHNo6o/6ubgqTgE0ooECUa5H
         s1Evxyd17d5Cvpyi+aZtWcpDJMWeHEbyYi6Fwh3Y=
Date:   Fri, 05 Nov 2021 13:39:56 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, deng.changcheng@zte.com.cn,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, urezki@gmail.com, zealci@zte.com.cn
Subject:  [patch 101/262] lib/test_vmalloc.c: use swap() to make
 code cleaner
Message-ID: <20211105203956.bvvtKSnFq%akpm@linux-foundation.org>
In-Reply-To: <20211105133408.cccbb98b71a77d5e8430aba1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
