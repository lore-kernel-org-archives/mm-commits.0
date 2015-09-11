From: akpm@linux-foundation.org
Subject: [merged]
 kmod-correct-documentation-of-return-status-of-request_module.patch removed from -mm tree
Date: Fri, 11 Sep 2015 11:12:43 -0700
Message-ID: <55f3199b.6paMWrKb8MfNXrfu%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53885 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751960AbbIKSMo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 11 Sep 2015 14:12:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: neilb@suse.com, oleg@redhat.com, rgoldwyn@suse.de, rusty@rustcorp.com.au, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: kmod: correct documentation of return status of request_module
has been removed from the -mm tree.  Its filename was
     kmod-correct-documentation-of-return-status-of-request_module.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: NeilBrown <neilb@suse.com>
Subject: kmod: correct documentation of return status of request_module

If request_module() successfully runs modprobe, but modprobe exits with a
non-zero status, then the return value from request_module() will be that
(positive) error status.  So the return from request_module can be:

 negative errno
 zero for success
 positive exit code.

Signed-off-by: NeilBrown <neilb@suse.com>
Cc: Goldwyn Rodrigues <rgoldwyn@suse.de>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kmod.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff -puN kernel/kmod.c~kmod-correct-documentation-of-return-status-of-request_module kernel/kmod.c
--- a/kernel/kmod.c~kmod-correct-documentation-of-return-status-of-request_module
+++ a/kernel/kmod.c
@@ -114,10 +114,11 @@ out:
  * @...: arguments as specified in the format string
  *
  * Load a module using the user mode module loader. The function returns
- * zero on success or a negative errno code on failure. Note that a
- * successful module load does not mean the module did not then unload
- * and exit on an error of its own. Callers must check that the service
- * they requested is now available not blindly invoke it.
+ * zero on success or a negative errno code or positive exit code from
+ * "modprobe" on failure. Note that a successful module load does not mean
+ * the module did not then unload and exit on an error of its own. Callers
+ * must check that the service they requested is now available not blindly
+ * invoke it.
  *
  * If module auto-loading support is disabled then this function
  * becomes a no-operation.
_

Patches currently in -mm which might be from neilb@suse.com are


