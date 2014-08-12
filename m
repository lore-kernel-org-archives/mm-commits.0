From: akpm@linux-foundation.org
Subject: [merged]
 autofs4-dont-take-spinlock-when-not-needed-in-autofs4_lookup_expiring.patch removed from -mm tree
Date: Tue, 12 Aug 2014 12:38:26 -0700
Message-ID: <53ea6d32.4QbpsrdtkYVqgls+%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ig0-f201.google.com ([209.85.213.201]:42068 "EHLO
	mail-ig0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754885AbaHLTi1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 Aug 2014 15:38:27 -0400
Received: by mail-ig0-f201.google.com with SMTP id h3so1067668igd.4
        for <mm-commits@vger.kernel.org>; Tue, 12 Aug 2014 12:38:26 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: neilb@suse.de, raven@themaw.net, mm-commits@vger.kernel.org


The patch titled
     Subject: autofs4: don't take spinlock when not needed in autofs4_lookup_expiring
has been removed from the -mm tree.  Its filename was
     autofs4-dont-take-spinlock-when-not-needed-in-autofs4_lookup_expiring.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
linux-next.patch

