From: akpm@linux-foundation.org
Subject: [to-be-updated]
 makefile-enable-werror=implicit-int-and-werror=strict-prototypes-by-default.patch removed from -mm tree
Date: Fri, 23 Aug 2013 16:07:39 -0700
Message-ID: <5217eb3b.2PDMHjjnEUqH3dsS%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:32805 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753610Ab3HWXHk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 23 Aug 2013 19:07:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mmarek@suse.cz, slyfox@gentoo.org

Subject: [to-be-updated] makefile-enable-werror=implicit-int-and-werror=strict-prototypes-by-default.patch removed from -mm tree
To: slyfox@gentoo.org,mmarek@suse.cz,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 23 Aug 2013 16:07:39 -0700


The patch titled
     Subject: Makefile: enable -Werror=implicit-int and -Werror=strict-prototypes by default
has been removed from the -mm tree.  Its filename was
     makefile-enable-werror=implicit-int-and-werror=strict-prototypes-by-default.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Sergei Trofimovich <slyfox@gentoo.org>
Subject: Makefile: enable -Werror=implicit-int and -Werror=strict-prototypes by default

A common error type found in forward-ported/backported patches is missing
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

Now it's a fata error. Tested on x86_64 allyesconfig.

Signed-off-by: Sergei Trofimovich <slyfox@gentoo.org>
Cc: Michal Marek <mmarek@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Makefile |    5 +++++
 1 file changed, 5 insertions(+)

diff -puN Makefile~makefile-enable-werror=implicit-int-and-werror=strict-prototypes-by-default Makefile
--- a/Makefile~makefile-enable-werror=implicit-int-and-werror=strict-prototypes-by-default
+++ a/Makefile
@@ -374,6 +374,11 @@ KBUILD_CFLAGS   := -Wall -Wundef -Wstric
 		   -Werror-implicit-function-declaration \
 		   -Wno-format-security \
 		   -fno-delete-null-pointer-checks
+
+# not universally available, but nice to have ones
+KBUILD_CFLAGS   +=  $(call cc-option,-Werror=implicit-int) \
+		    $(call cc-option,-Werror=strict-prototypes)
+
 KBUILD_AFLAGS_KERNEL :=
 KBUILD_CFLAGS_KERNEL :=
 KBUILD_AFLAGS   := -D__ASSEMBLY__
_

Patches currently in -mm which might be from slyfox@gentoo.org are

cleanup-add-forward-declarations-for-inplace-syscall-wrappers.patch

