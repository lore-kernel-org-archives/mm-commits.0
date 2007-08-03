From: akpm@linux-foundation.org
Subject: + uml-fix-console-writing-bugs.patch added to -mm tree
Date: Fri, 03 Aug 2007 10:31:33 -0700
Message-ID: <200708031731.l73HVZbl019517@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43576 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752078AbXHCRbr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 3 Aug 2007 13:31:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jdike@addtoit.com, jdike@linux.intel.com


The patch titled
     uml: fix console writing bugs
has been added to the -mm tree.  Its filename is
     uml-fix-console-writing-bugs.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: uml: fix console writing bugs
From: Jeff Dike <jdike@addtoit.com>

The previous console cleanup patch switched generic_read and generic_write
from calling os_{read,write}_file to calling read and write directly.  Because
the calling convention is different, they now need to get any error from errno
rather than the return value.  I did this for generic_read, but forgot about
generic_write.

While chasing some output corruption, I noticed that line_write was
unnecessarily calling flush_buffer, and deleted it.  I don't understand why,
but the corruption disappeared.  This is unneeded because there already is a
perfectly good mechanism for finding out when the host output device has some
room to write data - there is an interrupt that comes in when writes can
happen again.  line_write calling flush_buffer seemed to just be an attempt to
opportunistically get some data out to the host.

I also made write_chan short-circuit calling into the host-level code for
zero-length writes.  Calling libc write with a length of zero conflated write
not being able to write anything with asking it not to write anything.  Better
to just cut it off as soon as possible.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/drivers/chan_kern.c |    3 +++
 arch/um/drivers/chan_user.c |   11 ++++++++++-
 arch/um/drivers/line.c      |    9 +++------
 3 files changed, 16 insertions(+), 7 deletions(-)

diff -puN arch/um/drivers/chan_kern.c~uml-fix-console-writing-bugs arch/um/drivers/chan_kern.c
--- a/arch/um/drivers/chan_kern.c~uml-fix-console-writing-bugs
+++ a/arch/um/drivers/chan_kern.c
@@ -291,6 +291,9 @@ int write_chan(struct list_head *chans, 
 	struct chan *chan = NULL;
 	int n, ret = 0;
 
+	if (len == 0)
+		return 0;
+
 	list_for_each(ele, chans) {
 		chan = list_entry(ele, struct chan, list);
 		if (!chan->output || (chan->ops->write == NULL))
diff -puN arch/um/drivers/chan_user.c~uml-fix-console-writing-bugs arch/um/drivers/chan_user.c
--- a/arch/um/drivers/chan_user.c~uml-fix-console-writing-bugs
+++ a/arch/um/drivers/chan_user.c
@@ -38,7 +38,16 @@ int generic_read(int fd, char *c_out, vo
 
 int generic_write(int fd, const char *buf, int n, void *unused)
 {
-	return write(fd, buf, n);
+	int err;
+
+	err = write(fd, buf, n);
+	if (err > 0)
+		return err;
+	else if (errno == EAGAIN)
+		return 0;
+	else if (err == 0)
+		return -EIO;
+	return -errno;
 }
 
 int generic_window_size(int fd, void *unused, unsigned short *rows_out,
diff -puN arch/um/drivers/line.c~uml-fix-console-writing-bugs arch/um/drivers/line.c
--- a/arch/um/drivers/line.c~uml-fix-console-writing-bugs
+++ a/arch/um/drivers/line.c
@@ -216,18 +216,15 @@ int line_write(struct tty_struct *tty, c
 {
 	struct line *line = tty->driver_data;
 	unsigned long flags;
-	int n, err, ret = 0;
+	int n, ret = 0;
 
 	if(tty->stopped)
 		return 0;
 
 	spin_lock_irqsave(&line->lock, flags);
-	if (line->head != line->tail) {
+	if (line->head != line->tail)
 		ret = buffer_data(line, buf, len);
-		err = flush_buffer(line);
-		if (err <= 0 && (err != -EAGAIN || !ret))
-			ret = err;
-	} else {
+	else {
 		n = write_chan(&line->chan_list, buf, len,
 			       line->driver->write_irq);
 		if (n < 0) {
_

Patches currently in -mm which might be from jdike@addtoit.com are

origin.patch
git-kvm.patch
hostfs-convert-to-new-aops.patch
uml-move-userspace-code-to-userspace-file.patch
uml-tidy-recently-moved-code.patch
uml-fix-error-cleanup-ordering.patch
uml-console-subsystem-tidying.patch
uml-fix-console-writing-bugs.patch
uml-console-tidying.patch
