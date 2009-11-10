From: akpm@linux-foundation.org
Subject: + page-types-exit-early-when-invoked-with-d-describe.patch added to -mm tree
Date: Tue, 10 Nov 2009 15:54:32 -0800
Message-ID: <200911102354.nAANsXRx030047@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52611 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758689AbZKJXyc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 10 Nov 2009 18:54:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: achiang@hp.com, andi@firstfloor.org, fengguang.wu@intel.com, haicheng.li@intel.com


The patch titled
     page-types: exit early when invoked with -d|--describe
has been added to the -mm tree.  Its filename is
     page-types-exit-early-when-invoked-with-d-describe.patch

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

linux-next.patch
page-types-learn-to-describe-flags-directly-from-command-line.patch
page-types-whitespace-alignment.patch
page-types-exit-early-when-invoked-with-d-describe.patch

