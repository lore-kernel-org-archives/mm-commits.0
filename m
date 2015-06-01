From: akpm@linux-foundation.org
Subject: [merged]
 fs-omfs-add-null-terminator-in-the-end-up-the-token-list.patch removed from -mm tree
Date: Mon, 01 Jun 2015 12:15:56 -0700
Message-ID: <556caf6c.2GSH7NByj5gd4ICl%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47429 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753013AbbFATP4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 1 Jun 2015 15:15:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sasha.levin@oracle.com, me@bobcopeland.com, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: fs, omfs: add NULL terminator in the end up the token list
has been removed from the -mm tree.  Its filename was
     fs-omfs-add-null-terminator-in-the-end-up-the-token-list.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Sasha Levin <sasha.levin@oracle.com>
Subject: fs, omfs: add NULL terminator in the end up the token list

match_token() expects a NULL terminator at the end of the token list so
that it would know where to stop.  Not having one causes it to overrun to
invalid memory.

In practice, passing a mount option that omfs didn't recognize would sometimes
panic the system.

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
Signed-off-by: Bob Copeland <me@bobcopeland.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/omfs/inode.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN fs/omfs/inode.c~fs-omfs-add-null-terminator-in-the-end-up-the-token-list fs/omfs/inode.c
--- a/fs/omfs/inode.c~fs-omfs-add-null-terminator-in-the-end-up-the-token-list
+++ a/fs/omfs/inode.c
@@ -359,7 +359,7 @@ nomem:
 }
 
 enum {
-	Opt_uid, Opt_gid, Opt_umask, Opt_dmask, Opt_fmask
+	Opt_uid, Opt_gid, Opt_umask, Opt_dmask, Opt_fmask, Opt_err
 };
 
 static const match_table_t tokens = {
@@ -368,6 +368,7 @@ static const match_table_t tokens = {
 	{Opt_umask, "umask=%o"},
 	{Opt_dmask, "dmask=%o"},
 	{Opt_fmask, "fmask=%o"},
+	{Opt_err, NULL},
 };
 
 static int parse_options(char *options, struct omfs_sb_info *sbi)
_

Patches currently in -mm which might be from sasha.levin@oracle.com are

linux-next.patch
do_shared_fault-check-that-mmap_sem-is-held.patch

