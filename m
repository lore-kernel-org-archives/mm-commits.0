From: akpm@linux-foundation.org
Subject: + do-not-limit-locked-memory-when-rlimit_memlock-is-rlim_infinity.patch added to -mm tree
Date: Fri, 13 Jul 2007 00:43:25 -0700
Message-ID: <200707130743.l6D7hP1s005939@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55639 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755111AbXGMHoW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 13 Jul 2007 03:44:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Herbert.van.den.Bergh@oracle.com, chris.mason@oracle.com, herbert.van.den.bergh@oracle.com


The patch titled
     do not limit locked memory when RLIMIT_MEMLOCK is RLIM_INFINITY
has been added to the -mm tree.  Its filename is
     do-not-limit-locked-memory-when-rlimit_memlock-is-rlim_infinity.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: do not limit locked memory when RLIMIT_MEMLOCK is RLIM_INFINITY
From: Herbert van den Bergh <Herbert.van.den.Bergh@oracle.com>

Fix a bug in mm/mlock.c on 32-bit architectures that prevents a user from
locking more than 4GB of shared memory, or allocating more than 4GB of
shared memory in hugepages, when rlim[RLIMIT_MEMLOCK] is set to
RLIM_INFINITY.

Signed-off-by: Herbert van den Bergh <herbert.van.den.bergh@oracle.com>
Acked-by: Chris Mason <chris.mason@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mlock.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN mm/mlock.c~do-not-limit-locked-memory-when-rlimit_memlock-is-rlim_infinity mm/mlock.c
--- a/mm/mlock.c~do-not-limit-locked-memory-when-rlimit_memlock-is-rlim_infinity
+++ a/mm/mlock.c
@@ -244,9 +244,12 @@ int user_shm_lock(size_t size, struct us
 
 	locked = (size + PAGE_SIZE - 1) >> PAGE_SHIFT;
 	lock_limit = current->signal->rlim[RLIMIT_MEMLOCK].rlim_cur;
+	if (lock_limit == RLIM_INFINITY)
+		allowed = 1;
 	lock_limit >>= PAGE_SHIFT;
 	spin_lock(&shmlock_user_lock);
-	if (locked + user->locked_shm > lock_limit && !capable(CAP_IPC_LOCK))
+	if (!allowed &&
+	    locked + user->locked_shm > lock_limit && !capable(CAP_IPC_LOCK))
 		goto out;
 	get_uid(user);
 	user->locked_shm += locked;
_

Patches currently in -mm which might be from Herbert.van.den.Bergh@oracle.com are

do-not-limit-locked-memory-when-rlimit_memlock-is-rlim_infinity.patch
