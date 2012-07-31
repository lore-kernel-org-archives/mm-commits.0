From: akpm@linux-foundation.org
Subject: [merged] fs-cachefiles-add-support-for-large-files-in-filesystem-caching.patch removed from -mm tree
Date: Tue, 31 Jul 2012 11:54:28 -0700
Message-ID: <20120731185428.BCCEB100048@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:50151 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751913Ab2GaSya (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 31 Jul 2012 14:54:30 -0400
Received: by vcqp1 with SMTP id p1so758923vcq.1
        for <mm-commits@vger.kernel.org>; Tue, 31 Jul 2012 11:54:29 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jlec@gentoo.org, dhowells@redhat.com, sjayaraman@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: fs: cachefiles: add support for large files in filesystem caching
has been removed from the -mm tree.  Its filename was
     fs-cachefiles-add-support-for-large-files-in-filesystem-caching.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Justin Lecher <jlec@gentoo.org>
Subject: fs: cachefiles: add support for large files in filesystem caching

Support the caching of large files.

Addresses https://bugzilla.kernel.org/show_bug.cgi?id=31182

Signed-off-by: Justin Lecher <jlec@gentoo.org>
Signed-off-by: Suresh Jayaraman <sjayaraman@suse.com>
Tested-by: Suresh Jayaraman <sjayaraman@suse.com>
Acked-by: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/cachefiles/rdwr.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/cachefiles/rdwr.c~fs-cachefiles-add-support-for-large-files-in-filesystem-caching fs/cachefiles/rdwr.c
--- a/fs/cachefiles/rdwr.c~fs-cachefiles-add-support-for-large-files-in-filesystem-caching
+++ a/fs/cachefiles/rdwr.c
@@ -919,7 +919,7 @@ int cachefiles_write_page(struct fscache
 	 * own time */
 	path.mnt = cache->mnt;
 	path.dentry = object->backer;
-	file = dentry_open(&path, O_RDWR, cache->cache_cred);
+	file = dentry_open(&path, O_RDWR | O_LARGEFILE, cache->cache_cred);
 	if (IS_ERR(file)) {
 		ret = PTR_ERR(file);
 	} else {
_

Patches currently in -mm which might be from jlec@gentoo.org are

origin.patch

