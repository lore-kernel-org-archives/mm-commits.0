From: akpm@linux-foundation.org
Subject: - kernel-auditc-nlh-nlmsg_type-is-gotten-more-than-once.patch removed from -mm tree
Date: Wed, 02 Jul 2008 00:46:59 -0700
Message-ID: <200807020746.m627kxAk005609@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60696 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752023AbYGBH4y (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 2 Jul 2008 03:56:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: penght@cn.fujitsu.com, eparis@redhat.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     kernel/audit.c: nlh->nlmsg_type is gotten more than once
has been removed from the -mm tree.  Its filename was
     kernel-auditc-nlh-nlmsg_type-is-gotten-more-than-once.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kernel/audit.c: nlh->nlmsg_type is gotten more than once
From: Peng Haitao <penght@cn.fujitsu.com>

The first argument "nlh->nlmsg_type" of audit_receive_filter() should be
modified to "msg_type" in audit_receive_msg().

Signed-off-by: Peng Haitao <penght@cn.fujitsu.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Eric Paris <eparis@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/audit.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN kernel/audit.c~kernel-auditc-nlh-nlmsg_type-is-gotten-more-than-once kernel/audit.c
--- a/kernel/audit.c~kernel-auditc-nlh-nlmsg_type-is-gotten-more-than-once
+++ a/kernel/audit.c
@@ -779,7 +779,7 @@ static int audit_receive_msg(struct sk_b
 		}
 		/* fallthrough */
 	case AUDIT_LIST:
-		err = audit_receive_filter(nlh->nlmsg_type, NETLINK_CB(skb).pid,
+		err = audit_receive_filter(msg_type, NETLINK_CB(skb).pid,
 					   uid, seq, data, nlmsg_len(nlh),
 					   loginuid, sessionid, sid);
 		break;
@@ -798,7 +798,7 @@ static int audit_receive_msg(struct sk_b
 		}
 		/* fallthrough */
 	case AUDIT_LIST_RULES:
-		err = audit_receive_filter(nlh->nlmsg_type, NETLINK_CB(skb).pid,
+		err = audit_receive_filter(msg_type, NETLINK_CB(skb).pid,
 					   uid, seq, data, nlmsg_len(nlh),
 					   loginuid, sessionid, sid);
 		break;
_

Patches currently in -mm which might be from penght@cn.fujitsu.com are

origin.patch

