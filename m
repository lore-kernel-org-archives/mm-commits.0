From: akpm@linux-foundation.org
Subject: +
 kdump-print-a-message-in-case-parse_crashkernel_mem-resulted-in-zero-bytes.patch added to -mm tree
Date: Tue, 14 Nov 2017 16:19:19 -0800
Message-ID: <5a0b8807.MHkHdL0wFfs3oJJv%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50444 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753209AbdKOATU (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 14 Nov 2017 19:19:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dyoung@redhat.com, bhe@redhat.com, bhsharma@redhat.com, vgoyal@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kdump: print a message in case parse_crashkernel_mem resulted in zero bytes
has been added to the -mm tree.  Its filename is
     kdump-print-a-message-in-case-parse_crashkernel_mem-resulted-in-zero-bytes.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kdump-print-a-message-in-case-parse_crashkernel_mem-resulted-in-zero-bytes.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kdump-print-a-message-in-case-parse_crashkernel_mem-resulted-in-zero-bytes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Dave Young <dyoung@redhat.com>
Subject: kdump: print a message in case parse_crashkernel_mem resulted in zero bytes

parse_crashkernel_mem() silently returns if we get zero bytes in the
parsing function.  It is useful for debugging to add a message, especially
if the kernel cannot boot correctly.

Add a pr_info instead of pr_warn because it is expected behavior for size
= 0, eg.  crashkernel=2G-4G:128M, size will be 0 in case system memory is
less than 2G.

Link: http://lkml.kernel.org/r/20171114080129.GA6115@dhcp-128-65.nay.redhat.com
Signed-off-by: Dave Young <dyoung@redhat.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: Bhupesh Sharma <bhsharma@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/crash_core.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN kernel/crash_core.c~kdump-print-a-message-in-case-parse_crashkernel_mem-resulted-in-zero-bytes kernel/crash_core.c
--- a/kernel/crash_core.c~kdump-print-a-message-in-case-parse_crashkernel_mem-resulted-in-zero-bytes
+++ a/kernel/crash_core.c
@@ -108,7 +108,8 @@ static int __init parse_crashkernel_mem(
 				return -EINVAL;
 			}
 		}
-	}
+	} else
+		pr_info("crashkernel size resulted in zero bytes\n");
 
 	return 0;
 }
_

Patches currently in -mm which might be from dyoung@redhat.com are

kdump-print-a-message-in-case-parse_crashkernel_mem-resulted-in-zero-bytes.patch

