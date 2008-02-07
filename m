From: akpm@linux-foundation.org
Subject: - kernel-paramsc-remove-sparse-warning-different-signedness.patch removed from -mm tree
Date: Wed, 06 Feb 2008 16:24:57 -0800
Message-ID: <200802070024.m170Ock4006634@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38008 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759699AbYBGAoK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Feb 2008 19:44:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ricknu-0@student.ltu.se, mm-commits@vger.kernel.org


The patch titled
     kernel/params.c: remove sparse-warning (different signedness)
has been removed from the -mm tree.  Its filename was
     kernel-paramsc-remove-sparse-warning-different-signedness.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

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
