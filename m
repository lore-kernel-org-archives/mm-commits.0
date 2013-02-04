From: akpm@linux-foundation.org
Subject: [merged] digsig-fix-memory-leakage-in-digsig_verify_rsa.patch removed from -mm tree
Date: Mon, 04 Feb 2013 12:31:03 -0800
Message-ID: <20130204203103.891265A40F3@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f202.google.com ([209.85.160.202]:52869 "EHLO
	mail-gh0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755014Ab3BDUbF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Feb 2013 15:31:05 -0500
Received: by mail-gh0-f202.google.com with SMTP id z10so743067ghb.5
        for <mm-commits@vger.kernel.org>; Mon, 04 Feb 2013 12:31:04 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yoshfuji@linux-ipv6.org, dmitry.kasatkin@intel.com, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: digsig: fix memory leakage in digsig_verify_rsa()
has been removed from the -mm tree.  Its filename was
     digsig-fix-memory-leakage-in-digsig_verify_rsa.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>
Subject: digsig: fix memory leakage in digsig_verify_rsa()

digsig_verify_rsa() does not free kmalloc'ed buffer returned by
mpi_get_buffer().

Signed-off-by: YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>
Signed-off-by: Dmitry Kasatkin <dmitry.kasatkin@intel.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/digsig.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN lib/digsig.c~digsig-fix-memory-leakage-in-digsig_verify_rsa lib/digsig.c
--- a/lib/digsig.c~digsig-fix-memory-leakage-in-digsig_verify_rsa
+++ a/lib/digsig.c
@@ -162,6 +162,8 @@ static int digsig_verify_rsa(struct key 
 	memset(out1, 0, head);
 	memcpy(out1 + head, p, l);
 
+	kfree(p);
+
 	err = pkcs_1_v1_5_decode_emsa(out1, len, mblen, out2, &len);
 	if (err)
 		goto err;
_

Patches currently in -mm which might be from yoshfuji@linux-ipv6.org are

origin.patch
linux-next.patch

