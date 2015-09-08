From: akpm@linux-foundation.org
Subject: [merged]
 scripts-decode_stacktrace-fix-arm-architecture-decoding.patch removed from
 -mm tree
Date: Tue, 08 Sep 2015 11:01:50 -0700
Message-ID: <55ef228e.vbhsLEnStKAWhyBK%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58716 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754664AbbIHSBv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Sep 2015 14:01:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: robert.jarzmik@free.fr, mmarek@suse.cz, rmk+kernel@arm.linux.org.uk, sasha.levin@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Subject: scripts: decode_stacktrace: fix ARM architecture decoding
has been removed from the -mm tree.  Its filename was
     scripts-decode_stacktrace-fix-arm-architecture-decoding.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Robert Jarzmik <robert.jarzmik@free.fr>
Subject: scripts: decode_stacktrace: fix ARM architecture decoding

Fix the stack decoder for the ARM architecture.
An ARM stack is designed as :
[   81.547704] [<c023eb04>] (bucket_find_contain) from [<c023ec88>] (check_sync+0x40/0x4f8)
[   81.559668] [<c023ec88>] (check_sync) from [<c023f8c4>] (debug_dma_sync_sg_for_cpu+0x128/0x194)
[   81.571583] [<c023f8c4>] (debug_dma_sync_sg_for_cpu) from [<c0327dec>] (__videobuf_s

The current script doesn't expect the symbols to be bound by
parenthesis, and triggers the following errors :
awk: cmd. line:1: error: Unmatched ( or \(: / (check_sync$/
[   81.547704] (bucket_find_contain) from (check_sync+0x40/0x4f8)

Fix it by chopping starting and ending parenthesis from the each symbol
name.

As a side note, this probably comes from the function
dump_backtrace_entry(), which is implemented differently for each
architecture.  That makes a single decoding script a bit a challenge.

Signed-off-by: Robert Jarzmik <robert.jarzmik@free.fr>
Cc: Sasha Levin <sasha.levin@oracle.com>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>
Cc: Michal Marek <mmarek@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/decode_stacktrace.sh |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN scripts/decode_stacktrace.sh~scripts-decode_stacktrace-fix-arm-architecture-decoding scripts/decode_stacktrace.sh
--- a/scripts/decode_stacktrace.sh~scripts-decode_stacktrace-fix-arm-architecture-decoding
+++ a/scripts/decode_stacktrace.sh
@@ -14,11 +14,14 @@ declare -A cache
 
 parse_symbol() {
 	# The structure of symbol at this point is:
-	#   [name]+[offset]/[total length]
+	#   ([name]+[offset]/[total length])
 	#
 	# For example:
 	#   do_basic_setup+0x9c/0xbf
 
+	# Remove the englobing parenthesis
+	symbol=${symbol#\(}
+	symbol=${symbol%\)}
 
 	# Strip the symbol name so that we could look it up
 	local name=${symbol%+*}
_

Patches currently in -mm which might be from robert.jarzmik@free.fr are


