Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82FF6C6FD18
	for <mm-commits@archiver.kernel.org>; Tue, 28 Mar 2023 23:21:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229887AbjC1XVf (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 28 Mar 2023 19:21:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229877AbjC1XVR (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 28 Mar 2023 19:21:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F150A2724
        for <mm-commits@vger.kernel.org>; Tue, 28 Mar 2023 16:21:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9261EB81F54
        for <mm-commits@vger.kernel.org>; Tue, 28 Mar 2023 23:21:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 428F5C4339B;
        Tue, 28 Mar 2023 23:21:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680045673;
        bh=Z7L6O+4+nnX91C7suE5A3W0W8TTjSIypGE8agX0crZE=;
        h=Date:To:From:Subject:From;
        b=r+8O/AFuSV+he6I4C2TkDGxF5kPy41vRqB8nh/H0VNKy/LQnCbrosAN74ju/D28gi
         Zs6gClDOQY76R9i186iXqIUkM6YSHr2VPYMcZojb5I/2gj0JBWF31B51haCTCObZbb
         sy4Zuh1vflb4VgKxPtsoWgWXeg4hePVSHN1YKhHg=
Date:   Tue, 28 Mar 2023 16:21:12 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, vbabka@suse.cz,
        senozhatsky@chromium.org, rostedt@goodmis.org, pmladek@suse.com,
        john.ogness@linutronix.de, joe@perches.com, david@redhat.com,
        andriy.shevchenko@linux.intel.com, 42.hyeyoo@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mmflagsh-use-less-error-prone-method-to-define-pageflag_names.patch removed from -mm tree
Message-Id: <20230328232113.428F5C4339B@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mmflags.h: use less error prone method to define pageflag_names
has been removed from the -mm tree.  Its filename was
     mmflagsh-use-less-error-prone-method-to-define-pageflag_names.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Subject: mmflags.h: use less error prone method to define pageflag_names
Date: Mon, 30 Jan 2023 13:25:12 +0900

Patch series "mm, printk: introduce new format for page_type", v4.

This series moves PG_slab page flag to page_type, freeing one bit in
page->flags and introduces %pGt format that prints human-readable
page_type like %pGp for printing page flags.

See changelog of patch 2 for more implementation details.

Thanks everyone that gave valuable comments.


This patch (of 3):

Use helper macro to decrease chances of typo when defining pageflag_names.

Link: https://lkml.kernel.org/r/20230130042514.2418-1-42.hyeyoo@gmail.com
Link: https://lore.kernel.org/lkml/Y6AycLbpjVzXM5I9@smile.fi.intel.com
Link: https://lkml.kernel.org/r/20230130042514.2418-2-42.hyeyoo@gmail.com
Signed-off-by: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Suggested-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Joe Perches <joe@perches.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Steven Rostedt (Google) <rostedt@goodmis.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: John Ogness <john.ogness@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/trace/events/mmflags.h |   85 ++++++++++++++++---------------
 1 file changed, 44 insertions(+), 41 deletions(-)

--- a/include/trace/events/mmflags.h~mmflagsh-use-less-error-prone-method-to-define-pageflag_names
+++ a/include/trace/events/mmflags.h
@@ -67,71 +67,74 @@
 	) : "none"
 
 #ifdef CONFIG_MMU
-#define IF_HAVE_PG_MLOCK(flag,string) ,{1UL << flag, string}
+#define IF_HAVE_PG_MLOCK(_name) ,{1UL << PG_##_name, __stringify(_name)}
 #else
-#define IF_HAVE_PG_MLOCK(flag,string)
+#define IF_HAVE_PG_MLOCK(_name)
 #endif
 
 #ifdef CONFIG_ARCH_USES_PG_UNCACHED
-#define IF_HAVE_PG_UNCACHED(flag,string) ,{1UL << flag, string}
+#define IF_HAVE_PG_UNCACHED(_name) ,{1UL << PG_##_name, __stringify(_name)}
 #else
-#define IF_HAVE_PG_UNCACHED(flag,string)
+#define IF_HAVE_PG_UNCACHED(_name)
 #endif
 
 #ifdef CONFIG_MEMORY_FAILURE
-#define IF_HAVE_PG_HWPOISON(flag,string) ,{1UL << flag, string}
+#define IF_HAVE_PG_HWPOISON(_name) ,{1UL << PG_##_name, __stringify(_name)}
 #else
-#define IF_HAVE_PG_HWPOISON(flag,string)
+#define IF_HAVE_PG_HWPOISON(_name)
 #endif
 
 #if defined(CONFIG_PAGE_IDLE_FLAG) && defined(CONFIG_64BIT)
-#define IF_HAVE_PG_IDLE(flag,string) ,{1UL << flag, string}
+#define IF_HAVE_PG_IDLE(_name) ,{1UL << PG_##_name, __stringify(_name)}
 #else
-#define IF_HAVE_PG_IDLE(flag,string)
+#define IF_HAVE_PG_IDLE(_name)
 #endif
 
 #ifdef CONFIG_ARCH_USES_PG_ARCH_X
-#define IF_HAVE_PG_ARCH_X(flag,string) ,{1UL << flag, string}
+#define IF_HAVE_PG_ARCH_X(_name) ,{1UL << PG_##_name, __stringify(_name)}
 #else
-#define IF_HAVE_PG_ARCH_X(flag,string)
+#define IF_HAVE_PG_ARCH_X(_name)
 #endif
 
 #ifdef CONFIG_KASAN_HW_TAGS
-#define IF_HAVE_PG_SKIP_KASAN_POISON(flag,string) ,{1UL << flag, string}
+#define IF_HAVE_PG_SKIP_KASAN_POISON(_name) \
+	,{1UL << PG_##_name, __stringify(_name)}
 #else
-#define IF_HAVE_PG_SKIP_KASAN_POISON(flag,string)
+#define IF_HAVE_PG_SKIP_KASAN_POISON(_name)
 #endif
 
+#define DEF_PAGEFLAG_NAME(_name) { 1UL <<  PG_##_name, __stringify(_name) }
+
 #define __def_pageflag_names						\
-	{1UL << PG_locked,		"locked"	},		\
-	{1UL << PG_waiters,		"waiters"	},		\
-	{1UL << PG_error,		"error"		},		\
-	{1UL << PG_referenced,		"referenced"	},		\
-	{1UL << PG_uptodate,		"uptodate"	},		\
-	{1UL << PG_dirty,		"dirty"		},		\
-	{1UL << PG_lru,			"lru"		},		\
-	{1UL << PG_active,		"active"	},		\
-	{1UL << PG_workingset,		"workingset"	},		\
-	{1UL << PG_slab,		"slab"		},		\
-	{1UL << PG_owner_priv_1,	"owner_priv_1"	},		\
-	{1UL << PG_arch_1,		"arch_1"	},		\
-	{1UL << PG_reserved,		"reserved"	},		\
-	{1UL << PG_private,		"private"	},		\
-	{1UL << PG_private_2,		"private_2"	},		\
-	{1UL << PG_writeback,		"writeback"	},		\
-	{1UL << PG_head,		"head"		},		\
-	{1UL << PG_mappedtodisk,	"mappedtodisk"	},		\
-	{1UL << PG_reclaim,		"reclaim"	},		\
-	{1UL << PG_swapbacked,		"swapbacked"	},		\
-	{1UL << PG_unevictable,		"unevictable"	}		\
-IF_HAVE_PG_MLOCK(PG_mlocked,		"mlocked"	)		\
-IF_HAVE_PG_UNCACHED(PG_uncached,	"uncached"	)		\
-IF_HAVE_PG_HWPOISON(PG_hwpoison,	"hwpoison"	)		\
-IF_HAVE_PG_IDLE(PG_young,		"young"		)		\
-IF_HAVE_PG_IDLE(PG_idle,		"idle"		)		\
-IF_HAVE_PG_ARCH_X(PG_arch_2,		"arch_2"	)		\
-IF_HAVE_PG_ARCH_X(PG_arch_3,		"arch_3"	)		\
-IF_HAVE_PG_SKIP_KASAN_POISON(PG_skip_kasan_poison, "skip_kasan_poison")
+	DEF_PAGEFLAG_NAME(locked),					\
+	DEF_PAGEFLAG_NAME(waiters),					\
+	DEF_PAGEFLAG_NAME(error),					\
+	DEF_PAGEFLAG_NAME(referenced),					\
+	DEF_PAGEFLAG_NAME(uptodate),					\
+	DEF_PAGEFLAG_NAME(dirty),					\
+	DEF_PAGEFLAG_NAME(lru),						\
+	DEF_PAGEFLAG_NAME(active),					\
+	DEF_PAGEFLAG_NAME(workingset),					\
+	DEF_PAGEFLAG_NAME(slab),					\
+	DEF_PAGEFLAG_NAME(owner_priv_1),				\
+	DEF_PAGEFLAG_NAME(arch_1),					\
+	DEF_PAGEFLAG_NAME(reserved),					\
+	DEF_PAGEFLAG_NAME(private),					\
+	DEF_PAGEFLAG_NAME(private_2),					\
+	DEF_PAGEFLAG_NAME(writeback),					\
+	DEF_PAGEFLAG_NAME(head),					\
+	DEF_PAGEFLAG_NAME(mappedtodisk),				\
+	DEF_PAGEFLAG_NAME(reclaim),					\
+	DEF_PAGEFLAG_NAME(swapbacked),					\
+	DEF_PAGEFLAG_NAME(unevictable)					\
+IF_HAVE_PG_MLOCK(mlocked)						\
+IF_HAVE_PG_UNCACHED(uncached)						\
+IF_HAVE_PG_HWPOISON(hwpoison)						\
+IF_HAVE_PG_IDLE(idle)							\
+IF_HAVE_PG_IDLE(young)							\
+IF_HAVE_PG_ARCH_X(arch_2)						\
+IF_HAVE_PG_ARCH_X(arch_3)						\
+IF_HAVE_PG_SKIP_KASAN_POISON(skip_kasan_poison)
 
 #define show_page_flags(flags)						\
 	(flags) ? __print_flags(flags, "|",				\
_

Patches currently in -mm which might be from 42.hyeyoo@gmail.com are


