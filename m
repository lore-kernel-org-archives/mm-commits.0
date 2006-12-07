From: akpm@osdl.org
Subject: - honour-mnt_noexec-for-access.patch removed from -mm tree
Date: Thu, 07 Dec 2006 15:01:03 -0800
Message-ID: <200612072301.kB7N13Ag029694@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:52101 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163859AbWLGXEi (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 18:04:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: stsp@aknet.ru, alan@lxorguk.ukuu.org.uk, arjan@infradead.org, drepper@redhat.com, hugh@veritas.com, jakub@redhat.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     honour MNT_NOEXEC for access()
has been removed from the -mm tree.  Its filename was
     honour-mnt_noexec-for-access.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: honour MNT_NOEXEC for access()
From: Stas Sergeev <stsp@aknet.ru>

Make access(X_OK) take the "noexec" mount option into account.

Signed-off-by: Stas Sergeev <stsp@aknet.ru>
Cc: Jakub Jelinek <jakub@redhat.com>
Cc: Arjan van de Ven <arjan@infradead.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Hugh Dickins <hugh@veritas.com>
Cc: Ulrich Drepper <drepper@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/namei.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN fs/namei.c~honour-mnt_noexec-for-access fs/namei.c
--- a/fs/namei.c~honour-mnt_noexec-for-access
+++ a/fs/namei.c
@@ -249,9 +249,11 @@ int permission(struct inode *inode, int 
 
 	/*
 	 * MAY_EXEC on regular files requires special handling: We override
-	 * filesystem execute permissions if the mode bits aren't set.
+	 * filesystem execute permissions if the mode bits aren't set or
+	 * the fs is mounted with the "noexec" flag.
 	 */
-	if ((mask & MAY_EXEC) && S_ISREG(mode) && !(mode & S_IXUGO))
+	if ((mask & MAY_EXEC) && S_ISREG(mode) && (!(mode & S_IXUGO) ||
+			(nd && nd->mnt && (nd->mnt->mnt_flags & MNT_NOEXEC))))
 		return -EACCES;
 
 	/* Ordinary permission routines do not understand MAY_APPEND. */
_

Patches currently in -mm which might be from stsp@aknet.ru are

origin.patch

