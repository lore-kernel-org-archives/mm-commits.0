From: akpm@linux-foundation.org
Subject: [patch 095/124] proc: use rb_entry()
Date: Fri, 24 Feb 2017 15:00:17 -0800
Message-ID: <58b0bb01.DPLN8LPl7ZZVwlD4%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38952 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751694AbdBXXAT (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 24 Feb 2017 18:00:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, geliangtang@gmail.com, davem@davemloft.net, dmitry.torokhov@gmail.com, jack@suse.cz, jgross@suse.com, seth.forshee@canonical.com, viro@zeniv.linux.org.uk

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
