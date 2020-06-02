From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 074/128] mm: swapfile: fix /proc/swaps heading and
 Size/Used/Priority alignment
Date: Mon, 01 Jun 2020 21:49:26 -0700
Message-ID: <20200602044926.BVkZEzBS_%akpm@linux-foundation.org>
References: <20200601214457.919c35648e96a2b46b573fe1@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:40718 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725835AbgFBEt2 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 2 Jun 2020 00:49:28 -0400
In-Reply-To: <20200601214457.919c35648e96a2b46b573fe1@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, hughd@google.com, linux-mm@kvack.org, mm-commits@vger.kernel.org, rdunlap@infradead.org, torvalds@linux-foundation.org, viro@zeniv.linux.org.uk

From: Randy Dunlap <rdunlap@infradead.org>
Subject: mm: swapfile: fix /proc/swaps heading and Size/Used/Priority alignment

Fix the heading and Size/Used/Priority field alignments in /proc/swaps. 
If the Size and/or Used value is >= 10000000 (8 bytes), then the alignment
by using tab characters is broken.

This patch maintains the use of tabs for alignment.  If spaces are
preferred, we can just use a Field Width specifier for the bytes and inuse
fields.  That way those fields don't have to be a multiple of 8 bytes in
width.  E.g., with a field width of 12, both Size and Used would always
fit on the first line of an 80-column wide terminal (only Priority would
be on the second line).

There are actually 2 problems: heading alignment and field width.  On an
xterm, if Used is 7 bytes in length, the tab does nothing, and the display
is like this, with no space/tab between the Used and Priority fields. 
(ugh)

Filename				Type		Size	Used	Priority
/dev/sda8                               partition	16779260	2023012-1

To be clear, if one does 'cat /proc/swaps >/tmp/proc.swaps', it does look
different, like so:

Filename				Type		Size	Used	Priority
/dev/sda8                               partition	16779260	2086988	-1

Link: http://lkml.kernel.org/r/c0ffb41a-81ac-ddfa-d452-a9229ecc0387@infradead.org
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

--- a/mm/swapfile.c~mm-swapfile-fix-proc-swaps-heading-and-size-used-priority-alignment
+++ a/mm/swapfile.c
@@ -2801,20 +2801,24 @@ static int swap_show(struct seq_file *sw
 	struct swap_info_struct *si = v;
 	struct file *file;
 	int len;
+	unsigned int bytes, inuse;
 
 	if (si == SEQ_START_TOKEN) {
-		seq_puts(swap,"Filename\t\t\t\tType\t\tSize\tUsed\tPriority\n");
+		seq_puts(swap,"Filename\t\t\t\tType\t\tSize\t\tUsed\t\tPriority\n");
 		return 0;
 	}
 
+	bytes = si->pages << (PAGE_SHIFT - 10);
+	inuse = si->inuse_pages << (PAGE_SHIFT - 10);
+
 	file = si->swap_file;
 	len = seq_file_path(swap, file, " \t\n\\");
-	seq_printf(swap, "%*s%s\t%u\t%u\t%d\n",
+	seq_printf(swap, "%*s%s\t%u\t%s%u\t%s%d\n",
 			len < 40 ? 40 - len : 1, " ",
 			S_ISBLK(file_inode(file)->i_mode) ?
 				"partition" : "file\t",
-			si->pages << (PAGE_SHIFT - 10),
-			si->inuse_pages << (PAGE_SHIFT - 10),
+			bytes, bytes < 10000000 ? "\t" : "",
+			inuse, inuse < 10000000 ? "\t" : "",
 			si->prio);
 	return 0;
 }
_
