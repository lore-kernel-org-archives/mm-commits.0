From: akpm@linux-foundation.org
Subject: - fdtable-make-fdarray-and-fdsets-equal-in-size-slim.patch removed from -mm tree
Date: Mon, 05 Mar 2007 18:14:55 -0800
Message-ID: <200703060214.l262EtYF009123@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:47232 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933853AbXCFCO5 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 5 Mar 2007 21:14:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vlobanov@speakeasy.net, mm-commits@vger.kernel.org


The patch titled
     fdtable: Make fdarray and fdsets equal in size (slim part)
has been removed from the -mm tree.  Its filename was
     fdtable-make-fdarray-and-fdsets-equal-in-size-slim.patch

This patch was dropped because it was folded into slim-main-patch.patch

------------------------------------------------------
Subject: fdtable: Make fdarray and fdsets equal in size (slim part)
From: Vadim Lobanov <vlobanov@speakeasy.net>

Update slim for fdtable-make-fdarray-and-fdsets-equal-in-size.patch

Signed-off-by: Vadim Lobanov <vlobanov@speakeasy.net>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 security/slim/slm_main.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN security/slim/slm_main.c~fdtable-make-fdarray-and-fdsets-equal-in-size-slim security/slim/slm_main.c
--- a/security/slim/slm_main.c~fdtable-make-fdarray-and-fdsets-equal-in-size-slim
+++ a/security/slim/slm_main.c
@@ -157,7 +157,8 @@ static int has_file_wperm(struct slm_fil
 	spin_lock(&files->file_lock);
 	fdt = files_fdtable(files);
 
-	while((fd=find_next_bit(fdt->open_fds->fds_bits, fdt->max_fdset, fd)) < fdt->max_fdset) {
+	while ((fd = find_next_bit(fdt->open_fds->fds_bits,
+				   fdt->max_fds, fd)) < fdt->max_fds) {
 		file = fdt->fd[fd++];
 		if (file)
 			rc = mark_has_file_wperm(file, cur_level);
_

Patches currently in -mm which might be from vlobanov@speakeasy.net are

slim-main-patch.patch
fdtable-make-fdarray-and-fdsets-equal-in-size-slim.patch
