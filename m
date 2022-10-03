Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0333BC43217
	for <mm-commits@archiver.kernel.org>; Mon,  3 Oct 2022 21:15:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229876AbiJCVPV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 3 Oct 2022 17:15:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230282AbiJCVNz (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 3 Oct 2022 17:13:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2C505465A
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 14:09:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8CC3A611FB
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 21:09:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAC7CC433C1;
        Mon,  3 Oct 2022 21:09:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664831353;
        bh=y5bMIArDicMfixM2Ko8EKmPb1hqeqIMCP8TyR8PSKQ8=;
        h=Date:To:From:Subject:From;
        b=EJkz2vmKe5zV5TzKIeW1ThHTrc++hdqCb4WK0erj6IHbdy2sNZx92+6dr4cIkA+TY
         1oRgcfUjixefsmhPoXbNrkPDaQ1Zofk07PPUsg5CrG33PTKlSygNEIa61R0hmPZm4c
         El7lSyrexTMupuC4RLiP3or7G9ePVTCWyiY/uG7c=
Date:   Mon, 03 Oct 2022 14:09:12 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        viro@zeniv.linux.org.uk, vegard.nossum@oracle.com, vbabka@suse.cz,
        tglx@linutronix.de, sfr@canb.auug.org.au, rostedt@goodmis.org,
        rientjes@google.com, pmladek@suse.com, peterz@infradead.org,
        penberg@kernel.org, mst@redhat.com, mingo@redhat.com,
        mark.rutland@arm.com, luto@kernel.org, keescook@chromium.org,
        iii@linux.ibm.com, iamjoonsoo.kim@lge.com,
        herbert@gondor.apana.org.au, hch@lst.de,
        gregkh@linuxfoundation.org, gor@linux.ibm.com, elver@google.com,
        edumazet@google.com, ebiggers@kernel.org, ebiggers@google.com,
        dvyukov@google.com, cl@linux.com, bp@alien8.de, axboe@kernel.dk,
        ast@kernel.org, arnd@arndb.de, andreyknvl@google.com,
        andreyknvl@gmail.com, glider@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-fs-initialize-fsdata-passed-to-write_begin-write_end-interface.patch removed from -mm tree
Message-Id: <20221003210912.DAC7CC433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: fs: initialize fsdata passed to write_begin/write_end interface
has been removed from the -mm tree.  Its filename was
     mm-fs-initialize-fsdata-passed-to-write_begin-write_end-interface.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Alexander Potapenko <glider@google.com>
Subject: mm: fs: initialize fsdata passed to write_begin/write_end interface
Date: Thu, 15 Sep 2022 17:04:16 +0200

Functions implementing the a_ops->write_end() interface accept the `void
*fsdata` parameter that is supposed to be initialized by the corresponding
a_ops->write_begin() (which accepts `void **fsdata`).

However not all a_ops->write_begin() implementations initialize `fsdata`
unconditionally, so it may get passed uninitialized to a_ops->write_end(),
resulting in undefined behavior.

Fix this by initializing fsdata with NULL before the call to
write_begin(), rather than doing so in all possible a_ops implementations.

This patch covers only the following cases found by running x86 KMSAN
under syzkaller:

 - generic_perform_write()
 - cont_expand_zero() and generic_cont_expand_simple()
 - page_symlink()

Other cases of passing uninitialized fsdata may persist in the codebase.

Link: https://lkml.kernel.org/r/20220915150417.722975-43-glider@google.com
Signed-off-by: Alexander Potapenko <glider@google.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Andrey Konovalov <andreyknvl@google.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Eric Biggers <ebiggers@google.com>
Cc: Eric Biggers <ebiggers@kernel.org>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Ilya Leoshkevich <iii@linux.ibm.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Marco Elver <elver@google.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Michael S. Tsirkin <mst@redhat.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Vegard Nossum <vegard.nossum@oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/buffer.c  |    4 ++--
 fs/namei.c   |    2 +-
 mm/filemap.c |    2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

--- a/fs/buffer.c~mm-fs-initialize-fsdata-passed-to-write_begin-write_end-interface
+++ a/fs/buffer.c
@@ -2341,7 +2341,7 @@ int generic_cont_expand_simple(struct in
 	struct address_space *mapping = inode->i_mapping;
 	const struct address_space_operations *aops = mapping->a_ops;
 	struct page *page;
-	void *fsdata;
+	void *fsdata = NULL;
 	int err;
 
 	err = inode_newsize_ok(inode, size);
@@ -2367,7 +2367,7 @@ static int cont_expand_zero(struct file
 	const struct address_space_operations *aops = mapping->a_ops;
 	unsigned int blocksize = i_blocksize(inode);
 	struct page *page;
-	void *fsdata;
+	void *fsdata = NULL;
 	pgoff_t index, curidx;
 	loff_t curpos;
 	unsigned zerofrom, offset, len;
--- a/fs/namei.c~mm-fs-initialize-fsdata-passed-to-write_begin-write_end-interface
+++ a/fs/namei.c
@@ -5088,7 +5088,7 @@ int page_symlink(struct inode *inode, co
 	const struct address_space_operations *aops = mapping->a_ops;
 	bool nofs = !mapping_gfp_constraint(mapping, __GFP_FS);
 	struct page *page;
-	void *fsdata;
+	void *fsdata = NULL;
 	int err;
 	unsigned int flags;
 
--- a/mm/filemap.c~mm-fs-initialize-fsdata-passed-to-write_begin-write_end-interface
+++ a/mm/filemap.c
@@ -3720,7 +3720,7 @@ ssize_t generic_perform_write(struct kio
 		unsigned long offset;	/* Offset into pagecache page */
 		unsigned long bytes;	/* Bytes to write to page */
 		size_t copied;		/* Bytes copied from user */
-		void *fsdata;
+		void *fsdata = NULL;
 
 		offset = (pos & (PAGE_SIZE - 1));
 		bytes = min_t(unsigned long, PAGE_SIZE - offset,
_

Patches currently in -mm which might be from glider@google.com are


