From: akpm@linux-foundation.org
Subject: - char-use-get_unaligned_-helpers.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:49:15 -0700
Message-ID: <200804300549.m3U5nFIo029982@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33054 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758806AbYD3Ftp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 01:49:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: harvey.harrison@gmail.com, jirislaby@gmail.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     char: use get_unaligned_* helpers
has been removed from the -mm tree.  Its filename was
     char-use-get_unaligned_-helpers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: char: use get_unaligned_* helpers
From: Harvey Harrison <harvey.harrison@gmail.com>

Remove unnecessary temp variable from_buf in snsc_event.c

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Jiri Slaby <jirislaby@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/rocket_int.h |    2 +-
 drivers/char/snsc_event.c |   10 +++-------
 2 files changed, 4 insertions(+), 8 deletions(-)

diff -puN drivers/char/rocket_int.h~char-use-get_unaligned_-helpers drivers/char/rocket_int.h
--- a/drivers/char/rocket_int.h~char-use-get_unaligned_-helpers
+++ a/drivers/char/rocket_int.h
@@ -55,7 +55,7 @@ static inline void sOutW(unsigned short 
 
 static inline void out32(unsigned short port, Byte_t *p)
 {
-	u32 value = le32_to_cpu(get_unaligned((__le32 *)p));
+	u32 value = get_unaligned_le32(p);
 #ifdef ROCKET_DEBUG_IO
 	printk(KERN_DEBUG "out32(%x, %lx)...\n", port, value);
 #endif
diff -puN drivers/char/snsc_event.c~char-use-get_unaligned_-helpers drivers/char/snsc_event.c
--- a/drivers/char/snsc_event.c~char-use-get_unaligned_-helpers
+++ a/drivers/char/snsc_event.c
@@ -63,16 +63,13 @@ static int
 scdrv_parse_event(char *event, int *src, int *code, int *esp_code, char *desc)
 {
 	char *desc_end;
-	__be32 from_buf;
 
 	/* record event source address */
-	from_buf = get_unaligned((__be32 *)event);
-	*src = be32_to_cpup(&from_buf);
+	*src = get_unaligned_be32(event);
 	event += 4; 			/* move on to event code */
 
 	/* record the system controller's event code */
-	from_buf = get_unaligned((__be32 *)event);
-	*code = be32_to_cpup(&from_buf);
+	*code = get_unaligned_be32(event);
 	event += 4;			/* move on to event arguments */
 
 	/* how many arguments are in the packet? */
@@ -86,8 +83,7 @@ scdrv_parse_event(char *event, int *src,
 		/* not an integer argument, so give up */
 		return -1;
 	}
-	from_buf = get_unaligned((__be32 *)event);
-	*esp_code = be32_to_cpup(&from_buf);
+	*esp_code = get_unaligned_be32(event);
 	event += 4;
 
 	/* parse out the event description */
_

Patches currently in -mm which might be from harvey.harrison@gmail.com are

origin.patch
frv-fix-arch-frv-mm-unalignedo-build-error.patch
cifs-remove-global_extern-macro.patch
input-replace-remaining-__function__-occurrences.patch
git-kvm.patch
git-mips.patch
nfs-replace-remaining-__function__-occurrences.patch
parisc-replace-remaining-__function__-occurences.patch
drivers-parisc-replace-remaining-__function__-occurrences.patch
pcmcia-replace-remaining-__function__-occurrences.patch
scsi-replace-remaining-__function__-occurrences.patch
fusion-replace-remaining-__function__-occurrences.patch
scsi-replace-__inline-with-inline.patch
git-watchdog.patch
git-xfs.patch
xtensa-replace-remaining-__function__-occurences.patch
char-fix-sparse-shadowed-variable-warnings-in-espc.patch
char-espc-fix-possible-double-unlock.patch
char-rocketc-fix-sparse-variable-shadowing-and-int-as-null-pointer.patch
cycladesc-fix-sparse-shadowed-variable-warnings.patch
epcac-static-functions-and-integer-as-null-pointer-fixes.patch
epcac-static-functions-and-integer-as-null-pointer-fixes-checkpatch-fixes.patch
add-macros-similar-to-min-max-min_t-max_t.patch
add-macros-similar-to-min-max-min_t-max_t-doc.patch
ide-eliminate-fit-macro.patch
ata-remove-fit-macro.patch
b43-replace-limit_value-macro-with-clamp_val.patch
b43legacy-replace-limit_value-macro-with-clamp_val.patch
fuse-use-clamp-rather-than-nested-min-max.patch
ide-tape-use-clamp_t-rather-than-nested-min_t-max_t.patch
input-ff-memlessc-use-clamp_val-macro.patch
dccp-ccid2c-ccid3c-use-clamp-clamp_t.patch
drivers-replace-remaining-__function__-occurrences.patch
mm-remove-remaining-__function__-occurances.patch
block-remove-remaining-__function__-occurances.patch
kernel-replace-remaining-__function__-occurances.patch
lib-replace-remaining-__function__-occurances.patch
afs-replace-remaining-__function__-occurrences.patch
fs-replace-remaining-__function__-occurrences.patch
drivers-char-replace-remaining-__function__-occurrences.patch
serial-replace-remaining-__function__-occurrences.patch

