From: akpm@linux-foundation.org
Subject: [merged] seq_file-fix-mishandling-of-consecutive-pread-invocations.patch removed from -mm tree
Date: Thu, 22 Mar 2012 13:17:11 -0700
Message-ID: <20120322201711.7442CA024E@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gy0-f202.google.com ([209.85.160.202]:60535 "EHLO
	mail-gy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753755Ab2CVURM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 22 Mar 2012 16:17:12 -0400
Received: by mail-gy0-f202.google.com with SMTP id z15so402093ghb.1
        for <mm-commits@vger.kernel.org>; Thu, 22 Mar 2012 13:17:11 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: echew@ixiacom.com, adobriyan@gmail.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: seq_file: fix mishandling of consecutive pread() invocations.
has been removed from the -mm tree.  Its filename was
     seq_file-fix-mishandling-of-consecutive-pread-invocations.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Earl Chew <echew@ixiacom.com>
Subject: seq_file: fix mishandling of consecutive pread() invocations.

The following program illustrates the problem:

    char buf[8192];

    int fd = open("/proc/self/maps", O_RDONLY);

    n = pread(fd, buf, sizeof(buf), 0);
    printf("%d\n", n);

    /* lseek(fd, 0, SEEK_CUR); */ /* Uncomment to work around */

    n = pread(fd, buf, sizeof(buf), 0);
    printf("%d\n", n);

The second printf() prints zero, but uncommenting the lseek() corrects its
behaviour.

To fix, make seq_read() mirror seq_lseek() when processing changes in
*ppos.  Restore m->version first, then if required traverse and update
read_pos on success.

Addresses https://bugzilla.kernel.org/show_bug.cgi?id=11856

Signed-off-by: Earl Chew <echew@ixiacom.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/seq_file.c |   28 +++++++++++++++-------------
 1 file changed, 15 insertions(+), 13 deletions(-)

diff -puN fs/seq_file.c~seq_file-fix-mishandling-of-consecutive-pread-invocations fs/seq_file.c
--- a/fs/seq_file.c~seq_file-fix-mishandling-of-consecutive-pread-invocations
+++ a/fs/seq_file.c
@@ -140,9 +140,21 @@ ssize_t seq_read(struct file *file, char
 
 	mutex_lock(&m->lock);
 
+	/*
+	 * seq_file->op->..m_start/m_stop/m_next may do special actions
+	 * or optimisations based on the file->f_version, so we want to
+	 * pass the file->f_version to those methods.
+	 *
+	 * seq_file->version is just copy of f_version, and seq_file
+	 * methods can treat it simply as file version.
+	 * It is copied in first and copied out after all operations.
+	 * It is convenient to have it as  part of structure to avoid the
+	 * need of passing another argument to all the seq_file methods.
+	 */
+	m->version = file->f_version;
+
 	/* Don't assume *ppos is where we left it */
 	if (unlikely(*ppos != m->read_pos)) {
-		m->read_pos = *ppos;
 		while ((err = traverse(m, *ppos)) == -EAGAIN)
 			;
 		if (err) {
@@ -152,21 +164,11 @@ ssize_t seq_read(struct file *file, char
 			m->index = 0;
 			m->count = 0;
 			goto Done;
+		} else {
+			m->read_pos = *ppos;
 		}
 	}
 
-	/*
-	 * seq_file->op->..m_start/m_stop/m_next may do special actions
-	 * or optimisations based on the file->f_version, so we want to
-	 * pass the file->f_version to those methods.
-	 *
-	 * seq_file->version is just copy of f_version, and seq_file
-	 * methods can treat it simply as file version.
-	 * It is copied in first and copied out after all operations.
-	 * It is convenient to have it as  part of structure to avoid the
-	 * need of passing another argument to all the seq_file methods.
-	 */
-	m->version = file->f_version;
 	/* grab buffer if we didn't have one */
 	if (!m->buf) {
 		m->buf = kmalloc(m->size = PAGE_SIZE, GFP_KERNEL);
_

Patches currently in -mm which might be from echew@ixiacom.com are

origin.patch

