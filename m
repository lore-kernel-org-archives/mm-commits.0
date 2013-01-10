From: akpm@linux-foundation.org
Subject: + block-dont-select-percpu_rwsem.patch added to -mm tree
Date: Thu, 10 Jan 2013 14:23:28 -0800
Message-ID: <20130110222328.89DD5100048@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f201.google.com ([209.85.213.201]:52936 "EHLO
	mail-ye0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753245Ab3AJWX3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 10 Jan 2013 17:23:29 -0500
Received: by mail-ye0-f201.google.com with SMTP id r11so136356yen.4
        for <mm-commits@vger.kernel.org>; Thu, 10 Jan 2013 14:23:29 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mpatocka@redhat.com, axboe@kernel.dk


The patch titled
     Subject: block: don't select PERCPU_RWSEM
has been added to the -mm tree.  Its filename is
     block-dont-select-percpu_rwsem.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mikulas Patocka <mpatocka@redhat.com>
Subject: block: don't select PERCPU_RWSEM

The block device doesn't use percpu rw-semaphore anymore, so don't select
it for compilation.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 block/Kconfig |    1 -
 1 file changed, 1 deletion(-)

diff -puN block/Kconfig~block-dont-select-percpu_rwsem block/Kconfig
--- a/block/Kconfig~block-dont-select-percpu_rwsem
+++ a/block/Kconfig
@@ -4,7 +4,6 @@
 menuconfig BLOCK
        bool "Enable the block layer" if EXPERT
        default y
-       select PERCPU_RWSEM
        help
 	 Provide block layer support for the kernel.
 
_

Patches currently in -mm which might be from mpatocka@redhat.com are

linux-next.patch
block-dont-select-percpu_rwsem.patch

