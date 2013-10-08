From: akpm@linux-foundation.org
Subject: +
 lib-digsigc-use-err_cast-inlined-function-instead-of-err_ptrptr_err.patch
 added to -mm tree
Date: Mon, 07 Oct 2013 18:11:06 -0700
Message-ID: <52535baa.g/wFT7BoJjim7HsL%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35618 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751534Ab3JHBLH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Oct 2013 21:11:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, james.l.morris@oracle.com, duanj.fnst@cn.fujitsu.com

Subject: + lib-digsigc-use-err_cast-inlined-function-instead-of-err_ptrptr_err.patch added to -mm tree
To: duanj.fnst@cn.fujitsu.com,james.l.morris@oracle.com
From: akpm@linux-foundation.org
Date: Mon, 07 Oct 2013 18:11:06 -0700


The patch titled
     Subject: lib/digsig.c: use ERR_CAST inlined function instead of ERR_PTR(PTR_ERR(...))
has been added to the -mm tree.  Its filename is
     lib-digsigc-use-err_cast-inlined-function-instead-of-err_ptrptr_err.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-digsigc-use-err_cast-inlined-function-instead-of-err_ptrptr_err.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-digsigc-use-err_cast-inlined-function-instead-of-err_ptrptr_err.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Duan Jiong <duanj.fnst@cn.fujitsu.com>
Subject: lib/digsig.c: use ERR_CAST inlined function instead of ERR_PTR(PTR_ERR(...))

Signed-off-by: Duan Jiong <duanj.fnst@cn.fujitsu.com>
Cc: James Morris <james.l.morris@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/digsig.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN lib/digsig.c~lib-digsigc-use-err_cast-inlined-function-instead-of-err_ptrptr_err lib/digsig.c
--- a/lib/digsig.c~lib-digsigc-use-err_cast-inlined-function-instead-of-err_ptrptr_err
+++ a/lib/digsig.c
@@ -209,7 +209,7 @@ int digsig_verify(struct key *keyring, c
 		kref = keyring_search(make_key_ref(keyring, 1UL),
 						&key_type_user, name);
 		if (IS_ERR(kref))
-			key = ERR_PTR(PTR_ERR(kref));
+			key = ERR_CAST(kref);
 		else
 			key = key_ref_to_ptr(kref);
 	} else {
_

Patches currently in -mm which might be from duanj.fnst@cn.fujitsu.com are

lib-digsigc-use-err_cast-inlined-function-instead-of-err_ptrptr_err.patch
linux-next.patch

