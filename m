From: akpm@linux-foundation.org
Subject: + taskstats-pad-taskstats-netlink-response-for-aligment-issues-on-ia64.patch added to -mm tree
Date: Mon, 20 Dec 2010 21:48:55 -0800
Message-ID: <201012210552.oBL5qKT9021549@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37310 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751781Ab0LUFwb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 21 Dec 2010 00:52:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jeffm@suse.com, balbir@in.ibm.com, brian@xyzw.org, guichaz@gmail.com


The patch titled
     taskstats: pad taskstats netlink response for aligment issues on ia64
has been added to the -mm tree.  Its filename is
     taskstats-pad-taskstats-netlink-response-for-aligment-issues-on-ia64.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: taskstats: pad taskstats netlink response for aligment issues on ia64
From: Jeff Mahoney <jeffm@suse.com>

The taskstats structure is internally aligned on 8 byte boundaries but the
layout of the aggregrate reply, with two NLA headers and the pid (each 4
bytes), actually force the entire structure to be unaligned.  This causes
the kernel to issue unaligned access warnings on some architectures like
ia64.  Unfortunately, some software out there doesn't properly unroll the
NLA packet and assumes that the start of the taskstats structure will
always be 20 bytes from the start of the netlink payload.  Aligning the
start of the taskstats structure breaks this software, which we don't
want.  So, for now the alignment only happens on architectures that
require it and those users will have to update to fixed versions of those
packages.  Space is reserved in the packet only when needed.  This ifdef
should be removed in several years e.g.  2012 once we can be confident
that fixed versions are installed on most systems.  We add the padding
before the aggregate since the aggregate is already a defined type.

Commit 85893120 ("delayacct: align to 8 byte boundary on 64-bit systems")
previously addressed the alignment issues by padding out the pid field. 
This was supposed to be a compatible change but the circumstances
described above mean that it wasn't.  This patch backs out that change,
since it was a hack, and introduces a new NULL attribute type to provide
the padding.  Padding the response with 4 bytes avoids allocating an
aligned taskstats structure and copying it back.  Since the structure
weighs in at 328 bytes, it's too big to do it on the stack.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
Reported-by: Brian Rogers <brian@xyzw.org>
Cc: Jeff Mahoney <jeffm@suse.com>
Cc: Guillaume Chazarain <guichaz@gmail.com>
Cc: Balbir Singh <balbir@in.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/accounting/getdelays.c |    1 
 include/linux/taskstats.h            |    3 -
 kernel/taskstats.c                   |   57 +++++++++++++++++++------
 3 files changed, 47 insertions(+), 14 deletions(-)

diff -puN Documentation/accounting/getdelays.c~taskstats-pad-taskstats-netlink-response-for-aligment-issues-on-ia64 Documentation/accounting/getdelays.c
--- a/Documentation/accounting/getdelays.c~taskstats-pad-taskstats-netlink-response-for-aligment-issues-on-ia64
+++ a/Documentation/accounting/getdelays.c
@@ -516,6 +516,7 @@ int main(int argc, char *argv[])
 			default:
 				fprintf(stderr, "Unknown nla_type %d\n",
 					na->nla_type);
+			case TASKSTATS_TYPE_NULL:
 				break;
 			}
 			na = (struct nlattr *) (GENLMSG_DATA(&msg) + len);
diff -puN include/linux/taskstats.h~taskstats-pad-taskstats-netlink-response-for-aligment-issues-on-ia64 include/linux/taskstats.h
--- a/include/linux/taskstats.h~taskstats-pad-taskstats-netlink-response-for-aligment-issues-on-ia64
+++ a/include/linux/taskstats.h
@@ -33,7 +33,7 @@
  */
 
 
-#define TASKSTATS_VERSION	7
+#define TASKSTATS_VERSION	8
 #define TS_COMM_LEN		32	/* should be >= TASK_COMM_LEN
 					 * in linux/sched.h */
 
@@ -188,6 +188,7 @@ enum {
 	TASKSTATS_TYPE_STATS,		/* taskstats structure */
 	TASKSTATS_TYPE_AGGR_PID,	/* contains pid + stats */
 	TASKSTATS_TYPE_AGGR_TGID,	/* contains tgid + stats */
+	TASKSTATS_TYPE_NULL,		/* contains nothing */
 	__TASKSTATS_TYPE_MAX,
 };
 
diff -puN kernel/taskstats.c~taskstats-pad-taskstats-netlink-response-for-aligment-issues-on-ia64 kernel/taskstats.c
--- a/kernel/taskstats.c~taskstats-pad-taskstats-netlink-response-for-aligment-issues-on-ia64
+++ a/kernel/taskstats.c
@@ -348,25 +348,47 @@ static int parse(struct nlattr *na, stru
 	return ret;
 }
 
