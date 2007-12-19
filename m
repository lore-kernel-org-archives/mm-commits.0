From: akpm@linux-foundation.org
Subject: - mga_dma-return-err-not-just-zero-from-mga_do_cleanup_dma.patch removed from -mm tree
Date: Tue, 18 Dec 2007 18:20:46 -0800
Message-ID: <200712190220.lBJ2KkWf001308@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57316 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752467AbXLSCUs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 18 Dec 2007 21:20:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jesper.juhl@gmail.com, mm-commits@vger.kernel.org


The patch titled
     mga_dma: return 'err' not just zero from mga_do_cleanup_dma()
has been removed from the -mm tree.  Its filename was
     mga_dma-return-err-not-just-zero-from-mga_do_cleanup_dma.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: mga_dma: return 'err' not just zero from mga_do_cleanup_dma()
From: Jesper Juhl <jesper.juhl@gmail.com>

While reading some code I stumbled across the use of 'err' in
drivers/char/drm/mga_dma.c::mga_do_cleanup_dma() and I think there's a small
problem.

The variable is only used inside #if __OS_HAS_AGP which is fine, but all that
ever happens is an assignment to the variable - it is never actually used for
anything.  The variable is nicely initialized to zero which is also what the
return statement at the end of function returns (always at the moment).

It looks to me like that function should be returning 'err' instead of always
just returning 0.  Here's a patch to do that.

Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/drm/mga_dma.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/char/drm/mga_dma.c~mga_dma-return-err-not-just-zero-from-mga_do_cleanup_dma drivers/char/drm/mga_dma.c
--- a/drivers/char/drm/mga_dma.c~mga_dma-return-err-not-just-zero-from-mga_do_cleanup_dma
+++ a/drivers/char/drm/mga_dma.c
@@ -998,7 +998,7 @@ static int mga_do_cleanup_dma(struct drm
 		}
 	}
 
-	return 0;
+	return err;
 }
 
 int mga_dma_init(struct drm_device *dev, void *data,
_

Patches currently in -mm which might be from jesper.juhl@gmail.com are

git-drm.patch
mga_dma-return-err-not-just-zero-from-mga_do_cleanup_dma.patch
git-ubi.patch
