From: akpm@linux-foundation.org
Subject: + audit-remove-useless-argument-type-in-audit_filter_user.patch added to -mm tree
Date: Wed, 21 May 2008 14:45:54 -0700
Message-ID: <200805212145.m4LLjs43002333@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49600 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759702AbYEUVqD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 21 May 2008 17:46:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: penght@cn.fujitsu.com


The patch titled
     audit: remove useless argument type in audit_filter_user()
has been added to the -mm tree.  Its filename is
     audit-remove-useless-argument-type-in-audit_filter_user.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: audit: remove useless argument type in audit_filter_user()
From: Peng Haitao <penght@cn.fujitsu.com>

The second argument "type" is not used in audit_filter_user().

Signed-off-by: Peng Haitao <penght@cn.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/audit.h |    2 +-
 kernel/audit.c        |    2 +-
 kernel/auditfilter.c  |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff -puN include/linux/audit.h~audit-remove-useless-argument-type-in-audit_filter_user include/linux/audit.h
--- a/include/linux/audit.h~audit-remove-useless-argument-type-in-audit_filter_user
+++ a/include/linux/audit.h
@@ -571,7 +571,7 @@ extern void		    audit_log_lost(const ch
 extern int		    audit_update_lsm_rules(void);
 
 				/* Private API (for audit.c only) */
-extern int audit_filter_user(struct netlink_skb_parms *cb, int type);
+extern int audit_filter_user(struct netlink_skb_parms *cb);
 extern int audit_filter_type(int type);
 extern int  audit_receive_filter(int type, int pid, int uid, int seq,
 				void *data, size_t datasz, uid_t loginuid,
diff -puN kernel/audit.c~audit-remove-useless-argument-type-in-audit_filter_user kernel/audit.c
--- a/kernel/audit.c~audit-remove-useless-argument-type-in-audit_filter_user
+++ a/kernel/audit.c
@@ -738,7 +738,7 @@ static int audit_receive_msg(struct sk_b
 		if (!audit_enabled && msg_type != AUDIT_USER_AVC)
 			return 0;
 
-		err = audit_filter_user(&NETLINK_CB(skb), msg_type);
+		err = audit_filter_user(&NETLINK_CB(skb));
 		if (err == 1) {
 			err = 0;
 			if (msg_type == AUDIT_USER_TTY) {
diff -puN kernel/auditfilter.c~audit-remove-useless-argument-type-in-audit_filter_user kernel/auditfilter.c
--- a/kernel/auditfilter.c~audit-remove-useless-argument-type-in-audit_filter_user
+++ a/kernel/auditfilter.c
@@ -1720,7 +1720,7 @@ static int audit_filter_user_rules(struc
 	return 1;
 }
 
-int audit_filter_user(struct netlink_skb_parms *cb, int type)
+int audit_filter_user(struct netlink_skb_parms *cb)
 {
 	enum audit_state state = AUDIT_DISABLED;
 	struct audit_entry *e;
_

Patches currently in -mm which might be from penght@cn.fujitsu.com are

kernel-auditc-nlh-nlmsg_type-is-gotten-more-than-once.patch
audit-remove-useless-argument-type-in-audit_filter_user.patch

