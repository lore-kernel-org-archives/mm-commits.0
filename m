From: akpm@linux-foundation.org
Subject: + reregister_binfmt-returns-with-ebusy.patch added to -mm tree
Date: Mon, 02 Apr 2007 17:39:54 -0700
Message-ID: <200704030039.l330dsLh013756@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:55142 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966131AbXDCAj5 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 2 Apr 2007 20:39:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kalash.nainwal@gmail.com


The patch titled
     (re)register_binfmt returns with -EBUSY
has been added to the -mm tree.  Its filename is
     reregister_binfmt-returns-with-ebusy.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
 1 files changed, 1 insertion(+)

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

reregister_binfmt-returns-with-ebusy.patch
