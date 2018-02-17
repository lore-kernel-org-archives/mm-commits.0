From: akpm@linux-foundation.org
Subject: +
 proc-replace-seq_printf-on-seq_putc-to-speed-up-proc-pid-smaps.patch added
 to -mm tree
Date: Fri, 16 Feb 2018 16:47:19 -0800
Message-ID: <5a877b97.pGvoIAcmT4SSna6o%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51960 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750940AbeBQArU (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 16 Feb 2018 19:47:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: avagin@openvz.org, adobriyan@gmail.com, kamezawa.hiroyu@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     Subject: proc: replace seq_printf on seq_putc to speed up /proc/pid/smaps
has been added to the -mm tree.  Its filename is
     proc-replace-seq_printf-on-seq_putc-to-speed-up-proc-pid-smaps.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/proc-replace-seq_printf-on-seq_putc-to-speed-up-proc-pid-smaps.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/proc-replace-seq_printf-on-seq_putc-to-speed-up-proc-pid-smaps.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrei Vagin <avagin@openvz.org>
Subject: proc: replace seq_printf on seq_putc to speed up /proc/pid/smaps

seq_putc() works much faster than seq_printf()

$ time python test_smaps.py

== Before patch ==
real    0m3.828s
user    0m0.413s
sys     0m3.408s

== After patch ==
real	0m3.405s
user	0m0.401s
sys	0m3.003s

== Before patch ==
-   75.51%     4.62%  python   [kernel.kallsyms]    [k] show_smap.isra.33
   - 70.88% show_smap.isra.33
      + 24.82% seq_put_decimal_ull_aligned
      + 19.78% __walk_page_range
      + 12.74% seq_printf
      + 11.08% show_map_vma.isra.23
      + 1.68% seq_puts

== After patch ==
-   69.16%     5.70%  python   [kernel.kallsyms]    [k] show_smap.isra.33
   - 63.46% show_smap.isra.33
      + 25.98% seq_put_decimal_ull_aligned
      + 20.90% __walk_page_range
      + 12.60% show_map_vma.isra.23
        1.56% seq_putc
      + 1.55% seq_puts

Link: http://lkml.kernel.org/r/20180212074931.7227-2-avagin@openvz.org
Signed-off-by: Andrei Vagin <avagin@openvz.org>
Reviewed-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN fs/proc/task_mmu.c~proc-replace-seq_printf-on-seq_putc-to-speed-up-proc-pid-smaps fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~proc-replace-seq_printf-on-seq_putc-to-speed-up-proc-pid-smaps
+++ a/fs/proc/task_mmu.c
@@ -688,8 +688,9 @@ static void show_smap_vma_flags(struct s
 		if (!mnemonics[i][0])
 			continue;
 		if (vma->vm_flags & (1UL << i)) {
-			seq_printf(m, "%c%c ",
-				   mnemonics[i][0], mnemonics[i][1]);
+			seq_putc(m, mnemonics[i][0]);
+			seq_putc(m, mnemonics[i][1]);
+			seq_putc(m, ' ');
 		}
 	}
 	seq_putc(m, '\n');
_

Patches currently in -mm which might be from avagin@openvz.org are

procfs-add-seq_put_hex_ll-to-speed-up-proc-pid-maps.patch
procfs-add-seq_put_hex_ll-to-speed-up-proc-pid-maps-v3.patch
procfs-optimize-seq_pad-to-speed-up-proc-pid-maps.patch
proc-add-seq_put_decimal_ull_width-to-speed-up-proc-pid-smaps.patch
proc-replace-seq_printf-on-seq_putc-to-speed-up-proc-pid-smaps.patch
proc-optimize-single-symbol-delimiters-to-spead-up-seq_put_decimal_ull.patch
proc-replace-seq_printf-by-seq_put_smth-to-speed-up-proc-pid-status.patch

