From: akpm@linux-foundation.org
Subject: - cpusets-allow-empty-cpusmems_allowed-to-be-set-for-fix.patch removed from -mm tree
Date: Mon, 07 May 2007 22:11:22 -0700
Message-ID: <200705080511.l485BMRi014123@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:43933 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S967865AbXEHFLd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 01:11:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, clameter@engr.sgi.com, menage@google.com, pj@sgi.com, mm-commits@vger.kernel.org


The patch titled
     cpusets-allow-empty-cpusmems_allowed-to-be-set-for fix
has been removed from the -mm tree.  Its filename was
     cpusets-allow-empty-cpusmems_allowed-to-be-set-for-fix.patch

This patch was dropped because it was folded into cpusets-allow-empty-cpusmems_allowed-to-be-set-for.patch

------------------------------------------------------
Subject: cpusets-allow-empty-cpusmems_allowed-to-be-set-for fix
From: David Rientjes <rientjes@google.com>

Cc: Paul Jackson <pj@sgi.com>
Cc: Christoph Lameter <clameter@engr.sgi.com>
Cc: Paul Menage <menage@google.com>
Signed-off-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cpuset.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN kernel/cpuset.c~cpusets-allow-empty-cpusmems_allowed-to-be-set-for-fix kernel/cpuset.c
--- a/kernel/cpuset.c~cpusets-allow-empty-cpusmems_allowed-to-be-set-for-fix
+++ a/kernel/cpuset.c
@@ -772,7 +772,7 @@ static int update_cpumask(struct cpuset 
 	 * tasks, we'll catch it later when we validate the change and return
 	 * -ENOSPC.
 	 */
-	if (!*buf) {
+	if (!buf[0] || (buf[0] == '\n' && !buf[1])) {
 		cpus_clear(trialcs.cpus_allowed);
 	} else {
 		retval = cpulist_parse(buf, trialcs.cpus_allowed);
@@ -877,7 +877,7 @@ static int update_nodemask(struct cpuset
 	 * tasks, we'll catch it later when we validate the change and return
 	 * -ENOSPC.
 	 */
-	if (!*buf) {
+	if (!buf[0] || (buf[0] == '\n' && !buf[1])) {
 		nodes_clear(trialcs.mems_allowed);
 	} else {
 		retval = nodelist_parse(buf, trialcs.mems_allowed);
_

Patches currently in -mm which might be from rientjes@google.com are

origin.patch
cpusets-allow-empty-cpusmems_allowed-to-be-set-for.patch
cpusets-allow-empty-cpusmems_allowed-to-be-set-for-fix.patch
compiler-introduce-__used-and-__maybe_unused.patch
i386-pci-type-may-be-unused.patch
sh-dma-use-__maybe_unused.patch
scsi-fix-ambiguous-gdthtable-definition.patch
frv-gdb-use-__maybe_unused.patch
i386-voyager-use-__maybe_unused.patch
mips-excite-use-__maybe_unused.patch
mips-tlbex-use-__maybe_unused.patch
powerpc-ps3-use-__maybe_unused.patch
i386-mmzone-use-__maybe_unused.patch
