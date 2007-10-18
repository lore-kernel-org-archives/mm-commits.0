From: akpm@linux-foundation.org
Subject: - delete-gcc-295-compatible-structure-definition.patch removed from -mm tree
Date: Thu, 18 Oct 2007 00:00:47 -0700
Message-ID: <200710180700.l9I70lCs031113@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40662 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760140AbXJRHP3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 03:15:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rpjday@mindspring.com, mm-commits@vger.kernel.org


The patch titled
     Delete gcc-2.95 compatible structure definition.
has been removed from the -mm tree.  Its filename was
     delete-gcc-295-compatible-structure-definition.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Delete gcc-2.95 compatible structure definition.
From: "Robert P. J. Day" <rpjday@mindspring.com>

Since nothing earlier than gcc-3.2 is supported for kernel
compilation, that 2.95 hack can be removed.

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN mm/slab.c~delete-gcc-295-compatible-structure-definition mm/slab.c
--- a/mm/slab.c~delete-gcc-295-compatible-structure-definition
+++ a/mm/slab.c
@@ -267,11 +267,10 @@ struct array_cache {
 	unsigned int batchcount;
 	unsigned int touched;
 	spinlock_t lock;
-	void *entry[0];	/*
+	void *entry[];	/*
 			 * Must have this definition in here for the proper
 			 * alignment of array_cache. Also simplifies accessing
 			 * the entries.
-			 * [0] is for gcc 2.95. It should really be [].
 			 */
 };
 
_

Patches currently in -mm which might be from rpjday@mindspring.com are

origin.patch
git-kvm.patch
pcmcia-delete-obsolete-pcmcia_ioctl-feature.patch
