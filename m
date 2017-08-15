From: akpm@linux-foundation.org
Subject: + mm-cma-fix-stack-corruption-due-to-sprintf-usage.patch added to -mm tree
Date: Tue, 15 Aug 2017 15:57:25 -0700
Message-ID: <59937c55.RRVi/BTPJKFVJoBU%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60082 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752453AbdHOW50 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 15 Aug 2017 18:57:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: guptap@codeaurora.org, gregkh@linuxfoundation.org, labbott@redhat.com, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/cma_debug.c: fix stack corruption due to sprintf usage
has been added to the -mm tree.  Its filename is
     mm-cma-fix-stack-corruption-due-to-sprintf-usage.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-cma-fix-stack-corruption-due-to-sprintf-usage.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-cma-fix-stack-corruption-due-to-sprintf-usage.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Prakash Gupta <guptap@codeaurora.org>
Subject: mm/cma_debug.c: fix stack corruption due to sprintf usage

name[] in cma_debugfs_add_one() can only accommodate 16 chars including
NULL to store sprintf output.  It's common for cma device name to be
larger than 15 chars.  This can cause stack corrpution.  If the gcc stack
protector is turned on, this can cause a panic due to stack corruption.

Below is one example trace:

Kernel panic - not syncing: stack-protector: Kernel stack is corrupted in:
ffffff8e69a75730
Call trace:
  [<ffffff8e68289504>] dump_backtrace+0x0/0x2c4
  [<ffffff8e682897e8>] show_stack+0x20/0x28
  [<ffffff8e685ea808>] dump_stack+0xb8/0xf4
  [<ffffff8e683c454c>] panic+0x154/0x2b0
  [<ffffff8e682a724c>] print_tainted+0x0/0xc0
  [<ffffff8e69a75730>] cma_debugfs_init+0x274/0x290
  [<ffffff8e682839ec>] do_one_initcall+0x5c/0x168
  [<ffffff8e69a50e24>] kernel_init_freeable+0x1c8/0x280

Fix the short sprintf buffer in cma_debugfs_add_one() by using scnprintf()
instead of sprintf().

Link: http://lkml.kernel.org/r/1502446217-21840-1-git-send-email-guptap@codeaurora.org
Fixes: f318dd083c81 ("cma: Store a name in the cma structure")
Signed-off-by: Prakash Gupta <guptap@codeaurora.org>
Acked-by: Laura Abbott <labbott@redhat.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/cma_debug.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/cma_debug.c~mm-cma-fix-stack-corruption-due-to-sprintf-usage mm/cma_debug.c
--- a/mm/cma_debug.c~mm-cma-fix-stack-corruption-due-to-sprintf-usage
+++ a/mm/cma_debug.c
@@ -167,7 +167,7 @@ static void cma_debugfs_add_one(struct c
 	char name[16];
 	int u32s;
 
-	sprintf(name, "cma-%s", cma->name);
+	scnprintf(name, sizeof(name), "cma-%s", cma->name);
 
 	tmp = debugfs_create_dir(name, cma_debugfs_root);
 
_

Patches currently in -mm which might be from guptap@codeaurora.org are

mm-cma-fix-stack-corruption-due-to-sprintf-usage.patch

