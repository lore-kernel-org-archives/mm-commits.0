Return-Path: <SRS0=29NR=AV=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18238C433DF
	for <mm-commits@archiver.kernel.org>; Fri, 10 Jul 2020 00:36:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E28282070E
	for <mm-commits@archiver.kernel.org>; Fri, 10 Jul 2020 00:36:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1594341371;
	bh=1HkUGd6ma+zPts9zCmSXU1ILtv685CKXNsiJgPu3sSM=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=FpGiU2HWmLZVPlNTfjS7BdGbOgOnccmIIkAdKiGtmAZ13A3VkBRo0BcV4eSgk15MT
	 jBDrTrsy3smuGU6OiyvwFayATYbBFzaW5rDgVlGs2qecuAJILlcdDOB10fMzkJTWV1
	 7Dq7wV9v9AeqVxaoLV2h1kJK49N35HzTW1ntBcss=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726311AbgGJAgL (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 9 Jul 2020 20:36:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:34110 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726272AbgGJAgL (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 9 Jul 2020 20:36:11 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C9A2B2065D;
        Fri, 10 Jul 2020 00:36:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594341371;
        bh=1HkUGd6ma+zPts9zCmSXU1ILtv685CKXNsiJgPu3sSM=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=QnuJaNOfvtVfi8kfycLn23Z/05qS9nYUB7QJfNyRNE5VxkOQA9FTeGiCPUEQuy65d
         Cj5Xjocoa5jn7USoLmvReuJfZfbLmaKr1WenX57buQdMAAAVor54kwgsa7si3oGbFh
         idXjmqL1HytPl9/S8PuqmxyQjVzF/7niNPhp0Dz8=
Date:   Thu, 09 Jul 2020 17:36:10 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     corbet@lwn.net, laoar.shao@gmail.com, mhocko@suse.com,
        mm-commits@vger.kernel.org, rientjes@google.com
Subject:  + doc-mm-sync-up-oom_score_adj-documentation.patch added
 to -mm tree
Message-ID: <20200710003610.UWTHbou0w%akpm@linux-foundation.org>
In-Reply-To: <20200703151445.b6a0cfee402c7c5c4651f1b1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
Message-ID: <20200710003610.27HZjlcRTjlzUhkNNMEWI70oFa4JiFbq-KbzDvlQ_PE@z>


The patch titled
     Subject: doc, mm: sync up oom_score_adj documentation
has been added to the -mm tree.  Its filename is
     doc-mm-sync-up-oom_score_adj-documentation.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/doc-mm-sync-up-oom_score_adj-documentation.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/doc-mm-sync-up-oom_score_adj-documentation.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Michal Hocko <mhocko@suse.com>
Subject: doc, mm: sync up oom_score_adj documentation

There are at least two notes in the oom section.  The 3% discount for root
processes is gone since d46078b28889 ("mm, oom: remove 3% bonus for
CAP_SYS_ADMIN processes").

Likewise children of the selected oom victim are not sacrificed since
bbbe48029720 ("mm, oom: remove 'prefer children over parent' heuristic")

Drop both of them.

Link: http://lkml.kernel.org/r/20200709062603.18480-1-mhocko@kernel.org
Signed-off-by: Michal Hocko <mhocko@suse.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: David Rientjes <rientjes@google.com>
Cc: Yafang Shao <laoar.shao@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/proc.rst |    8 --------
 1 file changed, 8 deletions(-)

--- a/Documentation/filesystems/proc.rst~doc-mm-sync-up-oom_score_adj-documentation
+++ a/Documentation/filesystems/proc.rst
@@ -1634,9 +1634,6 @@ may allocate from based on an estimation
 For example, if a task is using all allowed memory, its badness score will be
 1000.  If it is using half of its allowed memory, its score will be 500.
 
-There is an additional factor included in the badness score: the current memory
-and swap usage is discounted by 3% for root processes.
-
 The amount of "allowed" memory depends on the context in which the oom killer
 was called.  If it is due to the memory assigned to the allocating task's cpuset
 being exhausted, the allowed memory represents the set of mems assigned to that
@@ -1672,11 +1669,6 @@ The value of /proc/<pid>/oom_score_adj m
 value set by a CAP_SYS_RESOURCE process. To reduce the value any lower
 requires CAP_SYS_RESOURCE.
 
-Caveat: when a parent task is selected, the oom killer will sacrifice any first
-generation children with separate address spaces instead, if possible.  This
-avoids servers and important system daemons from being killed and loses the
-minimal amount of work.
-
 
 3.2 /proc/<pid>/oom_score - Display current oom-killer score
 -------------------------------------------------------------
_

Patches currently in -mm which might be from mhocko@suse.com are

doc-mm-sync-up-oom_score_adj-documentation.patch
doc-mm-clarify-proc-pid-oom_score-value-range.patch

