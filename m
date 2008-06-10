From: akpm@linux-foundation.org
Subject: + proc_fsh-move-struct-mm_struct-forward-declaration.patch added to -mm tree
Date: Mon, 09 Jun 2008 21:14:19 -0700
Message-ID: <200806100414.m5A4EJHQ024766@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36137 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750754AbYFJEOd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 10 Jun 2008 00:14:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bn@niasdigital.com


The patch titled
     proc_fs.h: move struct mm_struct forward-declaration
has been added to the -mm tree.  Its filename is
     proc_fsh-move-struct-mm_struct-forward-declaration.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
