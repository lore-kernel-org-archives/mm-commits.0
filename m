From: akpm@linux-foundation.org
Subject: - cris-use-simple_read_from_buffer.patch removed from -mm tree
Date: Thu, 24 Jul 2008 16:25:48 -0700
Message-ID: <200807242325.m6ONPmUU010914@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33894 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755670AbYGXXZ5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Jul 2008 19:25:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, jesper.nilsson@axis.com, starvik@axis.com, mm-commits@vger.kernel.org


The patch titled
     cris: use simple_read_from_buffer()
has been removed from the -mm tree.  Its filename was
     cris-use-simple_read_from_buffer.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cris: use simple_read_from_buffer()
From: Akinobu Mita <akinobu.mita@gmail.com>

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Mikael Starvik <starvik@axis.com>
Cc: Jesper Nilsson <jesper.nilsson@axis.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/cris/kernel/profile.c |   17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

diff -puN arch/cris/kernel/profile.c~cris-use-simple_read_from_buffer arch/cris/kernel/profile.c
--- a/arch/cris/kernel/profile.c~cris-use-simple_read_from_buffer
+++ a/arch/cris/kernel/profile.c
@@ -35,19 +35,16 @@ read_cris_profile(struct file *file, cha
 		  size_t count, loff_t *ppos)
 {
 	unsigned long p = *ppos;
+	ssize_t ret;
 
-	if (p > SAMPLE_BUFFER_SIZE)
-		return 0;
+	ret = simple_read_from_buffer(buf, count, ppos, sample_buffer,
+						SAMPLE_BUFFER_SIZE);
+	if (ret < 0)
+		return ret;
 
-	if (p + count > SAMPLE_BUFFER_SIZE)
-		count = SAMPLE_BUFFER_SIZE - p;
-	if (copy_to_user(buf, sample_buffer + p,count))
-		return -EFAULT;
+	memset(sample_buffer + p, 0, ret);
 
-	memset(sample_buffer + p, 0, count);
-	*ppos += count;
-
-	return count;
+	return ret;
 }
 
 static ssize_t
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

origin.patch
linux-next.patch
ipr-use-memory_read_from_buffer.patch
qla2xxx-use-memory_read_from_buffer.patch
qla2xxx-use-memory_read_from_buffer-fix.patch
workqueues-do-cpu_up_canceled-if-cpu_up_prepare-fails.patch
ipc-use-simple_read_from_buffer.patch
nwflash-use-simple_read_from_buffer.patch
char-merge-ip2main-and-ip2base.patch
char-ip2-cleanup-globals.patch
char-ip2-fix-sparse-warnings.patch
char-ip2-init-deinit-cleanup.patch
ip2-avoid-add_timer-with-pending-timer.patch
firmware-use-memory_read_from_buffer.patch
firmware-use-memory_read_from_buffer-fix.patch
dcdbas-use-memory_read_from_buffer.patch
dcdbas-use-memory_read_from_buffer-fix.patch
dell_rbu-use-memory_read_from_buffer.patch
dell_rbu-use-memory_read_from_buffer-fix.patch

