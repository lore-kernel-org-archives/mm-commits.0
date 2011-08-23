From: akpm@linux-foundation.org
Subject: + procfs-report-eisdir-when-reading-sysctl-dirs-in-proc.patch added to -mm tree
Date: Tue, 23 Aug 2011 14:19:28 -0700
Message-ID: <201108232119.p7NLJSAd007379@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44440 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755516Ab1HWVTb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 23 Aug 2011 17:19:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: xemul@openvz.org, adobriyan@gmail.com, gorcunov@openvz.org, viro@ZenIV.linux.org.uk


The patch titled
     procfs: report EISDIR when reading sysctl dirs in proc
has been added to the -mm tree.  Its filename is
     procfs-report-eisdir-when-reading-sysctl-dirs-in-proc.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: procfs: report EISDIR when reading sysctl dirs in proc
From: Pavel Emelyanov <xemul@openvz.org>

On reading sysctl dirs we should return -EISDIR instead of -EINVAL.

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/proc_sysctl.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN fs/proc/proc_sysctl.c~procfs-report-eisdir-when-reading-sysctl-dirs-in-proc fs/proc/proc_sysctl.c
--- a/fs/proc/proc_sysctl.c~procfs-report-eisdir-when-reading-sysctl-dirs-in-proc
+++ a/fs/proc/proc_sysctl.c
@@ -360,6 +360,7 @@ static const struct file_operations proc
 };
 
 static const struct file_operations proc_sys_dir_file_operations = {
+	.read		= generic_read_dir,
 	.readdir	= proc_sys_readdir,
 	.llseek		= generic_file_llseek,
 };
_

Patches currently in -mm which might be from xemul@openvz.org are

procfs-report-eisdir-when-reading-sysctl-dirs-in-proc.patch

