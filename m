From: akpm@linux-foundation.org
Subject: + whitespace-fixes-system-auditing.patch added to -mm tree
Date: Fri, 20 Jul 2007 17:19:00 -0700
Message-ID: <200707210019.l6L0J0g0023905@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55244 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760196AbXGUAUh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 20 Jul 2007 20:20:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dwalker@mvista.com, dwmw2@infradead.org


The patch titled
     whitespace fixes: system auditing
has been added to the -mm tree.  Its filename is
     whitespace-fixes-system-auditing.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: whitespace fixes: system auditing
From: Daniel Walker <dwalker@mvista.com>

Just removing white space at the end of lines.

Signed-off-by: Daniel Walker <dwalker@mvista.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/audit.c |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff -puN kernel/audit.c~whitespace-fixes-system-auditing kernel/audit.c
--- a/kernel/audit.c~whitespace-fixes-system-auditing
+++ a/kernel/audit.c
@@ -664,11 +664,11 @@ static int audit_receive_msg(struct sk_b
 				if (sid) {
 					if (selinux_sid_to_string(
 							sid, &ctx, &len)) {
-						audit_log_format(ab, 
+						audit_log_format(ab,
 							" ssid=%u", sid);
 						/* Maybe call audit_panic? */
 					} else
-						audit_log_format(ab, 
+						audit_log_format(ab,
 							" subj=%s", ctx);
 					kfree(ctx);
 				}
@@ -769,7 +769,7 @@ static int audit_receive_msg(struct sk_b
 		sig_data->pid = audit_sig_pid;
 		memcpy(sig_data->ctx, ctx, len);
 		kfree(ctx);
-		audit_send_reply(NETLINK_CB(skb).pid, seq, AUDIT_SIGNAL_INFO, 
+		audit_send_reply(NETLINK_CB(skb).pid, seq, AUDIT_SIGNAL_INFO,
 				0, 0, sig_data, sizeof(*sig_data) + len);
 		kfree(sig_data);
 		break;
@@ -1013,7 +1013,7 @@ unsigned int audit_serial(void)
 	return ret;
 }
 
-static inline void audit_get_stamp(struct audit_context *ctx, 
+static inline void audit_get_stamp(struct audit_context *ctx,
 				   struct timespec *t, unsigned int *serial)
 {
 	if (ctx)
@@ -1064,7 +1064,7 @@ struct audit_buffer *audit_log_start(str
 	if (gfp_mask & __GFP_WAIT)
 		reserve = 0;
 	else
-		reserve = 5; /* Allow atomic callers to go up to five 
+		reserve = 5; /* Allow atomic callers to go up to five
 				entries over the normal backlog limit */
 
 	while (audit_backlog_limit
@@ -1327,7 +1327,7 @@ void audit_log_d_path(struct audit_buffe
 	if (IS_ERR(p)) { /* Should never happen since we send PATH_MAX */
 		/* FIXME: can we save some information here? */
 		audit_log_format(ab, "<too long>");
-	} else 
+	} else
 		audit_log_untrustedstring(ab, p);
 	kfree(path);
 }
@@ -1373,7 +1373,7 @@ void audit_log_end(struct audit_buffer *
  * audit_log_vformat, and audit_log_end.  It may be called
  * in any context.
  */
-void audit_log(struct audit_context *ctx, gfp_t gfp_mask, int type, 
+void audit_log(struct audit_context *ctx, gfp_t gfp_mask, int type,
 	       const char *fmt, ...)
 {
 	struct audit_buffer *ab;
_

Patches currently in -mm which might be from dwalker@mvista.com are

whitespace-fixes-time-syscalls.patch
whitespace-fixes-process-accounting.patch
whitespace-fixes-cpuset.patch
whitespace-fixes-relayfs.patch
whitespace-fixes-audit-filtering.patch
whitespace-fixes-dma-channel-allocator.patch
whitespace-fixes-fork.patch
whitespace-fixes-module-loading.patch
whitespace-fixes-panic-handling.patch
whitespace-fixes-capability-syscalls.patch
whitespace-fixes-syscall-auditing.patch
whitespace-fixes-compat-syscalls.patch
whitespace-fixes-system-auditing.patch
whitespace-fixes-execution-domains.patch
whitespace-fixes-interval-timers.patch
whitespace-fixes-system-timers.patch
whitespace-fixes-task-exit-handling.patch
profile-likely-unlikely-macros.patch
