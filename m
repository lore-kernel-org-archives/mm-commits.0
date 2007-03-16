From: akpm@linux-foundation.org
Subject: + ext3-dirindex-error-pointer-issues-fix.patch added to -mm tree
Date: Thu, 15 Mar 2007 18:45:39 -0800
Message-ID: <200703160245.l2G2jdcp000761@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:50279 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752251AbXCPCqy (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Mar 2007 22:46:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dmonakhov@sw.ru, adilger@clusterfs.com, dmonakhov@openvz.org, tytso@mit.edu


The patch titled
     ext3: dirindex error pointer issues (b)
has been added to the -mm tree.  Its filename is
     ext3-dirindex-error-pointer-issues-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ext3: dirindex error pointer issues (b)
From: Dmitriy Monakhov <dmonakhov@sw.ru>

Dmitriy Monakhov <dmonakhov@sw.ru> writes:

>  - ext3_dx_find_entry() exit with out setting proper error pointer
>  - do_split() exit with out setting proper error pointer
>    it is realy painful because many callers contain folowing code:
>            de = do_split(handle,dir, &bh, frame, &hinfo, &retval);
>            if (!(de))
>                         return retval;
>            <<< WOW retval wasn't changed by do_split(), so caller failed
>            <<< but return SUCCESS :)
>  - Rearrange do_split() error path. Current error path is realy ugly, all
>    this up and down jump stuff doesn't make code easy to understand.

Ohh my first patch change error message semantics in do_split(). Initially when
ext3_append() failed we just exit without printing error. In fact ext3_append()
may fail, it is legal and it's happens qite often (ENOSPC for example). This
cause annoying fake error message. So restore this semantic as it was before
patch.

Signed-off-by: Monakhov Dmitriy <dmonakhov@openvz.org>
Cc: Andreas Dilger <adilger@clusterfs.com>
Cc: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext3/namei.c |    2 +-
 fs/ext4/namei.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/ext3/namei.c~ext3-dirindex-error-pointer-issues-fix fs/ext3/namei.c
--- a/fs/ext3/namei.c~ext3-dirindex-error-pointer-issues-fix
+++ a/fs/ext3/namei.c
@@ -1197,8 +1197,8 @@ journal_error:
 	brelse(*bh);
 	brelse(bh2);
 	*bh = NULL;
-errout:
 	ext3_std_error(dir->i_sb, err);
+errout:
 	*error = err;
 	return NULL;
 }
diff -puN fs/ext4/namei.c~ext3-dirindex-error-pointer-issues-fix fs/ext4/namei.c
--- a/fs/ext4/namei.c~ext3-dirindex-error-pointer-issues-fix
+++ a/fs/ext4/namei.c
@@ -1195,8 +1195,8 @@ journal_error:
 	brelse(*bh);
 	brelse(bh2);
 	*bh = NULL;
-errout:
 	ext4_std_error(dir->i_sb, err);
+errout:
 	*error = err;
 	return NULL;
 }
_

Patches currently in -mm which might be from dmonakhov@sw.ru are

origin.patch
driver-core-handles-kobject_uevent-failure-while-device_add.patch
driver-core-handle-sysfs_op-failure-while-device_add.patch
git-libata-all.patch
freevxfs-possible-null-pointer-dereference-fix.patch
reiserfs-possible-null-pointer-dereference-during-resize.patch
ext3-dirindex-error-pointer-issues.patch
ext3-dirindex-error-pointer-issues-fix.patch
floppy-handle-device_create_file-failure-while-init.patch
splice-partial-write-handling-fix.patch
