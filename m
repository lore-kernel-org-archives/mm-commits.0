From: akpm@linux-foundation.org
Subject: + char-moxac-sparse-annotation.patch added to -mm tree
Date: Wed, 27 Aug 2008 20:36:03 -0700
Message-ID: <200808280336.m7S3a3ER005335@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38345 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753619AbYH1Dgn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Aug 2008 23:36:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: harvey.harrison@gmail.com, alan@lxorguk.ukuu.org.uk, jirislaby@gmail.com


The patch titled
     char: moxa.c sparse annotation
has been added to the -mm tree.  Its filename is
     char-moxac-sparse-annotation.patch

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
Subject: char: moxa.c sparse annotation
From: Harvey Harrison <harvey.harrison@gmail.com>

The only use is to pass this to le16_to_cpu, declare as such
drivers/char/moxa.c:548:11: warning: cast to restricted __le16.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Jiri Slaby <jirislaby@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/moxa.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/char/moxa.c~char-moxac-sparse-annotation drivers/char/moxa.c
--- a/drivers/char/moxa.c~char-moxac-sparse-annotation
+++ a/drivers/char/moxa.c
@@ -513,7 +513,7 @@ static int moxa_real_load_code(struct mo
 		size_t len)
 {
 	void __iomem *baseAddr = brd->basemem;
-	const u16 *uptr = ptr;
+	const __le16 *uptr = ptr;
 	size_t wlen, len2, j;
 	unsigned long key, loadbuf, loadlen, checksum, checksum_ok;
 	unsigned int i, retry;
_

Patches currently in -mm which might be from harvey.harrison@gmail.com are

linux-next.patch
acpi-toshiba_acpic-fix-sparse-signedness-mismatch-warnings.patch
x86-fix-shadowed-variable-warning.patch
cifs-remove-global_extern-macro.patch
v4l-drx397xdc-sparse-annotations.patch
v4l-mt9m111c-make-function-static.patch
input-ads7846c-sparse-lock-annotation.patch
misdn-endian-annotations-for-struct-zt.patch
misdn-annotate-iomem-pointer-and-add-statics.patch
drivers-net-replace-__function__-with-__func__.patch
rcu-spinlocks-take-an-unsigned-long-flags.patch
rcu-fix-sparse-shadowed-variable-warning.patch
scsi-replace-__inline-with-inline.patch
scsi-aic79xx_core-fix-shadowed-variables-add-statics.patch
scsi-aic79xx-aic79xx_pcic-fix-shadowed-variables.patch
scsi-gdthc-use-unaligned-access-helpers.patch
scsi-use-the-common-hex_asc-array-rather-than-a-private-one.patch
mm-hugetlbc-make-functions-static-use-null-rather-than-0.patch
olpc-olpc_batteryc-sparse-endian-annotations.patch
include-replace-__function__-with-__func__.patch
misc-replace-__function__-with-__func__.patch
befs-annotate-fs32-on-tests-for-superblock-endianness.patch
char-moxac-sparse-annotation.patch
byteorder-add-new-headers-for-make-headers-install.patch
pvrusb2-use-proper-byteorder-interface.patch

