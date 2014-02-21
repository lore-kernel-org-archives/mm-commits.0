From: akpm@linux-foundation.org
Subject: + makefile-fix-build-with-make-380-again.patch added to -mm tree
Date: Fri, 21 Feb 2014 12:07:52 -0800
Message-ID: <5307b218.8VLijuWgRh9icTUZ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58044 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752287AbaBUUHx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 21 Feb 2014 15:07:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mmarek@suse.cz, mingo@kernel.org, keescook@chromium.org, jbeulich@suse.com, JBeulich@suse.com

Subject: + makefile-fix-build-with-make-380-again.patch added to -mm tree
To: JBeulich@suse.com,jbeulich@suse.com,keescook@chromium.org,mingo@kernel.org,mmarek@suse.cz
From: akpm@linux-foundation.org
Date: Fri, 21 Feb 2014 12:07:52 -0800


The patch titled
     Subject: Makefile: fix build with make 3.80 again
has been added to the -mm tree.  Its filename is
     makefile-fix-build-with-make-380-again.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/makefile-fix-build-with-make-380-again.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/makefile-fix-build-with-make-380-again.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Jan Beulich" <JBeulich@suse.com>
Subject: Makefile: fix build with make 3.80 again

According to Documentation/Changes, make 3.80 is still being supported for
building the kernel, hence make files must not make (unconditional) use of
features introduced only in newer versions.  Commit 8779657d
("stackprotector: Introduce CONFIG_CC_STACKPROTECTOR_STRONG") however
introduced an "else ifdef" construct which make 3.80 doesn't understand.

Also correct a warning message still referencing the old config option
name.

Apart from that I question the use of "ifdef" here (but it was used that
way already prior to said commit): ifeq (,y) would seem more to the point.

Signed-off-by: Jan Beulich <jbeulich@suse.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Michal Marek <mmarek@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Makefile |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN Makefile~makefile-fix-build-with-make-380-again Makefile
--- a/Makefile~makefile-fix-build-with-make-380-again
+++ a/Makefile
@@ -605,7 +605,7 @@ endif
 ifdef CONFIG_CC_STACKPROTECTOR_REGULAR
   stackp-flag := -fstack-protector
   ifeq ($(call cc-option, $(stackp-flag)),)
-    $(warning Cannot use CONFIG_CC_STACKPROTECTOR: \
+    $(warning Cannot use CONFIG_CC_STACKPROTECTOR_REGULAR: \
              -fstack-protector not supported by compiler)
   endif
 else ifdef CONFIG_CC_STACKPROTECTOR_STRONG
@@ -618,6 +618,7 @@ else
   # Force off for distro compilers that enable stack protector by default.
   stackp-flag := $(call cc-option, -fno-stack-protector)
 endif
+endif
 KBUILD_CFLAGS += $(stackp-flag)
 
 # This warning generated too much noise in a regular build.
_

Patches currently in -mm which might be from JBeulich@suse.com are

makefile-fix-build-with-make-380-again.patch

