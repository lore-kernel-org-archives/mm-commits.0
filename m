From: akpm@linux-foundation.org
Subject: [merged] ulimit-raise-default-hard-ulimit-on-number-of-files-to-4096.patch removed from -mm tree
Date: Wed, 25 May 2011 13:31:10 -0700
Message-ID: <201105252029.p4PKTXx6014851@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55022 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756467Ab1EYUtF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 25 May 2011 16:49:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tim.gardner@canonical.com, dank@kegel.com, hch@lst.de, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     ulimit: raise default hard ulimit on number of files to 4096
has been removed from the -mm tree.  Its filename was
     ulimit-raise-default-hard-ulimit-on-number-of-files-to-4096.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ulimit: raise default hard ulimit on number of files to 4096
From: Tim Gardner <tim.gardner@canonical.com>

Apps are increasingly using more than 1024 file descriptors.  See
discussion in several distro bug trackers, e.g.  BugLink:
http://bugs.launchpad.net/bugs/663090
https://issues.rpath.com/browse/RPL-2054

You don't want to raise the default soft limit, since that might break
apps that use select(), but it's safe to raise the default hard limit;
that way, apps that know they need lots of file descriptors can raise
their soft limit without needing root, and without user intervention.

Ubuntu is doing this with a kernel change because they have a policy of
not changing kernel defaults in userland.

While 4096 might not be enough for *all* apps, it seems to be plenty for
the apps I've seen lately that are unhappy with 1024.

Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
Cc: Dan Kegel <dank@kegel.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/resource.h |    2 +-
 include/linux/fs.h             |    3 ++-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff -puN include/asm-generic/resource.h~ulimit-raise-default-hard-ulimit-on-number-of-files-to-4096 include/asm-generic/resource.h
--- a/include/asm-generic/resource.h~ulimit-raise-default-hard-ulimit-on-number-of-files-to-4096
+++ a/include/asm-generic/resource.h
@@ -78,7 +78,7 @@
 	[RLIMIT_CORE]		= {              0,  RLIM_INFINITY },	\
 	[RLIMIT_RSS]		= {  RLIM_INFINITY,  RLIM_INFINITY },	\
 	[RLIMIT_NPROC]		= {              0,              0 },	\
-	[RLIMIT_NOFILE]		= {       INR_OPEN,       INR_OPEN },	\
+	[RLIMIT_NOFILE]		= {   INR_OPEN_CUR,   INR_OPEN_MAX },	\
 	[RLIMIT_MEMLOCK]	= {    MLOCK_LIMIT,    MLOCK_LIMIT },	\
 	[RLIMIT_AS]		= {  RLIM_INFINITY,  RLIM_INFINITY },	\
 	[RLIMIT_LOCKS]		= {  RLIM_INFINITY,  RLIM_INFINITY },	\
diff -puN include/linux/fs.h~ulimit-raise-default-hard-ulimit-on-number-of-files-to-4096 include/linux/fs.h
--- a/include/linux/fs.h~ulimit-raise-default-hard-ulimit-on-number-of-files-to-4096
+++ a/include/linux/fs.h
@@ -23,7 +23,8 @@
 
 /* Fixed constants first: */
 #undef NR_OPEN
-#define INR_OPEN 1024		/* Initial setting for nfile rlimits */
+#define INR_OPEN_CUR 1024	/* Initial setting for nfile rlimits */
+#define INR_OPEN_MAX 4096	/* Hard limit for nfile rlimits */
 
 #define BLOCK_SIZE_BITS 10
 #define BLOCK_SIZE (1<<BLOCK_SIZE_BITS)
_

Patches currently in -mm which might be from tim.gardner@canonical.com are

origin.patch

