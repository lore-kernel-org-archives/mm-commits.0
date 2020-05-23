From: Andrew Morton <akpm@linux-foundation.org>
Subject: +
 mm-swapfile-fix-proc-swaps-heading-and-size-used-priority-alignment.patch
 added to -mm tree
Date: Fri, 22 May 2020 17:00:05 -0700
Message-ID: <20200523000005.dLcHFDIoy%akpm@linux-foundation.org>
References: <20200513175005.1f4839360c18c0238df292d1@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:33520 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731169AbgEWAAG (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 22 May 2020 20:00:06 -0400
In-Reply-To: <20200513175005.1f4839360c18c0238df292d1@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hughd@google.com, mm-commits@vger.kernel.org, rdunlap@infradead.org, viro@zeniv.linux.org.uk


The patch titled
     Subject: mm: swapfile: fix /proc/swaps heading and Size/Used/Priority alignment
has been added to the -mm tree.  Its filename is
     mm-swapfile-fix-proc-swaps-heading-and-size-used-priority-alignment.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-swapfile-fix-proc-swaps-heading-and-size-used-priority-alignment.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-swapfile-fix-proc-swaps-heading-and-size-used-priority-alignment.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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
Cc: Hugh Dickins <hughd@google.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

--- a/mm/swapfile.c~mm-swapfile-fix-proc-swaps-heading-and-size-used-priority-alignment
+++ a/mm/swapfile.c
@@ -2798,20 +2798,24 @@ static int swap_show(struct seq_file *sw
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

Patches currently in -mm which might be from rdunlap@infradead.org are

mm-swapfile-fix-proc-swaps-heading-and-size-used-priority-alignment.patch
mm-pass-task-and-mm-to-do_madvise.patch
mm-support-vector-address-ranges-for-process_madvise-fix-fix.patch
