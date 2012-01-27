From: akpm@linux-foundation.org
Subject: + seq_file-fix-mishandling-of-consecutive-pread-invocations.patch added to -mm tree
Date: Thu, 26 Jan 2012 16:00:55 -0800
Message-ID: <20120127000055.C0BD6A026F@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yx0-f202.google.com ([209.85.213.202]:55856 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754429Ab2A0AA4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 26 Jan 2012 19:00:56 -0500
Received: by yenr8 with SMTP id r8so119636yen.1
        for <mm-commits@vger.kernel.org>; Thu, 26 Jan 2012 16:00:56 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: echew@ixiacom.com, adobriyan@gmail.com, viro@zeniv.linux.org.uk


The patch titled
     Subject: seq_file: fix mishandling of consecutive pread() invocations.
has been added to the -mm tree.  Its filename is
     seq_file-fix-mishandling-of-consecutive-pread-invocations.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Subject: Subject: seq_file: fix mishandling of consecutive pread() invocations.

Patches currently in -mm which might be from echew@ixiacom.com are

seq_file-fix-mishandling-of-consecutive-pread-invocations.patch

