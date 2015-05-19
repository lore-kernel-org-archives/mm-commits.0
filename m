From: akpm@linux-foundation.org
Subject: + fs-omfs-add-null-terminator-in-the-end-up-the-token-list.patch
 added to -mm tree
Date: Tue, 19 May 2015 16:20:13 -0700
Message-ID: <555bc52d.VjjJ4wj1CCKG/Ggn%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52397 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751843AbbESXUO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 19 May 2015 19:20:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sasha.levin@oracle.com, me@bobcopeland.com, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: fs, omfs: add NULL terminator in the end up the token list
has been added to the -mm tree.  Its filename is
     fs-omfs-add-null-terminator-in-the-end-up-the-token-list.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-omfs-add-null-terminator-in-the-end-up-the-token-list.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-omfs-add-null-terminator-in-the-end-up-the-token-list.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

fs-omfs-add-null-terminator-in-the-end-up-the-token-list.patch
linux-next.patch
do_shared_fault-check-that-mmap_sem-is-held.patch

