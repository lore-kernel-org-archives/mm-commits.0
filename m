From: akpm@linux-foundation.org
Subject: [merged] taskstats-use-better-ifdef-for-alignment.patch removed from -mm tree
Date: Thu, 13 Jan 2011 12:09:13 -0800
Message-ID: <201101132011.p0DKBsaW030213@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41971 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933405Ab1AMUMk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Jan 2011 15:12:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jeffm@suse.com, balbir@in.ibm.com, davem@davemloft.net, error27@gmail.com, florian@mickler.org, guichaz@gmail.com, mm-commits@vger.kernel.org


The patch titled
     taskstats: use better ifdef for alignment
has been removed from the -mm tree.  Its filename was
     taskstats-use-better-ifdef-for-alignment.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: taskstats: use better ifdef for alignment
From: Jeff Mahoney <jeffm@suse.com>

Commit 4be2c95d ("taskstats: pad taskstats netlink response for aligment
issues on ia64") added a null field to align the taskstats structure but
the discussion centered around ia64.  The issue exists on other platforms
with inefficient unaligned access and adding them piecemeal would be an
unmaintainable mess.

This patch uses Dave Miller's suggestion of using a combination of
CONFIG_64BIT && !CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS to determine
whether alignment is needed.

Note that this will cause breakage on those platforms with applications
like iotop which had hard-coded offsets into the packet to access the
taskstats structure.

The message seen on systems without the alignment fixes looks like: kernel
unaligned access to 0xe000023879dca9bc, ip=0xa000000100133d10

The addresses may vary but resolve to locations inside __delayacct_add_tsk.


iotop makes what I'd call unreasonable assumptions about the contents of a
netlink genetlink packet containing generic attributes.  They're typed and
have headers that specify value lengths, so the client can (should)
identify and skip the ones the client doesn't understand.

The kernel, as of version 2.6.36, presented a packet like so:
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

The iotop code expects that the kernel will behave as it did then,
assuming that the packet format is set in stone.  The format is set in
stone, but the packet offsets are not.  There's nothing in the packet
format that guarantees that the packet will be sent in exactly the same
way.  The attribute contents are set (or versioned) and the aggregate
contents are set but they can be anywhere in the packet.

The issue here isn't that an unaligned structure gets passed to userspace,
it's that the NLA infrastructure has something of a weakness: The 4 byte
attribute header may force the payload to be unaligned.  The taskstats
structure is created at an unaligned location and then 64-bit values are
operated on inside the kernel, so the unaligned access warnings gets
spewed everywhere.

It's possible to use the unaligned access API to operate on the structure
in the kernel but it seems like a wasted effort to work around userspace
code that isn't following the packet format.  Any new additions would also
need the be worked around.  It's a maintenance nightmare.

The conclusion of the earlier discussion seemed to be "ok fine, if we have
to break it, don't break it on arches that don't have the problem." Dave
pointed out that the unaligned access problem doesn't only exist on ia64,
but also on other 64-bit arches that don't have efficient unaligned access
and it should be fixed there as well.  The committed version of the patch
and this addition keep with the conclusion of that discussion not to break
it unnecessarily, which the pid padding and the packet padding fixes did
do.  x86_64 and powerpc don't suffer this problem so they shouldn't suffer
the solution.  Other 64-bit architectures do and will, though.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
Reported-by: David S. Miller <davem@davemloft.net>
Acked-by: David S. Miller <davem@davemloft.net>
Cc: Dan Carpenter <error27@gmail.com>
Cc: Balbir Singh <balbir@in.ibm.com>
Cc: Florian Mickler <florian@mickler.org>
Cc: Guillaume Chazarain <guichaz@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/taskstats.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/taskstats.c~taskstats-use-better-ifdef-for-alignment kernel/taskstats.c
--- a/kernel/taskstats.c~taskstats-use-better-ifdef-for-alignment
+++ a/kernel/taskstats.c
@@ -348,7 +348,7 @@ static int parse(struct nlattr *na, stru
 	return ret;
 }
 
-#ifdef CONFIG_IA64
+#if defined(CONFIG_64BIT) && !defined(CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS)
 #define TASKSTATS_NEEDS_PADDING 1
 #endif
 
_

Patches currently in -mm which might be from jeffm@suse.com are

origin.patch

