From: akpm@linux-foundation.org
Subject: - proc_fsh-move-struct-mm_struct-forward-declaration.patch removed from -mm tree
Date: Sun, 15 Jun 2008 23:03:15 -0700
Message-ID: <200806160603.m5G63FqY010584@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53002 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754178AbYFPGDb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 16 Jun 2008 02:03:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bn@niasdigital.com, mm-commits@vger.kernel.org


The patch titled
     proc_fs.h: move struct mm_struct forward-declaration
has been removed from the -mm tree.  Its filename was
     proc_fsh-move-struct-mm_struct-forward-declaration.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: proc_fs.h: move struct mm_struct forward-declaration
From: Ben Nizette <bn@niasdigital.com>

Move the forward-declaration of struct mm_struct a little way up
proc_fs.h.  This fixes a bunch of "'struct mm_struct' declared inside
parameter list" warnings with CONFIG_PROC_FS=n

Signed-off-by: Ben Nizette <bn@niasdigital.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/proc_fs.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN include/linux/proc_fs.h~proc_fsh-move-struct-mm_struct-forward-declaration include/linux/proc_fs.h
--- a/include/linux/proc_fs.h~proc_fsh-move-struct-mm_struct-forward-declaration
+++ a/include/linux/proc_fs.h
@@ -9,6 +9,8 @@
 
 struct net;
 struct completion;
+struct mm_struct;
+
 /*
  * The proc filesystem constants/structures
  */
@@ -101,8 +103,6 @@ extern spinlock_t proc_subdir_lock;
 extern void proc_root_init(void);
 extern void proc_misc_init(void);
 
-struct mm_struct;
