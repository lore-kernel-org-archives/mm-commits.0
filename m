From: akpm@linux-foundation.org
Subject: +
 ocfs2-llseek-requires-ocfs2-inode-lock-for-the-file-in-seek_end.patch added to -mm tree
Date: Thu, 27 Jun 2013 15:03:45 -0700
Message-ID: <51ccb6c1.fohnWYhHx3f1pdQd%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39132 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753727Ab3F0WDq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 27 Jun 2013 18:03:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sunil.mushran@gmail.com, mfasheh@suse.com, jlbec@evilplan.org, jeff.liu@oracle.com, shencanquan@huawei.com

Subject: + ocfs2-llseek-requires-ocfs2-inode-lock-for-the-file-in-seek_end.patch added to -mm tree
To: shencanquan@huawei.com,jeff.liu@oracle.com,jlbec@evilplan.org,mfasheh@suse.com,sunil.mushran@gmail.com
From: akpm@linux-foundation.org
Date: Thu, 27 Jun 2013 15:03:45 -0700


The patch titled
     Subject: ocfs2: llseek requires ocfs2 inode lock for the file in SEEK_END
has been added to the -mm tree.  Its filename is
     ocfs2-llseek-requires-ocfs2-inode-lock-for-the-file-in-seek_end.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jensen <shencanquan@huawei.com>
Subject: ocfs2: llseek requires ocfs2 inode lock for the file in SEEK_END

llseek requires ocfs2 inode lock for updating the file size in SEEK_END. 
because the file size maybe update on another node.  if it not .  after
call llseek in SEEK_END.  the position is old.

This bug can be reproduce the following scenario: at first ,we dd a test
fileA,the file size is 10k.

on NodeA:
---------
1) open the test fileA, lseek the end of file. and print the position.
2) close the test fileA

on NodeB:
1) open the test fileA, append the 5k data to test FileA.
2) lseek the end of file. and print the position.
3) close file.

At first we run the test program1 on NodeA , the result is 10k.  and then
run the test program2 on NodeB, the result is 15k.  at last, we run the
test program1 on NodeA again, the result is 10k.

After applying this patch.  the three step result is 15k.

Signed-off-by: Jensen <shencanquan@huawei.com>
Cc: Jie Liu <jeff.liu@oracle.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Sunil Mushran <sunil.mushran@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/file.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff -puN fs/ocfs2/file.c~ocfs2-llseek-requires-ocfs2-inode-lock-for-the-file-in-seek_end fs/ocfs2/file.c
--- a/fs/ocfs2/file.c~ocfs2-llseek-requires-ocfs2-inode-lock-for-the-file-in-seek_end
+++ a/fs/ocfs2/file.c
@@ -2626,7 +2626,16 @@ static loff_t ocfs2_file_llseek(struct f
 	case SEEK_SET:
 		break;
 	case SEEK_END:
-		offset += inode->i_size;
+		/* SEEK_END requires the OCFS2 inode lock for the file
+		 * because it references the file's size.
+		 */
+		ret = ocfs2_inode_lock(inode, NULL, 0);
+		if (ret < 0) {
+			mlog_errno(ret);
+			goto out;
+		}
+		offset += i_size_read(inode);
+		ocfs2_inode_unlock(inode, 0);
 		break;
 	case SEEK_CUR:
 		if (offset == 0) {
_

Patches currently in -mm which might be from shencanquan@huawei.com are

ocfs2-should-not-use-le32_add_cpu-to-set-ocfs2_dinode-i_flags.patch
ocfs2-dlmlock_master-should-return-dlm_normal-after-adding-lock-to-blocked-list.patch
ocfs2-fix-readonly-issue-in-ocfs2_unlink.patch
ocfs2-fix-readonly-issue-in-ocfs2_unlink-fix.patch
ocfs2-llseek-requires-ocfs2-inode-lock-for-the-file-in-seek_end.patch

