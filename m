From: akpm@linux-foundation.org
Subject: + airo-use-simple_read_from_buffer.patch added to -mm tree
Date: Wed, 04 Jun 2008 17:29:51 -0700
Message-ID: <200806050029.m550Tptd016948@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38873 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756438AbYFEAae (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 4 Jun 2008 20:30:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akinobu.mita@gmail.com, dcbw@redhat.com, linville@tuxdriver.com, mschmidt@redhat.com


The patch titled
     airo: use simple_read_from_buffer()
has been added to the -mm tree.  Its filename is
     airo-use-simple_read_from_buffer.patch

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
Subject: airo: use simple_read_from_buffer()
From: Akinobu Mita <akinobu.mita@gmail.com>

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: John W. Linville <linville@tuxdriver.com>
Cc: Dan Williams <dcbw@redhat.com>
Cc: Michal Schmidt <mschmidt@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/wireless/airo.c |   15 +++------------
 1 file changed, 3 insertions(+), 12 deletions(-)

diff -puN drivers/net/wireless/airo.c~airo-use-simple_read_from_buffer drivers/net/wireless/airo.c
--- a/drivers/net/wireless/airo.c~airo-use-simple_read_from_buffer
+++ a/drivers/net/wireless/airo.c
@@ -4561,22 +4561,13 @@ static ssize_t proc_read( struct file *f
 			  size_t len,
 			  loff_t *offset )
 {
-	loff_t pos = *offset;
-	struct proc_data *priv = (struct proc_data*)file->private_data;
+	struct proc_data *priv = file->private_data;
 
 	if (!priv->rbuffer)
 		return -EINVAL;
 
-	if (pos < 0)
-		return -EINVAL;
-	if (pos >= priv->readlen)
-		return 0;
-	if (len > priv->readlen - pos)
-		len = priv->readlen - pos;
-	if (copy_to_user(buffer, priv->rbuffer + pos, len))
-		return -EFAULT;
-	*offset = pos + len;
-	return len;
+	return simple_read_from_buffer(buffer, len, offset, priv->rbuffer,
+					priv->readlen);
 }
 
 /*
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

