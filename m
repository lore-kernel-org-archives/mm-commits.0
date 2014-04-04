From: akpm@linux-foundation.org
Subject: [merged]
 ocfs2-llseek-requires-ocfs2-inode-lock-for-the-file-in-seek_end.patch
 removed from -mm tree
Date: Fri, 04 Apr 2014 12:30:19 -0700
Message-ID: <533f084b.oxKB6RjdYxe4K1H9%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42753 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754479AbaDDTaU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Apr 2014 15:30:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sunil.mushran@gmail.com, mfasheh@suse.com, jlbec@evilplan.org, jeff.liu@oracle.com, shencanquan@huawei.com

Subject: [merged] ocfs2-llseek-requires-ocfs2-inode-lock-for-the-file-in-seek_end.patch removed from -mm tree
To: shencanquan@huawei.com,jeff.liu@oracle.com,jlbec@evilplan.org,mfasheh@suse.com,sunil.mushran@gmail.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 04 Apr 2014 12:30:19 -0700


The patch titled
     Subject: ocfs2: llseek requires ocfs2 inode lock for the file in SEEK_END
has been removed from the -mm tree.  Its filename was
     ocfs2-llseek-requires-ocfs2-inode-lock-for-the-file-in-seek_end.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jensen <shencanquan@huawei.com>
Subject: ocfs2: llseek requires ocfs2 inode lock for the file in SEEK_END

llseek requires ocfs2 inode lock for updating the file size in SEEK_END. 
because the file size maybe update on another node.

This bug can be reproduce the following scenario: at first, we dd a test
fileA, the file size is 10k.

on NodeA:
---------
1) open the test fileA, lseek the end of file. and print the position.
2) close the test fileA

on NodeB:
1) open the test fileA, append the 5k data to test FileA.
2) lseek the end of file. and print the position.
3) close file.

At first we run the test program1 on NodeA , the result is 10k.  And then
run the test program2 on NodeB, the result is 15k.  At last, we run the
test program1 on NodeA again, the result is 10k.

After applying this patch the three step result is 15k.

test result: 1000000 times lseek call;
index        lseek with inode lock (unit:us)                lseek without inode lock (unit:us)
  1                   1168162                                    555383
  2                   1168011                                    549504
  3                   1170538                                    549396
  4                   1170375                                    551685
  5                   1170444                                    556719
  6                   1174364                                    555307
  7                   1163294                                    551552
  8                   1170080                                    549350
  9                   1162464                                    553700
 10                   1165441                                    552594
 avg                  1168317                                    552519

avg with lock - avg without lock = 615798
(avg with lock - avg without lock)/1000000=0.615798 us

Signed-off-by: Jensen <shencanquan@huawei.com>
Cc: Jie Liu <jeff.liu@oracle.com>
Acked-by: Joel Becker <jlbec@evilplan.org>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Sunil Mushran <sunil.mushran@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/file.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff -puN fs/ocfs2/file.c~ocfs2-llseek-requires-ocfs2-inode-lock-for-the-file-in-seek_end fs/ocfs2/file.c
--- a/fs/ocfs2/file.c~ocfs2-llseek-requires-ocfs2-inode-lock-for-the-file-in-seek_end
+++ a/fs/ocfs2/file.c
@@ -2630,7 +2630,16 @@ static loff_t ocfs2_file_llseek(struct f
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

origin.patch

