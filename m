From: akpm@linux-foundation.org
Subject: [merged] drivers-video-via-viafbdevc-fix-oops-with-no-proc.patch removed from -mm tree
Date: Wed, 16 Dec 2009 12:36:13 -0800
Message-ID: <200912162036.nBGKaDJY013151@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49468 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935438AbZLPUgT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 Dec 2009 15:36:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: error27@gmail.com, FlorianSchandinat@gmx.de, JosephChan@via.com.tw, ScottFang@viatech.com.cn, mm-commits@vger.kernel.org


The patch titled
     drivers/video/via/viafbdev.c: fix oops with no /proc
has been removed from the -mm tree.  Its filename was
     drivers-video-via-viafbdevc-fix-oops-with-no-proc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/video/via/viafbdev.c: fix oops with no /proc
From: Dan Carpenter <error27@gmail.com>

Fixed a typo: missing *.  This would lead to a kernel oops if the kernel
was compiled without support for the /proc file system.

Found with a static checker.  Compile tested.

Signed-off-by: Dan Carpenter <error27@gmail.com>
Acked-by: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: Joseph Chan <JosephChan@via.com.tw>
Cc: Scott Fang <ScottFang@viatech.com.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/via/viafbdev.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/video/via/viafbdev.c~drivers-video-via-viafbdevc-fix-oops-with-no-proc drivers/video/via/viafbdev.c
--- a/drivers/video/via/viafbdev.c~drivers-video-via-viafbdevc-fix-oops-with-no-proc
+++ a/drivers/video/via/viafbdev.c
@@ -1797,7 +1797,7 @@ static const struct file_operations viaf
 static void viafb_init_proc(struct proc_dir_entry **viafb_entry)
 {
 	*viafb_entry = proc_mkdir("viafb", NULL);
-	if (viafb_entry) {
+	if (*viafb_entry) {
 		proc_create("dvp0", 0, *viafb_entry, &viafb_dvp0_proc_fops);
 		proc_create("dvp1", 0, *viafb_entry, &viafb_dvp1_proc_fops);
 		proc_create("dfph", 0, *viafb_entry, &viafb_dfph_proc_fops);
_

Patches currently in -mm which might be from error27@gmail.com are

origin.patch
linux-next.patch

