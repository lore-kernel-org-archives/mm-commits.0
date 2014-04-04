From: akpm@linux-foundation.org
Subject: [merged] ocfs2-add-dlm_recover_callback_support-in-sysfs.patch
 removed from -mm tree
Date: Fri, 04 Apr 2014 12:30:09 -0700
Message-ID: <533f0841.8vgXq0MX/w55GgOz%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42720 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754458AbaDDTaK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Apr 2014 15:30:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sfr@canb.auug.org.au, rgoldwyn@suse.com, mfasheh@suse.com, jlbec@evilplan.org, rgoldwyn@suse.de

Subject: [merged] ocfs2-add-dlm_recover_callback_support-in-sysfs.patch removed from -mm tree
To: rgoldwyn@suse.de,jlbec@evilplan.org,mfasheh@suse.com,rgoldwyn@suse.com,sfr@canb.auug.org.au,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 04 Apr 2014 12:30:09 -0700


The patch titled
     Subject: ocfs2: add dlm_recover_callback_support in sysfs
has been removed from the -mm tree.  Its filename was
     ocfs2-add-dlm_recover_callback_support-in-sysfs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

[akpm@linux-foundation.org: simplify]
[sfr@canb.auug.org.au: VERIFY_OCTAL_PERMISSIONS fix up]
Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/stackglue.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff -puN fs/ocfs2/stackglue.c~ocfs2-add-dlm_recover_callback_support-in-sysfs fs/ocfs2/stackglue.c
--- a/fs/ocfs2/stackglue.c~ocfs2-add-dlm_recover_callback_support-in-sysfs
+++ a/fs/ocfs2/stackglue.c
@@ -603,11 +603,25 @@ static struct kobj_attribute ocfs2_attr_
 	       ocfs2_cluster_stack_show,
 	       ocfs2_cluster_stack_store);
 
+
+
+static ssize_t ocfs2_dlm_recover_show(struct kobject *kobj,
+					struct kobj_attribute *attr,
+					char *buf)
+{
+	return snprintf(buf, PAGE_SIZE, "1\n");
+}
+
+static struct kobj_attribute ocfs2_attr_dlm_recover_support =
+	__ATTR(dlm_recover_callback_support, S_IRUGO,
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

origin.patch

