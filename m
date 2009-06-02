From: akpm@linux-foundation.org
Subject: + seq_file-add-function-to-write-binary-data.patch added to -mm tree
Date: Tue, 02 Jun 2009 15:03:40 -0700
Message-ID: <200906022203.n52M3ffk011560@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55507 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752113AbZFBWFS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Jun 2009 18:05:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oberpar@linux.vnet.ibm.com, W.Li@Sun.COM, andi@firstfloor.org, heicars2@linux.vnet.ibm.com, jdike@addtoit.com, michaele@au1.ibm.com, mingo@elte.hu, mschwid2@linux.vnet.ibm.com, rusty@rustcorp.com.au, sam@ravnborg.org, viro@zeniv.linux.org.uk, xiyou.wangcong@gmail.com, ying.huang@intel.com


The patch titled
     seq_file: add function to write binary data
has been added to the -mm tree.  Its filename is
     seq_file-add-function-to-write-binary-data.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: seq_file: add function to write binary data
From: Peter Oberparleiter <oberpar@linux.vnet.ibm.com>

seq_write() can be used to construct seq_files containing arbitrary data. 
Required by the gcov-profiling interface to synthesize binary profiling
data files.

Signed-off-by: Peter Oberparleiter <oberpar@linux.vnet.ibm.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Huang Ying <ying.huang@intel.com>
Cc: Li Wei <W.Li@Sun.COM>
Cc: Michael Ellerman <michaele@au1.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Heiko Carstens <heicars2@linux.vnet.ibm.com>
Cc: Martin Schwidefsky <mschwid2@linux.vnet.ibm.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: WANG Cong <xiyou.wangcong@gmail.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Jeff Dike <jdike@addtoit.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/seq_file.c            |   20 ++++++++++++++++++++
 include/linux/seq_file.h |    1 +
 2 files changed, 21 insertions(+)

diff -puN fs/seq_file.c~seq_file-add-function-to-write-binary-data fs/seq_file.c
--- a/fs/seq_file.c~seq_file-add-function-to-write-binary-data
+++ a/fs/seq_file.c
@@ -640,6 +640,26 @@ int seq_puts(struct seq_file *m, const c
 }
 EXPORT_SYMBOL(seq_puts);
 
+/**
+ * seq_write - write arbitrary data to buffer
+ * @seq: seq_file identifying the buffer to which data should be written
+ * @data: data address
+ * @len: number of bytes
+ *
+ * Return 0 on success, non-zero otherwise.
+ */
+int seq_write(struct seq_file *seq, const void *data, size_t len)
+{
+	if (seq->count + len < seq->size) {
+		memcpy(seq->buf + seq->count, data, len);
+		seq->count += len;
+		return 0;
+	}
+	seq->count = seq->size;
+	return -1;
+}
+EXPORT_SYMBOL(seq_write);
+
 struct list_head *seq_list_start(struct list_head *head, loff_t pos)
 {
 	struct list_head *lh;
diff -puN include/linux/seq_file.h~seq_file-add-function-to-write-binary-data include/linux/seq_file.h
--- a/include/linux/seq_file.h~seq_file-add-function-to-write-binary-data
+++ a/include/linux/seq_file.h
@@ -43,6 +43,7 @@ int seq_release(struct inode *, struct f
 int seq_escape(struct seq_file *, const char *, const char *);
 int seq_putc(struct seq_file *m, char c);
 int seq_puts(struct seq_file *m, const char *s);
+int seq_write(struct seq_file *seq, const void *data, size_t len);
 
 int seq_printf(struct seq_file *, const char *, ...)
 	__attribute__ ((format (printf,2,3)));
_

Patches currently in -mm which might be from oberpar@linux.vnet.ibm.com are

kernel-constructor-support.patch
seq_file-add-function-to-write-binary-data.patch
gcov-add-gcov-profiling-infrastructure.patch
gcov-enable-gcov_profile_all-for-x86_64.patch

