From: akpm@linux-foundation.org
Subject: + kexec-prevent-double-free-on-image-allocation-failure.patch added to -mm tree
Date: Fri, 22 Feb 2013 13:48:09 -0800
Message-ID: <20130222214809.A05F45A41B6@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f201.google.com ([209.85.220.201]:49977 "EHLO
	mail-vc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757335Ab3BVVsL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Feb 2013 16:48:11 -0500
Received: by mail-vc0-f201.google.com with SMTP id n11so110334vch.4
        for <mm-commits@vger.kernel.org>; Fri, 22 Feb 2013 13:48:10 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sasha.levin@oracle.com, ebiederm@xmission.com, zhangyanfei@cn.fujitsu.com


The patch titled
     Subject: kexec: prevent double free on image allocation failure
has been added to the -mm tree.  Its filename is
     kexec-prevent-double-free-on-image-allocation-failure.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Sasha Levin <sasha.levin@oracle.com>
Subject: kexec: prevent double free on image allocation failure

If kimage_normal_alloc() fails to initialize an allocated kimage, it will
free the image but would still set 'rimage', as a result kexec_load will
try to free it again.

This would explode as part of the freeing process is accessing internal
members which point to uninitialized memory.

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kexec.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN kernel/kexec.c~kexec-prevent-double-free-on-image-allocation-failure kernel/kexec.c
--- a/kernel/kexec.c~kexec-prevent-double-free-on-image-allocation-failure
+++ a/kernel/kexec.c
@@ -242,8 +242,6 @@ static int kimage_normal_alloc(struct ki
 	if (result)
 		goto out;
 
-	*rimage = image;
-
 	/*
 	 * Find a location for the control code buffer, and add it
 	 * the vector of segments so that it's pages will also be
_

Patches currently in -mm which might be from sasha.levin@oracle.com are

origin.patch
linux-next.patch
watchdog-trigger-all-cpu-backtrace-when-locked-up-and-going-to-panic.patch
mm-huge_memory-use-new-hashtable-implementation.patch
mm-make-madvisemadv_willneed-support-swap-file-prefetch-fix-fix.patch
mm-memory_hotplug-no-need-to-check-res-twice-in-add_memory.patch
swap-make-each-swap-partition-have-one-address_space-fix-fix.patch
epoll-support-for-disabling-items-and-a-self-test-app-fix.patch
kexec-prevent-double-free-on-image-allocation-failure.patch
posix-timer-dont-call-idr_find-w-out-of-range-id.patch
idr-implement-lookup-hint-always-do-slow-path-when-hint-is-uninitialized.patch
hlist-drop-the-node-parameter-from-iterators.patch
hlist-drop-the-node-parameter-from-iterators-fix-fix-fix-fix.patch
hlist-drop-the-node-parameter-from-iterators-fix-fix-fix-fix-fix.patch
hlist-drop-the-node-parameter-from-iterators-checkpatch-fixes.patch
hlist-drop-the-node-parameter-from-iterators-fix.patch
hlist-drop-the-node-parameter-from-iterators-fix-fix.patch
hlist-drop-the-node-parameter-from-iterators-fix-fix-fix.patch
hlist-drop-the-node-parameter-from-iterators-redo-kvm.patch
hlist-drop-the-node-parameter-from-iterators-fix-fix-fix-fix-fix-fix.patch
hlist-drop-the-node-parameter-from-iterators-mlx4-fix.patch

