From: akpm@linux-foundation.org
Subject: + x86-numa-add-error-handling-for-bad-cpu-to-node-mappings.patch added to -mm tree
Date: Fri, 14 Jan 2011 16:25:29 -0800
Message-ID: <201101150025.p0F0PT8f009625@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33814 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751130Ab1AOAZe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 14 Jan 2011 19:25:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rientjes@google.com, jj@chaosbits.net


The patch titled
     x86, numa: add error handling for bad cpu-to-node mappings
has been added to the -mm tree.  Its filename is
     x86-numa-add-error-handling-for-bad-cpu-to-node-mappings.patch

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
Subject: x86, numa: add error handling for bad cpu-to-node mappings
From: David Rientjes <rientjes@google.com>

CONFIG_DEBUG_PER_CPU_MAPS may return NUMA_NO_NODE when an
early_cpu_to_node() mapping hasn't been initialized.  In such a case, it
emits a warning and continues without an issue but callers may try to use
the return value to index into an array.

We can catch those errors and fail silently since a warning has already
been emitted.  No current user of numa_add_cpu() requires this error
checking to avoid a crash, but it's better to be proactive in case a
future user happens to have a bug and a user tries to diagnose it with
CONFIG_DEBUG_PER_CPU_MAPS.

Signed-off-by: David Rientjes <rientjes@google.com>
Reported-by: Jesper Juhl <jj@chaosbits.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/numa_64.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff -puN arch/x86/mm/numa_64.c~x86-numa-add-error-handling-for-bad-cpu-to-node-mappings arch/x86/mm/numa_64.c
--- a/arch/x86/mm/numa_64.c~x86-numa-add-error-handling-for-bad-cpu-to-node-mappings
+++ a/arch/x86/mm/numa_64.c
@@ -839,6 +839,10 @@ static struct cpumask __cpuinit *debug_c
 	struct cpumask *mask;
 	char buf[64];
 
+	if (node == NUMA_NO_NODE) {
+		/* early_cpu_to_node() already emits a warning and trace */
+		return NULL;
+	}
 	mask = node_to_cpumask_map[node];
 	if (!mask) {
 		pr_err("node_to_cpumask_map[%i] NULL\n", node);
@@ -877,6 +881,10 @@ static void __cpuinit numa_set_cpumask(i
 	struct cpumask *mask;
 	int i;
 
+	if (node == NUMA_NO_NODE) {
+		/* early_cpu_to_node() already emits a warning and trace */
+		return;
+	}
 	for_each_online_node(i) {
 		unsigned long addr;
 
_

Patches currently in -mm which might be from rientjes@google.com are

origin.patch
linux-next.patch
x86-numa-add-error-handling-for-bad-cpu-to-node-mappings.patch
jbd-remove-dependency-on-__gfp_nofail.patch

