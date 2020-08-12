Return-Path: <SRS0=McLq=BW=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD399C433DF
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 01:31:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9DDC6206B2
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 01:31:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597195888;
	bh=/kWyIb8nPbwGblmHcL6U6yO2NXxzfbmR/CRTPBMN9Ew=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=oKu26LX2mrQTFum+EalaDpiMmtNBC8cDj5yfIQQWrO4hmg8R/qbU2veD6+Ux4eUo2
	 abcKk5Lo8icTf04CmVZrm0RA+1hN6Y4U1dGKWdSm5S0dhJDih1Cb6Q8UtLC+AMlZ0F
	 TV2x4qQ5aGkHtYu/SdQc7PRTBFI1JNfvuGYOh+rw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726402AbgHLBb2 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 11 Aug 2020 21:31:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:58790 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726235AbgHLBb2 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 11 Aug 2020 21:31:28 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4B35C207DA;
        Wed, 12 Aug 2020 01:31:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597195886;
        bh=/kWyIb8nPbwGblmHcL6U6yO2NXxzfbmR/CRTPBMN9Ew=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=m0ZQztRSyw1IQOwNE9mdyw+HpSwEfCvu3d/3YtX0vSXSTqOExu3fZyfalLlWQy1YU
         YR+cS7rGgk6WGAFM0NK/hGzPOj2PIi7ckPoWcUvTL7V3TQEi+U500z9BAnd2sRiYmB
         RF0UgLvLk79CEyqYpnT8pmEjRdglfN6kwGqk+LkM=
Date:   Tue, 11 Aug 2020 18:31:25 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, corbet@lwn.net, laoar.shao@gmail.com,
        linux-mm@kvack.org, mhocko@suse.com, mm-commits@vger.kernel.org,
        rientjes@google.com, torvalds@linux-foundation.org
Subject:  [patch 022/165] doc, mm: sync up oom_score_adj
 documentation
Message-ID: <20200812013125.T4WzqDPNY%akpm@linux-foundation.org>
In-Reply-To: <20200811182949.e12ae9a472e3b5e27e16ad6c@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
@@ -1633,9 +1633,6 @@ may allocate from based on an estimation
 For example, if a task is using all allowed memory, its badness score will be
 1000.  If it is using half of its allowed memory, its score will be 500.
 
-There is an additional factor included in the badness score: the current memory
-and swap usage is discounted by 3% for root processes.
-
 The amount of "allowed" memory depends on the context in which the oom killer
 was called.  If it is due to the memory assigned to the allocating task's cpuset
 being exhausted, the allowed memory represents the set of mems assigned to that
@@ -1671,11 +1668,6 @@ The value of /proc/<pid>/oom_score_adj m
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
