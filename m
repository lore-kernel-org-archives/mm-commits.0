From: akpm@linux-foundation.org
Subject: + pipe-match-pipe_max_size-data-type-with-procfs.patch added to
 -mm tree
Date: Mon, 16 Oct 2017 15:06:09 -0700
Message-ID: <59e52d51.sznYx7Z1zpbMcPH8%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37720 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754285AbdJPWGL (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 16 Oct 2017 18:06:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe.lawrence@redhat.com, axboe@kernel.dk, mpatocka@redhat.com, mtk.manpages@gmail.com, rdunlap@infradead.org, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: pipe: match pipe_max_size data type with procfs
has been added to the -mm tree.  Its filename is
     pipe-match-pipe_max_size-data-type-with-procfs.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/pipe-match-pipe_max_size-data-type-with-procfs.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/pipe-match-pipe_max_size-data-type-with-procfs.patch

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
Subject: pipe: match pipe_max_size data type with procfs

Patch series "A few round_pipe_size() and pipe-max-size fixups", v3.

While backporting Michael's "pipe: fix limit handling" patchset to a
distro-kernel, Mikulas noticed that current upstream pipe limit handling
contains a few problems:

  1 - procfs signed wrap: echo'ing a large number into
      /proc/sys/fs/pipe-max-size and then cat'ing it back out shows a
      negative value.

  2 - round_pipe_size() nr_pages overflow on 32bit:  this would
      subsequently try roundup_pow_of_two(0), which is undefined.

  3 - visible non-rounded pipe-max-size value: there is no mutual
      exclusion or protection between the time pipe_max_size is assigned
      a raw value from proc_dointvec_minmax() and when it is rounded.

  4 - unsigned long -> unsigned int conversion makes for potential odd
      return errors from do_proc_douintvec_minmax_conv() and
      do_proc_dopipe_max_size_conv().

This version underwent the same testing as v1:
https://marc.info/?l=linux-kernel&m=150643571406022&w=2


This patch (of 4):

pipe_max_size is defined as an unsigned int:

  unsigned int pipe_max_size = 1048576;

but its procfs/sysctl representation is an integer:

  static struct ctl_table fs_table[] = {
          ...
          {
                  .procname       = "pipe-max-size",
                  .data           = &pipe_max_size,
                  .maxlen         = sizeof(int),
                  .mode           = 0644,
                  .proc_handler   = &pipe_proc_fn,
                  .extra1         = &pipe_min_size,
          },
          ...

that is signed:

  int pipe_proc_fn(struct ctl_table *table, int write, void __user *buf,
                   size_t *lenp, loff_t *ppos)
  {
          ...
          ret = proc_dointvec_minmax(table, write, buf, lenp, ppos)

This leads to signed results via procfs for large values of pipe_max_size:

  % echo 2147483647 >/proc/sys/fs/pipe-max-size
  % cat /proc/sys/fs/pipe-max-size
  -2147483648

Use unsigned operations on this variable to avoid such negative values.

Link: http://lkml.kernel.org/r/1507658689-11669-2-git-send-email-joe.lawrence@redhat.com
Signed-off-by: Joe Lawrence <joe.lawrence@redhat.com>
Reported-by: Mikulas Patocka <mpatocka@redhat.com>
Reviewed-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/pipe.c       |    2 +-
 kernel/sysctl.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/pipe.c~pipe-match-pipe_max_size-data-type-with-procfs fs/pipe.c
--- a/fs/pipe.c~pipe-match-pipe_max_size-data-type-with-procfs
+++ a/fs/pipe.c
@@ -1124,7 +1124,7 @@ int pipe_proc_fn(struct ctl_table *table
 {
 	int ret;
 
-	ret = proc_dointvec_minmax(table, write, buf, lenp, ppos);
+	ret = proc_douintvec_minmax(table, write, buf, lenp, ppos);
 	if (ret < 0 || !write)
 		return ret;
 
diff -puN kernel/sysctl.c~pipe-match-pipe_max_size-data-type-with-procfs kernel/sysctl.c
--- a/kernel/sysctl.c~pipe-match-pipe_max_size-data-type-with-procfs
+++ a/kernel/sysctl.c
@@ -1812,7 +1812,7 @@ static struct ctl_table fs_table[] = {
 	{
 		.procname	= "pipe-max-size",
 		.data		= &pipe_max_size,
-		.maxlen		= sizeof(int),
+		.maxlen		= sizeof(pipe_max_size),
 		.mode		= 0644,
 		.proc_handler	= &pipe_proc_fn,
 		.extra1		= &pipe_min_size,
_

Patches currently in -mm which might be from joe.lawrence@redhat.com are

pipe-match-pipe_max_size-data-type-with-procfs.patch
pipe-avoid-round_pipe_size-nr_pages-overflow-on-32-bit.patch
pipe-add-proc_dopipe_max_size-to-safely-assign-pipe_max_size.patch
sysctl-check-for-uint_max-before-unsigned-int-min-max.patch

