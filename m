From: akpm@linux-foundation.org
Subject: [folded] eventfd-change-int-to-__u64-in-eventfd_signal-fix.patch removed from -mm tree
Date: Thu, 31 May 2012 16:19:41 -0700
Message-ID: <20120531231941.7618CA009B@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:58699 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758599Ab2EaXTm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 31 May 2012 19:19:42 -0400
Received: by vcbfl13 with SMTP id fl13so161751vcb.1
        for <mm-commits@vger.kernel.org>; Thu, 31 May 2012 16:19:42 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, davidel@xmailserver.org, handai.szj@taobao.com, mm-commits@vger.kernel.org


The patch titled
     Subject: eventfd-change-int-to-__u64-in-eventfd_signal-fix
has been removed from the -mm tree.  Its filename was
     eventfd-change-int-to-__u64-in-eventfd_signal-fix.patch

This patch was dropped because it was folded into eventfd-change-int-to-__u64-in-eventfd_signal.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: eventfd-change-int-to-__u64-in-eventfd_signal-fix

update interface documentation

Cc: Davide Libenzi <davidel@xmailserver.org>
Cc: Sha Zhengju <handai.szj@taobao.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/eventfd.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff -puN fs/eventfd.c~eventfd-change-int-to-__u64-in-eventfd_signal-fix fs/eventfd.c
--- a/fs/eventfd.c~eventfd-change-int-to-__u64-in-eventfd_signal-fix
+++ a/fs/eventfd.c
@@ -46,10 +46,8 @@ struct eventfd_ctx {
  * value, and we signal this as overflow condition by returining a POLLERR
  * to poll(2).
  *
- * Returns @n in case of success, a non-negative number lower than @n in case
- * of overflow, or the following error codes:
- *
- * -EINVAL    : The value of @n is negative.
+ * Returns the amount by which the counter was incrememnted.  This will be less
+ * than @n if the counter has overflowed.
  */
 __u64 eventfd_signal(struct eventfd_ctx *ctx, __u64 n)
 {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
security-keys-keyctlc-suppress-memory-allocation-failure-warning.patch
isdn-add-missing-kern_cont.patch
kernel-irq-managec-use-the-pr_foo-infrastructure-to-prefix-printks.patch
vsprintf-correctly-handle-width-when-flag-used-in-%p-format.patch
vsprintf-further-optimize-decimal-conversion.patch
proc-clean-up-proc-pid-environ-handling.patch
kernel-cpuc-document-clear_tasks_mm_cpumask.patch
ipc-mqueue-improve-performance-of-send-recv.patch
ipc-mqueue-correct-mq_attr_ok-test.patch
ipc-mqueue-strengthen-checks-on-mqueue-creation.patch
tools-selftests-add-mq_perf_tests.patch
ipc-mqueue-add-rbtree-node-caching-support.patch
pidns-make-killed-children-autoreap.patch
fs-nls-add-apple-nls.patch
eventfd-change-int-to-__u64-in-eventfd_signal.patch
syscalls-x86-add-__nr_kcmp-syscall-v8.patch
syscalls-x86-add-__nr_kcmp-syscall-v8-comment-update-fix.patch

