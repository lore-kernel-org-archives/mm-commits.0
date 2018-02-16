From: akpm@linux-foundation.org
Subject: +
 proc-optimize-single-symbol-delimiters-to-spead-up-seq_put_decimal_ull.patch added to -mm tree
Date: Fri, 16 Feb 2018 15:51:12 -0800
Message-ID: <5a876e70.jrdyAUMQKQ6gAFGN%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35544 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751055AbeBPXvN (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 16 Feb 2018 18:51:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: avagin@openvz.org, adobriyan@gmail.com, kamezawa.hiroyu@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     Subject: proc: optimize single-symbol delimiters to spead up seq_put_decimal_ull
has been added to the -mm tree.  Its filename is
     proc-optimize-single-symbol-delimiters-to-spead-up-seq_put_decimal_ull.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/proc-optimize-single-symbol-delimiters-to-spead-up-seq_put_decimal_ull.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/proc-optimize-single-symbol-delimiters-to-spead-up-seq_put_decimal_ull.patch

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
Subject: proc: optimize single-symbol delimiters to spead up seq_put_decimal_ull

A delimiter is a string which is printed before a number.
A syngle-symbol delimiters can be printed by set_putc() and this works
faster than printing by set_puts().

== test_proc.c

int main(int argc, char **argv)
{
	int n, i, fd;
	char buf[16384];

	n = atoi(argv[1]);
	for (i = 0; i < n; i++) {
		fd = open(argv[2], O_RDONLY);
		if (fd < 0)
			return 1;
		if (read(fd, buf, sizeof(buf)) <= 0)
			return 1;
		close(fd);
	}

	return 0;
}
==

$ time ./test_proc  1000000 /proc/1/stat

== Before patch ==
  real	0m3.820s
  user	0m0.337s
  sys	0m3.394s

== After patch ==
  real	0m3.110s
  user	0m0.324s
  sys	0m2.700s

Link: http://lkml.kernel.org/r/20180212074931.7227-3-avagin@openvz.org
Signed-off-by: Andrei Vagin <avagin@openvz.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/seq_file.c |   24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff -puN fs/seq_file.c~proc-optimize-single-symbol-delimiters-to-spead-up-seq_put_decimal_ull fs/seq_file.c
--- a/fs/seq_file.c~proc-optimize-single-symbol-delimiters-to-spead-up-seq_put_decimal_ull
+++ a/fs/seq_file.c
@@ -693,12 +693,12 @@ void seq_put_decimal_ull_width(struct se
 	if (m->count + 2 >= m->size) /* we'll write 2 bytes at least */
 		goto overflow;
 
-	len = strlen(delimiter);
-	if (m->count + len >= m->size)
-		goto overflow;
-
-	memcpy(m->buf + m->count, delimiter, len);
-	m->count += len;
+	if (delimiter && delimiter[0]) {
+		if (delimiter[1] == 0)
+			seq_putc(m, delimiter[0]);
+		else
+			seq_puts(m, delimiter);
+	}
 
 	if (!width)
 		width = 1;
@@ -782,12 +782,12 @@ void seq_put_decimal_ll(struct seq_file
 	if (m->count + 3 >= m->size) /* we'll write 2 bytes at least */
 		goto overflow;
 
-	len = strlen(delimiter);
-	if (m->count + len >= m->size)
-		goto overflow;
