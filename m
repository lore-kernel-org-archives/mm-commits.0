From: akpm@linux-foundation.org
Subject: - char-vt-use-kzalloc.patch removed from -mm tree
Date: Tue, 17 Jul 2007 16:06:28 -0700
Message-ID: <200707172306.l6HN6Srs012018@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48785 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765263AbXGQXPb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 17 Jul 2007 19:15:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, alan@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Char: vt, use kzalloc
has been removed from the -mm tree.  Its filename was
     char-vt-use-kzalloc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Char: vt, use kzalloc
From: Jiri Slaby <jirislaby@gmail.com>

vt, use kzalloc

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Acked-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/vt.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN drivers/char/vt.c~char-vt-use-kzalloc drivers/char/vt.c
--- a/drivers/char/vt.c~char-vt-use-kzalloc
+++ a/drivers/char/vt.c
@@ -729,10 +729,9 @@ int vc_allocate(unsigned int currcons)	/
 	    /* although the numbers above are not valid since long ago, the
 	       point is still up-to-date and the comment still has its value
 	       even if only as a historical artifact.  --mj, July 1998 */
-	    vc = kmalloc(sizeof(struct vc_data), GFP_KERNEL);
+	    vc = kzalloc(sizeof(struct vc_data), GFP_KERNEL);
 	    if (!vc)
 		return -ENOMEM;
-	    memset(vc, 0, sizeof(*vc));
 	    vc_cons[currcons].d = vc;
 	    INIT_WORK(&vc_cons[currcons].SAK_work, vc_SAK);
 	    visual_init(vc, currcons, 1);
_

Patches currently in -mm which might be from jirislaby@gmail.com are

origin.patch
some-kmalloc-memset-kzalloc-tree-wide.patch
shrink_slab-handle-bad-shrinkers.patch
