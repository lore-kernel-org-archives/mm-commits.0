From: akpm@linux-foundation.org
Subject: [merged]
 =?US-ASCII?Q?kdump-print-a-message-in-case-parse=5Fcrashkernel=5Fmem-resu?=
 =?US-ASCII?Q?lted-in-zero-bytes.patch?= removed from -mm tree
Date: Mon, 20 Nov 2017 13:25:58 -0800
Message-ID: <20171120212558.fDUpCU6wU%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40796 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753103AbdKTVZ7 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 20 Nov 2017 16:25:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bhe@redhat.com, bhsharma@redhat.com, dyoung@redhat.com, mm-commits@vger.kernel.org, vgoyal@redhat.com


The patch titled
     Subject: kdump: print a message in case parse_crashkernel_mem resulted in zero bytes
has been removed from the -mm tree.  Its filename was
     kdump-print-a-message-in-case-parse_crashkernel_mem-resulted-in-zero-bytes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


