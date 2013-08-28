From: akpm@linux-foundation.org
Subject: +
 aoe-do-not-bug-if-memory-pressure-prevented-debugfs-file-creation.patch
 added to -mm tree
Date: Wed, 28 Aug 2013 14:12:48 -0700
Message-ID: <521e67d0.cA84rB3Axe46EfvF%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54332 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754671Ab3H1VMt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 28 Aug 2013 17:12:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, ecashin@coraid.com

Subject: + aoe-do-not-bug-if-memory-pressure-prevented-debugfs-file-creation.patch added to -mm tree
To: ecashin@coraid.com
From: akpm@linux-foundation.org
Date: Wed, 28 Aug 2013 14:12:48 -0700


The patch titled
     Subject: aoe: do not BUG if memory pressure prevented debugfs file creation
has been added to the -mm tree.  Its filename is
     aoe-do-not-bug-if-memory-pressure-prevented-debugfs-file-creation.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/aoe-do-not-bug-if-memory-pressure-prevented-debugfs-file-creation.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/aoe-do-not-bug-if-memory-pressure-prevented-debugfs-file-creation.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Ed Cashin <ecashin@coraid.com>
Subject: aoe: do not BUG if memory pressure prevented debugfs file creation

If the system has trouble allocating memory for the creation of the aoe
debugfs directory or of a file inside it, the debugfs member of an aoedev
can be NULL.

Do not treat a NULL debugfs pointer as a BUG on aoedev shutdown, avoiding
the user impact of an unecessary panic.

Signed-off-by: Ed Cashin <ecashin@coraid.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/aoe/aoeblk.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN drivers/block/aoe/aoeblk.c~aoe-do-not-bug-if-memory-pressure-prevented-debugfs-file-creation drivers/block/aoe/aoeblk.c
--- a/drivers/block/aoe/aoeblk.c~aoe-do-not-bug-if-memory-pressure-prevented-debugfs-file-creation
+++ a/drivers/block/aoe/aoeblk.c
@@ -215,7 +215,6 @@ aoedisk_add_debugfs(struct aoedev *d)
 void
 aoedisk_rm_debugfs(struct aoedev *d)
 {
-	BUG_ON(d->debugfs == NULL);
 	debugfs_remove(d->debugfs);
 	d->debugfs = NULL;
 }
_

Patches currently in -mm which might be from ecashin@coraid.com are

aoe-create-and-destroy-debugfs-directory-for-aoe.patch
aoe-add-aoe-target-files-to-debugfs.patch
aoe-provide-file-operations-for-debugfs-files.patch
aoe-fill-in-per-aoe-target-information-for-debugfs-file.patch
aoe-update-copyright-date.patch
aoe-update-internal-version-number-to-85.patch
aoe-remove-custom-implementation-of-kbasename.patch
aoe-suppress-compiler-warnings.patch
aoe-do-not-bug-if-memory-pressure-prevented-debugfs-file-creation.patch
aoe-remove-do-nothing-name=%k-term-from-example-udev-rules.patch

