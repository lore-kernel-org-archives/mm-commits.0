From: akpm@linux-foundation.org
Subject: [folded-merged]
 fs-convert-fs-shrinkers-to-new-scan-count-api-fix-fix.patch removed from
 -mm tree
Date: Tue, 10 Sep 2013 15:31:24 -0700
Message-ID: <522f9dbc.0fBYpJmycxFvxSr1%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40069 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751560Ab3IJWbZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 10 Sep 2013 18:31:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, glommer@openvz.org, dchinner@redhat.com, dan.carpenter@oracle.com

Subject: [folded-merged] fs-convert-fs-shrinkers-to-new-scan-count-api-fix-fix.patch removed from -mm tree
To: dan.carpenter@oracle.com,dchinner@redhat.com,glommer@openvz.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 10 Sep 2013 15:31:24 -0700


The patch titled
     Subject: UBIFS: signedness bug in ubifs_shrink_count()
has been removed from the -mm tree.  Its filename was
     fs-convert-fs-shrinkers-to-new-scan-count-api-fix-fix.patch

This patch was dropped because it was folded into fs-convert-fs-shrinkers-to-new-scan-count-api.patch

------------------------------------------------------
From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: UBIFS: signedness bug in ubifs_shrink_count()

We test "clean_zn_cnt" for negative later in the function.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Dave Chinner <dchinner@redhat.com>
Cc: Glauber Costa <glommer@openvz.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ubifs/shrinker.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/ubifs/shrinker.c~fs-convert-fs-shrinkers-to-new-scan-count-api-fix-fix fs/ubifs/shrinker.c
--- a/fs/ubifs/shrinker.c~fs-convert-fs-shrinkers-to-new-scan-count-api-fix-fix
+++ a/fs/ubifs/shrinker.c
@@ -280,7 +280,7 @@ static int kick_a_thread(void)
 unsigned long ubifs_shrink_count(struct shrinker *shrink,
 				 struct shrink_control *sc)
 {
-	unsigned long clean_zn_cnt = atomic_long_read(&ubifs_clean_zn_cnt);
+	long clean_zn_cnt = atomic_long_read(&ubifs_clean_zn_cnt);
 
 	/*
 	 * Due to the way UBIFS updates the clean znode counter it may
_

Patches currently in -mm which might be from dan.carpenter@oracle.com are

origin.patch
ocfs2-use-list_for_each_entry-instead-of-list_for_each.patch
mbind-add-bug_onvma-in-new_vma_page.patch
affs-use-loff_t-in-affs_truncate.patch
pktcdvd-convert-printk-to-pr_level.patch
pktcdvd-fix-defective-misuses-of-pkt_level.patch
fs-convert-fs-shrinkers-to-new-scan-count-api.patch

