From: akpm@linux-foundation.org
Subject: + fs-cachefiles-add-support-for-large-files-in-filesystem-caching.patch added to -mm tree
Date: Mon, 11 Jun 2012 14:23:40 -0700
Message-ID: <20120611212341.1F485A011A@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:34311 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751710Ab2FKVXm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 11 Jun 2012 17:23:42 -0400
Received: by qcsp5 with SMTP id p5so126438qcs.1
        for <mm-commits@vger.kernel.org>; Mon, 11 Jun 2012 14:23:41 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jlec@gentoo.org, dhowells@redhat.com, sjayaraman@suse.com


The patch titled
     Subject: fs: cachefiles: add support for large files in filesystem caching
has been added to the -mm tree.  Its filename is
     fs-cachefiles-add-support-for-large-files-in-filesystem-caching.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Justin Lecher <jlec@gentoo.org>
Subject: fs: cachefiles: add support for large files in filesystem caching

Support the caching of large files.

Addresses https://bugzilla.kernel.org/show_bug.cgi?id=31182

Signed-off-by: Justin Lecher <jlec@gentoo.org>
Signed-off-by: Suresh Jayaraman <sjayaraman@suse.com>
Tested-by: Suresh Jayaraman <sjayaraman@suse.com>
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/cachefiles/rdwr.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/cachefiles/rdwr.c~fs-cachefiles-add-support-for-large-files-in-filesystem-caching fs/cachefiles/rdwr.c
--- a/fs/cachefiles/rdwr.c~fs-cachefiles-add-support-for-large-files-in-filesystem-caching
+++ a/fs/cachefiles/rdwr.c
@@ -919,7 +919,7 @@ int cachefiles_write_page(struct fscache
 	dget(object->backer);
 	mntget(cache->mnt);
 	file = dentry_open(object->backer, cache->mnt, O_RDWR,
-			   cache->cache_cred);
+			   (O_RDWR | O_LARGEFILE), cache->cache_cred);
 	if (IS_ERR(file)) {
 		ret = PTR_ERR(file);
 	} else {
_
Subject: Subject: fs: cachefiles: add support for large files in filesystem caching

Patches currently in -mm which might be from jlec@gentoo.org are

fs-cachefiles-add-support-for-large-files-in-filesystem-caching.patch

