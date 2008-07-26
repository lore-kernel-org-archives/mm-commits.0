From: akpm@linux-foundation.org
Subject: - make-cgroup_seqfile_release-static.patch removed from -mm tree
Date: Sat, 26 Jul 2008 14:18:06 -0700
Message-ID: <200807262118.m6QLI6Ui020060@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52769 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758030AbYGZVSV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 26 Jul 2008 17:18:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@kernel.org, menage@google.com, mm-commits@vger.kernel.org


The patch titled
     make cgroup_seqfile_release() static
has been removed from the -mm tree.  Its filename was
     make-cgroup_seqfile_release-static.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: make cgroup_seqfile_release() static
From: Adrian Bunk <bunk@kernel.org>

cgroup_seqfile_release() can become static.

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Acked-by: Paul Menage <menage@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cgroup.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/cgroup.c~make-cgroup_seqfile_release-static kernel/cgroup.c
--- a/kernel/cgroup.c~make-cgroup_seqfile_release-static
+++ a/kernel/cgroup.c
@@ -1529,7 +1529,7 @@ static int cgroup_seqfile_show(struct se
 	return cft->read_seq_string(state->cgroup, cft, m);
 }
 
-int cgroup_seqfile_release(struct inode *inode, struct file *file)
+static int cgroup_seqfile_release(struct inode *inode, struct file *file)
 {
 	struct seq_file *seq = file->private_data;
 	kfree(seq->private);
_

Patches currently in -mm which might be from bunk@kernel.org are

origin.patch
linux-next.patch
m32r-remove-the-unused-nohighmem-option.patch
if-0-ses_match_host.patch
git-xtensa.patch
include-linux-kernelh-userspace-header-cleanup.patch
make-mm-rmapc-anon_vma_cachep-static.patch
reiser4.patch

