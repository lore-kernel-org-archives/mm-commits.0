From: akpm@linux-foundation.org
Subject: + mn10300-make-cpu_relax-invoke-barrier.patch added to -mm tree
Date: Wed, 07 May 2008 09:54:33 -0700
Message-ID: <200805071654.m47GsXZI006671@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36143 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753737AbYEGQyz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 May 2008 12:54:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dhowells@redhat.com


The patch titled
     MN10300: make cpu_relax() invoke barrier()
has been added to the -mm tree.  Its filename is
     mn10300-make-cpu_relax-invoke-barrier.patch

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
Subject: MN10300: make cpu_relax() invoke barrier()
From: David Howells <dhowells@redhat.com>

Make cpu_relax() invoke barrier() to be the same as other arches.

Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-mn10300/processor.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/asm-mn10300/processor.h~mn10300-make-cpu_relax-invoke-barrier include/asm-mn10300/processor.h
--- a/include/asm-mn10300/processor.h~mn10300-make-cpu_relax-invoke-barrier
+++ a/include/asm-mn10300/processor.h
@@ -58,7 +58,7 @@ extern struct mn10300_cpuinfo boot_cpu_d
 extern void identify_cpu(struct mn10300_cpuinfo *);
 extern void print_cpu_info(struct mn10300_cpuinfo *);
 extern void dodgy_tsc(void);
-#define cpu_relax() do {} while (0)
+#define cpu_relax() barrier()
 
 /*
  * User space process size: 1.75GB (default).
_

Patches currently in -mm which might be from dhowells@redhat.com are

mn10300-replace-deprecated-topdir-with-newer-srctree.patch
mn10300-make-cpu_relax-invoke-barrier.patch
git-unionfs.patch
mutex-subsystem-synchro-test-module.patch

