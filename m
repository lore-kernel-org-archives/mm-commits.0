From: akpm@linux-foundation.org
Subject: [folded-merged]
 procfs-add-seq_put_hex_ll-to-speed-up-proc-pid-maps-v2.patch removed from
 -mm tree
Date: Thu, 08 Feb 2018 12:31:30 -0800
Message-ID: <5a7cb3a2.25ZguCbtj2Xj4PHR%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40048 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752308AbeBHUbb (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 8 Feb 2018 15:31:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: avagin@openvz.org, adobriyan@gmail.com, kamezawa.hiroyu@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     Subject: procfs-add-seq_put_hex_ll-to-speed-up-proc-pid-maps-v2
has been removed from the -mm tree.  Its filename was
     procfs-add-seq_put_hex_ll-to-speed-up-proc-pid-maps-v2.patch

This patch was dropped because it was folded into procfs-add-seq_put_hex_ll-to-speed-up-proc-pid-maps.patch

------------------------------------------------------
From: Andrei Vagin <avagin@openvz.org>
Subject: procfs-add-seq_put_hex_ll-to-speed-up-proc-pid-maps-v2

v2: don't create a separate function to print delimiter and a few fixes
to make code more readable.

Link: http://lkml.kernel.org/r/20180117082050.25406-1-avagin@openvz.org
Signed-off-by: Andrei Vagin <avagin@openvz.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/seq_file.c |   57 +++++++++++++++++++++---------------------------
 1 file changed, 26 insertions(+), 31 deletions(-)

diff -puN fs/seq_file.c~procfs-add-seq_put_hex_ll-to-speed-up-proc-pid-maps-v2 fs/seq_file.c
--- a/fs/seq_file.c~procfs-add-seq_put_hex_ll-to-speed-up-proc-pid-maps-v2
+++ a/fs/seq_file.c
@@ -670,26 +670,6 @@ void seq_puts(struct seq_file *m, const
 }
 EXPORT_SYMBOL(seq_puts);
 
-static inline void seq_put_delimeter(struct seq_file *m, const char *delimiter)
-{
-	int len;
-
-	if (!delimiter || !delimiter[0])
-		return;
-
-	if (delimiter[1] == 0)
-		return seq_putc(m, delimiter[0]);
-
-	len = strlen(delimiter);
-	if (m->count + len >= m->size) {
-		seq_set_overflow(m);
-		return;
-	}
-
-	memcpy(m->buf + m->count, delimiter, len);
-	m->count += len;
-}
-
 /*
  * A helper routine for putting decimal numbers without rich format of printf().
  * only 'unsigned long long' is supported.
@@ -705,7 +685,12 @@ void seq_put_decimal_ull(struct seq_file
 	if (m->count + 2 >= m->size) /* we'll write 2 bytes at least */
 		goto overflow;
 
-	seq_put_delimeter(m, delimiter);
+	len = strlen(delimiter);
+	if (m->count + len >= m->size)
+		goto overflow;
+
+	memcpy(m->buf + m->count, delimiter, len);
+	m->count += len;
 
 	if (m->count + 1 >= m->size)
 		goto overflow;
@@ -744,27 +729,32 @@ void seq_put_hex_ll(struct seq_file *m,
 {
 	int i, len;
 
-	seq_put_delimeter(m, delimiter);
-
-	len = (sizeof(v) * 8 - __builtin_clzll(v) + 3) / 4;
+	if (delimiter && delimiter[0]) {
+		if (delimiter[1] == 0)
+			seq_putc(m, delimiter[0]);
+		else
+			seq_puts(m, delimiter);
+	}
 
-	if (unlikely(len == 0))
+	/* If x is 0, the result of __builtin_clzll is undefined */
+	if (v == 0)
 		len = 1;
+	else
+		len = (sizeof(v) * 8 - __builtin_clzll(v) + 3) / 4;
 
 	if (len < width)
 		len = width;
 
-	if (m->count + len > m->size)
-		goto overflow;
+	if (m->count + len > m->size) {
+		seq_set_overflow(m);
+		return;
+	}
 
 	for (i = len - 1; i >= 0; i--) {
 		m->buf[m->count + i] = hex_asc[0xf & v];
 		v = v >> 4;
 	}
 	m->count += len;
-	return;
-overflow:
-	seq_set_overflow(m);
 }
 
 void seq_put_decimal_ll(struct seq_file *m, const char *delimiter, long long num)
@@ -774,7 +764,12 @@ void seq_put_decimal_ll(struct seq_file
 	if (m->count + 3 >= m->size) /* we'll write 2 bytes at least */
 		goto overflow;
 
-	seq_put_delimeter(m, delimiter);
+	len = strlen(delimiter);
+	if (m->count + len >= m->size)
+		goto overflow;
+
+	memcpy(m->buf + m->count, delimiter, len);
+	m->count += len;
 
 	if (m->count + 2 >= m->size)
 		goto overflow;
_

Patches currently in -mm which might be from avagin@openvz.org are

procfs-add-seq_put_hex_ll-to-speed-up-proc-pid-maps.patch
procfs-optimize-seq_pad-to-speed-up-proc-pid-maps.patch

