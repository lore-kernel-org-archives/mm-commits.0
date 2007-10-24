From: akpm@linux-foundation.org
Subject: + hugetlb-allow-sticky-directory-mount-option.patch added to -mm tree
Date: Tue, 23 Oct 2007 23:19:01 -0700
Message-ID: <200710240619.l9O6J1qW026080@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54189 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754080AbXJXGTe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 24 Oct 2007 02:19:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kenchen@google.com, agl@us.ibm.com, hermes@gibson.dropbear.id.au, pbadari@us.ibm.com, wli@holomorphy.com


The patch titled
     hugetlb: allow sticky directory mount option
has been added to the -mm tree.  Its filename is
     hugetlb-allow-sticky-directory-mount-option.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -769,7 +769,7 @@ hugetlbfs_parse_options(char *options, s
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
hugetlb-allow-sticky-directory-mount-option.patch
