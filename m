From: akpm@linux-foundation.org
Subject: [merged] kernel-pidc-improve-flow-of-a-loop-inside-alloc_pidmap.patch removed from -mm tree
Date: Tue, 07 May 2013 10:50:03 -0700
Message-ID: <20130507175004.0E68E31C3ED@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:37029 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753190Ab3EGRuF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 May 2013 13:50:05 -0400
Received: by mail-qa0-f74.google.com with SMTP id i13so110390qae.3
        for <mm-commits@vger.kernel.org>; Tue, 07 May 2013 10:50:04 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: raphael.scarv@gmail.com, ebiederm@xmission.com, serge.hallyn@canonical.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/pid.c: improve flow of a loop inside alloc_pidmap.
has been removed from the -mm tree.  Its filename was
     kernel-pidc-improve-flow-of-a-loop-inside-alloc_pidmap.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

[akpm@linux-foundation.org: simplify code]
Signed-off-by: Raphael S. Carvalho <raphael.scarv@gmail.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Serge Hallyn <serge.hallyn@canonical.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/pid.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff -puN kernel/pid.c~kernel-pidc-improve-flow-of-a-loop-inside-alloc_pidmap kernel/pid.c
--- a/kernel/pid.c~kernel-pidc-improve-flow-of-a-loop-inside-alloc_pidmap
+++ a/kernel/pid.c
@@ -183,15 +183,19 @@ static int alloc_pidmap(struct pid_names
 				break;
 		}
 		if (likely(atomic_read(&map->nr_free))) {
-			do {
+			for ( ; ; ) {
 				if (!test_and_set_bit(offset, map->page)) {
 					atomic_dec(&map->nr_free);
 					set_last_pid(pid_ns, last, pid);
 					return pid;
 				}
 				offset = find_next_offset(map, offset);
+				if (offset >= BITS_PER_PAGE)
+					break;
 				pid = mk_pid(pid_ns, map, offset);
-			} while (offset < BITS_PER_PAGE && pid < pid_max);
+				if (pid >= pid_max)
+					break;
+			}
 		}
 		if (map < &pid_ns->pidmap[(pid_max-1)/BITS_PER_PAGE]) {
 			++map;
_

Patches currently in -mm which might be from raphael.scarv@gmail.com are

origin.patch

