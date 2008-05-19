From: akpm@linux-foundation.org
Subject: + kernel-auditc-nlh-nlmsg_type-is-gotten-more-than-once.patch added to -mm tree
Date: Mon, 19 May 2008 14:25:42 -0700
Message-ID: <200805192125.m4JLPg1h021285@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40328 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757200AbYESV05 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 19 May 2008 17:26:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: penght@cn.fujitsu.com, eparis@redhat.com, viro@zeniv.linux.org.uk


The patch titled
     kernel/audit.c: nlh->nlmsg_type is gotten more than once
has been added to the -mm tree.  Its filename is
     kernel-auditc-nlh-nlmsg_type-is-gotten-more-than-once.patch

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

kernel-auditc-nlh-nlmsg_type-is-gotten-more-than-once.patch

