From: akpm@linux-foundation.org
Subject: + x86_64-o_excl-on-dev-mcelog.patch added to -mm tree
Date: Wed, 09 May 2007 16:47:03 -0700
Message-ID: <200705092347.l49Nl3xg006082@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:36695 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755188AbXEIXrO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 May 2007 19:47:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: thockin@google.com, ak@suse.de


The patch titled
     x86_64: O_EXCL on /dev/mcelog
has been added to the -mm tree.  Its filename is
     x86_64-o_excl-on-dev-mcelog.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: x86_64: O_EXCL on /dev/mcelog
From: Tim Hockin <thockin@google.com>

Background:
 /dev/mcelog is a clear-on-read interface.  It is currently possible for
 multiple users to open and read() the device.  Users are protected from
 each other during any one read, but not across reads.

Description:
 This patch adds support for O_EXCL to /dev/mcelog.  If a user opens the
 device with O_EXCL, no other user may open the device (EBUSY).  Likewise,
 any user that tries to open the device with O_EXCL while another user has
 the device will fail (EBUSY).

Result:
 Applications can get exclusive access to /dev/mcelog.  Applications that
 do not care will be unchanged.

Alternatives:
 A simpler choice would be to only allow one open() at all, regardless of
 O_EXCL.

Testing:
 I wrote an application that opens /dev/mcelog with O_EXCL and observed
 that any other app that tried to open /dev/mcelog would fail until the
 exclusive app had closed the device.

Caveats:
 None.

Signed-off-by: Tim Hockin <thockin@google.com>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86_64/kernel/mce.c |   36 ++++++++++++++++++++++++++++++++++++
 1 files changed, 36 insertions(+)

diff -puN arch/x86_64/kernel/mce.c~x86_64-o_excl-on-dev-mcelog arch/x86_64/kernel/mce.c
--- a/arch/x86_64/kernel/mce.c~x86_64-o_excl-on-dev-mcelog
+++ a/arch/x86_64/kernel/mce.c
@@ -465,6 +465,40 @@ void __cpuinit mcheck_init(struct cpuinf
  * Character device to read and clear the MCE log.
  */
 
+static DEFINE_SPINLOCK(mce_state_lock);
+static int open_count;	/* #times opened */
+static int open_exclu;	/* already open exclusive? */
+
+static int mce_open(struct inode *inode, struct file *file)
+{
+	spin_lock(&mce_state_lock);
+
+	if (open_exclu || (open_count && (file->f_flags & O_EXCL))) {
+		spin_unlock(&mce_state_lock);
+		return -EBUSY;
+	}
+
+	if (file->f_flags & O_EXCL)
+		open_exclu = 1;
+	open_count++;
+
+	spin_unlock(&mce_state_lock);
+
+	return 0;
+}
+
+static int mce_release(struct inode *inode, struct file *file)
+{
+	spin_lock(&mce_state_lock);
+
+	open_count--;
+	open_exclu = 0;
+
+	spin_unlock(&mce_state_lock);
+
+	return 0;
+}
+
 static void collect_tscs(void *data) 
 { 
 	unsigned long *cpu_tsc = (unsigned long *)data;
@@ -553,6 +587,8 @@ static int mce_ioctl(struct inode *i, st
 }
 
 static const struct file_operations mce_chrdev_ops = {
+	.open = mce_open,
+	.release = mce_release,
 	.read = mce_read,
 	.ioctl = mce_ioctl,
 };
_

Patches currently in -mm which might be from thockin@google.com are

origin.patch
x86_64-o_excl-on-dev-mcelog.patch
x86_64-support-poll-on-dev-mcelog.patch
