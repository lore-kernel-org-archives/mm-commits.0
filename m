From: akpm@linux-foundation.org
Subject: - whitespace-fixes-system-auditing.patch removed from -mm tree
Date: Thu, 18 Oct 2007 20:43:55 -0700
Message-ID: <200710190343.l9J3htEi013104@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36897 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966524AbXJSD4F (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 23:56:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dwalker@mvista.com, dwmw2@infradead.org, mm-commits@vger.kernel.org


The patch titled
     whitespace fixes: system auditing
has been removed from the -mm tree.  Its filename was
     whitespace-fixes-system-auditing.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: whitespace fixes: system auditing
From: Daniel Walker <dwalker@mvista.com>

Just removing white space at the end of lines.

Signed-off-by: Daniel Walker <dwalker@mvista.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/audit.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

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
@@ -1005,7 +1005,7 @@ unsigned int audit_serial(void)
 	return ret;
 }
 
-static inline void audit_get_stamp(struct audit_context *ctx, 
+static inline void audit_get_stamp(struct audit_context *ctx,
 				   struct timespec *t, unsigned int *serial)
 {
 	if (ctx)
@@ -1056,7 +1056,7 @@ struct audit_buffer *audit_log_start(str
 	if (gfp_mask & __GFP_WAIT)
 		reserve = 0;
 	else
-		reserve = 5; /* Allow atomic callers to go up to five 
+		reserve = 5; /* Allow atomic callers to go up to five
 				entries over the normal backlog limit */
 
 	while (audit_backlog_limit
@@ -1319,7 +1319,7 @@ void audit_log_d_path(struct audit_buffe
 	if (IS_ERR(p)) { /* Should never happen since we send PATH_MAX */
 		/* FIXME: can we save some information here? */
 		audit_log_format(ab, "<too long>");
-	} else 
+	} else
 		audit_log_untrustedstring(ab, p);
 	kfree(path);
 }
@@ -1365,7 +1365,7 @@ void audit_log_end(struct audit_buffer *
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

origin.patch
whitespace-fixes-task-exit-handling.patch
profile-likely-unlikely-macros.patch
profile-likely-unlikely-macros-fix.patch
