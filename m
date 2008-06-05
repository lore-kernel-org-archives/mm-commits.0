From: akpm@linux-foundation.org
Subject: + introduce-memory_read_from_buffer.patch added to -mm tree
Date: Wed, 04 Jun 2008 17:29:55 -0700
Message-ID: <200806050029.m550Tumb016954@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37984 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756697AbYFEAcg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 4 Jun 2008 20:32:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akinobu.mita@gmail.com, Abhay_Salunke@dell.com, Douglas_Warzecha@dell.com, James.Bottomley@HansenPartnership.com, Matt_Domsch@dell.com, adaplas@pol.net, benh@kernel.crashing.org, brking@us.ibm.com, geert@linux-m68k.org, gregkh@suse.de, heiko.carstens@de.ibm.com, holzheu@de.ibm.com, kay.sievers@vrfy.org, krzysztof.h1@poczta.fm, lenb@kernel.org, linux-driver@qlogic.com, markus.rechberger@amd.com, peter.oberparleiter@de.ibm.com, robert.moore@intel.com, rui.zhang@intel.com, schwidefsky@de.ibm.com, seokmann.ju@qlogic.com, trenn@suse.de, viro@zeniv.linux.org.uk


The patch titled
     introduce memory_read_from_buffer()
has been added to the -mm tree.  Its filename is
     introduce-memory_read_from_buffer.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: introduce memory_read_from_buffer()
From: Akinobu Mita <akinobu.mita@gmail.com>

This patch introduces memory_read_from_buffer().

The only difference between memory_read_from_buffer() and
simple_read_from_buffer() is which address space the function copies to.

simple_read_from_buffer copies to user space memory.
memory_read_from_buffer copies to normal memory.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Doug Warzecha <Douglas_Warzecha@dell.com>
Cc: Zhang Rui <rui.zhang@intel.com>
Cc: Matt Domsch <Matt_Domsch@dell.com>
Cc: Abhay Salunke <Abhay_Salunke@dell.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Markus Rechberger <markus.rechberger@amd.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Cc: Bob Moore <robert.moore@intel.com>
Cc: Thomas Renninger <trenn@suse.de>
Cc: Len Brown <lenb@kernel.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Cc: Krzysztof Helt <krzysztof.h1@poczta.fm>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Peter Oberparleiter <peter.oberparleiter@de.ibm.com>
Cc: Michael Holzheu <holzheu@de.ibm.com>
Cc: Brian King <brking@us.ibm.com>
Cc: James E.J. Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Vasquez <linux-driver@qlogic.com>
Cc: Seokmann Ju <seokmann.ju@qlogic.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/libfs.c         |   18 ++++++++++++++++++
 include/linux/fs.h |    5 ++++-
 2 files changed, 22 insertions(+), 1 deletion(-)

diff -puN fs/libfs.c~introduce-memory_read_from_buffer fs/libfs.c
--- a/fs/libfs.c~introduce-memory_read_from_buffer
+++ a/fs/libfs.c
@@ -528,6 +528,23 @@ ssize_t simple_read_from_buffer(void __u
 	return count;
 }
 
+ssize_t memory_read_from_buffer(void *to, size_t count, loff_t *ppos,
+				const void *from, size_t available)
+{
+	loff_t pos = *ppos;
+
+	if (pos < 0)
+		return -EINVAL;
+	if (pos >= available)
+		return 0;
+	if (count > available - pos)
+		count = available - pos;
+	memcpy(to, from + pos, count);
+	*ppos = pos + count;
+
+	return count;
+}
+
 /*
  * Transaction based IO.
  * The file expects a single write which triggers the transaction, and then
@@ -800,6 +817,7 @@ EXPORT_SYMBOL(simple_statfs);
 EXPORT_SYMBOL(simple_sync_file);
 EXPORT_SYMBOL(simple_unlink);
 EXPORT_SYMBOL(simple_read_from_buffer);
+EXPORT_SYMBOL(memory_read_from_buffer);
 EXPORT_SYMBOL(simple_transaction_get);
 EXPORT_SYMBOL(simple_transaction_read);
 EXPORT_SYMBOL(simple_transaction_release);
diff -puN include/linux/fs.h~introduce-memory_read_from_buffer include/linux/fs.h
--- a/include/linux/fs.h~introduce-memory_read_from_buffer
+++ a/include/linux/fs.h
@@ -2025,7 +2025,10 @@ extern int simple_fill_super(struct supe
 extern int simple_pin_fs(struct file_system_type *, struct vfsmount **mount, int *count);
 extern void simple_release_fs(struct vfsmount **mount, int *count);
 
-extern ssize_t simple_read_from_buffer(void __user *, size_t, loff_t *, const void *, size_t);
+extern ssize_t simple_read_from_buffer(void __user *to, size_t count,
+			loff_t *ppos, const void *from, size_t available);
+extern ssize_t memory_read_from_buffer(void *to, size_t count, loff_t *ppos,
+			const void *from, size_t available);
 
 #ifdef CONFIG_MIGRATION
 extern int buffer_migrate_page(struct address_space *,
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

lib-export-bitrev16.patch
bluetooth-hci_bcspc-small-cleanups-api-users.patch
bluetooth-hci_bcspc-small-cleanups-api-users-fix.patch
binfmt_misc-use-simple_read_from_buffer.patch
ocfs2-use-simple_read_from_buffer.patch
ipc-use-simple_read_from_buffer.patch
isdn-use-simple_read_from_buffer.patch
s390-vmcp-use-simple_read_from_buffer.patch
s390-use-simple_read_from_buffer.patch
nwflash-use-simple_read_from_buffer.patch
usbmon-use-simple_read_from_buffer.patch
ttusb-use-simple_read_from_buffer.patch
airo-use-simple_read_from_buffer.patch
cris-use-simple_read_from_buffer.patch
introduce-memory_read_from_buffer.patch
dcdbas-use-memory_read_from_buffer.patch
dell_rbu-use-memory_read_from_buffer.patch
firmware-use-memory_read_from_buffer.patch
acpi-use-memory_read_from_buffer.patch
aty-use-memory_read_from_buffer.patch
zorro-use-memory_read_from_buffer.patch
s390-cio-use-memory_read_from_buffer.patch
s390-use-memory_read_from_buffer.patch
ipr-use-memory_read_from_buffer.patch
qla2xxx-use-memory_read_from_buffer.patch

