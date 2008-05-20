From: akpm@linux-foundation.org
Subject: + linux-aouth-is-not-exported-to-userspace.patch added to -mm tree
Date: Mon, 19 May 2008 21:12:57 -0700
Message-ID: <200805200412.m4K4CvYR004278@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57742 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751698AbYETENP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 20 May 2008 00:13:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: raj.khem@gmail.com, stable@kernel.org


The patch titled
     linux/a.out.h is not exported to userspace
has been added to the -mm tree.  Its filename is
     linux-aouth-is-not-exported-to-userspace.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: linux/a.out.h is not exported to userspace
From: Khem Raj <raj.khem@gmail.com>

Looking for a compile failure for a package on uclibc system using
kernel-headers from 2.6.25 I found that linux/a.out.h is no more exported
to userland anymore.

This commit below has disabled it from being exported.  The commit Do not
export asm/page.h during make headers_install so I was wondering if it was
intended to unexport linux/a.out.h or not.

http://git.kernel.org/?p=3Dlinux/kernel/git/torvalds/linux-2.6.git;a=3Dcomm=
itdiff;h=3Ded7b1889da256977574663689b598d88950bbd23

Looking at the patch from lkml post

http://linux.derkeiler.com/Mailing-Lists/Kernel/2007-10/msg08913.html

second hunk to include/linux/Kbuild was not applied which caused this
problem.

Tested-by: Khem Raj <raj.khem@gmail.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/Kbuild |    1 +
 1 file changed, 1 insertion(+)

diff -puN include/linux/Kbuild~linux-aouth-is-not-exported-to-userspace include/linux/Kbuild
--- a/include/linux/Kbuild~linux-aouth-is-not-exported-to-userspace
+++ a/include/linux/Kbuild
@@ -168,6 +168,7 @@ unifdef-y += acct.h
 unifdef-y += adb.h
 unifdef-y += adfs_fs.h
 unifdef-y += agpgart.h
+unifdef-y += a.out.h
 unifdef-y += apm_bios.h
 unifdef-y += atalk.h
 unifdef-y += atmdev.h
_

Patches currently in -mm which might be from raj.khem@gmail.com are

linux-aouth-is-not-exported-to-userspace.patch

