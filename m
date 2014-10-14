From: akpm@linux-foundation.org
Subject: [merged] kexec-remove-the-unused-function-parameter.patch removed from -mm tree
Date: Tue, 14 Oct 2014 11:21:24 -0700
Message-ID: <543d69a4.QZSuXEeb4FwIfYfH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44410 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755447AbaJNSVX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 14 Oct 2014 14:21:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bhe@redhat.com, ebiederm@xmission.com, vgoyal@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kexec: remove the unused function parameter
has been removed from the -mm tree.  Its filename was
     kexec-remove-the-unused-function-parameter.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Baoquan He <bhe@redhat.com>
Subject: kexec: remove the unused function parameter

This is a cleanup.  In function parse_crashkernel_suffix, the parameter
crash_base is not used.  So here remove it.

Signed-off-by: Baoquan He <bhe@redhat.com>
Acked-by: Vivek Goyal <vgoyal@redhat.com>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kexec.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN kernel/kexec.c~kexec-remove-the-unused-function-parameter kernel/kexec.c
--- a/kernel/kexec.c~kexec-remove-the-unused-function-parameter
+++ a/kernel/kexec.c
@@ -1759,7 +1759,6 @@ static __initdata char *suffix_tbl[] = {
  */
 static int __init parse_crashkernel_suffix(char *cmdline,
 					   unsigned long long	*crash_size,
-					   unsigned long long	*crash_base,
 					   const char *suffix)
 {
 	char *cur = cmdline;
@@ -1848,7 +1847,7 @@ static int __init __parse_crashkernel(ch
 
 	if (suffix)
 		return parse_crashkernel_suffix(ck_cmdline, crash_size,
-				crash_base, suffix);
+				suffix);
 	/*
 	 * if the commandline contains a ':', then that's the extended
 	 * syntax -- if not, it must be the classic syntax
_

Patches currently in -mm which might be from bhe@redhat.com are

origin.patch

