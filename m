From: akpm@linux-foundation.org
Subject: + ocfs2-add-dlm_recover_callback_support-in-sysfs.patch added to
 -mm tree
Date: Tue, 25 Feb 2014 12:19:46 -0800
Message-ID: <530cfae2.OmTHOj3v2GKQWjGN%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60288 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753330AbaBYUTr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 25 Feb 2014 15:19:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rgoldwyn@suse.com, mfasheh@suse.com, jlbec@evilplan.org, rgoldwyn@suse.de

Subject: + ocfs2-add-dlm_recover_callback_support-in-sysfs.patch added to -mm tree
To: rgoldwyn@suse.de,jlbec@evilplan.org,mfasheh@suse.com,rgoldwyn@suse.com
From: akpm@linux-foundation.org
Date: Tue, 25 Feb 2014 12:19:46 -0800


The patch titled
     Subject: ocfs2: add dlm_recover_callback_support in sysfs
has been added to the -mm tree.  Its filename is
     ocfs2-add-dlm_recover_callback_support-in-sysfs.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-add-dlm_recover_callback_support-in-sysfs.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-add-dlm_recover_callback_support-in-sysfs.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Subject: ocfs2: add dlm_recover_callback_support in sysfs

This is a part of the nocontrold feature which was incorporated sometime
back.

This is required for backward compatibility of the tools, specifically the
scenario where the tools with recovery callback is used with a kernel not
using the recovery callbacks (older kernel + newer tools).  The tools look
for this file to understand if the kernel supports DLM recovery callbacks.

For kernels which support recovery callbacks but will miss this patch,
ocfs2 will continue to use the older API and would still be able to mount
the filesystem.

Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/stackglue.c |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff -puN fs/ocfs2/stackglue.c~ocfs2-add-dlm_recover_callback_support-in-sysfs fs/ocfs2/stackglue.c
--- a/fs/ocfs2/stackglue.c~ocfs2-add-dlm_recover_callback_support-in-sysfs
+++ a/fs/ocfs2/stackglue.c
@@ -601,11 +601,27 @@ static struct kobj_attribute ocfs2_attr_
 	       ocfs2_cluster_stack_show,
 	       ocfs2_cluster_stack_store);
 
+
+
+static ssize_t ocfs2_dlm_recover_show(struct kobject *kobj,
+					struct kobj_attribute *attr,
+					char *buf)
+{
+	ssize_t ret;
+	ret = snprintf(buf, PAGE_SIZE, "1\n");
+	return ret;
+}
+
+static struct kobj_attribute ocfs2_attr_dlm_recover_support =
+	__ATTR(dlm_recover_callback_support, S_IFREG | S_IRUGO,
+	       ocfs2_dlm_recover_show, NULL);
+
 static struct attribute *ocfs2_attrs[] = {
 	&ocfs2_attr_max_locking_protocol.attr,
 	&ocfs2_attr_loaded_cluster_plugins.attr,
 	&ocfs2_attr_active_cluster_plugin.attr,
 	&ocfs2_attr_cluster_stack.attr,
+	&ocfs2_attr_dlm_recover_support.attr,
 	NULL,
 };
 
_

Patches currently in -mm which might be from rgoldwyn@suse.de are

ocfs2-fix-quota-file-corruption.patch
ocfs2-revert-iput-deferring-code-in-ocfs2_drop_dentry_lock.patch
ocfs2-add-dlm_recover_callback_support-in-sysfs.patch

