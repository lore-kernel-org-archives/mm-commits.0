From: akpm@linux-foundation.org
Subject: + reiser4-fix-read_tail.patch added to -mm tree
Date: Mon, 16 Jul 2007 14:54:05 -0700
Message-ID: <200707162154.l6GLs5rr005987@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52209 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756371AbXGPVyU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 16 Jul 2007 17:54:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: edward@namesys.com


The patch titled
     reiser4: fix read_tail
has been added to the -mm tree.  Its filename is
     reiser4-fix-read_tail.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: reiser4: fix read_tail
From: Edward Shishkin <edward@namesys.com>

Update hint when reading tails

Signed-off-by: Edward Shishkin <edward@namesys.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/reiser4/plugin/item/tail.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/reiser4/plugin/item/tail.c~reiser4-fix-read_tail fs/reiser4/plugin/item/tail.c
--- a/fs/reiser4/plugin/item/tail.c~reiser4-fix-read_tail
+++ a/fs/reiser4/plugin/item/tail.c
@@ -758,7 +758,7 @@ int reiser4_read_tail(struct file *file 
 		coord->unit_pos--;
 		coord->between = AFTER_UNIT;
 	}
-
+	reiser4_set_hint(hint, &f->key, ZNODE_READ_LOCK);
 	return 0;
 }
 
_

Patches currently in -mm which might be from edward@namesys.com are

reiser4.patch
mm-clean-up-and-kernelify-shrinker-registration-reiser4.patch
reiser4-fix-extent2tail.patch
reiser4-fix-read_tail.patch
reiser4-fix-unix-file-readpages-filler.patch
reiser4-fix-for-new-aops-patches.patch
git-block-vs-reiser4.patch
