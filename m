From: akpm@linux-foundation.org
Subject: + proc-use-rb_entry.patch added to -mm tree
Date: Tue, 20 Dec 2016 14:41:52 -0800
Message-ID: <5859b3b0.yL9STcAmH1nR0U96%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36594 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752094AbcLTWku (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 20 Dec 2016 17:40:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: geliangtang@gmail.com, davem@davemloft.net, dmitry.torokhov@gmail.com, jack@suse.cz, jgross@suse.com, seth.forshee@canonical.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: proc: use rb_entry()
has been added to the -mm tree.  Its filename is
     proc-use-rb_entry.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/proc-use-rb_entry.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/proc-use-rb_entry.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Geliang Tang <geliangtang@gmail.com>
Subject: proc: use rb_entry()

To make the code clearer, use rb_entry() instead of container_of() to
deal with rbtree.

Link: http://lkml.kernel.org/r/4fd1f82818665705ce75c5156a060ae7caa8e0a9.1482160150.git.geliangtang@gmail.com
Signed-off-by: Geliang Tang <geliangtang@gmail.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Juergen Gross <jgross@suse.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Seth Forshee <seth.forshee@canonical.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/generic.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff -puN fs/proc/generic.c~proc-use-rb_entry fs/proc/generic.c
--- a/fs/proc/generic.c~proc-use-rb_entry
+++ a/fs/proc/generic.c
@@ -57,9 +57,9 @@ static struct proc_dir_entry *pde_subdir
 	struct rb_node *node = dir->subdir.rb_node;
 
 	while (node) {
-		struct proc_dir_entry *de = container_of(node,
-							 struct proc_dir_entry,
-							 subdir_node);
+		struct proc_dir_entry *de = rb_entry(node,
+						     struct proc_dir_entry,
+						     subdir_node);
 		int result = proc_match(len, name, de);
 
 		if (result < 0)
@@ -80,8 +80,9 @@ static bool pde_subdir_insert(struct pro
 
 	/* Figure out where to put new node */
 	while (*new) {
-		struct proc_dir_entry *this =
-			container_of(*new, struct proc_dir_entry, subdir_node);
+		struct proc_dir_entry *this = rb_entry(*new,
+						       struct proc_dir_entry,
+						       subdir_node);
 		int result = proc_match(de->namelen, de->name, this);
 
 		parent = *new;
_

Patches currently in -mm which might be from geliangtang@gmail.com are

mm-vmallocc-use-rb_entry_safe.patch
proc-use-rb_entry.patch
timerqueue-use-rb_entry_safe.patch

