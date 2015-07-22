From: akpm@linux-foundation.org
Subject: + ocfs2-export-ocfs2_kset-for-online-file-check.patch added to
 -mm tree
Date: Wed, 22 Jul 2015 13:14:22 -0700
Message-ID: <55aff99e.4Vu2ITfaqukyk2+n%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46954 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751940AbbGVUOX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 22 Jul 2015 16:14:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ghe@suse.com, jlbec@evilplan.org, mfasheh@suse.com, rgoldwyn@suse.de, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: export ocfs2_kset for online file check
has been added to the -mm tree.  Its filename is
     ocfs2-export-ocfs2_kset-for-online-file-check.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-export-ocfs2_kset-for-online-file-check.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-export-ocfs2_kset-for-online-file-check.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Gang He <ghe@suse.com>
Subject: ocfs2: export ocfs2_kset for online file check

When there are errors in the ocfs2 filesystem, they are usually
accompanied by the inode number which caused the error.  This inode number
would be the input to fixing the file.  One of these options could be
considered: A file in the sys filesytem which would accept inode numbers. 
This could be used to communication back what has to be fixed or is fixed.

You could write:

	$# echo "CHECK <inode>" > /sys/fs/ocfs2/devname/filecheck
or

	$# echo "FIX <inode>" > /sys/fs/ocfs2/devname/filecheck



This patch (of 5):

Export ocfs2_kset object from ocfs2_stackglue kernel module, then online
file check code will create the related sysfiles under ocfs2_kset object.

Signed-off-by: Gang He <ghe@suse.com>
Reviewed-by: Goldwyn Rodrigues <rgoldwyn@suse.de>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/stackglue.c |    3 ++-
 fs/ocfs2/stackglue.h |    2 ++
 2 files changed, 4 insertions(+), 1 deletion(-)

diff -puN fs/ocfs2/stackglue.c~ocfs2-export-ocfs2_kset-for-online-file-check fs/ocfs2/stackglue.c
--- a/fs/ocfs2/stackglue.c~ocfs2-export-ocfs2_kset-for-online-file-check
+++ a/fs/ocfs2/stackglue.c
@@ -629,7 +629,8 @@ static struct attribute_group ocfs2_attr
 	.attrs = ocfs2_attrs,
 };
 
-static struct kset *ocfs2_kset;
+struct kset *ocfs2_kset;
+EXPORT_SYMBOL_GPL(ocfs2_kset);
 
 static void ocfs2_sysfs_exit(void)
 {
diff -puN fs/ocfs2/stackglue.h~ocfs2-export-ocfs2_kset-for-online-file-check fs/ocfs2/stackglue.h
--- a/fs/ocfs2/stackglue.h~ocfs2-export-ocfs2_kset-for-online-file-check
+++ a/fs/ocfs2/stackglue.h
@@ -298,4 +298,6 @@ void ocfs2_stack_glue_set_max_proto_vers
 int ocfs2_stack_glue_register(struct ocfs2_stack_plugin *plugin);
 void ocfs2_stack_glue_unregister(struct ocfs2_stack_plugin *plugin);
 
+extern struct kset *ocfs2_kset;
+
 #endif  /* STACKGLUE_H */
_

Patches currently in -mm which might be from ghe@suse.com are

ocfs2-export-ocfs2_kset-for-online-file-check.patch
ocfs2-sysfile-interfaces-for-online-file-check.patch
ocfs2-sysfile-interfaces-for-online-file-check-fix.patch
ocfs2-create-remove-sysfile-for-online-file-check.patch
ocfs2-check-fix-inode-block-for-online-file-check.patch
ocfs2-add-feature-document-for-online-file-check.patch

