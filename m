From: akpm@linux-foundation.org
Subject: + procfs-add-seq_put_hex_ll-to-speed-up-proc-pid-maps-v3.patch
 added to -mm tree
Date: Fri, 16 Feb 2018 15:36:18 -0800
Message-ID: <5a876af2.bvT3lN0SO0RnoykL%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58448 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750787AbeBPXgT (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 16 Feb 2018 18:36:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: avagin@openvz.org, adobriyan@gmail.com, kamezawa.hiroyu@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     Subject: procfs-add-seq_put_hex_ll-to-speed-up-proc-pid-maps-v3
has been added to the -mm tree.  Its filename is
     procfs-add-seq_put_hex_ll-to-speed-up-proc-pid-maps-v3.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/procfs-add-seq_put_hex_ll-to-speed-up-proc-pid-maps-v3.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/procfs-add-seq_put_hex_ll-to-speed-up-proc-pid-maps-v3.patch

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
Subject: procfs-add-seq_put_hex_ll-to-speed-up-proc-pid-maps-v3

v3: use unsigned int instead of int where it is suitable.

Link: http://lkml.kernel.org/r/20180214025619.4005-1-avagin@openvz.org
Signed-off-by: Andrei Vagin <avagin@openvz.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/seq_file.c            |    7 ++++---
 include/linux/seq_file.h |    2 +-
 2 files changed, 5 insertions(+), 4 deletions(-)

diff -puN fs/seq_file.c~procfs-add-seq_put_hex_ll-to-speed-up-proc-pid-maps-v3 fs/seq_file.c
--- a/fs/seq_file.c~procfs-add-seq_put_hex_ll-to-speed-up-proc-pid-maps-v3
+++ a/fs/seq_file.c
@@ -722,15 +722,16 @@ EXPORT_SYMBOL(seq_put_decimal_ull);
  * @v: the number
  * @width: a minimum field width
  *
- * seq_put_hex_ll(m, "", v, 8) is equal to seq_printf(m, "0x08llx", v)
+ * seq_put_hex_ll(m, "", v, 8) is equal to seq_printf(m, "%08llx", v)
  *
  * This routine is very quick when you show lots of numbers.
  * In usual cases, it will be better to use seq_printf(). It's easier to read.
  */
 void seq_put_hex_ll(struct seq_file *m, const char *delimiter,
-				unsigned long long v, int width)
+				unsigned long long v, unsigned int width)
 {
-	int i, len;
+	unsigned int len;
+	int i;
 
 	if (delimiter && delimiter[0]) {
 		if (delimiter[1] == 0)
diff -puN include/linux/seq_file.h~procfs-add-seq_put_hex_ll-to-speed-up-proc-pid-maps-v3 include/linux/seq_file.h
--- a/include/linux/seq_file.h~procfs-add-seq_put_hex_ll-to-speed-up-proc-pid-maps-v3
+++ a/include/linux/seq_file.h
@@ -122,7 +122,7 @@ void seq_put_decimal_ull(struct seq_file
 			 unsigned long long num);
 void seq_put_decimal_ll(struct seq_file *m, const char *delimiter, long long num);
 void seq_put_hex_ll(struct seq_file *m, const char *delimiter,
-		    unsigned long long v, int width);
+		    unsigned long long v, unsigned int width);
 
 void seq_escape(struct seq_file *m, const char *s, const char *esc);
 
_

Patches currently in -mm which might be from avagin@openvz.org are

procfs-add-seq_put_hex_ll-to-speed-up-proc-pid-maps.patch
procfs-add-seq_put_hex_ll-to-speed-up-proc-pid-maps-v3.patch
procfs-optimize-seq_pad-to-speed-up-proc-pid-maps.patch

