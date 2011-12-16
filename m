From: akpm@linux-foundation.org
Subject: + mm-add-missing-mutex-lock-arround-notify_change.patch added to -mm tree
Date: Fri, 16 Dec 2011 12:56:14 -0800
Message-ID: <20111216205615.43FB95C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:52694 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752411Ab1LPU4S (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 16 Dec 2011 15:56:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tixxdz@opendz.org, fengguang.wu@intel.com, hughd@google.com, kamezawa.hiroyu@jp.fujitsu.com, minchan.kim@gmail.com, stable@vger.kernel.org, viro@zeniv.linux.org.uk


The patch titled
     Subject: mm: add missing mutex lock arround notify_change
has been added to the -mm tree.  Its filename is
     mm-add-missing-mutex-lock-arround-notify_change.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Djalal Harouni <tixxdz@opendz.org>
Subject: mm: add missing mutex lock arround notify_change

Calls to notify_change() must hold i_mutex.

Signed-off-by: Djalal Harouni <tixxdz@opendz.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff -puN mm/filemap.c~mm-add-missing-mutex-lock-arround-notify_change mm/filemap.c
--- a/mm/filemap.c~mm-add-missing-mutex-lock-arround-notify_change
+++ a/mm/filemap.c
@@ -1994,10 +1994,16 @@ EXPORT_SYMBOL(should_remove_suid);
 
 static int __remove_suid(struct dentry *dentry, int kill)
 {
+	int ret;
 	struct iattr newattrs;
 
 	newattrs.ia_valid = ATTR_FORCE | kill;
-	return notify_change(dentry, &newattrs);
+
+	mutex_lock(&dentry->d_inode->i_mutex);
+	ret = notify_change(dentry, &newattrs);
+	mutex_unlock(&dentry->d_inode->i_mutex);
+
+	return ret;
 }
 
 int file_remove_suid(struct file *file)
_
Subject: Subject: mm: add missing mutex lock arround notify_change

Patches currently in -mm which might be from tixxdz@opendz.org are

origin.patch
linux-next.patch
mm-add-missing-mutex-lock-arround-notify_change.patch
notify_change-check-that-i_mutex-is-held.patch

