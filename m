From: akpm@linux-foundation.org
Subject: + kexec-remove-the-unused-function-parameter.patch added to -mm
 tree
Date: Wed, 10 Sep 2014 12:22:20 -0700
Message-ID: <5410a4ec.GaJ7ICekoiw/cZMr%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57421 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753030AbaIJTWV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 10 Sep 2014 15:22:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bhe@redhat.com, ebiederm@xmission.com, vgoyal@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kexec: remove the unused function parameter
has been added to the -mm tree.  Its filename is
     kexec-remove-the-unused-function-parameter.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kexec-remove-the-unused-function-parameter.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kexec-remove-the-unused-function-parameter.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

not-adding-modules-range-to-kcore-if-its-equal-to-vmcore-range.patch
not-adding-modules-range-to-kcore-if-its-equal-to-vmcore-range-checkpatch-fixes.patch
try-to-use-automatic-variable-in-kexec-purgatory-makefile.patch
take-the-segment-adding-out-of-locate_mem_hole-functions.patch
check-if-crashk_res_low-exists-when-exclude-it-from-crash-mem-ranges.patch
kexec-remove-the-unused-function-parameter.patch

