From: akpm@linux-foundation.org
Subject: - linux-aouth-is-not-exported-to-userspace.patch removed from -mm tree
Date: Fri, 23 May 2008 00:21:48 -0700
Message-ID: <200805230733.m4N7X4ga011362@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40338 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752809AbYEWHdt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 23 May 2008 03:33:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: raj.khem@gmail.com, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     linux/a.out.h is not exported to userspace
has been removed from the -mm tree.  Its filename was
     linux-aouth-is-not-exported-to-userspace.patch

This patch was dropped because it had testing failures

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

