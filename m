From: akpm@linux-foundation.org
Subject: +
 autofs4-dont-take-spinlock-when-not-needed-in-autofs4_lookup_expiring.patch added to -mm tree
Date: Mon, 21 Jul 2014 16:00:09 -0700
Message-ID: <53cd9b79.aUzgvS015AcyvMfG%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-pa0-f74.google.com ([209.85.220.74]:58854 "EHLO
	mail-pa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750835AbaGUXAK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 21 Jul 2014 19:00:10 -0400
Received: by mail-pa0-f74.google.com with SMTP id lj1so2023200pab.1
        for <mm-commits@vger.kernel.org>; Mon, 21 Jul 2014 16:00:10 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: neilb@suse.de, raven@themaw.net, mm-commits@vger.kernel.org


The patch titled
     Subject: autofs4: don't take spinlock when not needed in autofs4_lookup_expiring
has been added to the -mm tree.  Its filename is
     autofs4-dont-take-spinlock-when-not-needed-in-autofs4_lookup_expiring.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/autofs4-dont-take-spinlock-when-not-needed-in-autofs4_lookup_expiring.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/autofs4-dont-take-spinlock-when-not-needed-in-autofs4_lookup_expiring.patch

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
Subject: autofs4: don't take spinlock when not needed in autofs4_lookup_expiring

If the expiring_list is empty, we can avoid a costly spinlock in the
rcu-walk path through autofs4_d_manage (once the rest of the path becomes
rcu-walk friendly).

Signed-off-by: NeilBrown <neilb@suse.de>
Reviewed-by: Ian Kent <raven@themaw.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/autofs4/root.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff -puN fs/autofs4/root.c~autofs4-dont-take-spinlock-when-not-needed-in-autofs4_lookup_expiring fs/autofs4/root.c
--- a/fs/autofs4/root.c~autofs4-dont-take-spinlock-when-not-needed-in-autofs4_lookup_expiring
+++ a/fs/autofs4/root.c
@@ -166,8 +166,10 @@ static struct dentry *autofs4_lookup_act
 	const unsigned char *str = name->name;
 	struct list_head *p, *head;
 
-	spin_lock(&sbi->lookup_lock);
 	head = &sbi->active_list;
+	if (list_empty(head))
+		return NULL;
+	spin_lock(&sbi->lookup_lock);
 	list_for_each(p, head) {
 		struct autofs_info *ino;
 		struct dentry *active;
@@ -218,8 +220,10 @@ static struct dentry *autofs4_lookup_exp
 	const unsigned char *str = name->name;
 	struct list_head *p, *head;
 
-	spin_lock(&sbi->lookup_lock);
 	head = &sbi->expiring_list;
+	if (list_empty(head))
+		return NULL;
+	spin_lock(&sbi->lookup_lock);
 	list_for_each(p, head) {
 		struct autofs_info *ino;
 		struct dentry *expiring;
_

Patches currently in -mm which might be from neilb@suse.de are

autofs4-remove-unused-autofs4_ispending.patch
autofs4-remove-a-redundant-assignment.patch
autofs4-comment-typo-remove-a-a-doubled-word.patch
autofs4-remove-some-unused-inline-functions.patch
autofs4-dont-take-spinlock-when-not-needed-in-autofs4_lookup_expiring.patch
linux-next.patch

