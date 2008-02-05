From: akpm@linux-foundation.org
Subject: - hugetlb-allow-sticky-directory-mount-option.patch removed from -mm tree
Date: Tue, 05 Feb 2008 14:29:48 -0800
Message-ID: <200802052229.m15MTTM1011987@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41349 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762408AbYBEWnq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Feb 2008 17:43:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kenchen@google.com, agl@us.ibm.com, hermes@gibson.dropbear.id.au, pbadari@us.ibm.com, wli@holomorphy.com, mm-commits@vger.kernel.org


The patch titled
     hugetlb: allow sticky directory mount option
has been removed from the -mm tree.  Its filename was
     hugetlb-allow-sticky-directory-mount-option.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hugetlb: allow sticky directory mount option
From: "Ken Chen" <kenchen@google.com>

Allow sticky directory mount option for hugetlbfs.  This allows admin
to create a shared hugetlbfs mount point for multiple users, while
prevent accidental file deletion that users may step on each other.
It is similiar to default tmpfs mount option, or typical option used
on /tmp.

Signed-off-by: Ken Chen <kenchen@google.com>
Cc: Badari Pulavarty <pbadari@us.ibm.com>
Cc: Adam Litke <agl@us.ibm.com>
Cc: David Gibson <hermes@gibson.dropbear.id.au>
Cc: William Lee Irwin III <wli@holomorphy.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hugetlbfs/inode.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/hugetlbfs/inode.c~hugetlb-allow-sticky-directory-mount-option fs/hugetlbfs/inode.c
--- a/fs/hugetlbfs/inode.c~hugetlb-allow-sticky-directory-mount-option
+++ a/fs/hugetlbfs/inode.c
@@ -768,7 +768,7 @@ hugetlbfs_parse_options(char *options, s
 		case Opt_mode:
 			if (match_octal(&args[0], &option))
  				goto bad_val;
-			pconfig->mode = option & 0777U;
+			pconfig->mode = option & 01777U;
 			break;
 
 		case Opt_size: {
_

Patches currently in -mm which might be from kenchen@google.com are

origin.patch
mount-options-fix-hugetlbfs.patch
