From: akpm@linux-foundation.org
Subject: + proc-much-faster-proc-vmstat.patch added to -mm tree
Date: Tue, 09 Aug 2016 16:26:50 -0700
Message-ID: <57aa66ba.jwDnJ74WCnFZ9H37%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41637 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932677AbcHIX0v (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Aug 2016 19:26:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, andi@firstfloor.org, joe@perches.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: proc: much faster /proc/vmstat
has been added to the -mm tree.  Its filename is
     proc-much-faster-proc-vmstat.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/proc-much-faster-proc-vmstat.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/proc-much-faster-proc-vmstat.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: proc: much faster /proc/vmstat

Every current KDE system has process named ksysguardd polling files below
once in several seconds:

	$ strace -e trace=open -p $(pidof ksysguardd)
	Process 1812 attached
	open("/etc/mtab", O_RDONLY|O_CLOEXEC)   = 8
	open("/etc/mtab", O_RDONLY|O_CLOEXEC)   = 8
	open("/proc/net/dev", O_RDONLY)         = 8
	open("/proc/net/wireless", O_RDONLY)    = -1 ENOENT (No such file or directory)
	open("/proc/stat", O_RDONLY)            = 8
	open("/proc/vmstat", O_RDONLY)          = 8

Hell knows what it is doing but speed up reading /proc/vmstat by 33%!

Benchmark is open+read+close 1.000.000 times.

			BEFORE
$ perf stat -r 10 taskset -c 3 ./proc-vmstat

 Performance counter stats for 'taskset -c 3 ./proc-vmstat' (10 runs):

      13146.768464      task-clock (msec)         #    0.960 CPUs utilized            ( +-  0.60% )
                15      context-switches          #    0.001 K/sec                    ( +-  1.41% )
                 1      cpu-migrations            #    0.000 K/sec                    ( +- 11.11% )
               104      page-faults               #    0.008 K/sec                    ( +-  0.57% )
    45,489,799,349      cycles                    #    3.460 GHz                      ( +-  0.03% )
     9,970,175,743      stalled-cycles-frontend   #   21.92% frontend cycles idle     ( +-  0.10% )
     2,800,298,015      stalled-cycles-backend    #   6.16% backend cycles idle       ( +-  0.32% )
    79,241,190,850      instructions              #    1.74  insn per cycle
                                                  #    0.13  stalled cycles per insn  ( +-  0.00% )
    17,616,096,146      branches                  # 1339.956 M/sec                    ( +-  0.00% )
       176,106,232      branch-misses             #    1.00% of all branches          ( +-  0.18% )

      13.691078109 seconds time elapsed                                          ( +-  0.03% )
      ^^^^^^^^^^^^

			AFTER
$ perf stat -r 10 taskset -c 3 ./proc-vmstat

 Performance counter stats for 'taskset -c 3 ./proc-vmstat' (10 runs):

       8688.353749      task-clock (msec)         #    0.950 CPUs utilized            ( +-  1.25% )
                10      context-switches          #    0.001 K/sec                    ( +-  2.13% )
                 1      cpu-migrations            #    0.000 K/sec
               104      page-faults               #    0.012 K/sec                    ( +-  0.56% )
    30,384,010,730      cycles                    #    3.497 GHz                      ( +-  0.07% )
    12,296,259,407      stalled-cycles-frontend   #   40.47% frontend cycles idle     ( +-  0.13% )
     3,370,668,651      stalled-cycles-backend    #  11.09% backend cycles idle       ( +-  0.69% )
    28,969,052,879      instructions              #    0.95  insn per cycle
                                                  #    0.42  stalled cycles per insn  ( +-  0.01% )
     6,308,245,891      branches                  #  726.058 M/sec                    ( +-  0.00% )
       214,685,502      branch-misses             #    3.40% of all branches          ( +-  0.26% )

       9.146081052 seconds time elapsed                                          ( +-  0.07% )
       ^^^^^^^^^^^

vsnprintf() is slow because:

1.  format_decode() is busy looking for format specifier: 2 branches
   per character (not in this case, but in others)

2. approximately million branches while parsing format mini language
   and everywhere

3.  just look at what string() does /proc/vmstat is good case because
   most of its content are strings

Link: http://lkml.kernel.org/r/20160806125455.GA1187@p183.telecom.by
Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Joe Perches <joe@perches.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmstat.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN mm/vmstat.c~proc-much-faster-proc-vmstat mm/vmstat.c
--- a/mm/vmstat.c~proc-much-faster-proc-vmstat
+++ a/mm/vmstat.c
@@ -1592,7 +1592,10 @@ static int vmstat_show(struct seq_file *
 {
 	unsigned long *l = arg;
 	unsigned long off = l - (unsigned long *)m->private;
-	seq_printf(m, "%s %lu\n", vmstat_text[off], *l);
+
+	seq_puts(m, vmstat_text[off]);
+	seq_put_decimal_ull(m, ' ', *l);
+	seq_putc(m, '\n');
 	return 0;
 }
 
_

Patches currently in -mm which might be from adobriyan@gmail.com are

kbuild-simpler-generation-of-assembly-constants.patch
proc-much-faster-proc-vmstat.patch
proc-faster-proc-status.patch

