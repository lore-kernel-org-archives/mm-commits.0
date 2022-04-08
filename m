Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8F0AC433F5
	for <mm-commits@archiver.kernel.org>; Fri,  8 Apr 2022 18:07:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236150AbiDHSJ0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 8 Apr 2022 14:09:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238320AbiDHSJZ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 8 Apr 2022 14:09:25 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F8343553A5
        for <mm-commits@vger.kernel.org>; Fri,  8 Apr 2022 11:07:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E94EEB82CD0
        for <mm-commits@vger.kernel.org>; Fri,  8 Apr 2022 18:07:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B6FBC385A5;
        Fri,  8 Apr 2022 18:07:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1649441235;
        bh=+MhMN5RWcqJt2NorFAeDISjIgS7eoaYLK5p9jPh4xVw=;
        h=Date:To:From:Subject:From;
        b=A0L/ASGEEwb7don/O0T14StLrKrsB50dPGLAcj7+CyErRX9R3pvHT6Zx34q1tCd9Y
         dqwkrb0b1i39ZEWbAzNU3q3fv8ZmSPv6VJJeQ8P7HKbdQFv5vw6auDB1TetWRIsHxr
         MSx5ChaToyKsqENJYvne0tWr9RJACYWdS084TctQ=
Date:   Fri, 08 Apr 2022 11:07:14 -0700
To:     mm-commits@vger.kernel.org, zhouchengming@bytedance.com,
        tj@kernel.org, songmuchun@bytedance.com, ming.lei@redhat.com,
        dennis@kernel.org, cl@linux.com, zhengqi.arch@bytedance.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [nacked] percpu_ref-call-wake_up_all-after-percpu_ref_put-completes.patch removed from -mm tree
Message-Id: <20220408180715.9B6FBC385A5@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: percpu_ref: call wake_up_all() after percpu_ref_put() completes
has been removed from the -mm tree.  Its filename was
     percpu_ref-call-wake_up_all-after-percpu_ref_put-completes.patch

This patch was dropped because it was nacked

------------------------------------------------------
From: Qi Zheng <zhengqi.arch@bytedance.com>
Subject: percpu_ref: call wake_up_all() after percpu_ref_put() completes

In the percpu_ref_call_confirm_rcu(), we call the wake_up_all() before
calling percpu_ref_put(), which will cause the value of percpu_ref to be
unstable when percpu_ref_switch_to_atomic_sync() returns.

	CPU0				CPU1

percpu_ref_switch_to_atomic_sync(&ref)
--> percpu_ref_switch_to_atomic(&ref)
    --> percpu_ref_get(ref);	/* put after confirmation */
	call_rcu(&ref->data->rcu, percpu_ref_switch_to_atomic_rcu);

					percpu_ref_switch_to_atomic_rcu
					--> percpu_ref_call_confirm_rcu
					    --> data->confirm_switch = NULL;
						wake_up_all(&percpu_ref_switch_waitq);

    /* here waiting to wake up */
    wait_event(percpu_ref_switch_waitq, !ref->data->confirm_switch);
						(A)percpu_ref_put(ref);
/* The value of &ref is unstable! */
percpu_ref_is_zero(&ref)
						(B)percpu_ref_put(ref);

As shown above, assuming that the counts on each cpu add up to 0 before
calling percpu_ref_switch_to_atomic_sync(), we expect that after switching
to atomic mode, percpu_ref_is_zero() can return true.  But actually it
will return different values in the two cases of A and B, which is not
what we expected.

Maybe the original purpose of percpu_ref_switch_to_atomic_sync() is just
to ensure that the conversion to atomic mode is completed, but it should
not return with an extra reference count.

Calling wake_up_all() after percpu_ref_put() ensures that the value of
percpu_ref is stable after percpu_ref_switch_to_atomic_sync() returns.  So
just do it.

Link: https://lkml.kernel.org/r/20220407103335.36885-1-zhengqi.arch@bytedance.com
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Dennis Zhou <dennis@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Christoph Lameter <cl@linux.com>
Cc: Chengming Zhou <zhouchengming@bytedance.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/percpu-refcount.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/lib/percpu-refcount.c~percpu_ref-call-wake_up_all-after-percpu_ref_put-completes
+++ a/lib/percpu-refcount.c
@@ -154,13 +154,14 @@ static void percpu_ref_call_confirm_rcu(
 
 	data->confirm_switch(ref);
 	data->confirm_switch = NULL;
-	wake_up_all(&percpu_ref_switch_waitq);
 
 	if (!data->allow_reinit)
 		__percpu_ref_exit(ref);
 
 	/* drop ref from percpu_ref_switch_to_atomic() */
 	percpu_ref_put(ref);
+
+	wake_up_all(&percpu_ref_switch_waitq);
 }
 
 static void percpu_ref_switch_to_atomic_rcu(struct rcu_head *rcu)
_

Patches currently in -mm which might be from zhengqi.arch@bytedance.com are


