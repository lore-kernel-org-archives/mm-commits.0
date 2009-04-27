From: akpm@linux-foundation.org
Subject: [merged] cachefiles-fix-the-documentation-to-use-the-correct-credential-pointer-names.patch removed from -mm tree
Date: Mon, 27 Apr 2009 11:17:33 -0700
Message-ID: <200904271817.n3RIHXje009882@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50640 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751739AbZD0STt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 27 Apr 2009 14:19:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: marc.c.dionne@gmail.com, dhowells@redhat.com, mm-commits@vger.kernel.org


The patch titled
     CacheFiles: Fix the documentation to use the correct credential pointer names
has been removed from the -mm tree.  Its filename was
     cachefiles-fix-the-documentation-to-use-the-correct-credential-pointer-names.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: CacheFiles: Fix the documentation to use the correct credential pointer names
From: Marc Dionne <marc.c.dionne@gmail.com>

Adjust the CacheFiles documentation to use the correct names of the
credential pointers in task_struct.

The documentation was using names from the old versions of the credentials
patches.

Signed-off-by: Marc Dionne <marc.c.dionne@gmail.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/caching/cachefiles.txt |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN Documentation/filesystems/caching/cachefiles.txt~cachefiles-fix-the-documentation-to-use-the-correct-credential-pointer-names Documentation/filesystems/caching/cachefiles.txt
--- a/Documentation/filesystems/caching/cachefiles.txt~cachefiles-fix-the-documentation-to-use-the-correct-credential-pointer-names
+++ a/Documentation/filesystems/caching/cachefiles.txt
@@ -407,7 +407,7 @@ A NOTE ON SECURITY
 ==================
 
 CacheFiles makes use of the split security in the task_struct.  It allocates
-its own task_security structure, and redirects current->act_as to point to it
+its own task_security structure, and redirects current->cred to point to it
 when it acts on behalf of another process, in that process's context.
 
 The reason it does this is that it calls vfs_mkdir() and suchlike rather than
@@ -429,9 +429,9 @@ This means it may lose signals or ptrace
 the process looks like in /proc.
 
 So CacheFiles makes use of a logical split in the security between the
-objective security (task->sec) and the subjective security (task->act_as).  The
-objective security holds the intrinsic security properties of a process and is
-never overridden.  This is what appears in /proc, and is what is used when a
+objective security (task->real_cred) and the subjective security (task->cred).
+The objective security holds the intrinsic security properties of a process and
+is never overridden.  This is what appears in /proc, and is what is used when a
 process is the target of an operation by some other process (SIGKILL for
 example).
 
_

Patches currently in -mm which might be from marc.c.dionne@gmail.com are

origin.patch

