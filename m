From: akpm@linux-foundation.org
Subject: [merged] drivers-md-mdc-use-%pu-to-print-uuids.patch removed from -mm tree
Date: Tue, 15 Dec 2009 13:58:06 -0800
Message-ID: <200912152158.nBFLw67f015777@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38478 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755481AbZLOWGn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Dec 2009 17:06:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, neilb@suse.de, mm-commits@vger.kernel.org


The patch titled
     drivers/md/md.c: use %pU to print UUIDs
has been removed from the -mm tree.  Its filename was
     drivers-md-mdc-use-%pu-to-print-uuids.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/md/md.c: use %pU to print UUIDs
From: Joe Perches <joe@perches.com>

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/md/md.c |   16 ++++------------
 1 file changed, 4 insertions(+), 12 deletions(-)

diff -puN drivers/md/md.c~drivers-md-mdc-use-%pu-to-print-uuids drivers/md/md.c
--- a/drivers/md/md.c~drivers-md-mdc-use-%pu-to-print-uuids
+++ a/drivers/md/md.c
@@ -1827,15 +1827,11 @@ static void print_sb_1(struct mdp_superb
 
 	uuid = sb->set_uuid;
 	printk(KERN_INFO
-	       "md:  SB: (V:%u) (F:0x%08x) Array-ID:<%02x%02x%02x%02x"
-	       ":%02x%02x:%02x%02x:%02x%02x:%02x%02x%02x%02x%02x%02x>\n"
+	       "md:  SB: (V:%u) (F:0x%08x) Array-ID:<%pU>\n"
 	       "md:    Name: \"%s\" CT:%llu\n",
 		le32_to_cpu(sb->major_version),
 		le32_to_cpu(sb->feature_map),
-		uuid[0], uuid[1], uuid[2], uuid[3],
-		uuid[4], uuid[5], uuid[6], uuid[7],
-		uuid[8], uuid[9], uuid[10], uuid[11],
-		uuid[12], uuid[13], uuid[14], uuid[15],
+		uuid,
 		sb->set_name,
 		(unsigned long long)le64_to_cpu(sb->ctime)
 		       & MD_SUPERBLOCK_1_TIME_SEC_MASK);
@@ -1844,8 +1840,7 @@ static void print_sb_1(struct mdp_superb
 	printk(KERN_INFO
 	       "md:       L%u SZ%llu RD:%u LO:%u CS:%u DO:%llu DS:%llu SO:%llu"
 			" RO:%llu\n"
-	       "md:     Dev:%08x UUID: %02x%02x%02x%02x:%02x%02x:%02x%02x:%02x%02x"
-	                ":%02x%02x%02x%02x%02x%02x\n"
+	       "md:     Dev:%08x UUID: %pU\n"
 	       "md:       (F:0x%08x) UT:%llu Events:%llu ResyncOffset:%llu CSUM:0x%08x\n"
 	       "md:         (MaxDev:%u) \n",
 		le32_to_cpu(sb->level),
@@ -1858,10 +1853,7 @@ static void print_sb_1(struct mdp_superb
 		(unsigned long long)le64_to_cpu(sb->super_offset),
 		(unsigned long long)le64_to_cpu(sb->recovery_offset),
 		le32_to_cpu(sb->dev_number),
-		uuid[0], uuid[1], uuid[2], uuid[3],
-		uuid[4], uuid[5], uuid[6], uuid[7],
-		uuid[8], uuid[9], uuid[10], uuid[11],
-		uuid[12], uuid[13], uuid[14], uuid[15],
+		uuid,
 		sb->devflags,
 		(unsigned long long)le64_to_cpu(sb->utime) & MD_SUPERBLOCK_1_TIME_SEC_MASK,
 		(unsigned long long)le64_to_cpu(sb->events),
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
linux-next.patch
scripts-checkpatchpl-add-warn-on-sizeof.patch
checkpatchpl-allow-80-char-lines-for-logging-functions-not-just-printk.patch
isicomc-use-pr_fmt-and-pr_level.patch
parport_pcc-use-correct-length-in-strncmp.patch

