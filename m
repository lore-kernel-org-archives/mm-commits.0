From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 049/118] mm, tracing: print symbol name for
 kmem_alloc_node call_site events
Date: Thu, 30 Jan 2020 22:13:48 -0800
Message-ID: <20200131061348.5qy8B5wov%akpm@linux-foundation.org>
References: <20200130221021.5f0211c56346d5485af07923@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:33422 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725907AbgAaGNt (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 31 Jan 2020 01:13:49 -0500
In-Reply-To: <20200130221021.5f0211c56346d5485af07923@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, changbin.du@intel.com, joel@joelfernandes.org, linux-mm@kvack.org, mingo@redhat.com, mm-commits@vger.kernel.org, rostedt@goodmis.org, sunjunyong@xiaomi.com, sunjy516@gmail.com, timmurray@google.com, torvalds@linux-foundation.org

From: Junyong Sun <sunjy516@gmail.com>
Subject: mm, tracing: print symbol name for kmem_alloc_node call_site events

Print the call_site ip of kmem_alloc_node using '%pS' to improve the
readability of raw slab trace points.

Link: http://lkml.kernel.org/r/1577949568-4518-1-git-send-email-sunjunyong@xiaomi.com
Signed-off-by: Junyong Sun <sunjunyong@xiaomi.com>
Acked-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Joel Fernandes (Google) <joel@joelfernandes.org>
Cc: Changbin Du <changbin.du@intel.com>
Cc: Tim Murray <timmurray@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/trace/events/kmem.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/include/trace/events/kmem.h~mm-tracing-print-symbol-name-for-kmem_alloc_node-call_site-events
+++ a/include/trace/events/kmem.h
@@ -88,8 +88,8 @@ DECLARE_EVENT_CLASS(kmem_alloc_node,
 		__entry->node		= node;
 	),
 
-	TP_printk("call_site=%lx ptr=%p bytes_req=%zu bytes_alloc=%zu gfp_flags=%s node=%d",
-		__entry->call_site,
+	TP_printk("call_site=%pS ptr=%p bytes_req=%zu bytes_alloc=%zu gfp_flags=%s node=%d",
+		(void *)__entry->call_site,
 		__entry->ptr,
 		__entry->bytes_req,
 		__entry->bytes_alloc,
_
