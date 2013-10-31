From: akpm@linux-foundation.org
Subject: [merged]
 makefile-enable-werror=implicit-int-and-werror=strict-prototypes-by-default.patch removed from -mm tree
Date: Thu, 31 Oct 2013 10:59:50 -0700
Message-ID: <52729a96.kNX+wLFBb+r9AmQM%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59444 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754576Ab3JaR7v (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 31 Oct 2013 13:59:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mmarek@suse.cz, geert@linux-m68k.org, slyfox@gentoo.org

Subject: [merged] makefile-enable-werror=implicit-int-and-werror=strict-prototypes-by-default.patch removed from -mm tree
To: slyfox@gentoo.org,geert@linux-m68k.org,mmarek@suse.cz,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 31 Oct 2013 10:59:50 -0700


The patch titled
     Subject: ./Makefile: enable -Werror=implicit-int and -Werror=strict-prototypes by default
has been removed from the -mm tree.  Its filename was
     makefile-enable-werror=implicit-int-and-werror=strict-prototypes-by-default.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Sergei Trofimovich <slyfox@gentoo.org>
Subject: ./Makefile: enable -Werror=implicit-int and -Werror=strict-prototypes by default

The common error found in forward-ported/backported patches is missing
headers.  One recent example (files and function names are mangled):

    void foo(){}
    EXPORT_SYMBOL(foo);

gave only warning

    foo.c:12345678:5: warning: function declaration isn't a prototype [-Wstrict-prototypes]
    void foo(){}
         ^

    foo.c:12345679:5: warning: data definition has no type or storage class [enabled by default]
    EXPORT_SYMBOL(foo);
    foo.c:12345679:5: warning: type defaults to 'int' in declaration of 'EXORT_SYMBOL' [-Werror=implicit-int]

Now it's a fatal error. Tested on x86_64 allyesconfig.

[akpm@linux-foundation.org: fix typos in comments]
Signed-off-by: Sergei Trofimovich <slyfox@gentoo.org>
Cc: Michal Marek <mmarek@suse.cz>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Makefile |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN Makefile~makefile-enable-werror=implicit-int-and-werror=strict-prototypes-by-default Makefile
--- a/Makefile~makefile-enable-werror=implicit-int-and-werror=strict-prototypes-by-default
+++ a/Makefile
@@ -659,6 +659,12 @@ KBUILD_CFLAGS	+= $(call cc-option,-fno-s
 # conserve stack if available
 KBUILD_CFLAGS   += $(call cc-option,-fconserve-stack)
 
+# disallow errors like 'EXPORT_GPL(foo);' with missing header
+KBUILD_CFLAGS   += $(call cc-option,-Werror=implicit-int)
+
+# require functions to have arguments in prototypes, not empty 'int foo()'
+KBUILD_CFLAGS   += $(call cc-option,-Werror=strict-prototypes)
+
 # use the deterministic mode of AR if available
 KBUILD_ARFLAGS := $(call ar-option,D)
 
_

Patches currently in -mm which might be from slyfox@gentoo.org are

linux-next.patch

