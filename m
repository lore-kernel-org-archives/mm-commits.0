From: akpm@linux-foundation.org
Subject: [patch 105/124] kernel/ksysfs.c: add __ro_after_init to
 bin_attribute structure
Date: Fri, 24 Feb 2017 15:00:46 -0800
Message-ID: <58b0bb1e.P/IEq/AFL8gVLTjd%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39040 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751756AbdBXXAs (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 24 Feb 2017 18:00:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, bhumirks@gmail.com, keescook@chromium.org

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
