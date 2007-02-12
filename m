From: akpm@linux-foundation.org
Subject: - kexec-fix-references-to-init-in-documentation-for-kexe.patch removed from -mm tree
Date: Mon, 12 Feb 2007 14:44:00 -0800
Message-ID: <200702122244.l1CMi0uc013544@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:44924 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030253AbXBLWoK (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Feb 2007 17:44:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: horms@verge.net.au, ebiederm@xmission.com, judith@linux-foundation.org, vgoyal@in.ibm.com, mm-commits@vger.kernel.org


The patch titled
     kexec: fix references to init in documentation for kexec
has been removed from the -mm tree.  Its filename was
     kexec-fix-references-to-init-in-documentation-for-kexe.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: kexec: fix references to init in documentation for kexec
From: Horms <horms@verge.net.au>

I've noticed that the boot options are not correct for in the documentation
for kdump.  The "init" keyword is not necessary, and causes a kernel panic
when booting with an initrd on Fedora 5.

[horms@verge.net.au: put original comment with the latest version of the patch]
Signed-off-by: Judith Lebzeelter <judith@osdl.org>
Acked-by: Vivek Goyal <vgoyal@in.ibm.com>
Signed-off-by: Simon Horman <horms@verge.net.au>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/kdump/kdump.txt |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN Documentation/kdump/kdump.txt~kexec-fix-references-to-init-in-documentation-for-kexe Documentation/kdump/kdump.txt
--- a/Documentation/kdump/kdump.txt~kexec-fix-references-to-init-in-documentation-for-kexe
+++ a/Documentation/kdump/kdump.txt
@@ -311,10 +311,10 @@ Following are the arch specific command 
 loading dump-capture kernel.
 
 For i386, x86_64 and ia64:
-	"init 1 irqpoll maxcpus=1"
+	"1 irqpoll maxcpus=1"
 
 For ppc64:
-	"init 1 maxcpus=1 noirqdistrib"
+	"1 maxcpus=1 noirqdistrib"
 
 
 Notes on loading the dump-capture kernel:
@@ -332,8 +332,8 @@ Notes on loading the dump-capture kernel
 * You must specify <root-dev> in the format corresponding to the root
   device name in the output of mount command.
 
-* "init 1" boots the dump-capture kernel into single-user mode without
-  networking. If you want networking, use "init 3."
+* Boot parameter "1" boots the dump-capture kernel into single-user
+  mode without networking. If you want networking, use "3".
 
 * We generally don' have to bring up a SMP kernel just to capture the
   dump. Hence generally it is useful either to build a UP dump-capture
_

Patches currently in -mm which might be from horms@verge.net.au are

origin.patch
git-ia64.patch
