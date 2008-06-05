From: akpm@linux-foundation.org
Subject: + cris-use-simple_read_from_buffer.patch added to -mm tree
Date: Wed, 04 Jun 2008 17:29:53 -0700
Message-ID: <200806050029.m550Trec016951@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53957 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754307AbYFEAaD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 4 Jun 2008 20:30:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akinobu.mita@gmail.com, jesper.nilsson@axis.com, starvik@axis.com


The patch titled
     cris: use simple_read_from_buffer()
has been added to the -mm tree.  Its filename is
     cris-use-simple_read_from_buffer.patch

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
Subject: cris: use simple_read_from_buffer()
From: Akinobu Mita <akinobu.mita@gmail.com>

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Mikael Starvik <starvik@axis.com>
Cc: Jesper Nilsson <jesper.nilsson@axis.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/cris/kernel/profile.c |   17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

diff -puN arch/cris/kernel/profile.c~cris-use-simple_read_from_buffer arch/cris/kernel/profile.c
--- a/arch/cris/kernel/profile.c~cris-use-simple_read_from_buffer
+++ a/arch/cris/kernel/profile.c
@@ -35,19 +35,16 @@ read_cris_profile(struct file *file, cha
 		  size_t count, loff_t *ppos)
 {
 	unsigned long p = *ppos;
+	ssize_t ret;
 
-	if (p > SAMPLE_BUFFER_SIZE)
-		return 0;
+	ret = simple_read_from_buffer(buf, count, ppos, sample_buffer,
+						SAMPLE_BUFFER_SIZE);
+	if (ret < 0)
+		return ret;
 
-	if (p + count > SAMPLE_BUFFER_SIZE)
-		count = SAMPLE_BUFFER_SIZE - p;
-	if (copy_to_user(buf, sample_buffer + p,count))
-		return -EFAULT;
+	memset(sample_buffer + p, 0, ret);
 
-	memset(sample_buffer + p, 0, count);
-	*ppos += count;
-
-	return count;
+	return ret;
 }
 
 static ssize_t
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

