From: akpm@linux-foundation.org
Subject: + seq_file-more-atomicity-in-traverse.patch added to -mm tree
Date: Mon, 04 Jun 2007 13:08:13 -0700
Message-ID: <200706042008.l54K8D34017570@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34102 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758422AbXFDUJA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Jun 2007 16:09:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adobriyan@sw.ru, viro@zeniv.linux.org.uk


The patch titled
     seq_file: more atomicity in traverse()
has been added to the -mm tree.  Its filename is
     seq_file-more-atomicity-in-traverse.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: seq_file: more atomicity in traverse()
From: Alexey Dobriyan <adobriyan@sw.ru>

Original problem: in some circumstances seq_file interface can present
infinite proc file to the following script when normally said proc file is
finite:

	while read line; do
		[do something with $line]
	done </proc/$FILE

bash, to implement such loop does essentially

	read(0, buf, 128);
	[find \n]
	lseek(0, -difference, SEEK_CUR);

Consider, proc file prints list of objects each of them consists of many
lines, each line is shorter than 128 bytes.

Two objects in list, with ->index'es being 0 and 1.  Current one is 1, as
bash prints second object line by line.

Imagine first object being removed right before lseek().
traverse() will be called, because there is negative offset.
traverse() will reset ->index to 0 (!).
traverse() will call ->next() and get NULL in any usual iterate-over-list
code using list_for_each_entry_continue() and such. There is one object in
list now after all...
traverse() will return 0, lseek() will update file position and pretend
everything is OK.

So, what we have now: ->f_pos points to place where second object will be
printed, but ->index is 0.  seq_read() instead of returning EOF, will start
printing first line of first object every time it's called, until enough
objects are added to ->f_pos return in bounds.

Fix is to update ->index only after we're sure we saw enough objects down
the road.

Signed-off-by: Alexey Dobriyan <adobriyan@sw.ru>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/seq_file.c |   16 ++++++++++------
 1 files changed, 10 insertions(+), 6 deletions(-)

diff -puN fs/seq_file.c~seq_file-more-atomicity-in-traverse fs/seq_file.c
--- a/fs/seq_file.c~seq_file-more-atomicity-in-traverse
+++ a/fs/seq_file.c
@@ -177,21 +177,23 @@ EXPORT_SYMBOL(seq_read);
 
 static int traverse(struct seq_file *m, loff_t offset)
 {
-	loff_t pos = 0;
+	loff_t pos = 0, index;
 	int error = 0;
 	void *p;
 
 	m->version = 0;
-	m->index = 0;
+	index = 0;
 	m->count = m->from = 0;
-	if (!offset)
+	if (!offset) {
+		m->index = index;
 		return 0;
+	}
 	if (!m->buf) {
 		m->buf = kmalloc(m->size = PAGE_SIZE, GFP_KERNEL);
 		if (!m->buf)
 			return -ENOMEM;
 	}
-	p = m->op->start(m, &m->index);
+	p = m->op->start(m, &index);
 	while (p) {
 		error = PTR_ERR(p);
 		if (IS_ERR(p))
@@ -204,15 +206,17 @@ static int traverse(struct seq_file *m, 
 		if (pos + m->count > offset) {
 			m->from = offset - pos;
 			m->count -= m->from;
+			m->index = index;
 			break;
 		}
 		pos += m->count;
 		m->count = 0;
 		if (pos == offset) {
-			m->index++;
+			index++;
+			m->index = index;
 			break;
 		}
-		p = m->op->next(m, p, &m->index);
+		p = m->op->next(m, p, &index);
 	}
 	m->op->stop(m, p);
 	return error;
_

Patches currently in -mm which might be from adobriyan@sw.ru are

origin.patch
fix-rmmod-read-write-races-in-proc-entries.patch
fix-rmmod-read-write-races-in-proc-entries-cleanup.patch
fix-rmmod-read-write-races-in-proc-entries-fix.patch
proc-environ-wrong-placing-of-ptrace_may_attach-check.patch
mutex_unlock-later-in-seq_lseek.patch
seq_file-more-atomicity-in-traverse.patch
