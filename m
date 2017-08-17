From: akpm@linux-foundation.org
Subject: + init-move-stack-canary-initialization-after-setup_arch.patch
 added to -mm tree
Date: Thu, 17 Aug 2017 14:59:56 -0700
Message-ID: <599611dc.WdEM85E19qNjLL/Y%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44600 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753669AbdHQWAB (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 17 Aug 2017 18:00:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lauraa@codeaurora.org, danielmicay@gmail.com, keescook@chromium.org, labbott@redhat.com, tytso@mit.edu, mm-commits@vger.kernel.org


The patch titled
     Subject: init: move stack canary initialization after setup_arch
has been added to the -mm tree.  Its filename is
     init-move-stack-canary-initialization-after-setup_arch.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/init-move-stack-canary-initialization-after-setup_arch.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/init-move-stack-canary-initialization-after-setup_arch.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Laura Abbott <lauraa@codeaurora.org>
Subject: init: move stack canary initialization after setup_arch

Patch series "Command line randomness", v3.

A series to add the kernel command line as a source of randomness.

This patch (of 2):

Stack canary intialization involves getting a random number.  Getting this
random number may involve accessing caches or other architectural specific
features which are not available until after the architecture is setup. 
Move the stack canary initialization later to accomodate this.

Link: http://lkml.kernel.org/r/20170816231458.2299-2-labbott@redhat.com
Signed-off-by: Laura Abbott <lauraa@codeaurora.org>
Signed-off-by: Laura Abbott <labbott@redhat.com>
Acked-by: Kees Cook <keescook@chromium.org>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: Daniel Micay <danielmicay@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/main.c |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff -puN init/main.c~init-move-stack-canary-initialization-after-setup_arch init/main.c
--- a/init/main.c~init-move-stack-canary-initialization-after-setup_arch
+++ a/init/main.c
@@ -515,12 +515,6 @@ asmlinkage __visible void __init start_k
 	smp_setup_processor_id();
 	debug_objects_early_init();
 
-	/*
-	 * Set up the initial canary ASAP:
-	 */
-	add_latent_entropy();
-	boot_init_stack_canary();
