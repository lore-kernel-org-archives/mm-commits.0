From: akpm@linux-foundation.org
Subject: + autofs4-remove-a-redundant-assignment.patch added to -mm tree
Date: Mon, 21 Jul 2014 16:00:06 -0700
Message-ID: <53cd9b76.0+kz2742d1vB+Sjt%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f74.google.com ([209.85.213.74]:51478 "EHLO
	mail-yh0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750795AbaGUXAH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 21 Jul 2014 19:00:07 -0400
Received: by mail-yh0-f74.google.com with SMTP id 29so1104675yhl.3
        for <mm-commits@vger.kernel.org>; Mon, 21 Jul 2014 16:00:06 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: neilb@suse.de, raven@themaw.net, mm-commits@vger.kernel.org


The patch titled
     Subject: autofs4: remove a redundant assignment
has been added to the -mm tree.  Its filename is
     autofs4-remove-a-redundant-assignment.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/autofs4-remove-a-redundant-assignment.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/autofs4-remove-a-redundant-assignment.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: NeilBrown <neilb@suse.de>
Subject: autofs4: remove a redundant assignment

The variable 'ino' already exists and already has the correct value.  The
d_fsdata of a dentry is never changed after the d_fsdata is instantiated,
so this new assignment cannot be necessary.

It was introduced in b5b801779d59 ("autofs4: Add d_manage() dentry
operation").

Signed-off-by: NeilBrown <neilb@suse.de>
Acked-by: Ian Kent <raven@themaw.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/autofs4/expire.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN fs/autofs4/expire.c~autofs4-remove-a-redundant-assignment fs/autofs4/expire.c
--- a/fs/autofs4/expire.c~autofs4-remove-a-redundant-assignment
+++ a/fs/autofs4/expire.c
@@ -333,7 +333,6 @@ struct dentry *autofs4_expire_direct(str
 	if (ino->flags & AUTOFS_INF_PENDING)
 		goto out;
 	if (!autofs4_direct_busy(mnt, root, timeout, do_now)) {
-		struct autofs_info *ino = autofs4_dentry_ino(root);
 		ino->flags |= AUTOFS_INF_EXPIRING;
 		init_completion(&ino->expire_complete);
 		spin_unlock(&sbi->fs_lock);
_

Patches currently in -mm which might be from neilb@suse.de are

autofs4-remove-unused-autofs4_ispending.patch
autofs4-remove-a-redundant-assignment.patch
autofs4-comment-typo-remove-a-a-doubled-word.patch
autofs4-remove-some-unused-inline-functions.patch
autofs4-dont-take-spinlock-when-not-needed-in-autofs4_lookup_expiring.patch
linux-next.patch

