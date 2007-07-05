From: akpm@linux-foundation.org
Subject: + isapnp-remove-pointless-check-of-type-against-0-in-isapnp_read_tag.patch added to -mm tree
Date: Thu, 05 Jul 2007 14:26:50 -0700
Message-ID: <200707052126.l65LQo2f020580@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35179 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759782AbXGEV05 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jul 2007 17:26:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jesper.juhl@gmail.com


The patch titled
     isapnp: remove pointless check of 'type' against 0 in isapnp_read_tag()
has been added to the -mm tree.  Its filename is
     isapnp-remove-pointless-check-of-type-against-0-in-isapnp_read_tag.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: isapnp: remove pointless check of 'type' against 0 in isapnp_read_tag()
From: Jesper Juhl <jesper.juhl@gmail.com>

In drivers/pnp/isapnp/core.c::isapnp_read_tag() there is a test of 'type'
being == 0 a bit down in the function.  That test doesn't make any sense. 
If 'type' could indeed be NULL, then the test happens way too late as we'd
already have tried to dereference the pointer earlier and looking at the
callers it also turns out that there is no way type can ever actually be
NULL.

So the test is completely pointless and should just be removed.

Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pnp/isapnp/core.c |    2 --
 1 files changed, 2 deletions(-)

diff -puN drivers/pnp/isapnp/core.c~isapnp-remove-pointless-check-of-type-against-0-in-isapnp_read_tag drivers/pnp/isapnp/core.c
--- a/drivers/pnp/isapnp/core.c~isapnp-remove-pointless-check-of-type-against-0-in-isapnp_read_tag
+++ a/drivers/pnp/isapnp/core.c
@@ -370,8 +370,6 @@ static int __init isapnp_read_tag(unsign
 #if 0
 	printk(KERN_DEBUG "tag = 0x%x, type = 0x%x, size = %i\n", tag, *type, *size);
 #endif
-	if (type == 0)				/* wrong type */
-		return -1;
 	if (*type == 0xff && *size == 0xffff)	/* probably invalid data */
 		return -1;
 	return 0;
_

Patches currently in -mm which might be from jesper.juhl@gmail.com are

remove-unneeded-test-of-task-in-dump_trace.patch
git-xfs.patch
submitchecklist-update-fix-spelling-error.patch
add-missing-files-and-dirs-to-00-index-in-documentation.patch
remove-the-last-few-umsdos-leftovers.patch
isapnp-remove-pointless-check-of-type-against-0-in-isapnp_read_tag.patch
