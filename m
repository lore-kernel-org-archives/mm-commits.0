From: akpm@linux-foundation.org
Subject: +
 ocfs2-convert-use-of-typedef-ctl_table-to-struct-ctl_table.patch added to
 -mm tree
Date: Thu, 07 Nov 2013 13:55:38 -0800
Message-ID: <527c0c5a.xHSLThp3GlVy+8+w%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49232 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752690Ab3KGVzj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Nov 2013 16:55:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mfasheh@suse.com, jlbec@evilplan.org, joe@perches.com

Subject: + ocfs2-convert-use-of-typedef-ctl_table-to-struct-ctl_table.patch added to -mm tree
To: joe@perches.com,jlbec@evilplan.org,mfasheh@suse.com
From: akpm@linux-foundation.org
Date: Thu, 07 Nov 2013 13:55:38 -0800


The patch titled
     Subject: ocfs2: convert use of typedef ctl_table to struct ctl_table
has been added to the -mm tree.  Its filename is
     ocfs2-convert-use-of-typedef-ctl_table-to-struct-ctl_table.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-convert-use-of-typedef-ctl_table-to-struct-ctl_table.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-convert-use-of-typedef-ctl_table-to-struct-ctl_table.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: ocfs2: convert use of typedef ctl_table to struct ctl_table

This typedef is unnecessary and should just be removed.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Mark Fasheh <mfasheh@suse.com>
Acked-by: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/stackglue.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN fs/ocfs2/stackglue.c~ocfs2-convert-use-of-typedef-ctl_table-to-struct-ctl_table fs/ocfs2/stackglue.c
--- a/fs/ocfs2/stackglue.c~ocfs2-convert-use-of-typedef-ctl_table-to-struct-ctl_table
+++ a/fs/ocfs2/stackglue.c
@@ -643,7 +643,7 @@ error:
 
 #define FS_OCFS2_NM		1
 
-static ctl_table ocfs2_nm_table[] = {
+static struct ctl_table ocfs2_nm_table[] = {
 	{
 		.procname	= "hb_ctl_path",
 		.data		= ocfs2_hb_ctl_path,
@@ -654,7 +654,7 @@ static ctl_table ocfs2_nm_table[] = {
 	{ }
 };
 
-static ctl_table ocfs2_mod_table[] = {
+static struct ctl_table ocfs2_mod_table[] = {
 	{
 		.procname	= "nm",
 		.data		= NULL,
@@ -665,7 +665,7 @@ static ctl_table ocfs2_mod_table[] = {
 	{ }
 };
 
-static ctl_table ocfs2_kern_table[] = {
+static struct ctl_table ocfs2_kern_table[] = {
 	{
 		.procname	= "ocfs2",
 		.data		= NULL,
@@ -676,7 +676,7 @@ static ctl_table ocfs2_kern_table[] = {
 	{ }
 };
 
-static ctl_table ocfs2_root_table[] = {
+static struct ctl_table ocfs2_root_table[] = {
 	{
 		.procname	= "fs",
 		.data		= NULL,
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
kernel-timerc-convert-kmalloc_nodegfp_zero-to-kzalloc_node.patch
ocfs2-convert-use-of-typedef-ctl_table-to-struct-ctl_table.patch
ksm-remove-redundant-__gfp_zero-from-kcalloc.patch
printk-report-console-names-during-cut-over.patch
kernel-printk-printkc-convert-to-pr_foo.patch
vsprintf-check-real-user-group-id-for-%pk.patch
printkc-comments-should-refer-to-proc-vmcore-instead-of-proc-vmcoreinfo.patch
printk-cache-mark-printk_once-test-variable-__read_mostly.patch
printk-cache-mark-printk_once-test-variable-__read_mostly-fix.patch
get_maintainerpl-incomplete-output.patch
checkpatch-report-missing-spaces-around-trigraphs-with-strict.patch
checkpatch-extend-camelcase-types-and-ignore-existing-camelcase-uses-in-a-patch.patch
checkpatch-update-seq_foo-tests.patch
checkpatch-find-camelcase-definitions-of-struct-union-enum.patch
checkpatch-add-test-for-defines-of-arch_has_foo.patch
checkpatch-add-rules-to-check-init-attribute-and-const-defects.patch
checkpatch-make-the-memory-barrier-test-noisier.patch
checkpatchpl-check-for-the-fsf-mailing-address.patch
checkpatch-improve-return-is-not-a-function-test.patch
checkpatch-add-check-for-sscanf-without-return-use.patch
checkpatch-add-check-for-sscanf-without-return-use-v2.patch
drivers-rtc-rtc-puv3c-use-dev_dbg-instead-of-pr_debug.patch
drivers-rtc-rtc-pl030c-use-devm_kzalloc-instead-of-kmalloc.patch
kernel-modulec-use-pr_foo.patch
linux-next.patch
seq_file-introduce-seq_setwidth-and-seq_pad.patch
seq_file-remove-%n-usage-from-seq_file-users.patch
vsprintf-ignore-%n-again.patch

