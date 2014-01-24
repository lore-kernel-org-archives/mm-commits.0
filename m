From: akpm@linux-foundation.org
Subject: [merged] uapi-convert-u64-to-__u64-in-exported-headers.patch
 removed from -mm tree
Date: Fri, 24 Jan 2014 11:00:45 -0800
Message-ID: <52e2b85d.Y8+5k8wLnV9dv22E%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43515 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752340AbaAXTAp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 24 Jan 2014 14:00:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rientjes@google.com, vapier@gentoo.org

Subject: [merged] uapi-convert-u64-to-__u64-in-exported-headers.patch removed from -mm tree
To: vapier@gentoo.org,rientjes@google.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 24 Jan 2014 11:00:45 -0800


The patch titled
     Subject: uapi: convert u64 to __u64 in exported headers
has been removed from the -mm tree.  Its filename was
     uapi-convert-u64-to-__u64-in-exported-headers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mike Frysinger <vapier@gentoo.org>
Subject: uapi: convert u64 to __u64 in exported headers

The u64 type is not defined in any exported kernel headers, so trying to
use it will lead to build failures.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/uapi/linux/nfs4.h       |    2 +-
 include/uapi/linux/perf_event.h |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN include/uapi/linux/nfs4.h~uapi-convert-u64-to-__u64-in-exported-headers include/uapi/linux/nfs4.h
--- a/include/uapi/linux/nfs4.h~uapi-convert-u64-to-__u64-in-exported-headers
+++ a/include/uapi/linux/nfs4.h
@@ -150,7 +150,7 @@
 #define NFS4_SECINFO_STYLE4_CURRENT_FH	0
 #define NFS4_SECINFO_STYLE4_PARENT	1
 
-#define NFS4_MAX_UINT64	(~(u64)0)
+#define NFS4_MAX_UINT64	(~(__u64)0)
 
 /* An NFS4 sessions server must support at least NFS4_MAX_OPS operations.
  * If a compound requires more operations, adjust NFS4_MAX_OPS accordingly.
diff -puN include/uapi/linux/perf_event.h~uapi-convert-u64-to-__u64-in-exported-headers include/uapi/linux/perf_event.h
--- a/include/uapi/linux/perf_event.h~uapi-convert-u64-to-__u64-in-exported-headers
+++ a/include/uapi/linux/perf_event.h
@@ -788,7 +788,7 @@ union perf_mem_data_src {
 #define PERF_MEM_TLB_SHIFT	26
 
 #define PERF_MEM_S(a, s) \
-	(((u64)PERF_MEM_##a##_##s) << PERF_MEM_##a##_SHIFT)
+	(((__u64)PERF_MEM_##a##_##s) << PERF_MEM_##a##_SHIFT)
 
 /*
  * single taken branch record layout:
_

Patches currently in -mm which might be from vapier@gentoo.org are

origin.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-fix.patch
linux-next.patch

