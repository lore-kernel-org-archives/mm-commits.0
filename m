From: akpm@linux-foundation.org
Subject: + documentation-sysctl-kerneltxt-show-taint-codes-in-hex.patch
 added to -mm tree
Date: Fri, 16 Feb 2018 13:03:41 -0800
Message-ID: <5a87472d.bGuOnD4buy7PKavH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57138 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750730AbeBPVDm (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 16 Feb 2018 16:03:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, adobriyan@gmail.com, corbet@lwn.net, keescook@chromium.org, rdunlap@infradead.org, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: Documentation/sysctl/kernel.txt: show taint codes in hex
has been added to the -mm tree.  Its filename is
     documentation-sysctl-kerneltxt-show-taint-codes-in-hex.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/documentation-sysctl-kerneltxt-show-taint-codes-in-hex.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/documentation-sysctl-kerneltxt-show-taint-codes-in-hex.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: Documentation/sysctl/kernel.txt: show taint codes in hex

The decimal representation is getting a bit hard to follow.

Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Kees Cook <keescook@chromium.org>
Cc: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/sysctl/kernel.txt |   50 +++++++++++++++---------------
 1 file changed, 25 insertions(+), 25 deletions(-)

diff -puN Documentation/sysctl/kernel.txt~documentation-sysctl-kerneltxt-show-taint-codes-in-hex Documentation/sysctl/kernel.txt
--- a/Documentation/sysctl/kernel.txt~documentation-sysctl-kerneltxt-show-taint-codes-in-hex
+++ a/Documentation/sysctl/kernel.txt
@@ -967,31 +967,31 @@ tainted:
 Non-zero if the kernel has been tainted. Numeric values, which can be
 ORed together. The letters are seen in "Tainted" line of Oops reports.
 
-     1 (P):  A module with a non-GPL license has been loaded, this
-             includes modules with no license.
-             Set by modutils >= 2.4.9 and module-init-tools.
-     2 (F): A module was force loaded by insmod -f.
-            Set by modutils >= 2.4.9 and module-init-tools.
-     4 (S): Unsafe SMP processors: SMP with CPUs not designed for SMP.
-     8 (R): A module was forcibly unloaded from the system by rmmod -f.
-    16 (M): A hardware machine check error occurred on the system.
-    32 (B): A bad page was discovered on the system.
-    64 (U): The user has asked that the system be marked "tainted". This
-            could be because they are running software that directly modifies
-            the hardware, or for other reasons.
-   128 (D): The system has died.
-   256 (A): The ACPI DSDT has been overridden with one supplied by the user
-            instead of using the one provided by the hardware.
-   512 (W): A kernel warning has occurred.
-  1024 (C): A module from drivers/staging was loaded.
-  2048 (I): The system is working around a severe firmware bug.
-  4096 (O): An out-of-tree module has been loaded.
-  8192 (E): An unsigned module has been loaded in a kernel supporting module
-            signature.
- 16384 (L): A soft lockup has previously occurred on the system.
- 32768 (K): The kernel has been live patched.
- 65536 (X): Auxiliary taint, defined and used by for distros.
-131072 (T): The kernel was built with the struct randomization plugin.
+0x00000001 (P):  A module with a non-GPL license has been loaded, this
+                 includes modules with no license.
+                 Set by modutils >= 2.4.9 and module-init-tools.
+0x00000002 (F): A module was force loaded by insmod -f.
+                Set by modutils >= 2.4.9 and module-init-tools.
+0x00000004 (S): Unsafe SMP processors: SMP with CPUs not designed for SMP.
+0x00000008 (R): A module was forcibly unloaded from the system by rmmod -f.
+0x00000010 (M): A hardware machine check error occurred on the system.
+0x00000020 (B): A bad page was discovered on the system.
+0x00000040 (U): The user has asked that the system be marked "tainted". This
+                could be because they are running software that directly
+                modifies the hardware, or for other reasons.
+0x00000080 (D): The system has died.
+0x00000100 (A): The ACPI DSDT has been overridden with one supplied by the user
+                instead of using the one provided by the hardware.
+0x00000200 (W): A kernel warning has occurred.
+0x00000400 (C): A module from drivers/staging was loaded.
+0x00000400 (I): The system is working around a severe firmware bug.
+0x00000800 (O): An out-of-tree module has been loaded.
+0x00020000 (E): An unsigned module has been loaded in a kernel supporting module
+                signature.
+0x00040000 (L): A soft lockup has previously occurred on the system.
+0x00080000 (K): The kernel has been live patched.
+0x00100000 (X): Auxiliary taint, defined and used by for distros.
+0x00200000 (T): The kernel was built with the struct randomization plugin.
 
 ==============================================================
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
include-linux-sched-mmh-re-inline-mmdrop.patch
mm-zpool-zpool_evictable-fix-mismatch-in-parameter-name-and-kernel-doc-fix.patch
vmalloc-fix-__gfp_highmem-usage-for-vmalloc_32-on-32b-systems-checkpatch-fixes.patch
mm-dont-defer-struct-page-initialization-for-xen-pv-guests-fix.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
mm.patch
list_lru-prefetch-neighboring-list-entries-before-acquiring-lock-fix.patch
mm-oom-cgroup-aware-oom-killer-fix.patch
mm-oom-docs-describe-the-cgroup-aware-oom-killer-fix-2-fix.patch
documentation-sysctl-kerneltxt-show-taint-codes-in-hex.patch
linux-next-git-rejects.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