+#ifdef CONFIG_IA64
+#define TASKSTATS_NEEDS_PADDING 1
+#endif
+
 static struct taskstats *mk_reply(struct sk_buff *skb, int type, u32 pid)
 {
 	struct nlattr *na, *ret;
 	int aggr;
 
-	/* If we don't pad, we end up with alignment on a 4 byte boundary.
-	 * This causes lots of runtime warnings on systems requiring 8 byte
-	 * alignment */
-	u32 pids[2] = { pid, 0 };
-	int pid_size = ALIGN(sizeof(pid), sizeof(long));
-
 	aggr = (type == TASKSTATS_TYPE_PID)
 			? TASKSTATS_TYPE_AGGR_PID
 			: TASKSTATS_TYPE_AGGR_TGID;
 
+	/*
+	 * The taskstats structure is internally aligned on 8 byte
+	 * boundaries but the layout of the aggregrate reply, with
+	 * two NLA headers and the pid (each 4 bytes), actually
+	 * force the entire structure to be unaligned. This causes
+	 * the kernel to issue unaligned access warnings on some
+	 * architectures like ia64. Unfortunately, some software out there
+	 * doesn't properly unroll the NLA packet and assumes that the start
+	 * of the taskstats structure will always be 20 bytes from the start
+	 * of the netlink payload. Aligning the start of the taskstats
+	 * structure breaks this software, which we don't want. So, for now
+	 * the alignment only happens on architectures that require it
+	 * and those users will have to update to fixed versions of those
+	 * packages. Space is reserved in the packet only when needed.
+	 * This ifdef should be removed in several years e.g. 2012 once
+	 * we can be confident that fixed versions are installed on most
+	 * systems. We add the padding before the aggregate since the
+	 * aggregate is already a defined type.
+	 */
+#ifdef TASKSTATS_NEEDS_PADDING
+	if (nla_put(skb, TASKSTATS_TYPE_NULL, 0, NULL) < 0)
+		goto err;
+#endif
 	na = nla_nest_start(skb, aggr);
 	if (!na)
 		goto err;
-	if (nla_put(skb, type, pid_size, pids) < 0)
+
+	if (nla_put(skb, type, sizeof(pid), &pid) < 0)
 		goto err;
 	ret = nla_reserve(skb, TASKSTATS_TYPE_STATS, sizeof(struct taskstats));
 	if (!ret)
@@ -455,6 +477,18 @@ out:
 	return rc;
 }
 
+static size_t taskstats_packet_size(void)
+{
+	size_t size;
+
+	size = nla_total_size(sizeof(u32)) +
+		nla_total_size(sizeof(struct taskstats)) + nla_total_size(0);
+#ifdef TASKSTATS_NEEDS_PADDING
+	size += nla_total_size(0); /* Padding for alignment */
+#endif
+	return size;
+}
+
 static int cmd_attr_pid(struct genl_info *info)
 {
 	struct taskstats *stats;
@@ -463,8 +497,7 @@ static int cmd_attr_pid(struct genl_info
 	u32 pid;
 	int rc;
 
-	size = nla_total_size(sizeof(u32)) +
-		nla_total_size(sizeof(struct taskstats)) + nla_total_size(0);
+	size = taskstats_packet_size();
 
 	rc = prepare_reply(info, TASKSTATS_CMD_NEW, &rep_skb, size);
 	if (rc < 0)
@@ -493,8 +526,7 @@ static int cmd_attr_tgid(struct genl_inf
 	u32 tgid;
 	int rc;
 
-	size = nla_total_size(sizeof(u32)) +
-		nla_total_size(sizeof(struct taskstats)) + nla_total_size(0);
+	size = taskstats_packet_size();
 
 	rc = prepare_reply(info, TASKSTATS_CMD_NEW, &rep_skb, size);
 	if (rc < 0)
@@ -569,8 +601,7 @@ void taskstats_exit(struct task_struct *
 	/*
 	 * Size includes space for nested attributes
 	 */
-	size = nla_total_size(sizeof(u32)) +
-		nla_total_size(sizeof(struct taskstats)) + nla_total_size(0);
+	size = taskstats_packet_size();
 
 	is_thread_group = !!taskstats_tgid_alloc(tsk);
 	if (is_thread_group) {
_

Patches currently in -mm which might be from jeffm@suse.com are

taskstats-pad-taskstats-netlink-response-for-aligment-issues-on-ia64.patch

