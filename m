From: akpm@linux-foundation.org
Subject: + cap-shmmax-at-int_max-in-compat-shminfo.patch added to -mm tree
Date: Wed, 28 Feb 2007 22:42:11 -0800
Message-ID: <200703010642.l216gBCN006672@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:57714 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932696AbXCAGmZ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 1 Mar 2007 01:42:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: streeter@redhat.com


The patch titled
     Cap shmmax at INT_MAX in compat shminfo
has been added to the -mm tree.  Its filename is
     cap-shmmax-at-int_max-in-compat-shminfo.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Cap shmmax at INT_MAX in compat shminfo
From: Guy Streeter <streeter@redhat.com>

The value of shmmax may be larger than will fit in the struct used by
the 32bit compat version of sys_shmctl. This change mirrors what the
normal sys_shmctl does when called with the old IPC_INFO command.

Signed-off-by: Guy Streeter <streeter@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/compat.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN ipc/compat.c~cap-shmmax-at-int_max-in-compat-shminfo ipc/compat.c
--- a/ipc/compat.c~cap-shmmax-at-int_max-in-compat-shminfo
+++ a/ipc/compat.c
@@ -542,6 +542,8 @@ static inline int put_compat_shminfo64(s
 
 	if (!access_ok(VERIFY_WRITE, up64, sizeof(*up64)))
 		return -EFAULT;
+	if (smi->shmmax > INT_MAX)
+		smi->shmmax = INT_MAX;
 	err  = __put_user(smi->shmmax, &up64->shmmax);
 	err |= __put_user(smi->shmmin, &up64->shmmin);
 	err |= __put_user(smi->shmmni, &up64->shmmni);
@@ -557,6 +559,8 @@ static inline int put_compat_shminfo(str
 
 	if (!access_ok(VERIFY_WRITE, up, sizeof(*up)))
 		return -EFAULT;
+	if (smi->shmmax > INT_MAX)
+		smi->shmmax = INT_MAX;
 	err  = __put_user(smi->shmmax, &up->shmmax);
 	err |= __put_user(smi->shmmin, &up->shmmin);
 	err |= __put_user(smi->shmmni, &up->shmmni);
_

Patches currently in -mm which might be from streeter@redhat.com are

cap-shmmax-at-int_max-in-compat-shminfo.patch
