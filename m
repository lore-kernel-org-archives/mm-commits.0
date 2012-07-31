From: akpm@linux-foundation.org
Subject: + fs-direct-ioc-set-bi_rw-when-alloc-bio.patch added to -mm tree
Date: Tue, 31 Jul 2012 15:56:03 -0700
Message-ID: <20120731225604.69E2A100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f202.google.com ([209.85.214.202]:64210 "EHLO
	mail-ob0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753579Ab2GaW4G (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 31 Jul 2012 18:56:06 -0400
Received: by obbwc20 with SMTP id wc20so4803288obb.1
        for <mm-commits@vger.kernel.org>; Tue, 31 Jul 2012 15:56:05 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: majianpeng@gmail.com, jmoyer@redhat.com, neilb@suse.de, stable@vger.kernel.org, viro@zeniv.linux.org.uk


The patch titled
     Subject: fs/direct-io.c: set bi_rw when allocating bio
has been added to the -mm tree.  Its filename is
     fs-direct-ioc-set-bi_rw-when-alloc-bio.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: majianpeng <majianpeng@gmail.com>
Subject: fs/direct-io.c: set bi_rw when allocating bio

When calling bio_alloc(), the bi_rw is zero. But after calling bio_add_page()
it will use bi_rw.

Fox example, in __bio_add_page() it will call merge_bvec_fn().
The merge_bvec_fn of raid456 will use the bi_rw to judge the merge:

	if ((bvm->bi_rw & 1) == WRITE)
		return biovec->bv_len; /* always allow writes to be mergeable */

This bug is causing raid5 performance issues.

Signed-off-by: Jianpeng Ma <majianpeng@gmail.com>
Reviewed-by: Jeff Moyer <jmoyer@redhat.com>
Cc: Neil Brown <neilb@suse.de>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/direct-io.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN fs/direct-io.c~fs-direct-ioc-set-bi_rw-when-alloc-bio fs/direct-io.c
--- a/fs/direct-io.c~fs-direct-ioc-set-bi_rw-when-alloc-bio
+++ a/fs/direct-io.c
@@ -349,6 +349,7 @@ dio_bio_alloc(struct dio *dio, struct di
 
 	bio->bi_bdev = bdev;
 	bio->bi_sector = first_sector;
+	bio->bi_rw = dio->rw;
 	if (dio->is_async)
 		bio->bi_end_io = dio_bio_end_aio;
 	else
_

Patches currently in -mm which might be from majianpeng@gmail.com are

origin.patch
linux-next.patch
fs-direct-ioc-set-bi_rw-when-alloc-bio.patch

