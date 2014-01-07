From: akpm@linux-foundation.org
Subject: + fs-read_writec-compat_readv-remove-bogus-area-verify.patch
 added to -mm tree
Date: Tue, 07 Jan 2014 15:03:24 -0800
Message-ID: <52cc87bc.reNgPTyh0qbgd6TO%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60115 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753875AbaAGXDZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Jan 2014 18:03:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, cminyard@mvista.com, minyard@acm.org

Subject: + fs-read_writec-compat_readv-remove-bogus-area-verify.patch added to -mm tree
To: minyard@acm.org,cminyard@mvista.com
From: akpm@linux-foundation.org
Date: Tue, 07 Jan 2014 15:03:24 -0800


The patch titled
     Subject: fs/read_write.c:compat_readv(): remove bogus area verify
has been added to the -mm tree.  Its filename is
     fs-read_writec-compat_readv-remove-bogus-area-verify.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-read_writec-compat_readv-remove-bogus-area-verify.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-read_writec-compat_readv-remove-bogus-area-verify.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Corey Minyard <minyard@acm.org>
Subject: fs/read_write.c:compat_readv(): remove bogus area verify

The compat_do_readv_writev() function was doing a verify_area on the
incoming iov, but the nr_segs value is not checked.  If someone passes in
a -1 for nr_segs, for instance, the function should return an EINVAL. 
However, it returns a EFAULT because the verify_area fails because it is
checking an array of size MAX_UINT.  The check is bogus, anyway, because
the next check, compat_rw_copy_check_uvector(), will do all the necessary
checking, anyway.  The non-compat do_readv_writev() function doesn't do
this check, so I think it's safe to just remove the code.

Signed-off-by: Corey Minyard <cminyard@mvista.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/read_write.c |    4 ----
 1 file changed, 4 deletions(-)

diff -puN fs/read_write.c~fs-read_writec-compat_readv-remove-bogus-area-verify fs/read_write.c
--- a/fs/read_write.c~fs-read_writec-compat_readv-remove-bogus-area-verify
+++ a/fs/read_write.c
@@ -901,10 +901,6 @@ static ssize_t compat_do_readv_writev(in
 	io_fn_t fn;
 	iov_fn_t fnv;
 
-	ret = -EFAULT;
-	if (!access_ok(VERIFY_READ, uvector, nr_segs*sizeof(*uvector)))
-		goto out;
