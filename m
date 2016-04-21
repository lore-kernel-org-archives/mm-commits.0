From: akpm@linux-foundation.org
Subject: + fs-execc-fix-minor-memory-leak.patch added to -mm tree
Date: Thu, 21 Apr 2016 14:13:58 -0700
Message-ID: <57194296.PkA+tTVuiuaiFdzB%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56484 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753140AbcDUVN7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Apr 2016 17:13:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/exec.c: fix minor memory leak
has been added to the -mm tree.  Its filename is
     fs-execc-fix-minor-memory-leak.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-execc-fix-minor-memory-leak.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-execc-fix-minor-memory-leak.patch

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
Subject: fs/exec.c: fix minor memory leak

When the to-be-removed argument's trailing '\0' is the final byte in the
page, remove_arg_zero()'s logic will avoid freeing the page, will break
from the loop and will then advance bprm->p to point at the first byte in
the next page.  Net result: the final page for the zeroeth argument is
unfreed.

It isn't a very important leak - that page will be freed later by the
bprm-wide sweep in free_arg_pages().

Fixes: https://bugzilla.kernel.org/show_bug.cgi?id=116841
Reported by: hujunjie <jj.net@163.com>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/exec.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff -puN fs/exec.c~fs-execc-fix-minor-memory-leak fs/exec.c
--- a/fs/exec.c~fs-execc-fix-minor-memory-leak
+++ a/fs/exec.c
@@ -1482,8 +1482,15 @@ int remove_arg_zero(struct linux_binprm
 		kunmap_atomic(kaddr);
 		put_arg_page(page);
 
-		if (offset == PAGE_SIZE)
+		if (offset == PAGE_SIZE) {
 			free_arg_page(bprm, (bprm->p >> PAGE_SHIFT) - 1);
+		} else if (offset == PAGE_SIZE - 1) {
+			/*
+			 * The trailing '\0' is the last byte in a page - we're
+			 * about to advance past that byte so free its page now
+			 */
+			free_arg_page(bprm, (bprm->p >> PAGE_SHIFT));
+		}
 	} while (offset == PAGE_SIZE);
 
 	bprm->p++;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
mm.patch
mm-rename-_count-field-of-the-struct-page-to-_refcount-fix.patch
mm-rename-_count-field-of-the-struct-page-to-_refcount-fix-fix.patch
include-linux-apply-__malloc-attribute-checkpatch-fixes.patch
include-linux-nodemaskh-create-next_node_in-helper.patch
include-linux-nodemaskh-create-next_node_in-helper-fix-fix.patch
mm-hugetlbc-use-first_memory_node.patch
mm-mempolicyc-offset_il_node-document-and-clarify.patch
mm-compaction-direct-freepage-allocation-for-async-direct-compaction-checkpatch-fixes.patch
mm-uninline-page_mapped.patch
mm-uninline-page_mapped-checkpatch-fixes.patch
memory_hotplug-introduce-config_memory_hotplug_default_online-fix.patch
exit_thread-remove-empty-bodies-fix.patch
exit_thread-accept-a-task-parameter-to-be-exited-checkpatch-fixes.patch
fs-execc-fix-minor-memory-leak.patch
drivers-net-wireless-intel-iwlwifi-dvm-calibc-fix-min-warning.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

