From: akpm@linux-foundation.org
Subject: [merged]
 kernel-ksysfs-add-__ro_after_init-to-bin_attribute-structure.patch removed
 from -mm tree
Date: Mon, 27 Feb 2017 12:28:50 -0800
Message-ID: <58b48c02.UNYtcdyWeHWX5l6z%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34536 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751571AbdB0Ukd (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 27 Feb 2017 15:40:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bhumirks@gmail.com, keescook@chromium.org, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/ksysfs.c: add __ro_after_init to bin_attribute structure
has been removed from the -mm tree.  Its filename was
     kernel-ksysfs-add-__ro_after_init-to-bin_attribute-structure.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Bhumika Goyal <bhumirks@gmail.com>
Subject: kernel/ksysfs.c: add __ro_after_init to bin_attribute structure

The object notes_attr of type bin_attribute is not modified after getting
initailized by ksysfs_init.  Apart from initialization in ksysfs_init it
is also passed as an argument to the function sysfs_create_bin_file but
this argument is of type const.  Therefore, add __ro_after_init to its
declaration.

Link: http://lkml.kernel.org/r/1486839969-16891-1-git-send-email-bhumirks@gmail.com
Signed-off-by: Bhumika Goyal <bhumirks@gmail.com>
Acked-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/ksysfs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/ksysfs.c~kernel-ksysfs-add-__ro_after_init-to-bin_attribute-structure kernel/ksysfs.c
--- a/kernel/ksysfs.c~kernel-ksysfs-add-__ro_after_init-to-bin_attribute-structure
+++ a/kernel/ksysfs.c
@@ -195,7 +195,7 @@ static ssize_t notes_read(struct file *f
 	return count;
 }
 
-static struct bin_attribute notes_attr = {
+static struct bin_attribute notes_attr __ro_after_init  = {
 	.attr = {
 		.name = "notes",
 		.mode = S_IRUGO,
_

Patches currently in -mm which might be from bhumirks@gmail.com are


