From: akpm@linux-foundation.org
Subject: [patch 52/94] pipe: match pipe_max_size data type with
 procfs
Date: Fri, 17 Nov 2017 15:29:17 -0800
Message-ID: <20171117232917.kUAZebaLa%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55800 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S966933AbdKQX3T (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 17 Nov 2017 18:29:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, axboe@kernel.dk, joe.lawrence@redhat.com, jpoimboe@redhat.com, mm-commits@vger.kernel.org, mpatocka@redhat.com, mtk.manpages@gmail.com, rdunlap@infradead.org, torvalds@linux-foundation.org, viro@zeniv.linux.org.uk

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
Cc: Josh Poimboeuf <jpoimboe@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/pipe.c       |    2 +-
 kernel/sysctl.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/pipe.c~pipe-match-pipe_max_size-data-type-with-procfs fs/pipe.c
--- a/fs/pipe.c~pipe-match-pipe_max_size-data-type-with-procfs
+++ a/fs/pipe.c
@@ -1125,7 +1125,7 @@ int pipe_proc_fn(struct ctl_table *table
 {
 	int ret;
 
-	ret = proc_dointvec_minmax(table, write, buf, lenp, ppos);
+	ret = proc_douintvec_minmax(table, write, buf, lenp, ppos);
 	if (ret < 0 || !write)
 		return ret;
 
diff -puN kernel/sysctl.c~pipe-match-pipe_max_size-data-type-with-procfs kernel/sysctl.c
--- a/kernel/sysctl.c~pipe-match-pipe_max_size-data-type-with-procfs
+++ a/kernel/sysctl.c
@@ -1816,7 +1816,7 @@ static struct ctl_table fs_table[] = {
 	{
 		.procname	= "pipe-max-size",
 		.data		= &pipe_max_size,
-		.maxlen		= sizeof(int),
+		.maxlen		= sizeof(pipe_max_size),
 		.mode		= 0644,
 		.proc_handler	= &pipe_proc_fn,
 		.extra1		= &pipe_min_size,
_
