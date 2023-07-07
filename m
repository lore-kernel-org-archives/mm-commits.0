Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E091AC001B0
	for <mm-commits@archiver.kernel.org>; Fri,  7 Jul 2023 18:56:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232079AbjGGS44 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 7 Jul 2023 14:56:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231845AbjGGS4z (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 7 Jul 2023 14:56:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3872124
        for <mm-commits@vger.kernel.org>; Fri,  7 Jul 2023 11:56:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2A03561A11
        for <mm-commits@vger.kernel.org>; Fri,  7 Jul 2023 18:56:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82078C433C8;
        Fri,  7 Jul 2023 18:56:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1688756212;
        bh=rM44eE95dH0PZ47TR9zalErcNz2w8k3SBJPT4HuBLXM=;
        h=Date:To:From:Subject:From;
        b=WxuQfLxO0SOzMxnnp29JlTiCu8V/Dwmk6GatCZVaUaHNs0CWFtciTt6CmXsPxudZ4
         Wkfaw1u4RAytdzQ0YwjKHHAj6SAG+XtCKtG/GcRTt7+x0uVnFY4ZJheNrGkPfkroYO
         +sJBPza9/X8Rfd0cnhptWpFWosDMFwlLmf9AS4Oc=
Date:   Fri, 07 Jul 2023 11:56:51 -0700
To:     mm-commits@vger.kernel.org, xiubli@redhat.com, willy@infradead.org,
        tytso@mit.edu, torvalds@linux-foundation.org, sfrench@samba.org,
        rohiths.msft@gmail.com, nspmangalore@gmail.com,
        jefflexu@linux.alibaba.com, idryomov@gmail.com,
        dwysocha@redhat.com, asmadeus@codewreck.org,
        adilger.kernel@dilger.ca, dhowells@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-netfs-fscache-stop-read-optimisation-when-folio-removed-from-pagecache.patch added to mm-unstable branch
Message-Id: <20230707185652.82078C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm, netfs, fscache: stop read optimisation when folio removed from pagecache
has been added to the -mm mm-unstable branch.  Its filename is
     mm-netfs-fscache-stop-read-optimisation-when-folio-removed-from-pagecache.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-netfs-fscache-stop-read-optimisation-when-folio-removed-from-pagecache.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: David Howells <dhowells@redhat.com>
Subject: mm, netfs, fscache: stop read optimisation when folio removed from pagecache
Date: Wed, 28 Jun 2023 11:48:52 +0100

Fscache has an optimisation by which reads from the cache are skipped
until we know that (a) there's data there to be read and (b) that data
isn't entirely covered by pages resident in the netfs pagecache.  This is
done with two flags manipulated by fscache_note_page_release():

	if (...
	    test_bit(FSCACHE_COOKIE_HAVE_DATA, &cookie->flags) &&
	    test_bit(FSCACHE_COOKIE_NO_DATA_TO_READ, &cookie->flags))
		clear_bit(FSCACHE_COOKIE_NO_DATA_TO_READ, &cookie->flags);

where the NO_DATA_TO_READ flag causes cachefiles_prepare_read() to
indicate that netfslib should download from the server or clear the page
instead.

The fscache_note_page_release() function is intended to be called from
->releasepage() - but that only gets called if PG_private or PG_private_2
is set - and currently the former is at the discretion of the network
filesystem and the latter is only set whilst a page is being written to
the cache, so sometimes we miss clearing the optimisation.

Fix this by following Willy's suggestion[1] and adding an address_space
flag, AS_RELEASE_ALWAYS, that causes filemap_release_folio() to always call
->release_folio() if it's set, even if PG_private or PG_private_2 aren't
set.

Note that this would require folio_test_private() and page_has_private() to
become more complicated.  To avoid that, in the places[*] where these are
used to conditionalise calls to filemap_release_folio() and
try_to_release_page(), the tests are removed the those functions just
jumped to unconditionally and the test is performed there.

[*] There are some exceptions in vmscan.c where the check guards more than
just a call to the releaser.  I've added a function, folio_needs_release()
to wrap all the checks for that.

AS_RELEASE_ALWAYS should be set if a non-NULL cookie is obtained from
fscache and cleared in ->evict_inode() before truncate_inode_pages_final()
is called.

Additionally, the FSCACHE_COOKIE_NO_DATA_TO_READ flag needs to be cleared
and the optimisation cancelled if a cachefiles object already contains data
when we open it.

Link: https://lkml.kernel.org/r/20230628104852.3391651-3-dhowells@redhat.com
Fixes: 1f67e6d0b188 ("fscache: Provide a function to note the release of a page")
Fixes: 047487c947e8 ("cachefiles: Implement the I/O routines")
Reported-by: Rohith Surabattula <rohiths.msft@gmail.com>
Suggested-by: Matthew Wilcox <willy@infradead.org>
Signed-off-by: David Howells <dhowells@redhat.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Steve French <sfrench@samba.org>
Cc: Shyam Prasad N <nspmangalore@gmail.com>
Cc: Rohith Surabattula <rohiths.msft@gmail.com>
Cc: Dave Wysochanski <dwysocha@redhat.com>
Cc: Dominique Martinet <asmadeus@codewreck.org>
Cc: Ilya Dryomov <idryomov@gmail.com>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>
Cc: Jingbo Xu <jefflexu@linux.alibaba.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: Xiubo Li <xiubli@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/9p/cache.c           |    2 ++
 fs/afs/internal.h       |    2 ++
 fs/cachefiles/namei.c   |    2 ++
 fs/ceph/cache.c         |    2 ++
 fs/nfs/fscache.c        |    3 +++
 fs/smb/client/fscache.c |    2 ++
 include/linux/pagemap.h |   16 ++++++++++++++++
 mm/internal.h           |    5 ++++-
 8 files changed, 33 insertions(+), 1 deletion(-)

--- a/fs/9p/cache.c~mm-netfs-fscache-stop-read-optimisation-when-folio-removed-from-pagecache
+++ a/fs/9p/cache.c
@@ -68,6 +68,8 @@ void v9fs_cache_inode_get_cookie(struct
 				       &path, sizeof(path),
 				       &version, sizeof(version),
 				       i_size_read(&v9inode->netfs.inode));
+	if (v9inode->netfs.cache)
+		mapping_set_release_always(inode->i_mapping);
 
 	p9_debug(P9_DEBUG_FSC, "inode %p get cookie %p\n",
 		 inode, v9fs_inode_cookie(v9inode));
--- a/fs/afs/internal.h~mm-netfs-fscache-stop-read-optimisation-when-folio-removed-from-pagecache
+++ a/fs/afs/internal.h
@@ -681,6 +681,8 @@ static inline void afs_vnode_set_cache(s
 {
 #ifdef CONFIG_AFS_FSCACHE
 	vnode->netfs.cache = cookie;
+	if (cookie)
+		mapping_set_release_always(vnode->netfs.inode.i_mapping);
 #endif
 }
 
--- a/fs/cachefiles/namei.c~mm-netfs-fscache-stop-read-optimisation-when-folio-removed-from-pagecache
+++ a/fs/cachefiles/namei.c
@@ -585,6 +585,8 @@ static bool cachefiles_open_file(struct
 	if (ret < 0)
 		goto check_failed;
 
+	clear_bit(FSCACHE_COOKIE_NO_DATA_TO_READ, &object->cookie->flags);
+
 	object->file = file;
 
 	/* Always update the atime on an object we've just looked up (this is
--- a/fs/ceph/cache.c~mm-netfs-fscache-stop-read-optimisation-when-folio-removed-from-pagecache
+++ a/fs/ceph/cache.c
@@ -36,6 +36,8 @@ void ceph_fscache_register_inode_cookie(
 				       &ci->i_vino, sizeof(ci->i_vino),
 				       &ci->i_version, sizeof(ci->i_version),
 				       i_size_read(inode));
+	if (ci->netfs.cache)
+		mapping_set_release_always(inode->i_mapping);
 }
 
 void ceph_fscache_unregister_inode_cookie(struct ceph_inode_info *ci)
--- a/fs/nfs/fscache.c~mm-netfs-fscache-stop-read-optimisation-when-folio-removed-from-pagecache
+++ a/fs/nfs/fscache.c
@@ -180,6 +180,9 @@ void nfs_fscache_init_inode(struct inode
 					       &auxdata,      /* aux_data */
 					       sizeof(auxdata),
 					       i_size_read(inode));
+
+	if (netfs_inode(inode)->cache)
+		mapping_set_release_always(inode->i_mapping);
 }
 
 /*
--- a/fs/smb/client/fscache.c~mm-netfs-fscache-stop-read-optimisation-when-folio-removed-from-pagecache
+++ a/fs/smb/client/fscache.c
@@ -108,6 +108,8 @@ void cifs_fscache_get_inode_cookie(struc
 				       &cifsi->uniqueid, sizeof(cifsi->uniqueid),
 				       &cd, sizeof(cd),
 				       i_size_read(&cifsi->netfs.inode));
+	if (cifsi->netfs.cache)
+		mapping_set_release_always(inode->i_mapping);
 }
 
 void cifs_fscache_unuse_inode_cookie(struct inode *inode, bool update)
--- a/include/linux/pagemap.h~mm-netfs-fscache-stop-read-optimisation-when-folio-removed-from-pagecache
+++ a/include/linux/pagemap.h
@@ -203,6 +203,7 @@ enum mapping_flags {
 	/* writeback related tags are not used */
 	AS_NO_WRITEBACK_TAGS = 5,
 	AS_LARGE_FOLIO_SUPPORT = 6,
+	AS_RELEASE_ALWAYS,	/* Call ->release_folio(), even if no private data */
 };
 
 /**
@@ -273,6 +274,21 @@ static inline int mapping_use_writeback_
 	return !test_bit(AS_NO_WRITEBACK_TAGS, &mapping->flags);
 }
 
+static inline bool mapping_release_always(const struct address_space *mapping)
+{
+	return test_bit(AS_RELEASE_ALWAYS, &mapping->flags);
+}
+
+static inline void mapping_set_release_always(struct address_space *mapping)
+{
+	set_bit(AS_RELEASE_ALWAYS, &mapping->flags);
+}
+
+static inline void mapping_clear_release_always(struct address_space *mapping)
+{
+	clear_bit(AS_RELEASE_ALWAYS, &mapping->flags);
+}
+
 static inline gfp_t mapping_gfp_mask(struct address_space * mapping)
 {
 	return mapping->gfp_mask;
--- a/mm/internal.h~mm-netfs-fscache-stop-read-optimisation-when-folio-removed-from-pagecache
+++ a/mm/internal.h
@@ -181,7 +181,10 @@ static inline void set_page_refcounted(s
  */
 static inline bool folio_needs_release(struct folio *folio)
 {
-	return folio_has_private(folio);
+	struct address_space *mapping = folio->mapping;
+
+	return folio_has_private(folio) ||
+		(mapping && mapping_release_always(mapping));
 }
 
 extern unsigned long highest_memmap_pfn;
_

Patches currently in -mm which might be from dhowells@redhat.com are

mm-merge-folio_has_private-filemap_release_folio-call-pairs.patch
mm-netfs-fscache-stop-read-optimisation-when-folio-removed-from-pagecache.patch

