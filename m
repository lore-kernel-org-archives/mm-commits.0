From: akpm@linux-foundation.org
Subject: [merged] raid6test-use-prandom_bytes.patch removed from -mm tree
Date: Tue, 30 Apr 2013 12:02:17 -0700
Message-ID: <20130430190217.7700A31C27C@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ve0-f202.google.com ([209.85.128.202]:54781 "EHLO
	mail-ve0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932638Ab3D3TCS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 15:02:18 -0400
Received: by mail-ve0-f202.google.com with SMTP id ox1so78098veb.1
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 12:02:18 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, djbw@fb.com, vinod.koul@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: raid6test: use prandom_bytes()
has been removed from the -mm tree.  Its filename was
     raid6test-use-prandom_bytes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: raid6test: use prandom_bytes()

Use prandom_bytes() to generate random bytes for test data.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Dan Williams <djbw@fb.com>
Cc: Vinod Koul <vinod.koul@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 crypto/async_tx/raid6test.c |    9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff -puN crypto/async_tx/raid6test.c~raid6test-use-prandom_bytes crypto/async_tx/raid6test.c
--- a/crypto/async_tx/raid6test.c~raid6test-use-prandom_bytes
+++ a/crypto/async_tx/raid6test.c
@@ -46,15 +46,10 @@ static void callback(void *param)
 
 static void makedata(int disks)
 {
-	int i, j;
+	int i;
 
 	for (i = 0; i < disks; i++) {
-		for (j = 0; j < PAGE_SIZE/sizeof(u32); j += sizeof(u32)) {
-			u32 *p = page_address(data[i]) + j;
-
-			*p = random32();
-		}
