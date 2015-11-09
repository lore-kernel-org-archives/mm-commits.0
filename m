From: akpm@linux-foundation.org
Subject: [merged]
 mm-page_alloc-remove-unnecessary-taking-of-a-seqlock-when-cpusets-are-disabled.patch removed from -mm tree
Date: Mon, 09 Nov 2015 11:44:16 -0800
Message-ID: <5640f790.BPCVFnWvWb7Fmn6f%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57047 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751779AbbKIToR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Nov 2015 14:44:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@techsingularity.net, cl@linux.com, hannes@cmpxchg.org, mhocko@suse.com, riel@redhat.com, rientjes@google.com, vbabka@suse.cz, vitalywool@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, page_alloc: remove unnecessary taking of a seqlock when cpusets are disabled
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-remove-unnecessary-taking-of-a-seqlock-when-cpusets-are-disabled.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mel Gorman <mgorman@techsingularity.net>
Subject: mm, page_alloc: remove unnecessary taking of a seqlock when cpusets are disabled

There is a seqcounter that protects against spurious allocation failures
when a task is changing the allowed nodes in a cpuset.  There is no need
to check the seqcounter until a cpuset exists.

Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Acked-by: Christoph Lameter <cl@linux.com>
Acked-by: David Rientjes <rientjes@google.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Vitaly Wool <vitalywool@gmail.com>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/cpuset.h |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN include/linux/cpuset.h~mm-page_alloc-remove-unnecessary-taking-of-a-seqlock-when-cpusets-are-disabled include/linux/cpuset.h
--- a/include/linux/cpuset.h~mm-page_alloc-remove-unnecessary-taking-of-a-seqlock-when-cpusets-are-disabled
+++ a/include/linux/cpuset.h
@@ -104,6 +104,9 @@ extern void cpuset_print_current_mems_al
  */
 static inline unsigned int read_mems_allowed_begin(void)
 {
+	if (!cpusets_enabled())
+		return 0;
+
 	return read_seqcount_begin(&current->mems_allowed_seq);
 }
 
@@ -115,6 +118,9 @@ static inline unsigned int read_mems_all
  */
 static inline bool read_mems_allowed_retry(unsigned int seq)
 {
+	if (!cpusets_enabled())
+		return false;
+
 	return read_seqcount_retry(&current->mems_allowed_seq, seq);
 }
 
_

Patches currently in -mm which might be from mgorman@techsingularity.net are


