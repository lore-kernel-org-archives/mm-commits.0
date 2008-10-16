From: akpm@linux-foundation.org
Subject: + seq_file-dont-call-bitmap_scnprintf_len.patch added to -mm tree
Date: Thu, 16 Oct 2008 12:54:39 -0700
Message-ID: <200810161954.m9GJsdFc010534@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60459 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753716AbYJPTzV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 16 Oct 2008 15:55:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: laijs@cn.fujitsu.com, adobriyan@gmail.com, menage@google.com, pj@sgi.com


The patch titled
     seq_file: don't call bitmap_scnprintf_len()
has been added to the -mm tree.  Its filename is
     seq_file-dont-call-bitmap_scnprintf_len.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/added-to-mm.txt to find
out what to do about this

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
cgroups-fix-probable-race-with-put_css_set-and-find_css_set.patch
cgroups-fix-probable-race-with-put_css_set-and-find_css_set-fix.patch
cgroups-fix-probable-race-with-put_css_set-and-find_css_set-cgroups-eliminate-race-in-css_set-refcounting.patch
cgroups-convert-tasks-file-to-use-a-seq_file-with-shared-pid-array.patch
devcgroup-remove-spin_lock.patch
seq_file-dont-call-bitmap_scnprintf_len.patch
seq_file-add-seq_cpumask_list-seq_nodemask_list.patch
cpuset-use-seq_mask_-to-print-masks.patch
bitmask-remove-bitmap_scnprintf_len.patch

