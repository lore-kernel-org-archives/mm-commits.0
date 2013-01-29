From: akpm@linux-foundation.org
Subject: + digsig-fix-memory-leakage-in-digsig_verify_rsa.patch added to -mm tree
Date: Mon, 28 Jan 2013 16:24:15 -0800
Message-ID: <20130129002415.A73C931C25A@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-oa0-f74.google.com ([209.85.219.74]:53231 "EHLO
	mail-oa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753419Ab3A2AYR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 28 Jan 2013 19:24:17 -0500
Received: by mail-oa0-f74.google.com with SMTP id h2so710349oag.5
        for <mm-commits@vger.kernel.org>; Mon, 28 Jan 2013 16:24:16 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: yoshfuji@linux-ipv6.org, dmitry.kasatkin@intel.com, stable@vger.kernel.org


The patch titled
     Subject: digsig: fix memory leakage in digsig_verify_rsa()
has been added to the -mm tree.  Its filename is
     digsig-fix-memory-leakage-in-digsig_verify_rsa.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

linux-next.patch
digsig-fix-memory-leakage-in-digsig_verify_rsa.patch

