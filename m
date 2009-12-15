From: akpm@linux-foundation.org
Subject: [merged] page-types-exit-early-when-invoked-with-d-describe.patch removed from -mm tree
Date: Tue, 15 Dec 2009 13:50:18 -0800
Message-ID: <200912152150.nBFLoIfA014944@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49119 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761374AbZLOWSL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Dec 2009 17:18:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: achiang@hp.com, andi@firstfloor.org, fengguang.wu@intel.com, haicheng.li@intel.com, mm-commits@vger.kernel.org


The patch titled
     page-types: exit early when invoked with -d|--describe
has been removed from the -mm tree.  Its filename was
     page-types-exit-early-when-invoked-with-d-describe.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: page-types: exit early when invoked with -d|--describe
From: Alex Chiang <achiang@hp.com>

On a system with large amount of memory (256GB), invoking page-types can
take quite a long time, which is unreasonable considering the user only
wants a description of the flags:

	# time ./page-types -d 0x10
	0x0000000000000010	____D_____________________________	dirty

	real	0m34.285s
	user	0m1.966s
	sys	0m32.313s

This is because we still walk the entire address range.

Exiting early seems like a reasonble solution:

# time ./page-types -d 0x10
	0x0000000000000010	____D_____________________________	dirty

	real	0m0.007s
	user	0m0.001s
	sys	0m0.005s

Signed-off-by: Alex Chiang <achiang@hp.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Haicheng Li <haicheng.li@intel.com>
Acked-by: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/vm/page-types.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN Documentation/vm/page-types.c~page-types-exit-early-when-invoked-with-d-describe Documentation/vm/page-types.c
--- a/Documentation/vm/page-types.c~page-types-exit-early-when-invoked-with-d-describe
+++ a/Documentation/vm/page-types.c
@@ -940,9 +940,8 @@ int main(int argc, char *argv[])
 			parse_bits_mask(optarg);
 			break;
 		case 'd':
-			opt_no_summary = 1;
 			describe_flags(optarg);
-			break;
+			exit(0);
 		case 'l':
 			opt_list = 1;
 			break;
_

Patches currently in -mm which might be from achiang@hp.com are

origin.patch
linux-next.patch

