From: akpm@linux-foundation.org
Subject: [merged] kconfig-recalculate-symbol-value-before-showing-search-results.patch removed from -mm tree
Date: Wed, 24 Mar 2010 10:51:49 -0400
Message-ID: <201003241752.o2OHqi1m015525@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38764 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756642Ab0CXRxm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 24 Mar 2010 13:53:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lizf@cn.fujitsu.com, mmarek@suse.cz, mm-commits@vger.kernel.org


The patch titled
     kconfig: recalculate symbol value before showing search results
has been removed from the -mm tree.  Its filename was
     kconfig-recalculate-symbol-value-before-showing-search-results.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kconfig: recalculate symbol value before showing search results
From: Li Zefan <lizf@cn.fujitsu.com>

A symbol's value won't be recalculated until we save the config file or
enter the menu where the symbol sits.

So If I enable OPTIMIZE_FOR_SIZE, and search FUNCTION_GRAPH_TRACER:

  Symbol: FUNCTION_GRAPH_TRACER [=y]
  Prompt: Kernel Function Graph Tracer
    Defined at kernel/trace/Kconfig:140
    Depends on: ... [=y] && (!X86_32 [=y] || !CC_OPTIMIZE_FOR_SIZE [=y])
    ...

Via the dependency it should result in FUNCTION_GRAPH_TRACER=n, but it
still shows FUNCTION_GRAPH_TRACER=y.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Cc: Michal Marek <mmarek@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/kconfig/symbol.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN scripts/kconfig/symbol.c~kconfig-recalculate-symbol-value-before-showing-search-results scripts/kconfig/symbol.c
--- a/scripts/kconfig/symbol.c~kconfig-recalculate-symbol-value-before-showing-search-results
+++ a/scripts/kconfig/symbol.c
@@ -755,6 +755,7 @@ struct symbol **sym_re_search(const char
 				return NULL;
 			}
 		}
+		sym_calc_value(sym);
 		sym_arr[cnt++] = sym;
 	}
 	if (sym_arr)
_

Patches currently in -mm which might be from lizf@cn.fujitsu.com are

cgroups-remove-duplicate-include.patch
cpuset-fix-the-problem-that-cpuset_mem_spread_node-returns-an-offline-node.patch
cpuset-alloc-nodemask_t-on-the-heap-rather-than-the-stack.patch
linux-next.patch
sunrpc-cache-fix-module-refcnt-leak-in-a-failure-path.patch

