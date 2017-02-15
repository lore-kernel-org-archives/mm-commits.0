From: akpm@linux-foundation.org
Subject: +
 kernel-ksysfs-add-__ro_after_init-to-bin_attribute-structure.patch added to -mm tree
Date: Tue, 14 Feb 2017 16:54:41 -0800
Message-ID: <58a3a6d1.TUsfj/XT2HFHF3my%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60764 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750905AbdBOAym (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 14 Feb 2017 19:54:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bhumirks@gmail.com, keescook@chromium.org, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/ksysfs.c: add __ro_after_init to bin_attribute structure
has been added to the -mm tree.  Its filename is
     kernel-ksysfs-add-__ro_after_init-to-bin_attribute-structure.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kernel-ksysfs-add-__ro_after_init-to-bin_attribute-structure.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kernel-ksysfs-add-__ro_after_init-to-bin_attribute-structure.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

kernel-ksysfs-add-__ro_after_init-to-bin_attribute-structure.patch

