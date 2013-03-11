From: akpm@linux-foundation.org
Subject: + kernel-pidc-improve-flow-of-a-loop-inside-alloc_pidmap.patch added to -mm tree
Date: Mon, 11 Mar 2013 14:57:45 -0700
Message-ID: <20130311215745.D17145A41EC@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f201.google.com ([209.85.161.201]:47797 "EHLO
	mail-gg0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754134Ab3CKV5q (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 11 Mar 2013 17:57:46 -0400
Received: by mail-gg0-f201.google.com with SMTP id l2so435310ggn.0
        for <mm-commits@vger.kernel.org>; Mon, 11 Mar 2013 14:57:46 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: raphael.scarv@gmail.com, ebiederm@xmission.com, serge.hallyn@canonical.com


The patch titled
     Subject: kernel/pid.c: improve flow of a loop inside alloc_pidmap.
has been added to the -mm tree.  Its filename is
     kernel-pidc-improve-flow-of-a-loop-inside-alloc_pidmap.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Raphael S. Carvalho <raphael.scarv@gmail.com>
Subject: kernel/pid.c: improve flow of a loop inside alloc_pidmap.

find_next_offset() searches for an available "cleaned bit" in the
respective pid bitmap (page), so returns the offset if found, otherwise it
returns a value equals to BITS_PER_PAGE.

For example, suppose find_next_offset didn't find any available bit, so
there's no purpose to call mk_pid (Wasteful Cpu Cycles).

Therefore, I found it could be better to call mk_pid after the checking
(offset < BITS_PER_PAGE) returned sucessfully!  Another point: If (offset
< BITS_PER_PAGE) results in a "failure", then mk_pid would be called again
afterwards.

Signed-off-by: Raphael S. Carvalho <raphael.scarv@gmail.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Serge Hallyn <serge.hallyn@canonical.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/pid.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN kernel/pid.c~kernel-pidc-improve-flow-of-a-loop-inside-alloc_pidmap kernel/pid.c
--- a/kernel/pid.c~kernel-pidc-improve-flow-of-a-loop-inside-alloc_pidmap
+++ a/kernel/pid.c
@@ -190,8 +190,8 @@ static int alloc_pidmap(struct pid_names
 					return pid;
 				}
 				offset = find_next_offset(map, offset);
-				pid = mk_pid(pid_ns, map, offset);
-			} while (offset < BITS_PER_PAGE && pid < pid_max);
+			} while (offset < BITS_PER_PAGE &&
+				(pid = mk_pid(pid_ns, map, offset)) < pid_max);
 		}
 		if (map < &pid_ns->pidmap[(pid_max-1)/BITS_PER_PAGE]) {
 			++map;
_

Patches currently in -mm which might be from raphael.scarv@gmail.com are

kernel-pidc-improve-flow-of-a-loop-inside-alloc_pidmap.patch
kernel-pidc-improve-flow-of-a-loop-inside-alloc_pidmap-fix.patch
pid_namespacec-h-simplify-defines.patch
pid_namespacec-h-simplify-defines-fix.patch

