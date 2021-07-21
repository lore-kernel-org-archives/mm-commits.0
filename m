Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17D9EC6377B
	for <mm-commits@archiver.kernel.org>; Wed, 21 Jul 2021 20:50:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F423E61246
	for <mm-commits@archiver.kernel.org>; Wed, 21 Jul 2021 20:50:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229629AbhGUUJv (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 21 Jul 2021 16:09:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:58590 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229604AbhGUUJu (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 21 Jul 2021 16:09:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 666A260FEA;
        Wed, 21 Jul 2021 20:50:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1626900626;
        bh=jI5nD4S7R9sYc3FuhMBhfhzmajutPQSmJixt2TEgMho=;
        h=Date:From:To:Subject:From;
        b=PVboqSpRQPGyPghnfpBhHIGUN1R5c0GYNUH2Q3mL6gllDZ29PZk8Ug12Tx+UuTqOF
         XMhZQpTmyZ9OsO3VhfAN3U6H7kl/6fnUjo3wrNpn2JZbF25v5KeCApHZ8SU4szYNYA
         a49BsJzqtIT3nh2QSRxFkRfDyQGkf/Mes4UMhXnc=
Date:   Wed, 21 Jul 2021 13:50:25 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, vinmenon@codeaurora.org,
        vbabka@suse.cz, rientjes@google.com, nigupta@nvidia.com,
        khalid.aziz@oracle.com, charante@codeaurora.org
Subject:  +
 mm-compaction-optimize-proactive-compaction-deferrals.patch added to -mm tree
Message-ID: <20210721205025.1oLfl%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: compaction: optimize proactive compaction deferrals
has been added to the -mm tree.  Its filename is
     mm-compaction-optimize-proactive-compaction-deferrals.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-compaction-optimize-proactive-compaction-deferrals.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-compaction-optimize-proactive-compaction-deferrals.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Charan Teja Reddy <charante@codeaurora.org>
Subject: mm: compaction: optimize proactive compaction deferrals

Vlastimil Babka figured out that when fragmentation score didn't go down
across the proactive compaction i.e.  when no progress is made, next wake
up for proactive compaction is deferred for 1 << COMPACT_MAX_DEFER_SHIFT,
i.e.  64 times, with each wakeup interval of
HPAGE_FRAG_CHECK_INTERVAL_MSEC(=500).  In each of this wakeup, it just
decrement 'proactive_defer' counter and goes sleep i.e.  it is getting
woken to just decrement a counter.

The same deferral time can also achieved by simply doing the
HPAGE_FRAG_CHECK_INTERVAL_MSEC << COMPACT_MAX_DEFER_SHIFT thus unnecessary
wakeup of kcompact thread is avoided thus also removes the need of
'proactive_defer' thread counter.

Link: https://lore.kernel.org/linux-fsdevel/88abfdb6-2c13-b5a6-5b46-742d12d1c910@suse.cz/
Link: https://lkml.kernel.org/r/1626869599-25412-1-git-send-email-charante@codeaurora.org
Signed-off-by: Charan Teja Reddy <charante@codeaurora.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: David Rientjes <rientjes@google.com>
Cc: Nitin Gupta <nigupta@nvidia.com>
Cc: Khalid Aziz <khalid.aziz@oracle.com>
Cc: Vinayak Menon <vinmenon@codeaurora.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |   29 +++++++++++++++++++----------
 1 file changed, 19 insertions(+), 10 deletions(-)

--- a/mm/compaction.c~mm-compaction-optimize-proactive-compaction-deferrals
+++ a/mm/compaction.c
@@ -2885,7 +2885,8 @@ static int kcompactd(void *p)
 {
 	pg_data_t *pgdat = (pg_data_t *)p;
 	struct task_struct *tsk = current;
-	unsigned int proactive_defer = 0;
+	long default_timeout = msecs_to_jiffies(HPAGE_FRAG_CHECK_INTERVAL_MSEC);
+	long timeout = default_timeout;
 
 	const struct cpumask *cpumask = cpumask_of_node(pgdat->node_id);
 
@@ -2902,23 +2903,30 @@ static int kcompactd(void *p)
 
 		trace_mm_compaction_kcompactd_sleep(pgdat->node_id);
 		if (wait_event_freezable_timeout(pgdat->kcompactd_wait,
-			kcompactd_work_requested(pgdat),
-			msecs_to_jiffies(HPAGE_FRAG_CHECK_INTERVAL_MSEC))) {
+			kcompactd_work_requested(pgdat), timeout)) {
 
 			psi_memstall_enter(&pflags);
 			kcompactd_do_work(pgdat);
 			psi_memstall_leave(&pflags);
+			/*
+			 * Reset the timeout value. The defer timeout by
+			 * proactive compaction can effectively lost
+			 * here but that is fine as the condition of the
+			 * zone changed substantionally and carrying on
+			 * with the previous defer is not useful.
+			 */
+			timeout = default_timeout;
 			continue;
 		}
 
-		/* kcompactd wait timeout */
+		/*
+		 * Start the proactive work with default timeout. Based
+		 * on the fragmentation score, this timeout is updated.
+		 */
+		timeout = default_timeout;
 		if (should_proactive_compact_node(pgdat)) {
 			unsigned int prev_score, score;
 
-			if (proactive_defer) {
-				proactive_defer--;
-				continue;
-			}
 			prev_score = fragmentation_score_node(pgdat);
 			proactive_compact_node(pgdat);
 			score = fragmentation_score_node(pgdat);
@@ -2926,8 +2934,9 @@ static int kcompactd(void *p)
 			 * Defer proactive compaction if the fragmentation
 			 * score did not go down i.e. no progress made.
 			 */
-			proactive_defer = score < prev_score ?
-					0 : 1 << COMPACT_MAX_DEFER_SHIFT;
+			if (unlikely(score >= prev_score))
+				timeout =
+				   default_timeout << COMPACT_MAX_DEFER_SHIFT;
 		}
 	}
 
_

Patches currently in -mm which might be from charante@codeaurora.org are

mm-compaction-optimize-proactive-compaction-deferrals.patch

