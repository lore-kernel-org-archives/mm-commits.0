From: akpm@linux-foundation.org
Subject: +
 makefile-enable-werror=implicit-int-and-werror=strict-prototypes-by-default.patch added to -mm tree
Date: Thu, 15 Aug 2013 14:17:43 -0700
Message-ID: <520d4577.fxa4Rg/M8Ryb9Fvo%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42684 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751793Ab3HOVRo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 15 Aug 2013 17:17:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mmarek@suse.cz, slyfox@gentoo.org

Subject: + makefile-enable-werror=implicit-int-and-werror=strict-prototypes-by-default.patch added to -mm tree
To: slyfox@gentoo.org,mmarek@suse.cz
From: akpm@linux-foundation.org
Date: Thu, 15 Aug 2013 14:17:43 -0700


The patch titled
     Subject: Makefile: enable -Werror=implicit-int and -Werror=strict-prototypes by default
has been added to the -mm tree.  Its filename is
     makefile-enable-werror=implicit-int-and-werror=strict-prototypes-by-default.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/makefile-enable-werror=implicit-int-and-werror=strict-prototypes-by-default.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/makefile-enable-werror=implicit-int-and-werror=strict-prototypes-by-default.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

makefile-enable-werror=implicit-int-and-werror=strict-prototypes-by-default.patch
cleanup-add-forward-declarations-for-inplace-syscall-wrappers.patch

