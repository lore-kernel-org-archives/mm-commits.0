From: akpm@linux-foundation.org
Subject: [merged] uuid-use-prandom_bytes.patch removed from -mm tree
Date: Tue, 30 Apr 2013 12:02:20 -0700
Message-ID: <20130430190220.75C1931C27C@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f74.google.com ([209.85.213.74]:33118 "EHLO
	mail-yh0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933531Ab3D3TCV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 15:02:21 -0400
Received: by mail-yh0-f74.google.com with SMTP id z12so87350yhz.1
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 12:02:21 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, tytso@mit.edu, ying.huang@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: uuid: use prandom_bytes()
has been removed from the -mm tree.  Its filename was
     uuid-use-prandom_bytes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: uuid: use prandom_bytes()

Use prandom_bytes() to generate 16 bytes of pseudo-random bytes.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: Huang Ying <ying.huang@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/uuid.c |    8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff -puN lib/uuid.c~uuid-use-prandom_bytes lib/uuid.c
--- a/lib/uuid.c~uuid-use-prandom_bytes
+++ a/lib/uuid.c
@@ -25,13 +25,7 @@
 
 static void __uuid_gen_common(__u8 b[16])
 {
-	int i;
-	u32 r;
