From: akpm@linux-foundation.org
Subject: [merged]
 init-move-stack-canary-initialization-after-setup_arch.patch removed from
 -mm tree
Date: Mon, 11 Sep 2017 12:42:58 -0700
Message-ID: <20170911194258.81O5JS9qy%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50364 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751110AbdIKTm7 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 11 Sep 2017 15:42:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: danielmicay@gmail.com, keescook@chromium.org, labbott@redhat.com, lauraa@codeaurora.org, mm-commits@vger.kernel.org, nnk@google.com, tytso@mit.edu


The patch titled
     Subject: init: move stack canary initialization after setup_arch
has been removed from the -mm tree.  Its filename was
     init-move-stack-canary-initialization-after-setup_arch.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Laura Abbott <lauraa@codeaurora.org>
Subject: init: move stack canary initialization after setup_arch

Patch series "Command line randomness", v3.

A series to add the kernel command line as a source of randomness.

This patch (of 2):

Stack canary intialization involves getting a random number.  Getting this
random number may involve accessing caches or other architectural specific
features which are not available until after the architecture is setup. 
Move the stack canary initialization later to accommodate this.

Link: http://lkml.kernel.org/r/20170816231458.2299-2-labbott@redhat.com
Signed-off-by: Laura Abbott <lauraa@codeaurora.org>
Signed-off-by: Laura Abbott <labbott@redhat.com>
Acked-by: Kees Cook <keescook@chromium.org>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: Daniel Micay <danielmicay@gmail.com>
Cc: Nick Kralevich <nnk@google.com>
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
