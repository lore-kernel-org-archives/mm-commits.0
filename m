From: akpm@linux-foundation.org
Subject: + kernel-paramsc-remove-sparse-warning-different-signedness.patch added to -mm tree
Date: Tue, 18 Dec 2007 15:28:59 -0800
Message-ID: <200712182329.lBINSxs2027468@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33438 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756706AbXLRX3e (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 18 Dec 2007 18:29:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ricknu-0@student.ltu.se


The patch titled
     kernel/params.c: remove sparse-warning (different signedness)
has been added to the -mm tree.  Its filename is
     kernel-paramsc-remove-sparse-warning-different-signedness.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: kernel/params.c: remove sparse-warning (different signedness)
From: Richard Knutsson <ricknu-0@student.ltu.se>

Fixing:
  CHECK   kernel/params.c
kernel/params.c:329:41: warning: incorrect type in argument 8 (different signedness)
kernel/params.c:329:41:    expected int *num
kernel/params.c:329:41:    got unsigned int *

Signed-off-by: Richard Knutsson <ricknu-0@student.ltu.se>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/params.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/params.c~kernel-paramsc-remove-sparse-warning-different-signedness kernel/params.c
--- a/kernel/params.c~kernel-paramsc-remove-sparse-warning-different-signedness
+++ a/kernel/params.c
@@ -272,7 +272,7 @@ static int param_array(const char *name,
 		       unsigned int min, unsigned int max,
 		       void *elem, int elemsize,
 		       int (*set)(const char *, struct kernel_param *kp),
-		       int *num)
+		       unsigned int *num)
 {
 	int ret;
 	struct kernel_param kp;
_

Patches currently in -mm which might be from ricknu-0@student.ltu.se are

origin.patch
kernel-compliment-va_copy-with-va_end.patch
git-dvb.patch
mm-mmap-remove-sparse-warning-null-as-0.patch
dio-array_size-cleanup-update.patch
dio-array_size-cleanup-update-checkpatch-fixes.patch
reiserfs-complement-va_start-with-va_end.patch
kernel-paramsc-remove-sparse-warning-different-signedness.patch
