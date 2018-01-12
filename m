From: akpm@linux-foundation.org
Subject: + procfs-optimize-seq_pad-to-speed-up-proc-pid-maps.patch added
 to -mm tree
Date: Fri, 12 Jan 2018 15:33:22 -0800
Message-ID: <5a5945c2.cN4gcPnk1RwOoDMn%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57768 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965302AbeALXdX (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 12 Jan 2018 18:33:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: avagin@openvz.org, adobriyan@gmail.com, kamezawa.hiroyu@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     Subject: procfs: optimize seq_pad() to speed up /proc/pid/maps
has been added to the -mm tree.  Its filename is
     procfs-optimize-seq_pad-to-speed-up-proc-pid-maps.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/procfs-optimize-seq_pad-to-speed-up-proc-pid-maps.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/procfs-optimize-seq_pad-to-speed-up-proc-pid-maps.patch

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
Subject: procfs: optimize seq_pad() to speed up /proc/pid/maps

seq_printf() is slow and it can be replaced by memset() in this case.

== test.py
num = 0
with open("/proc/1/maps") as f:
        while num < 10000 :
                data = f.read()
                f.seek(0, 0)
                num = num + 1
==

== Before patch ==
$  time python test.py

real	0m0.986s
user	0m0.279s
sys	0m0.707s

== After patch ==
$ time python test.py
real	0m0.932s
user	0m0.261s
sys	0m0.669s

$ perf record -g python test.py
== Before patch ==
-   47.35%     3.38%  python   [kernel.kallsyms] [k] show_map_vma.isra.23
   - 43.97% show_map_vma.isra.23
      + 20.84% seq_path
      - 15.73% show_vma_header_prefix
      + 6.96% seq_pad
   + 2.94% __GI___libc_read

== After patch ==
-   44.01%     0.34%  python   [kernel.kallsyms] [k] show_pid_map
   - 43.67% show_pid_map
      - 42.91% show_map_vma.isra.23
         + 21.55% seq_path
         - 15.68% show_vma_header_prefix
         + 2.08% seq_pad
        0.55% seq_putc

Link: http://lkml.kernel.org/r/20180112185812.7710-2-avagin@openvz.org
Signed-off-by: Andrei Vagin <avagin@openvz.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/seq_file.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff -puN fs/seq_file.c~procfs-optimize-seq_pad-to-speed-up-proc-pid-maps fs/seq_file.c
--- a/fs/seq_file.c~procfs-optimize-seq_pad-to-speed-up-proc-pid-maps
+++ a/fs/seq_file.c
@@ -829,8 +829,14 @@ EXPORT_SYMBOL(seq_write);
 void seq_pad(struct seq_file *m, char c)
 {
 	int size = m->pad_until - m->count;
-	if (size > 0)
-		seq_printf(m, "%*s", size, "");
+	if (size > 0) {
+		if (size + m->count > m->size) {
+			seq_set_overflow(m);
+			return;
+		}
+		memset(m->buf + m->count, ' ', size);
+		m->count += size;
+	}
 	if (c)
 		seq_putc(m, c);
 }
_

Patches currently in -mm which might be from avagin@openvz.org are

fs-elf-drop-map_fixed-usage-from-elf_map-fix.patch
procfs-add-seq_put_hex_ll-to-speed-up-proc-pid-maps.patch
procfs-optimize-seq_pad-to-speed-up-proc-pid-maps.patch

