From: akpm@linux-foundation.org
Subject: + apparmorfs-replace-current_time-with-current_time.patch added
 to -mm tree
Date: Mon, 10 Apr 2017 15:34:35 -0700
Message-ID: <58ec087b.NUSytNSsTTENY+Hr%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60536 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752369AbdDJWeg (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 10 Apr 2017 18:34:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: deepa.kernel@gmail.com, john.johansen@canonical.com, mm-commits@vger.kernel.org


The patch titled
     Subject: apparmorfs: replace CURRENT_TIME with current_time()
has been added to the -mm tree.  Its filename is
     apparmorfs-replace-current_time-with-current_time.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/apparmorfs-replace-current_time-with-current_time.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/apparmorfs-replace-current_time-with-current_time.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Deepa Dinamani <deepa.kernel@gmail.com>
Subject: apparmorfs: replace CURRENT_TIME with current_time()

CURRENT_TIME macro is not y2038 safe on 32 bit systems.

The patch replaces all the uses of CURRENT_TIME by current_time().

This is also in preparation for the patch that transitions vfs timestamps
to use 64 bit time and hence make them y2038 safe.  current_time() is also
planned to be transitioned to y2038 safe behavior along with this change.

CURRENT_TIME macro will be deleted before merging the aforementioned
change.

Link: http://lkml.kernel.org/r/1491613030-11599-11-git-send-email-deepa.kernel@gmail.com
Signed-off-by: Deepa Dinamani <deepa.kernel@gmail.com>
Cc: John Johansen <john.johansen@canonical.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 security/apparmor/apparmorfs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN security/apparmor/apparmorfs.c~apparmorfs-replace-current_time-with-current_time security/apparmor/apparmorfs.c
--- a/security/apparmor/apparmorfs.c~apparmorfs-replace-current_time-with-current_time
+++ a/security/apparmor/apparmorfs.c
@@ -1357,7 +1357,7 @@ static int aa_mk_null_file(struct dentry
 
 	inode->i_ino = get_next_ino();
 	inode->i_mode = S_IFCHR | S_IRUGO | S_IWUGO;
-	inode->i_atime = inode->i_mtime = inode->i_ctime = CURRENT_TIME;
+	inode->i_atime = inode->i_mtime = inode->i_ctime = current_time(inode);
 	init_special_inode(inode, S_IFCHR | S_IRUGO | S_IWUGO,
 			   MKDEV(MEM_MAJOR, 3));
 	d_instantiate(dentry, inode);
_

Patches currently in -mm which might be from deepa.kernel@gmail.com are

fs-f2fs-use-ktime_get_real_seconds-for-sit_info-times.patch
trace-make-trace_hwlat-timestamp-y2038-safe.patch
fs-cifs-replace-current_time-by-other-appropriate-apis.patch
fs-ceph-current_time-with-ktime_get_real_ts.patch
fs-ufs-use-ktime_get_real_ts64-for-birthtime.patch
audit-use-timespec64-to-represent-audit-timestamps.patch
fs-btrfs-use-ktime_get_real_ts-for-root-ctime.patch
fs-ubifs-replace-current_time_sec-with-current_time.patch
lustre-replace-current_time-macro.patch
apparmorfs-replace-current_time-with-current_time.patch
time-delete-current_time_sec-and-current_time.patch
time-delete-current_fs_time-function.patch

