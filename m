From: akpm@linux-foundation.org
Subject: [patch 01/17] include/linux/idr.h: add #include <linux/bug.h>
Date: Thu, 14 Dec 2017 15:32:24 -0800
Message-ID: <5a330a08.Pae2jlkiyrn/BwoN%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54206 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754296AbdLNXc0 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 14 Dec 2017 18:32:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, wei.w.wang@intel.com, ebiggers@google.com, jack@suse.cz, mawilcox@microsoft.com, mhocko@kernel.org, tj@kernel.org, yamada.masahiro@socionext.com

From: Wei Wang <wei.w.wang@intel.com>
Subject: include/linux/idr.h: add #include <linux/bug.h>

The <linux/bug.h> was removed from radix-tree.h by f5bba9d11a2
("include/linux/radix-tree.h: remove unneeded #include <linux/bug.h>").

Since that commit, tools/testing/radix-tree/ couldn't pass compilation due
to tools/testing/radix-tree/idr.c:17: undefined reference to WARN_ON_ONCE.
This patch adds the bug.h header to idr.h to solve the issue.

Link: http://lkml.kernel.org/r/1511963726-34070-2-git-send-email-wei.w.wang@intel.com
Fixes: f5bba9d11a2 ("include/linux/radix-tree.h: remove unneeded #include <linux/bug.h>")
Signed-off-by: Wei Wang <wei.w.wang@intel.com>
Cc: Matthew Wilcox <mawilcox@microsoft.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Eric Biggers <ebiggers@google.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Masahiro Yamada <yamada.masahiro@socionext.com>
Cc: Michal Hocko <mhocko@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/idr.h |    1 +
 1 file changed, 1 insertion(+)

diff -puN include/linux/idr.h~idr-add-include-linux-bugh include/linux/idr.h
--- a/include/linux/idr.h~idr-add-include-linux-bugh
+++ a/include/linux/idr.h
@@ -15,6 +15,7 @@
 #include <linux/radix-tree.h>
 #include <linux/gfp.h>
 #include <linux/percpu.h>
+#include <linux/bug.h>
 
 struct idr {
 	struct radix_tree_root	idr_rt;
_
