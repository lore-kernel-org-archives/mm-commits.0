From: akpm@linux-foundation.org
Subject: + drivers-video-via-viafbdevc-fix-oops-with-no-proc.patch added to -mm tree
Date: Wed, 25 Nov 2009 14:20:56 -0800
Message-ID: <200911252220.nAPMKu4F023085@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60701 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964928AbZKYWVQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 25 Nov 2009 17:21:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: error27@gmail.com, FlorianSchandinat@gmx.de, JosephChan@via.com.tw, ScottFang@viatech.com.cn


The patch titled
     drivers/video/via/viafbdev.c: fix oops with no /proc
has been added to the -mm tree.  Its filename is
     drivers-video-via-viafbdevc-fix-oops-with-no-proc.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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

drivers-rtc-rtc-pcf50633c-fix-use-after-free-in-pcf50633_rtc_probe.patch
drivers-video-via-viafbdevc-fix-oops-with-no-proc.patch
linux-next.patch
kexec-premit-reduction-of-the-reserved-memory-size-fix.patch

