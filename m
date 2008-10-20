From: akpm@linux-foundation.org
Subject: - seq_file-dont-call-bitmap_scnprintf_len.patch removed from -mm tree
Date: Mon, 20 Oct 2008 13:36:43 -0700
Message-ID: <200810202036.m9KKahVx011438@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40811 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754251AbYJTUq7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 20 Oct 2008 16:46:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: laijs@cn.fujitsu.com, adobriyan@gmail.com, menage@google.com, pj@sgi.com, mm-commits@vger.kernel.org


The patch titled
     seq_file: don't call bitmap_scnprintf_len()
has been removed from the -mm tree.  Its filename was
     seq_file-dont-call-bitmap_scnprintf_len.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: seq_file: don't call bitmap_scnprintf_len()
From: Lai Jiangshan <laijs@cn.fujitsu.com>

"m->count + len < m->size" is true commonly, so bitmap_scnprintf()
is commonly called. this fix saves a call to bitmap_scnprintf_len().

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Paul Menage <menage@google.com>
Cc: Paul Jackson <pj@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/seq_file.c |   15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff -puN fs/seq_file.c~seq_file-dont-call-bitmap_scnprintf_len fs/seq_file.c
--- a/fs/seq_file.c~seq_file-dont-call-bitmap_scnprintf_len
+++ a/fs/seq_file.c
@@ -452,17 +452,18 @@ int seq_dentry(struct seq_file *m, struc
 
 int seq_bitmap(struct seq_file *m, unsigned long *bits, unsigned int nr_bits)
 {
-	size_t len = bitmap_scnprintf_len(nr_bits);
-
-	if (m->count + len < m->size) {
-		bitmap_scnprintf(m->buf + m->count, m->size - m->count,
-				 bits, nr_bits);
-		m->count += len;
-		return 0;
+	if (m->count < m->size) {
+		int len = bitmap_scnprintf(m->buf + m->count,
+				m->size - m->count, bits, nr_bits);
+		if (m->count + len < m->size) {
+			m->count += len;
+			return 0;
+		}
 	}
 	m->count = m->size;
 	return -1;
 }
+EXPORT_SYMBOL(seq_bitmap);
 
 static void *single_start(struct seq_file *p, loff_t *pos)
 {
_

Patches currently in -mm which might be from laijs@cn.fujitsu.com are

origin.patch
linux-next.patch

