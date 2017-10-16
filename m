From: akpm@linux-foundation.org
Subject: + pipe-avoid-round_pipe_size-nr_pages-overflow-on-32-bit.patch
 added to -mm tree
Date: Mon, 16 Oct 2017 15:06:12 -0700
Message-ID: <59e52d54.T40mHenS5HL4wFIx%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37732 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754299AbdJPWGN (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 16 Oct 2017 18:06:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe.lawrence@redhat.com, axboe@kernel.dk, mpatocka@redhat.com, mtk.manpages@gmail.com, rdunlap@infradead.org, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: pipe: avoid round_pipe_size() nr_pages overflow on 32-bit
has been added to the -mm tree.  Its filename is
     pipe-avoid-round_pipe_size-nr_pages-overflow-on-32-bit.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/pipe-avoid-round_pipe_size-nr_pages-overflow-on-32-bit.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/pipe-avoid-round_pipe_size-nr_pages-overflow-on-32-bit.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joe Lawrence <joe.lawrence@redhat.com>
Subject: pipe: avoid round_pipe_size() nr_pages overflow on 32-bit

round_pipe_size() contains a right-bit-shift expression which may
overflow, which would cause undefined results in a subsequent
roundup_pow_of_two() call.

  static inline unsigned int round_pipe_size(unsigned int size)
  {
          unsigned long nr_pages;

          nr_pages = (size + PAGE_SIZE - 1) >> PAGE_SHIFT;
          return roundup_pow_of_two(nr_pages) << PAGE_SHIFT;
  }

PAGE_SIZE is defined as (1UL << PAGE_SHIFT), so:
  - 4 bytes wide on 32-bit (0 to 0xffffffff)
  - 8 bytes wide on 64-bit (0 to 0xffffffffffffffff)

That means that 32-bit round_pipe_size(), nr_pages may overflow to 0:

  size=0x00000000    nr_pages=0x0
  size=0x00000001    nr_pages=0x1
  size=0xfffff000    nr_pages=0xfffff
  size=0xfffff001    nr_pages=0x0         << !
  size=0xffffffff    nr_pages=0x0         << !

This is bad because roundup_pow_of_two(n) is undefined when n == 0!

64-bit is not a problem as the unsigned int size is 4 bytes wide (similar
to 32-bit) and the larger, 8 byte wide unsigned long, is sufficient to
handle the largest value of the bit shift expression:

  size=0xffffffff    nr_pages=100000

Modify round_pipe_size() to return 0 if n == 0 and updates its callers to
handle accordingly.

Link: http://lkml.kernel.org/r/1507658689-11669-3-git-send-email-joe.lawrence@redhat.com
Signed-off-by: Joe Lawrence <joe.lawrence@redhat.com>
Reported-by: Mikulas Patocka <mpatocka@redhat.com>
Reviewed-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/pipe.c |   17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff -puN fs/pipe.c~pipe-avoid-round_pipe_size-nr_pages-overflow-on-32-bit fs/pipe.c
--- a/fs/pipe.c~pipe-avoid-round_pipe_size-nr_pages-overflow-on-32-bit
+++ a/fs/pipe.c
@@ -1017,13 +1017,19 @@ const struct file_operations pipefifo_fo
 
 /*
  * Currently we rely on the pipe array holding a power-of-2 number
- * of pages.
+ * of pages. Returns 0 on error.
  */
 static inline unsigned int round_pipe_size(unsigned int size)
 {
 	unsigned long nr_pages;
 
+	if (size < pipe_min_size)
+		size = pipe_min_size;
+
 	nr_pages = (size + PAGE_SIZE - 1) >> PAGE_SHIFT;
+	if (nr_pages == 0)
+		return 0;
+
 	return roundup_pow_of_two(nr_pages) << PAGE_SHIFT;
 }
 
@@ -1039,6 +1045,8 @@ static long pipe_set_size(struct pipe_in
 	long ret = 0;
 
 	size = round_pipe_size(arg);
+	if (size == 0)
+		return -EINVAL;
 	nr_pages = size >> PAGE_SHIFT;
 
 	if (!nr_pages)
@@ -1122,13 +1130,18 @@ out_revert_acct:
 int pipe_proc_fn(struct ctl_table *table, int write, void __user *buf,
 		 size_t *lenp, loff_t *ppos)
 {
+	unsigned int rounded_pipe_max_size;
 	int ret;
 
 	ret = proc_douintvec_minmax(table, write, buf, lenp, ppos);
 	if (ret < 0 || !write)
 		return ret;
 
-	pipe_max_size = round_pipe_size(pipe_max_size);
+	rounded_pipe_max_size = round_pipe_size(pipe_max_size);
+	if (rounded_pipe_max_size == 0)
+		return -EINVAL;
+
+	pipe_max_size = rounded_pipe_max_size;
 	return ret;
 }
 
_

Patches currently in -mm which might be from joe.lawrence@redhat.com are

pipe-match-pipe_max_size-data-type-with-procfs.patch
pipe-avoid-round_pipe_size-nr_pages-overflow-on-32-bit.patch
pipe-add-proc_dopipe_max_size-to-safely-assign-pipe_max_size.patch
sysctl-check-for-uint_max-before-unsigned-int-min-max.patch

