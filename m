From: akpm@linux-foundation.org
Subject: - reregister_binfmt-returns-with-ebusy.patch removed from -mm tree
Date: Tue, 08 May 2007 19:48:38 -0700
Message-ID: <200705090248.l492mctP009134@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:43373 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755318AbXEICsm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 22:48:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kalash.nainwal@gmail.com, mm-commits@vger.kernel.org


The patch titled
     (re)register_binfmt returns with -EBUSY
has been removed from the -mm tree.  Its filename was
     reregister_binfmt-returns-with-ebusy.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: (re)register_binfmt returns with -EBUSY
From: "kalash nainwal" <kalash.nainwal@gmail.com>

When a binary format is unregistered and re-registered, register_binfmt
fails with -EBUSY.  The reason is that unregister_binfmt does not set
fmt->next to NULL, and seeing (fmt->next != NULL), register_binfmt fails
with -EBUSY.

One can find his way around by explicitly setting fmt->next to NULL after
unregistering, but that is kind of unclean (one should better be using only
the interfaces, and not the interal members, isn't it?)

Attached one-liner can fix it.

Signed-off-by: Kalash Nainwal <kalash.nainwal@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/exec.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN fs/exec.c~reregister_binfmt-returns-with-ebusy fs/exec.c
--- a/fs/exec.c~reregister_binfmt-returns-with-ebusy
+++ a/fs/exec.c
@@ -100,6 +100,7 @@ int unregister_binfmt(struct linux_binfm
 	while (*tmp) {
 		if (fmt == *tmp) {
 			*tmp = fmt->next;
+			fmt->next = NULL;
 			write_unlock(&binfmt_lock);
 			return 0;
 		}
_

Patches currently in -mm which might be from kalash.nainwal@gmail.com are

origin.patch
