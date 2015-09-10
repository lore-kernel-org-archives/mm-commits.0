From: akpm@linux-foundation.org
Subject: +
 inotify-actually-check-for-invalid-bits-in-sys_inotify_add_watch.patch
 added to -mm tree
Date: Thu, 10 Sep 2015 13:49:40 -0700
Message-ID: <55f1ece4.fyrbjGlTSukafVvz%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36359 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750994AbbIJUtl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 10 Sep 2015 16:49:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dave.hansen@linux.intel.com, eparis@parisplace.org, john@johnmccutchan.com, rlove@rlove.org, mm-commits@vger.kernel.org


The patch titled
     Subject: inotify: actually check for invalid bits in sys_inotify_add_watch()
has been added to the -mm tree.  Its filename is
     inotify-actually-check-for-invalid-bits-in-sys_inotify_add_watch.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/inotify-actually-check-for-invalid-bits-in-sys_inotify_add_watch.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/inotify-actually-check-for-invalid-bits-in-sys_inotify_add_watch.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Dave Hansen <dave.hansen@linux.intel.com>
Subject: inotify: actually check for invalid bits in sys_inotify_add_watch()

The comment here says that it is checking for invalid bits.  But, the mask
is *actually* checking to ensure that _any_ valid bit is set, which is
quite different.

Add the actual check which was intended.  Retain the existing check
because it actually does something useful: ensure that some inotify bits
are being added to the watch.  Plus, this is existing behavior which would
be nice to preserve.

I did a quick sniff test that inotify functions and that my
'inotify-tools' package passes 'make check'.

Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Cc: John McCutchan <john@johnmccutchan.com>
Cc: Robert Love <rlove@rlove.org>
Cc: Eric Paris <eparis@parisplace.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/notify/inotify/inotify_user.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN fs/notify/inotify/inotify_user.c~inotify-actually-check-for-invalid-bits-in-sys_inotify_add_watch fs/notify/inotify/inotify_user.c
--- a/fs/notify/inotify/inotify_user.c~inotify-actually-check-for-invalid-bits-in-sys_inotify_add_watch
+++ a/fs/notify/inotify/inotify_user.c
@@ -707,6 +707,9 @@ SYSCALL_DEFINE3(inotify_add_watch, int,
 	unsigned flags = 0;
 
 	/* don't allow invalid bits: we don't want flags set */
+	if (unlikely(mask & ~ALL_INOTIFY_BITS))
+		return -EINVAL;
+	/* require at least one valid bit set in the mask */
 	if (unlikely(!(mask & ALL_INOTIFY_BITS)))
 		return -EINVAL;
 
_

Patches currently in -mm which might be from dave.hansen@linux.intel.com are

inotify-actually-check-for-invalid-bits-in-sys_inotify_add_watch.patch

