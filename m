From: akpm@linux-foundation.org
Subject: - ecryptfs-zero-out-last-page-for-llseek-write.patch removed from -mm tree
Date: Fri, 29 Jun 2007 13:40:14 -0700
Message-ID: <200706292040.l5TKeEiL022414@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50213 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753840AbXF2UkW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 29 Jun 2007 16:40:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhalcrow@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     zero out last page for llseek/write
has been removed from the -mm tree.  Its filename was
     ecryptfs-zero-out-last-page-for-llseek-write.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: zero out last page for llseek/write
From: Michael Halcrow <mhalcrow@us.ibm.com>

When one llseek's past the end of the file and then writes, every page past
the previous end of the file should be cleared.  Trevor found that the code,
as is, does not assure that the very last page is always cleared.  This patch
takes care of that.

Signed-off-by: Michael Halcrow <mhalcrow@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ecryptfs/mmap.c |    2 ++
 1 files changed, 2 insertions(+)

diff -puN fs/ecryptfs/mmap.c~ecryptfs-zero-out-last-page-for-llseek-write fs/ecryptfs/mmap.c
--- a/fs/ecryptfs/mmap.c~ecryptfs-zero-out-last-page-for-llseek-write
+++ a/fs/ecryptfs/mmap.c
@@ -422,6 +422,8 @@ static int ecryptfs_prepare_write(struct
 				goto out;
 			}
 		}
+		if (end_of_prev_pg_pos + 1 > i_size_read(page->mapping->host))
+			zero_user_page(page, 0, PAGE_CACHE_SIZE, KM_USER0);
 	}
 out:
 	return rc;
_

Patches currently in -mm which might be from mhalcrow@us.ibm.com are

origin.patch
git-unionfs.patch
fs-remove-some-aop_truncated_page.patch
couple-fixes-to-fs-ecryptfs-inodec.patch
ecryptfs-move-ecryptfs-docs-into-documentation-filesystems.patch
fs-introduce-vfs_path_lookup.patch
sunrpc-use-vfs_path_lookup.patch
nfsctl-use-vfs_path_lookup.patch
fs-mark-link_path_walk-static.patch
fs-remove-path_walk-export.patch
