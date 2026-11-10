Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794275590;
	b=KR/A5DaLa/bvGrf5boceUGJ28NbnhZCAaq+uc8Kqu/nUoXLHSpsFt3BNMtN7Y+lxWjaf
	 9PRFfR3yr7LfQaw7Q1Fi1vHIilsmqBPY6JDE0mxVt1PYGQQZnCRVXunIns/7euDb8CYwH
	 KX8LD8zisxYssK7WyuWRs9QQQhrMi+LZe7PoA7t5znVcmL2+Eo3AUM7bPbozYv2wUzYU2
	 VWWr+7KYxOs5k0N1qFzxbo9gzrTQFkvuRYpwaqnhcg/ytePMuRfQkdmmxBLY1rZWnS181
	 lH9IGSaWYwto9NSwQ4bKXZb/pezF0HIvjHzgznL+i0M67u9LlBYi2GE4GMVlqbiBEXg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794275590;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=nup5Jl6TG1kwTeviqRxzrq5zV1E4BLjLfUTUEB1Wms4=;
	b=K3MiiRA3KAKly23/+umsPpaw2l+7omg7m9xnVKwjpW0e2oc/igIgFSmpwbm7rLY8r2iH
	 tYgof/opHsK+MUDqUh1j6qXpEa4dHEM7JvYaBfHqhP7vthd7xkWZ5s3gVEWE9rUoQas49
	 D22EN26oztdWoaA0bADzvmqr09G8LeyZckPnunLUn6B5vWffOWWIZlwQNjLL/fQ8r8YjM
	 vYl4cckNAb9Roqhc2US8rAeruCVxkjRMLzCwzSjWm3S81tV6swfO4a0mbymf3maOE7s7u
	 +d48VMFVuJ9U7b6fiPxY3zIs51tAtXJcTxOZQKThSN0ZRKD5kv5IwLNrjxNUdHgiwGA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=XkK+i1yy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7317D606A31C
	for <mm-commits@vger.kernel.org>; Tue, 10 Nov 2026 01:53:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=XkK+i1yy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFBBE1F0089F;
	Tue, 10 Nov 2026 01:53:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794275590;
	bh=nup5Jl6TG1kwTeviqRxzrq5zV1E4BLjLfUTUEB1Wms4=;
	h=Date:To:From:Subject;
	b=XkK+i1yy+4r8Yk0r3LyDTBFnMzDk6PTx7yC4ckAYiAbf2TVlTjchJxw4b07Sw/7cy
	 Q6ofEU9Wh9oiVUpAsXkc1BvpF2KOprhmUNg+gT8c+Iq57daZLnLFtb4Zptl4D8SowH
	 /Nh7NLVIoPKPP+X31nIdqk9epKRY2FFl1nvKrEJU=
Date: Mon, 09 Nov 2026 17:53:09 -0800
To: mm-commits@vger.kernel.org,skhan@linuxfoundation.org,sj@kernel.org,
	rdunlap@infradead.org,lienze@kylinos.cn,jm5905938@gmail.com,corbet@lwn.net,
	manuelebnerli@mailbox.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + docs-admin-guide-mm-damon-reclaim-improve-language.patch added to mm-new branch
Message-Id: <20261110015309.DFBBE1F0089F@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: Docs/admin-guide/mm/damon/reclaim: improve language
has been added to the -mm mm-new branch.  Its filename is
     docs-admin-guide-mm-damon-reclaim-improve-language.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-admin-guide-mm-damon-reclaim-improve-language.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Manuel Ebner <manuelebnerli@mailbox.org>
Subject: Docs/admin-guide/mm/damon/reclaim: improve language
Date: Mon, 09 Nov 2026 17:05:57 -0800

Fix upper case.  Fix tenses.  Replace 'set as' with 'set to'.  Add space
after sentence to make it double space.  Rewrite and refine complex
sentences.

Link: https://lore.kernel.org/20261110010558.104905-3-sj@kernel.org
Signed-off-by: Manuel Ebner <manuelebnerli@mailbox.org>
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: SJ Park <sj@kernel.org>
Cc: Aveline Noir <jm5905938@gmail.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Cc: Enze Li <lienze@kylinos.cn>
---

 Documentation/admin-guide/mm/damon/reclaim.rst |   45 +++++++--------
 1 file changed, 23 insertions(+), 22 deletions(-)

--- a/Documentation/admin-guide/mm/damon/reclaim.rst~docs-admin-guide-mm-damon-reclaim-improve-language
+++ a/Documentation/admin-guide/mm/damon/reclaim.rst
@@ -4,7 +4,7 @@
 DAMON-based Reclamation
 =======================
 
-DAMON-based Reclamation (DAMON_RECLAIM) is a static kernel module that aimed to
+DAMON-based reclamation (DAMON_RECLAIM) is a static kernel module that aims to
 be used for proactive and lightweight reclamation under light memory pressure.
 It doesn't aim to replace the LRU-list based page_granularity reclamation, but
 to be selectively used for different level of memory pressure and requirements.
@@ -30,12 +30,13 @@ guests could mitigate this problem.
 How It Works?
 =============
 
