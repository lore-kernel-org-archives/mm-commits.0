From: akpm@linux-foundation.org
Subject: + epoll-trim-epitem-by-one-cache-line-on-x86_64.patch added to -mm tree
Date: Wed, 06 Mar 2013 14:38:50 -0800
Message-ID: <20130306223850.C9F055A4123@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f73.google.com ([209.85.213.73]:38185 "EHLO
	mail-yh0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754260Ab3CFWiv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Mar 2013 17:38:51 -0500
Received: by mail-yh0-f73.google.com with SMTP id 28so928712yhr.2
        for <mm-commits@vger.kernel.org>; Wed, 06 Mar 2013 14:38:51 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: normalperson@yhbt.net, davidel@xmailserver.org, viro@ZenIV.linux.org.uk


The patch titled
     Subject: epoll: trim epitem by one cache line
has been added to the -mm tree.  Its filename is
     epoll-trim-epitem-by-one-cache-line-on-x86_64.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Eric Wong <normalperson@yhbt.net>
Subject: epoll: trim epitem by one cache line

It is common for epoll users to have thousands of epitems, so saving a
cache line on every allocation leads to large memory savings.

Since epitem allocations are cache-aligned, reducing sizeof(struct epitem)
from 136 bytes to 128 bytes will allow it to squeeze under a cache line
boundary on x86_64.

Via /sys/kernel/slab/eventpoll_epi, I see the following changes on my
x86_64 Core2 Duo (which has 64-byte cache alignment):

	object_size  :  192 => 128
	objs_per_slab:   21 =>  32

Signed-off-by: Eric Wong <normalperson@yhbt.net>
Cc: Davide Libenzi <davidel@xmailserver.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/eventpoll.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/eventpoll.c~epoll-trim-epitem-by-one-cache-line-on-x86_64 fs/eventpoll.c
--- a/fs/eventpoll.c~epoll-trim-epitem-by-one-cache-line-on-x86_64
+++ a/fs/eventpoll.c
@@ -105,7 +105,7 @@
 struct epoll_filefd {
 	struct file *file;
 	int fd;
-};
+} EPOLL_PACKED;
 
 /*
  * Structure used to track possible nested calls, for too deep recursions
_

Patches currently in -mm which might be from normalperson@yhbt.net are

epoll-trim-epitem-by-one-cache-line-on-x86_64.patch
epoll-trim-epitem-by-one-cache-line-on-x86_64-fix.patch

