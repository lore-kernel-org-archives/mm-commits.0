From: akpm@linux-foundation.org
Subject: + x86-fix-setup-printk-format-warning.patch added to -mm tree
Date: Wed, 30 Apr 2008 14:18:51 -0700
Message-ID: <200804302118.m3ULIpvW003617@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57120 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762440AbYD3VTs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 17:19:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com


The patch titled
     x86: fix setup printk format warning
has been added to the -mm tree.  Its filename is
     x86-fix-setup-printk-format-warning.patch

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
Subject: x86: fix setup printk format warning
From: Randy Dunlap <randy.dunlap@oracle.com>

Fix x86 setup printk format warming:

next-20080430/arch/x86/kernel/setup.c:172: warning: format '%lu' expects type 'long unsigned int', but argument 2 has type 'ssize_t'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/setup.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/x86/kernel/setup.c~x86-fix-setup-printk-format-warning arch/x86/kernel/setup.c
--- a/arch/x86/kernel/setup.c~x86-fix-setup-printk-format-warning
+++ a/arch/x86/kernel/setup.c
@@ -95,7 +95,7 @@ void __init setup_per_cpu_areas(void)
 
 	/* Copy section for each CPU (we discard the original) */
 	size = PERCPU_ENOUGH_ROOM;
-	printk(KERN_INFO "PERCPU: Allocating %lu bytes of per cpu data\n",
+	printk(KERN_INFO "PERCPU: Allocating %zd bytes of per cpu data\n",
 			  size);
 
 	for_each_possible_cpu(i) {
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
basic-braille-screen-reader-support.patch
add-macros-similar-to-min-max-min_t-max_t.patch
infrastructure-to-debug-dynamic-objects.patch
debugobjects-add-documentation.patch
debugobjects-add-timer-specific-object-debugging-code.patch
add-hrtimer-specific-debugobjects-code.patch
sysfs-sysfs_update_group-stub-for-config_sysfs=n.patch
docbook-fix-fatal-rapidio-yet-again-and-more-to-come.patch
docbook-fix-vmalloc-missing-parameter-notation.patch
x86-fix-setup-printk-format-warning.patch
rapidio-fix-docbook-references.patch
rapidio-fix-kernel-doc-problems.patch
git-kvm.patch
8390-split-8390-support-into-a-pausing-and-a-non-pausing-driver-core.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
git-ocfs2.patch
git-unionfs.patch
fix-gregkh-usb-usb-isp1760-hcd-driver.patch
docbook-some-kernel-locking-fixes.patch
documentation-build-source-files-in-documentation-sub-dir.patch
documentation-build-source-files-in-documentation-sub-dir-disable.patch
profile-likely-unlikely-macros.patch