-DAMON_RECLAIM finds memory regions that didn't accessed for specific time
-duration and page out.  To avoid it consuming too much CPU for the paging out
-operation, a speed limit can be configured.  Under the speed limit, it pages
-out memory regions that didn't accessed longer time first.  System
-administrators can also configure under what situation this scheme should
-automatically activated and deactivated with three memory pressure watermarks.
+DAMON_RECLAIM finds memory regions that have not been accessed for a
+specified period and attempts to page out those.  To avoid it consuming
+too much CPU for the paging out operation, a speed limit can be configured.
+Within the configured speed limit, it prioritizes regions that have been
+idle longer for reclamation.  System administrators can also configure under
+what situation this scheme should automatically be activated and deactivated
+with three memory pressure watermarks.
 
 Interface: Module Parameters
 ============================
@@ -55,10 +56,10 @@ enabled
 
 Enable or disable DAMON_RECLAIM.
 
-You can enable DAMON_RECLAIM by setting the value of this parameter as ``Y``.
-Setting it as ``N`` disables DAMON_RECLAIM.  Note that DAMON_RECLAIM could do
+You can enable DAMON_RECLAIM by setting the value of this parameter to ``Y``.
+Setting it to ``N`` disables DAMON_RECLAIM.  Note that DAMON_RECLAIM could do
 no real monitoring and reclamation due to the watermarks-based activation
-condition.  Refer to below descriptions for the watermarks parameter for this.
+condition.  Refer to below descriptions of the watermarks parameter for this.
 
 commit_inputs
 -------------
@@ -66,9 +67,9 @@ commit_inputs
 Make DAMON_RECLAIM reads the input parameters again, except ``enabled``.
 
 Input parameters that updated while DAMON_RECLAIM is running are not applied
-by default.  Once this parameter is set as ``Y``, DAMON_RECLAIM reads values
+by default.  Once this parameter is set to ``Y``, DAMON_RECLAIM reads values
 of parameters except ``enabled`` again.  Once the re-reading is done, this
-parameter is set as ``N``.  If invalid parameters are found while the
+parameter is set to ``N``.  If invalid parameters are found while the
 re-reading, DAMON_RECLAIM will be disabled.
 
 Once ``Y`` is written to this parameter, the user must not write to any
@@ -88,10 +89,10 @@ identifies the region as cold, and recla
 autotune_monitoring_intervals
 -----------------------------
 
-If this parameter is set as ``Y``, DAMON_RECLAIM automatically tunes DAMON's
+If this parameter is set to ``Y``, DAMON_RECLAIM automatically tunes DAMON's
 sampling and aggregation intervals.  The auto-tuning aims to capture meaningful
 amount of access events in each DAMON-snapshot, while keeping the sampling
-interval 5 milliseconds in minimum, and 10 seconds in maximum.  Setting this as
+interval 5 milliseconds in minimum, and 10 seconds in maximum.  Setting this to
 ``N`` disables the auto-tuning.
 
 Disabled by default.
@@ -113,10 +114,10 @@ quota_sz
 
 Limit of size of memory for the reclamation in bytes.
 
-DAMON_RECLAIM charges amount of memory which it tried to reclaim within a time
-window (quota_reset_interval_ms) and makes no more than this limit is tried.
-This can be used for limiting consumption of CPU and IO.  If this value is
-zero, the limit is disabled.
+DAMON_RECLAIM charges the amount of memory which it tried to reclaim within a time
+window (quota_reset_interval_ms) and stops trying to reclaim memory when this limit
+is reached.  This can be used for limiting consumption of CPU and IO.  If this value
+is zero, the limit is disabled.
 
 128 MiB by default.
 
@@ -137,7 +138,7 @@ quota_mem_pressure_us
 
 Desired level of memory pressure-stall time in microseconds.
 
-While keeping the caps that set by other quotas, DAMON_RECLAIM automatically
+While keeping the caps that are set by other quotas, DAMON_RECLAIM automatically
 increases and decreases the effective level of the quota aiming this level of
 memory pressure is incurred.  System-wide ``some`` memory PSI in microseconds
 per quota reset interval (``quota_reset_interval_ms``) is collected and
@@ -223,7 +224,7 @@ monitoring.  This can be used to set low
 But, setting this too high could result in increased monitoring overhead.
 Please refer to the DAMON documentation (:doc:`usage`) for more detail.
 
-Note that this must be 3 or higher. Please refer to the :ref:`Monitoring
+Note that this must be 3 or higher.  Please refer to the :ref:`Monitoring
 <damon_design_monitoring>` section of the design document for the rationale
 behind this lower bound.
 
@@ -267,7 +268,7 @@ This parameter is for setting and gettin
 
 ``monitor_region_start`` and ``monitor_region_end`` should be provided in this
 unit.  For example, let's suppose ``addr_unit``, ``monitor_region_start`` and
-``monitor_region_end`` are set as ``1024``, ``0`` and ``10``, respectively.
+``monitor_region_end`` are set to ``1024``, ``0`` and ``10``, respectively.
 Then DAMON_RECLAIM will work for 10 KiB length of physical address range that
 starts from address zero (``[0 * 1024, 10 * 1024)`` in bytes).
 
@@ -284,7 +285,7 @@ skip_anon
 
 Skip anonymous pages reclamation.
 
-If this parameter is set as ``Y``, DAMON_RECLAIM does not reclaim anonymous
+If this parameter is set to ``Y``, DAMON_RECLAIM does not reclaim anonymous
 pages.  By default, ``N``.
 
 
_

Patches currently in -mm which might be from manuelebnerli@mailbox.org are

mm-damon-reclaim-fix-typo-and-grammar.patch
docs-admin-guide-mm-damon-lru_sort-fix-grammar-and-style.patch
docs-admin-guide-mm-damon-reclaim-improve-language.patch

