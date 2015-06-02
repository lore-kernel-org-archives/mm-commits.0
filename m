From: akpm@linux-foundation.org
Subject: + fs-allocate-structure-unconditionally-in-seq_open.patch added
 to -mm tree
Date: Tue, 02 Jun 2015 14:42:50 -0700
Message-ID: <556e235a.nS/27LVSCeB1CPuM%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46409 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751704AbbFBVmv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Jun 2015 17:42:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ydroneaud@opteya.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: fs: allocate structure unconditionally in seq_open()
has been added to the -mm tree.  Its filename is
     fs-allocate-structure-unconditionally-in-seq_open.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-allocate-structure-unconditionally-in-seq_open.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-allocate-structure-unconditionally-in-seq_open.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Yann Droneaud <ydroneaud@opteya.com>
Subject: fs: allocate structure unconditionally in seq_open()

Since patch described below, from v2.6.15-rc1, seq_open() could use a
struct seq_file already allocated by the caller if the pointer to the
structure is stored in file->private_data before calling the function.

    Commit 1abe77b0fc4b485927f1f798ae81a752677e1d05
    Author: Al Viro <viro@zeniv.linux.org.uk>
    Date:   Mon Nov 7 17:15:34 2005 -0500

        [PATCH] allow callers of seq_open do allocation themselves

        Allow caller of seq_open() to kmalloc() seq_file + whatever else they
        want and set ->private_data to it.  seq_open() will then abstain from
        doing allocation itself.

As there's no more use for such feature, as it could be easily replaced by
calls to seq_open_private() (see commit 39699037a5c9 ("[FS] seq_file:
Introduce the seq_open_private()")) and seq_release_private() (see
v2.6.0-test3), support for this uncommon feature can be removed from
seq_open().

Link: http://lkml.kernel.org/r/cover.1433193673.git.ydroneaud@opteya.com
Signed-off-by: Yann Droneaud <ydroneaud@opteya.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/seq_file.c |   17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff -puN fs/seq_file.c~fs-allocate-structure-unconditionally-in-seq_open fs/seq_file.c
--- a/fs/seq_file.c~fs-allocate-structure-unconditionally-in-seq_open
+++ a/fs/seq_file.c
@@ -51,15 +51,16 @@ static void *seq_buf_alloc(unsigned long
  */
 int seq_open(struct file *file, const struct seq_operations *op)
 {
-	struct seq_file *p = file->private_data;
+	struct seq_file *p;
+
+	WARN_ON(file->private_data);
+
+	p = kzalloc(sizeof(*p), GFP_KERNEL);
+	if (!p)
+		return -ENOMEM;
+
+	file->private_data = p;
 
-	if (!p) {
-		p = kmalloc(sizeof(*p), GFP_KERNEL);
-		if (!p)
-			return -ENOMEM;
-		file->private_data = p;
-	}
-	memset(p, 0, sizeof(*p));
 	mutex_init(&p->lock);
 	p->op = op;
 #ifdef CONFIG_USER_NS
_

Patches currently in -mm which might be from ydroneaud@opteya.com are

fs-use-seq_open_private-for-proc_mounts.patch
fs-allocate-structure-unconditionally-in-seq_open.patch
fs-documents-seq_opens-usage-of-file-private_data.patch
linux-next.patch

