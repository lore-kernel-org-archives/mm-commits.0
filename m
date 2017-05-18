From: akpm@linux-foundation.org
Subject: + fs-kill-config_percpu_rwsem-some-more.patch added to -mm tree
Date: Thu, 18 May 2017 12:33:04 -0700
Message-ID: <591df6f0.TwxronWAt1JaOAaJ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58502 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757265AbdERTdF (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 18 May 2017 15:33:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dave@stgolabs.net, dbueso@suse.de, oleg@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/Kconfig: kill CONFIG_PERCPU_RWSEM some more
has been added to the -mm tree.  Its filename is
     fs-kill-config_percpu_rwsem-some-more.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-kill-config_percpu_rwsem-some-more.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-kill-config_percpu_rwsem-some-more.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Davidlohr Bueso <dave@stgolabs.net>
Subject: fs/Kconfig: kill CONFIG_PERCPU_RWSEM some more

As of bf3eac84c42 ("percpu-rwsem: kill CONFIG_PERCPU_RWSEM") we
unconditionally build pcpu-rwsems.  Remove a leftover in for FILE_LOCKING.

Link: http://lkml.kernel.org/r/20170518180115.2794-1-dave@stgolabs.net
Signed-off-by: Davidlohr Bueso <dbueso@suse.de>
Cc: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/Kconfig |    1 -
 1 file changed, 1 deletion(-)

diff -puN fs/Kconfig~fs-kill-config_percpu_rwsem-some-more fs/Kconfig
--- a/fs/Kconfig~fs-kill-config_percpu_rwsem-some-more
+++ a/fs/Kconfig
@@ -80,7 +80,6 @@ config EXPORTFS_BLOCK_OPS
 config FILE_LOCKING
 	bool "Enable POSIX file locking API" if EXPERT
 	default y
-	select PERCPU_RWSEM
 	help
 	  This option enables standard file locking support, required
           for filesystems like NFS and for the flock() system
_

Patches currently in -mm which might be from dave@stgolabs.net are

lib-interval_tree_test-allow-the-module-to-be-compiled-in.patch
lib-interval_tree_test-make-test-options-module-parameters.patch
lib-interval_tree_test-allow-users-to-limit-scope-of-endpoint.patch
lib-interval_tree_test-allow-full-tree-search.patch
fs-kill-config_percpu_rwsem-some-more.patch

