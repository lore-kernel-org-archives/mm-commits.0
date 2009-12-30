From: akpm@linux-foundation.org
Subject: + kernel-credc-use-kmem_cache_free.patch added to -mm tree
Date: Wed, 30 Dec 2009 13:20:10 -0800
Message-ID: <200912302120.nBULKAGR002889@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45475 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752702AbZL3VVI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Dec 2009 16:21:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: julia@diku.dk, dhowells@redhat.com, jmorris@namei.org, stable@kernel.org, steved@redhat.com


The patch titled
     kernel/cred.c: use kmem_cache_free
has been added to the -mm tree.  Its filename is
     kernel-credc-use-kmem_cache_free.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kernel/cred.c: use kmem_cache_free
From: Julia Lawall <julia@diku.dk>

Free memory allocated using kmem_cache_zalloc using kmem_cache_free rather
than kfree.

The semantic patch that makes this change is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
expression x,E,c;
@@

 x = \(kmem_cache_alloc\|kmem_cache_zalloc\|kmem_cache_alloc_node\)(c,...)
 ... when != x = E
     when != &x
?-kfree(x)
+kmem_cache_free(c,x)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
Cc: David Howells <dhowells@redhat.com>
Cc: James Morris <jmorris@namei.org>
Cc: Steve Dickson <steved@redhat.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cred.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/cred.c~kernel-credc-use-kmem_cache_free kernel/cred.c
--- a/kernel/cred.c~kernel-credc-use-kmem_cache_free
+++ a/kernel/cred.c
@@ -224,7 +224,7 @@ struct cred *cred_alloc_blank(void)
 #ifdef CONFIG_KEYS
 	new->tgcred = kzalloc(sizeof(*new->tgcred), GFP_KERNEL);
 	if (!new->tgcred) {
-		kfree(new);
+		kmem_cache_free(cred_jar, new);
 		return NULL;
 	}
 	atomic_set(&new->tgcred->usage, 1);
_

Patches currently in -mm which might be from julia@diku.dk are

linux-next.patch
drivers-scsi-sesc-eliminate-double-free.patch
kernel-credc-use-kmem_cache_free.patch
drivers-media-video-move-dereference-after-null-test.patch
arch-mips-alchemy-correct-code-taking-the-size-of-a-pointer.patch
drivers-isdn-eliminate-duplicated-test.patch
drivers-scsi-libsas-use-sam_good.patch
drivers-scsi-remove-unnecessary-null-test.patch
drivers-message-move-dereference-after-null-test.patch
drivers-edac-introduce-missing-kfree.patch

