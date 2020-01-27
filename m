From: akpm@linux-foundation.org
Subject: + swap_next-should-increase-position-index.patch added to
 -mm tree
Date: Sun, 26 Jan 2020 19:10:47 -0800
Message-ID: <20200127031047.MX4gRK_vi%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:53782 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726545AbgA0DKs (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 26 Jan 2020 22:10:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hughd@google.com, jannh@google.com, keescook@chromium.org, mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk, vvs@virtuozzo.com


The patch titled
     Subject: mm/swapfile.c: swap_next should increase position index
has been added to the -mm tree.  Its filename is
     swap_next-should-increase-position-index.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/swap_next-should-increase-position-index.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/swap_next-should-increase-position-index.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Vasily Averin <vvs@virtuozzo.com>
Subject: mm/swapfile.c: swap_next should increase position index

If seq_file .next fuction does not change position index, read after some
lseek can generate unexpected output.

In Aug 2018 NeilBrown noticed commit 1f4aace60b0e ("fs/seq_file.c:
simplify seq_file iteration code and interface") "Some ->next functions do
not increment *pos when they return NULL...  Note that such ->next
functions are buggy and should be fixed.  A simple demonstration is

dd if=/proc/swaps bs=1000 skip=1

Choose any block size larger than the size of /proc/swaps.  This will
always show the whole last line of /proc/swaps"

Described problem is still actual.  If you make lseek into middle of last
output line following read will output end of last line and whole last
line once again.

$ dd if=/proc/swaps bs=1  # usual output
Filename				Type		Size	Used	Priority
/dev/dm-0                               partition	4194812	97536	-2
104+0 records in
104+0 records out
104 bytes copied

$ dd if=/proc/swaps bs=40 skip=1    # last line was generated twice
dd: /proc/swaps: cannot skip to specified offset
v/dm-0                               partition	4194812	97536	-2
/dev/dm-0                               partition	4194812	97536	-2
3+1 records in
3+1 records out
131 bytes copied

https://bugzilla.kernel.org/show_bug.cgi?id=206283

Link: http://lkml.kernel.org/r/bd8cfd7b-ac95-9b91-f9e7-e8438bd5047d@virtuozzo.com
Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
Cc: Jann Horn <jannh@google.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Kees Cook <keescook@chromium.org>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/swapfile.c~swap_next-should-increase-position-index
+++ a/mm/swapfile.c
@@ -2737,10 +2737,10 @@ static void *swap_next(struct seq_file *
 	else
 		type = si->type + 1;
 
+	++(*pos);
 	for (; (si = swap_type_to_swap_info(type)); type++) {
 		if (!(si->flags & SWP_USED) || !si->swap_map)
 			continue;
-		++*pos;
 		return si;
 	}
 
_

Patches currently in -mm which might be from vvs@virtuozzo.com are

swap_next-should-increase-position-index.patch
