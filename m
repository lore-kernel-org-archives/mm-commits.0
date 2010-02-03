From: akpm@linux-foundation.org
Subject: [merged] kernel-credc-use-kmem_cache_free.patch removed from -mm tree
Date: Wed, 03 Feb 2010 09:55:23 -0800
Message-ID: <201002031755.o13HtNHG008980@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47736 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932806Ab0BCR4o (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Feb 2010 12:56:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: julia@diku.dk, dhowells@redhat.com, jmorris@namei.org, stable@kernel.org, steved@redhat.com, mm-commits@vger.kernel.org


The patch titled
     kernel/cred.c: use kmem_cache_free
has been removed from the -mm tree.  Its filename was
     kernel-credc-use-kmem_cache_free.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
Acked-by: David Howells <dhowells@redhat.com>
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

origin.patch
linux-next.patch
drivers-scsi-sesc-eliminate-double-free.patch
arch-arm-plat-pxa-dmac-correct-null-test.patch
drivers-gpu-drm-nouveau-nouveau_grctxc-correct-null-test.patch
drivers-media-video-move-dereference-after-null-test.patch
net-ipv4-correct-the-size-argument-to-kzalloc.patch
drivers-scsi-libsas-use-sam_good.patch
drivers-scsi-remove-unnecessary-null-test.patch
drivers-message-move-dereference-after-null-test.patch
drivers-scsi-correct-the-size-argument-to-kmalloc.patch
drivers-scsi-bfa-bfad_imc-eliminate-useless-code.patch
drivers-staging-tm6000-tm6000-videoc-correct-null-test.patch
drivers-misc-iwmc3200top-mainc-eliminate-useless-code.patch
rtc-at91sam9-correct-size-given-to-memset.patch
drivers-edac-introduce-missing-kfree.patch
drivers-char-mmtimerc-eliminate-useless-code.patch

