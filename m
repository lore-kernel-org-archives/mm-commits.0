From: akpm@linux-foundation.org
Subject: [patch 097/126] init: move stack canary initialization
 after setup_arch
Date: Fri, 08 Sep 2017 16:16:17 -0700
Message-ID: <20170908231617.WgTAIt3If%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53338 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757261AbdIHXQS (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 8 Sep 2017 19:16:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, danielmicay@gmail.com, keescook@chromium.org, labbott@redhat.com, lauraa@codeaurora.org, mm-commits@vger.kernel.org, nnk@google.com, torvalds@linux-foundation.org, tytso@mit.edu

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
