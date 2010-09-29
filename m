From: akpm@linux-foundation.org
Subject: + delayacct-align-to-8-byte-boundary-on-64-bit-systems.patch added to -mm tree
Date: Wed, 29 Sep 2010 11:01:50 -0700
Message-ID: <201009291800.o8TI0jbH009935@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47907 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754724Ab0I2SBU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 29 Sep 2010 14:01:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jeffm@suse.com, balbir@in.ibm.com


The patch titled
     delayacct: align to 8 byte boundary on 64-bit systems
has been added to the -mm tree.  Its filename is
     delayacct-align-to-8-byte-boundary-on-64-bit-systems.patch

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
Subject: delayacct: align to 8 byte boundary on 64-bit systems
From: Jeff Mahoney <jeffm@suse.com>

prepare_reply() sets up an skb for the response.  The payload contains:

 +--------------------------------+
 | genlmsghdr - 4 bytes           |
 +--------------------------------+
 | NLA header - 4 bytes           | /* Aggregate header */
 +-+------------------------------+
 | | NLA header - 4 bytes         | /* PID header */
 | +------------------------------+
 | | pid/tgid   - 4 bytes         |
 | +------------------------------+
 | | NLA header - 4 bytes         | /* stats header */
 | + -----------------------------+ <- oops. aligned on 4 byte boundary
 | | struct taskstats - 328 bytes |
 +-+------------------------------+

The start of the taskstats struct must be 8 byte aligned on IA64 (and
other systems with 8 byte alignment rules for 64-bit types) or runtime
alignment warnings will be issued.

This patch pads the pid/tgid field out to sizeof(long), which forces the
alignment of taskstats.  The getdelays userspace code is ok with this
since it assumes 32-bit pid/tgid and then honors that header's length
field.

An array is used to avoid exposing kernel memory contents to userspace in
the response.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
Cc: Balbir Singh <balbir@in.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/taskstats.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff -puN kernel/taskstats.c~delayacct-align-to-8-byte-boundary-on-64-bit-systems kernel/taskstats.c
--- a/kernel/taskstats.c~delayacct-align-to-8-byte-boundary-on-64-bit-systems
+++ a/kernel/taskstats.c
@@ -360,6 +360,12 @@ static struct taskstats *mk_reply(struct
 	struct nlattr *na, *ret;
 	int aggr;
 
+	/* If we don't pad, we end up with alignment on a 4 byte boundary.
+	 * This causes lots of runtime warnings on systems requiring 8 byte
+	 * alignment */
+	u32 pids[2] = { pid, 0 };
+	int pid_size = ALIGN(sizeof(pid), sizeof(long));
+
 	aggr = (type == TASKSTATS_TYPE_PID)
 			? TASKSTATS_TYPE_AGGR_PID
 			: TASKSTATS_TYPE_AGGR_TGID;
@@ -367,7 +373,7 @@ static struct taskstats *mk_reply(struct
 	na = nla_nest_start(skb, aggr);
 	if (!na)
 		goto err;
-	if (nla_put(skb, type, sizeof(pid), &pid) < 0)
+	if (nla_put(skb, type, pid_size, pids) < 0)
 		goto err;
 	ret = nla_reserve(skb, TASKSTATS_TYPE_STATS, sizeof(struct taskstats));
 	if (!ret)
_

Patches currently in -mm which might be from jeffm@suse.com are

linux-next.patch
reiserfs-fix-dependency-inversion-between-inode-and-reiserfs-mutexes.patch
reiserfs-fix-unwanted-reiserfs-lock-recursion.patch
drivers-net-tulip-de4x5c-fix-copy-length-in-de4x5_ioctl-checkpatch-fixes.patch
delayacct-align-to-8-byte-boundary-on-64-bit-systems.patch

